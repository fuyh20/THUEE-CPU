`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: MultiCycleCPU
// Project Name: Multi-cycle-cpu
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//module MultiCycleCPU (reset, clk);
//     //Input Clock Signals
//     input reset;
//     input clk;

module MultiCycleCPU (reset, clk, regChoose, led, an, digitalTube);
     //Input Clock Signals
     input reset;
     input clk;
    input [1:0] regChoose;
    output [7:0] led, digitalTube;
    output [3:0] an;

// module MultiCycleCPU(reset, clk_i, sysclk, regChoose, led, an, digitalTube);
//    input reset, clk_i, sysclk;
//    input [1:0] regChoose;
//    output [7:0] led, digitalTube;
//    output [3:0] an;
    
    //--------------Your code below-----------------------

    wire PCWrite_;
    wire [31:0] PC_i;
    wire [31:0] PC_o;

    PC PC(reset, clk, PCWrite_, PC_i, PC_o);

    wire [31:0] Address;
    wire [31:0] InstAndDataMemory_Write_data;
    wire MemRead;
    wire MemWrite;
    wire [31:0] Mem_data;
    InstAndDataMemory InstAndDataMemory(reset, clk, Address, InstAndDataMemory_Write_data, MemRead, MemWrite, Mem_data);
    
    wire IPWrite;
    wire [5:0] OpCode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] Shamt;
    wire [5:0] Funct;
    InstReg InstReg(reset, clk, IRWrite, Mem_data, OpCode, rs, rt, rd, Shamt, Funct);

    wire [31:0] Mem_data_save;
    RegTemp MemDataReg(reset, clk, Mem_data, Mem_data_save);

    wire RegWrite;
    wire [4:0] Write_register;
    wire [31:0] RegisterFile_Write_data;
    wire [31:0] Read_data1;
    wire [31:0] Read_data2;

    RegisterFile RegisterFile(reset, clk, RegWrite, rs, rt, Write_register, 
                              RegisterFile_Write_data, Read_data1, Read_data2);

    wire [31:0] Read_data1_save;
    wire [31:0] Read_data2_save;
    RegTemp Read_data_A_Reg(reset, clk, Read_data1, Read_data1_save);
    RegTemp Read_data_B_Reg(reset, clk, Read_data2, Read_data2_save);

    wire [3:0] ALUop;
    wire [4:0] ALUConf;
    wire Sign;
    ALUControl ALUControl(ALUop, Funct, ALUConf, Sign);

    wire [31:0] In1;
    wire [31:0] In2;
    wire Zero;
    wire [31:0] Result;
    ALU ALU(ALUConf, Sign, In1, In2, Zero, Result);

    wire [31:0] Result_save;
    RegTemp ALUOut(reset, clk, Result, Result_save);

    wire [15:0] Immediate;
    wire ExtOp;
    wire LuiOp;
    wire [31:0] ImmExtOut;
    wire [31:0] ImmExtShift;
    ImmProcess ImmProcess(ExtOp, LuiOp, Immediate, ImmExtOut, ImmExtShift);

    wire PCWrite;
    wire PCWriteCond;
    assign PCWrite_ = PCWrite | (PCWriteCond & Zero);

    wire [1:0] PCSource;
    assign PC_i = (PCSource == 2'b00)? Result:
                  (PCSource == 2'b01)? Result_save:
                  (PCSource == 2'b10)? {PC_o[31:28], rs, rt, rd, Shamt, Funct, 2'b00}:
                  (PCSource == 2'b11)? Read_data1_save:
                  Result_save;

    wire IorD;
    assign Address = (IorD == 1'b0)? PC_o: Result_save;
    assign InstAndDataMemory_Write_data = Read_data2_save;

    wire [1:0] RegDst;
    assign Write_register = (RegDst == 2'b00)? rt:
                            (RegDst == 2'b01)? rd:
                            (RegDst == 2'b10)? 5'd31:
                            rd;

    wire [1:0] MemtoReg;
    assign RegisterFile_Write_data = (MemtoReg == 2'b00)? Mem_data_save:
                                     (MemtoReg == 2'b01)? Result_save:
                                     (MemtoReg == 2'b10)? PC_o:
                                     Result_save;

    wire [1:0] ALUSrcA;
    assign In1 = (ALUSrcA == 2'b00)? PC_o:
                 (ALUSrcA == 2'b01)? Read_data1_save:
                 (ALUSrcA == 2'b10)? Shamt:
                 Read_data1_save;

    wire [1:0] ALUSrcB;
    assign In2 = (ALUSrcB == 2'b00)? Read_data2_save:
                 (ALUSrcB == 2'b01)? 32'd4:
                 (ALUSrcB == 2'b10)? ImmExtOut:
                 (ALUSrcB == 2'b11)? ImmExtShift:
                 Read_data2_save;

    assign Immediate = {rd, Shamt, Funct};
    Controller Controller(reset, clk, OpCode, Funct, PCWrite,
                          PCWriteCond, IorD, MemWrite, MemRead,
                          IRWrite, MemtoReg, RegDst, RegWrite,
                          ExtOp, LuiOp, ALUSrcA, ALUSrcB, ALUop,PCSource);                    
    

    //--------------Your code above-----------------------

// 数�?�实验演示部�?
//    wire clk;
    reg [15:0] regData;
//    debounce xbounce(.clk(sysclk), .key_i(clk_i), .key_o(clk));
    assign led = PC_o[7:0];

    always @(*) begin
        case(regChoose)
            2'b00: regData <= RegisterFile.RF_data[4][15:0];
            2'b01: regData <= RegisterFile.RF_data[2][15:0];
            2'b10: regData <= RegisterFile.RF_data[29][15:0];
            2'b11: regData <= RegisterFile.RF_data[31][15:0];
            default: regData <= 16'h0;
        endcase
    end

//    Display Display(reset, sysclk, regData, an, digitalTube);
    Display Display(reset, clk, regData, an, digitalTube);
     
endmodule