`timescale 1ns / 1ps

module test_cpu();
	
	reg reset;
	reg clk;
	wire [7:0] leds;
	wire [11:0] digitalTube;
	
	CPU cpu1(reset, clk, leds, digitalTube);
	
	initial begin
		reset = 1;
		clk = 1;
		#100 reset = 0;
	end
	
	always #50 clk = ~clk;
		
endmodule
