module Display
(
    input reset,
    input clk,
    input [15:0] regData,
    output [3:0] an,
    output reg [7:0] digitalTube
);

reg [3:0] anTemp;
assign an = anTemp;

reg [16:0] divider;
reg clk_flush;

initial begin
    divider <= 0;
    clk_flush <= 0;
end

always @(posedge reset or posedge clk) begin
    if (reset) begin
        divider <= 0;
        clk_flush <= 0;
    end
    else begin
        if (divider >= 9999) begin
            clk_flush <= ~clk_flush;
            divider <= 0;
        end
        else begin
            divider = divider + 1;
        end
    end
end

always @(posedge reset or posedge clk_flush) begin
    if (reset) begin
        anTemp <= 4'b0111;
    end
    else begin
        case (anTemp)
            4'b1000: anTemp <= 4'b0100;
            4'b0100: anTemp <= 4'b0010;
            4'b0010: anTemp <= 4'b0001;
            4'b0001: anTemp <= 4'b1000;
            default: anTemp <= 4'b1000;
        endcase
    end
end

reg [3:0] to_display;
always @(*) begin
    case (anTemp)
    4'b1000: to_display <= regData[3:0];
    4'b0100: to_display <= regData[7:4];
    4'b0010: to_display <= regData[11:8];
    4'b0001: to_display <= regData[15:12];
    default: to_display <= 16'h0;
    endcase
end

always @(*) begin
    case (to_display)
    4'h0: digitalTube <= 8'b00111111;
    4'h1: digitalTube <= 8'b00000110;
    4'h2: digitalTube <= 8'b01011011;
    4'h3: digitalTube <= 8'b01001111;
    4'h4: digitalTube <= 8'b01100110;
    4'h5: digitalTube <= 8'b01101101;
    4'h6: digitalTube <= 8'b01111101;
    4'h7: digitalTube <= 8'b00000111;
    4'h8: digitalTube <= 8'b01111111;
    4'h9: digitalTube <= 8'b01101111;
    4'ha: digitalTube <= 8'b01110111;
    4'hb: digitalTube <= 8'b01111100;
    4'hc: digitalTube <= 8'b00111001;
    4'hd: digitalTube <= 8'b01011110;
    4'he: digitalTube <= 8'b01111001;
    4'hf: digitalTube <= 8'b01110001;
    default: digitalTube <= 8'b00000000;
    endcase
end

endmodule