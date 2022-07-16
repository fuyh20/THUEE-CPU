
module ALU(in1, in2, ALUCtrl, Sign, out, zero);
    input [31:0] in1, in2;
    input [4:0] ALUCtrl;
    input Sign;
    output reg [31:0] out;
    output zero;

    // Your code below
      
    assign zero = (out == 0);   
    wire ss;
    wire lt_31;
    wire lt_signed;

    assign ss = {in1[31], in2[31]};
    assign lt_31 = (in1[30:0] < in2[30:0]);
    assign lt_signed = (in1[31] ^ in2[31])? ((ss == 2'b01)? 0: 1): lt_31;
     
    always @(*) begin
        case (ALUCtrl)
            5'b00000: out <= in1 + in2;
            5'b00001: out <= in1 | in2;
            5'b00010: out <= in1 & in2;
            5'b00110: out <= in1 - in2;
            5'b00111: out <= {31'h00000000, Sign? lt_signed: (in1 < in2)};
            5'b01100: out <= ~(in1 | in2);
            5'b01101: out <= in1 ^ in2;
            5'b10000: out <= (in2 >> in1[4:0]);
            5'b11000: out <= ({{32{in2[31]}}, in2} >> in1[4:0]);
            5'b11001: out <= (in2 << in1[4:0]);
            default: out <= 32'h00000000;
        endcase
    end

    // Your code above

endmodule