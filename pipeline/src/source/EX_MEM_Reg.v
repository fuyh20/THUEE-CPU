`timescale 1ns / 1ps

module EX_MEM_Reg(reset, clk, EX_PC_plus4, EX_ALUOut, EX_Rt_Data, EX_Rd,
                  EX_MemWrite, EX_MemRead, EX_MemToReg, EX_RegWrite, EX_is_lb);
    
    input reset, clk;

    input [31:0] EX_PC_plus4, EX_ALUOut, EX_Rt_Data;
    input [4:0] EX_Rd;
    input [1:0] EX_MemToReg;
    input EX_MemWrite, EX_MemRead, EX_RegWrite, EX_is_lb;

    reg [31:0] PC_plus4, ALUOut, Rt_Data;
    reg [4:0] Rd;
    reg [1:0] MemToReg;
    reg MemWrite, MemRead, RegWrite, is_lb;

    always @(posedge reset or posedge clk) begin
        if (reset) begin
            PC_plus4 <= 32'h0;
            ALUOut <= 32'h0;
            Rt_Data <= 32'h0;
            Rd <= 5'h0;
            MemToReg <= 2'h0;
            MemWrite <= 1'b0;
            MemRead <= 1'b0;
            RegWrite <= 1'b0;
            is_lb <= 1'b0;
        end
        else begin
            PC_plus4 <= EX_PC_plus4;
            ALUOut <= EX_ALUOut;
            Rt_Data <= EX_Rt_Data;
            Rd <= EX_Rd;
            is_lb <= EX_is_lb;
            MemToReg <= EX_MemToReg;
            MemRead <= EX_MemRead;
            MemWrite <= EX_MemWrite;
            RegWrite <= EX_RegWrite;
        end
    end


endmodule