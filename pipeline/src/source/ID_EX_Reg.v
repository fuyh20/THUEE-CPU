`timescale 1ns / 1ps

module ID_EX_Reg(reset, clk, Flush, ID_PC_plus4, ID_Rs_Data, 
                 ID_Rt_Data, ID_Imm, ID_Rs, ID_Rt, ID_Rd, 
                 ID_BranchOp, ID_ALUSrc, ID_ALUOp, ID_RegDst,
                 ID_MemWrite, ID_MemRead, ID_MemToReg, ID_RegWrite, ID_is_lb);
    
    input reset, clk, Flush;

    input [31:0] ID_PC_plus4, ID_Rs_Data, ID_Rt_Data, ID_Imm;
    input [4:0] ID_Rs, ID_Rt, ID_Rd;
    input [3:0] ID_ALUOp;
    input [2:0] ID_ALUSrc, ID_BranchOp;
    input [1:0] ID_RegDst, ID_MemToReg;
    input ID_MemWrite, ID_MemRead, ID_RegWrite, ID_is_lb;

    reg [31:0] PC_plus4, Rs_Data, Rt_Data, Imm;
    reg [4:0] Rs, Rt, Rd;
    reg [3:0] ALUOp;
    reg [2:0] ALUSrc, BranchOp;
    reg [1:0] RegDst, MemToReg;
    reg MemWrite, MemRead, RegWrite, is_lb;

    always @(posedge clk or posedge reset) begin
        if (reset || Flush) begin
            PC_plus4 <= 32'h0;
            Rs <= 5'h0;
            Rt <= 5'h0;
            Rd <= 5'h0;
            Rs_Data <= 32'h0;
            Rt_Data <= 32'h0;
            Imm <= 32'h0;
            ALUOp <= 4'h0;
            BranchOp <= 3'h0;
            ALUSrc <= 3'h0;
            RegDst <= 3'h0;
            MemToReg <= 2'h0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            RegWrite <= 1'b0;
            is_lb <= 1'b0;
        end
        else begin
            PC_plus4 <= ID_PC_plus4;
            Rs_Data <= ID_Rs_Data;
            Rt_Data <= ID_Rt_Data;
            Imm <= ID_Imm;
            Rs <= ID_Rs;
            Rt <= ID_Rt;
            Rd <= ID_Rd;
            ALUOp <= ID_ALUOp;
            BranchOp <= ID_BranchOp;
            ALUSrc <= ID_ALUSrc;
            RegDst <= ID_RegDst; 
            MemToReg <= ID_MemToReg;
            is_lb <= ID_is_lb;
            MemWrite <= ID_MemWrite;
            MemRead <= ID_MemRead;
            RegWrite <= ID_RegWrite;
        end
    end

endmodule    