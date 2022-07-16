`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: InstAndDataMemory
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


module InstAndDataMemory(reset, clk, Address, Write_data, MemRead, MemWrite, Mem_data);
	//Input Clock Signals
	input reset;
	input clk;
	//Input Data Signals
	input [31:0] Address;
	input [31:0] Write_data;
	//Input Control Signals
	input MemRead;
	input MemWrite;
	//Output Data
	output [31:0] Mem_data;
	
	parameter RAM_SIZE = 256;
	parameter RAM_SIZE_BIT = 8;
	parameter RAM_INST_SIZE = 32;
	
	reg [31:0] RAM_data[RAM_SIZE - 1: 0];

	//read data
	assign Mem_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	//write data
	integer i;
	always @(posedge reset or posedge clk) begin
		if (reset) begin
		    // init instruction memory
            // addi $a0, $zero, 12123 #(0x2f5b)
            RAM_data[8'd0] <= {6'h08, 5'd0 , 5'd4 , 16'h2f5b};
            // addiu $a1, $zero, -12345 #(0xcfc7)
            RAM_data[8'd1] <= {6'h09, 5'd0 , 5'd5 , 16'hcfc7};
            // sll $a2, $a1, 16
            RAM_data[8'd2] <= {6'h00, 5'd0 , 5'd5 , 5'd6 , 5'd16 , 6'h00};
            // sra $a3, $a2, 16
            RAM_data[8'd3] <= {6'h00, 5'd0 , 5'd6 , 5'd7 , 5'd16 , 6'h03};
            // beq $a3, $a1, L1
            RAM_data[8'd4] <= {6'h04, 5'd7 , 5'd5 , 16'h0001};
            // lui $a0, 22222 #(0x56ce)
            RAM_data[8'd5] <= {6'h0f, 5'd0 , 5'd4 , 16'h56ce};
            // L1:
            // add $t0, $a2, $a0
            RAM_data[8'd6] <= {6'h00, 5'd6 , 5'd4 , 5'd8 , 5'd0 , 6'h20};
            // sra $t1, $t0, 8
            RAM_data[8'd7] <= {6'h00, 5'd0 , 5'd8 , 5'd9 , 5'd8 , 6'h03};
            // addi $t2, $zero, -12123 #(0xd0a5)
            RAM_data[8'd8] <= {6'h08, 5'd0 , 5'd10, 16'hd0a5};
            // slt $v0, $a0, $t2
            RAM_data[8'd9] <= {6'h00, 5'd4 , 5'd10 , 5'd2 , 5'd0 , 6'h2a};
            // sltu $v1, $a0, $t2
            RAM_data[8'd10] <= {6'h00, 5'd4 , 5'd10 , 5'd3 , 5'd0 , 6'h2b};
            // Loop:
            // j Loop
            RAM_data[8'd11] <= {6'h02, 26'd11};
       
            //init instruction memory
            //reset data memory		  
			for (i = RAM_INST_SIZE; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
		end else if (MemWrite) begin
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
		end
	end

endmodule
