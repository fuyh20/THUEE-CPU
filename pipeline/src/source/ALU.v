`timescale 1ns / 1ps

module ALU (ALUCtrl, Sign, In1, In2, Zero, Result);
    input [4:0] ALUCtrl;
    input Sign;
    input [31:0] In1;
    input [31:0] In2;

    output Zero;
    output reg [31:0] Result;

    assign Zero = (Result == 0);

    wire [1:0] ss;
    wire lt_31;
    wire lt_signed;

    assign ss = {In1[31], In2[31]};
    assign lt_31 = (In1[30:0] < In2[30:0]);
    assign lt_signed = (In1[31] ^ In2[31])? ((ss == 2'b01)? 0: 1): lt_31;

    always @(*) begin
        case (ALUCtrl)
            5'b00000: Result <= In1 & In2;
            5'b00001: Result <= In1 | In2;
            5'b00010: Result <= In1 + In2;
            5'b00110: Result <= In1 - In2;
            5'b00111: Result <= {31'h00000000, Sign? lt_signed: (In1 < In2)};
            5'b01100: Result <= ~(In1 | In2);
            5'b01101: Result <= In1 ^ In2;
            5'b10000: Result <= (In2 << In1[10:6]);
            5'b10001: Result <= (In2 >> In1[10:6]);
            5'b10010: Result <= ({{32{In2[31]}}, In2} >> In1[10:6]);
            default: Result <= 32'h00000000;
        endcase
    end
    
endmodule