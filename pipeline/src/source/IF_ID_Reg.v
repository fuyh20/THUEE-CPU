`timescale 1ns / 1ps

module IF_ID_Reg(reset, clk, wen, Flush, IF_Instuction, IF_PC_plus4);
    input reset, clk, wen, Flush;
    input [31:0] IF_Instuction, IF_PC_plus4;

    reg [31:0] Instruction, PC_plus4;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Instruction <= 32'h0;
            PC_plus4 <= 32'h0;
        end
        else if (wen) begin
            Instruction <= Flush? 32'h0: IF_Instuction;
            PC_plus4 <= IF_PC_plus4; 
        end
    end

endmodule