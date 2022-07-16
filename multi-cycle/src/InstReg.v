`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: RegTemp
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

module InstReg(reset, clk, IRWrite, Instruction, OpCode, rs, rt, rd, Shamt, Funct);
    //Input Clock Signals
    input reset;
    input clk;
    //Input Control Signals
    input IRWrite;
    //Input Instruction
    input [31:0] Instruction;
    //Output Data
    output reg [5:0]  OpCode;
    output reg [4:0]  rs;
    output reg [4:0]  rt;
    output reg [4:0]  rd;
    output reg [4:0]  Shamt;
    output reg [5:0]  Funct;
    
    reg [31:0] instruction;
    
    always @(posedge reset or posedge clk) begin
        if (reset) begin
            OpCode <= 6'b000000;
            rs <= 5'b00000;
            rt <= 5'b00000;
            rd <= 5'b00000;
            Shamt <= 5'b00000;
            Funct <= 6'b000000;
            instruction <= 32'b0;
        end
        else if (IRWrite) begin
            OpCode <= Instruction[31:26];
            rs <= Instruction[25:21];
            rt <= Instruction[20:16];
            rd <= Instruction[15:11];
            Shamt <= Instruction[10:6];
            Funct <= Instruction[5:0];
            instruction <= Instruction;
        end
        else begin
            OpCode <= OpCode;
            rs <= rs;
            rt <= rt;
            rd <= rd;
            Shamt <= Shamt;
            Funct <= Funct;
            instruction <= instruction;
        end
    end

endmodule