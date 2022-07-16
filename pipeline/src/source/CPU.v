`timescale 1ns / 1ps

module CPU(reset, clk, leds, digitalTube);
    input reset, clk;
    output [7:0] leds;
    output [11:0] digitalTube;

    wire IF_Wen, IF_Flush, ID_Flush;

    wire [31:0] branch_target, jump_target, jr_target;
    wire [1:0] PCSrc;
    wire branch_hazard;

    wire [31:0] PC_o, PC_next, PC_plus4;
    wire PC_Wen;
    assign PC_plus4 = {PC_o[31], PC_o[30:0] + 31'd4};
    assign PC_next = branch_hazard? branch_target:
                     (PCSrc == 2'b00)? PC_plus4:
                     (PCSrc == 2'b01)? jump_target:
                     (PCSrc == 2'b10)? jr_target:
                     32'h00400000;
    
    PC pc(.reset(reset), .clk(clk), .PCWrite(PC_Wen), .PC_i(PC_next), .PC_o(PC_o));
    
    wire [31:0] Instruction;
    InstMem inst_mem(.Address(PC_o), .Instruction(Instruction));

    IF_ID_Reg if_id(.reset(reset), .clk(clk), .wen(IF_Wen), .Flush(IF_Flush), .IF_Instuction(Instruction), .IF_PC_plus4(PC_plus4));

    wire [1:0] RegDst, MemToReg;
    wire [2:0] BranchOp, ALUSrc;
    wire [3:0] ALUOp;
    wire ImmSrc, ExtOp, RegWrite, MemWrite, MemRead, jump_hazard, is_lb;
    Control control(.OpCode(if_id.Instruction[31:26]), .Funct(if_id.Instruction[5:0]), .ImmSrc(ImmSrc), .PCSrc(PCSrc),
                    .BranchOp(BranchOp), .RegDst(RegDst), .ALUSrc(ALUSrc), .ALUOp(ALUOp), .ExtOp(ExtOp),
                    .RegWrite(RegWrite), .MemWrite(MemWrite), .MemRead(MemRead), .MemToReg(MemToReg),
                    .jump_hazard(jump_hazard), .is_lb(is_lb));

    Hazard hazard(.reset(reset), .branch_hazard(branch_hazard), .jump_hazard(jump_hazard), .ID_EX_MemRead(id_ex.MemRead),
                  .ID_EX_Rt(id_ex.Rt), .IF_ID_Rs(if_id.Instruction[25:21]), .IF_ID_Rt(if_id.Instruction[20:16]),
                  .PC_Wen(PC_Wen), .IF_Flush(IF_Flush), .IF_Wen(IF_Wen), .ID_Flush(ID_Flush));

    wire [31:0] rs_data, rt_data;
    RegisterFile regs(.reset(reset), .clk(clk), .RegWrite(mem_wb.RegWrite), .Read_register1(if_id.Instruction[25:21]),
                      .Read_register2(if_id.Instruction[20:16]), .Write_register(mem_wb.Rd), .Write_data(mem_wb.Write_data),
                      .Read_data1(rs_data), .Read_data2(rt_data));

    wire [31:0] Imm;
    assign Imm = ImmSrc? (ExtOp? {{17{if_id.Instruction[15]}}, if_id.Instruction[14:0]}:
                                 {16'b0, if_id.Instruction[15:0]}):
                                 {if_id.Instruction[15:0], 16'b0};

    assign jump_target = {if_id.PC_plus4[31:28], if_id.Instruction[25:0], 2'b00};

    wire [1:0] id_forward_1;
    wire id_forward_2;
    ID_Forward id_forward_control(.EX_MEM_Rd(ex_mem.Rd), .MEM_WB_Rd(mem_wb.Rd), .EX_MEM_RegWrite(ex_mem.RegWrite), 
                                  .MEM_WB_RegWrite(mem_wb.RegWrite), .IF_ID_Rs(if_id.Instruction[25:21]), 
                                  .IF_ID_Rt(if_id.Instruction[20:16]), .ID_Forward_1(id_forward_1), .ID_Forward_2(id_forward_2));

    wire [31:0] rs_data_foward_id, rt_data_foward_id;
    assign rs_data_foward_id = (id_forward_1 == 2'b00)? rs_data:
                               (id_forward_1 == 2'b01)? ex_mem.ALUOut:
                               mem_wb.Write_data;
    assign rt_data_foward_id = id_forward_2? mem_wb.Write_data: rt_data;

    assign jr_target = rs_data_foward_id;

    ID_EX_Reg id_ex(.reset(reset), .clk(clk), .Flush(ID_Flush), .ID_PC_plus4(if_id.PC_plus4), .ID_Rs_Data(rs_data_foward_id),
                    .ID_Rt_Data(rt_data_foward_id), .ID_Imm(Imm), .ID_Rs(if_id.Instruction[25:21]), .ID_Rt(if_id.Instruction[20:16]),
                    .ID_Rd(if_id.Instruction[15:11]), .ID_BranchOp(BranchOp), .ID_ALUSrc(ALUSrc), .ID_ALUOp(ALUOp), .ID_RegDst(RegDst),
                    .ID_MemWrite(MemWrite), .ID_MemRead(MemRead), .ID_MemToReg(MemToReg), .ID_RegWrite(RegWrite), .ID_is_lb(is_lb));

    wire [4:0] ALUCtrl;
    wire sign;

    ALUControl alu_control(.ALUOp(id_ex.ALUOp), .Funct(id_ex.Imm[5:0]), .ALUCtrl(ALUCtrl), .Sign(sign));

    wire [1:0] ex_forward_1, ex_forward_2;

    EX_Forward ex_forward_control(.EX_MEM_Rd(ex_mem.Rd), .MEM_WB_Rd(mem_wb.Rd), .EX_MEM_RegWrite(ex_mem.RegWrite),
                                  .MEM_WB_RegWrite(mem_wb.RegWrite), .ID_EX_Rs(id_ex.Rs), .ID_EX_Rt(id_ex.Rt),
                                  .EX_Forward_1(ex_forward_1), .EX_Forward_2(ex_forward_2));

    wire [31:0] rs_data_foward_ex, rt_data_foward_ex;
    assign rs_data_foward_ex = (ex_forward_1 == 2'b01)? ex_mem.ALUOut:
                               (ex_forward_1 == 2'b10)? mem_wb.Write_data:
                               id_ex.Rs_Data;
    assign rt_data_foward_ex = (ex_forward_2 == 2'b01)? ex_mem.ALUOut:
                               (ex_forward_2 == 2'b10)? mem_wb.Write_data:
                               id_ex.Rt_Data;

    wire [31:0] alu_src1, alu_src2;
    assign alu_src1 = (id_ex.ALUSrc[1:0] == 2'b01)? id_ex.Imm:
                      (id_ex.ALUSrc[1:0] == 2'b10)? 32'h0:
                      rs_data_foward_ex;
    assign alu_src2 = id_ex.ALUSrc[2]? id_ex.Imm: rt_data_foward_ex;

    wire [31:0] alu_out;
    wire zero;
    ALU alu(.ALUCtrl(ALUCtrl), .Sign(sign), .In1(alu_src1), .In2(alu_src2), .Zero(zero), .Result(alu_out));
    
    assign branch_target = id_ex.PC_plus4 + {id_ex.Imm[29:0], 2'b00};
    Branch branch(.In1(rs_data_foward_ex), .In2(rt_data_foward_ex), .BranchOp(id_ex.BranchOp), .flag(id_ex.Rt), .branch_hazard(branch_hazard));

    wire [4:0] Rd;
    assign Rd = (id_ex.RegDst == 2'b01)? id_ex.Rd:
                (id_ex.RegDst == 2'b10)? 5'd31:
                id_ex.Rt;

    EX_MEM_Reg ex_mem(.reset(reset), .clk(clk), .EX_PC_plus4(id_ex.PC_plus4), .EX_ALUOut(alu_out), .EX_Rt_Data(rt_data_foward_ex),
                      .EX_Rd(Rd), .EX_MemWrite(id_ex.MemWrite), .EX_MemRead(id_ex.MemRead), .EX_MemToReg(id_ex.MemToReg),
                      .EX_RegWrite(id_ex.RegWrite), .EX_is_lb(id_ex.is_lb));

    wire [31:0] mem_out, write_data;

    assign write_data = (ex_mem.MemToReg == 2'b10)? ex_mem.PC_plus4:
                        (ex_mem.MemToReg == 2'b01)? mem_out:
                        ex_mem.ALUOut;

    DataMem data_mem(.reset(reset), .clk(clk), .Address(ex_mem.ALUOut), .Write_data(ex_mem.Rt_Data), .Read_data(mem_out), 
                     .MemRead(ex_mem.MemRead), .MemWrite(ex_mem.MemWrite), .leds(leds), .digitalTube(digitalTube), .is_lb(ex_mem.is_lb));

    MEM_WB_Reg mem_wb(.reset(reset), .clk(clk), .MEM_Write_Data(write_data), .MEM_Rd(ex_mem.Rd), .MEM_RegWrite(ex_mem.RegWrite));

endmodule