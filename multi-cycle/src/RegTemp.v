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


module RegTemp(reset, clk, Data_i, Data_o);
    //Input Clock Signals
    input reset;
    input clk;
    //Input Data
    input [31:0] Data_i;
    //Output Data
    output reg [31:0] Data_o;
    
    always@(posedge reset or posedge clk) begin
        if (reset) begin
            Data_o <= 32'h00000000;
        end else begin
            Data_o <= Data_i;
        end
    end
endmodule
