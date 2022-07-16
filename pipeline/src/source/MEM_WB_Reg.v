`timescale 1ns / 1ps

module MEM_WB_Reg(reset, clk, MEM_Write_Data, MEM_Rd, MEM_RegWrite);
    input reset, clk;
    
    input [31:0] MEM_Write_Data;
    input [4:0] MEM_Rd;
    input MEM_RegWrite;

    reg [31:0] Write_data;
    reg [4:0] Rd;
    reg RegWrite;

    always @(posedge reset or posedge clk) begin
        if (reset) begin
            Write_data <= 32'h0;
            Rd <= 5'h0;
            RegWrite <= 1'b0;
        end
        else begin
            Write_data <= MEM_Write_Data;
            Rd <= MEM_Rd;
            RegWrite <= MEM_RegWrite;
        end
    end

endmodule