`timescale 1ns / 1ps

module PC(reset, clk, PCWrite, PC_i, PC_o);
    input reset;
    input clk;
    input PCWrite;
    input [31:0] PC_i;
    output reg [31:0] PC_o;

    always @(posedge reset or posedge clk)
    begin
        if (reset) begin
            PC_o <= 32'h00400000;
        end
        else if(PCWrite) begin
            PC_o <= PC_i;
        end 
    end

endmodule