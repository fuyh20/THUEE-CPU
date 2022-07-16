`timescale 1ns / 1ps

module DataMem(reset, clk, Address, Write_data, Read_data, MemRead, MemWrite, leds, digitalTube, is_lb);
    input reset, clk;
    input [31:0] Address, Write_data;
    input MemRead, MemWrite, is_lb;
    output [31:0] Read_data;
    output reg [7:0] leds;
    output reg [11:0] digitalTube;

    parameter RAM_SIZE = 512;
    parameter RAM_SIZE_BIT = 9;

    reg [31:0] RAM_data[RAM_SIZE - 1: 0];
    assign Read_data = (MemRead == 0)? 32'b0:
                       (Address == 32'h4000000c)? {24'h0, leds}: 
                       (Address == 32'h40000010)? {20'h0, digitalTube}:
                       (is_lb && Address[1:0] == 2'b00)? {24'h0, RAM_data[Address[RAM_SIZE_BIT + 1:2]][7:0]}:
                       (is_lb && Address[1:0] == 2'b01)? {24'h0, RAM_data[Address[RAM_SIZE_BIT + 1:2]][15:8]}:
                       (is_lb && Address[1:0] == 2'b10)? {24'h0, RAM_data[Address[RAM_SIZE_BIT + 1:2]][23:16]}:
                       (is_lb && Address[1:0] == 2'b11)? {24'h0, RAM_data[Address[RAM_SIZE_BIT + 1:2]][31:24]}:
                       RAM_data[Address[RAM_SIZE_BIT + 1:2]];

    integer i;
    always @(posedge reset or posedge clk) begin
        if (reset) begin
            leds <= 8'h0;
            digitalTube <= 12'h0;
            for (i = 0; i < RAM_SIZE; i = i + 1)
                RAM_data[i] <= 32'h00000000;
        end
        else if (MemWrite) begin
            if(Address == 32'h4000000c)
                leds <= Write_data[7:0];
            else if (Address == 32'h40000010)
                digitalTube <= Write_data[11:0];
            else
                RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
        end
    end

endmodule
