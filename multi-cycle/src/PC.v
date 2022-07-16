`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: PC
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

module PC(reset, clk, PCWrite, PC_i, PC_o);
    //Input Clock Signals
    input reset;             
    input clk;
    //Input Control Signals             
    input PCWrite;
    //Input PC             
    input [31:0] PC_i;
    //Output PC  
    output reg [31:0] PC_o; 


    always@(posedge reset or posedge clk)
    begin
        if(reset) begin
            PC_o <= 0;
        end else if (PCWrite) begin
            PC_o <= PC_i;
        end else begin
            PC_o <= PC_o;
        end
    end
endmodule