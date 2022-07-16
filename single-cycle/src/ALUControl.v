
module ALUControl(OpCode, Funct, ALUCtrl, Sign);
    input [5:0] OpCode;
    input [5:0] Funct;
    output reg [4:0] ALUCtrl;
    output Sign;

    // Your code below

    parameter aluADD = 5'b00000;
    parameter aluOR  = 5'b00001;
    parameter aluAND = 5'b00010;
    parameter aluSUB = 5'b00110;
    parameter aluSLT = 5'b00111;
    parameter aluNOR = 5'b01100;
    parameter aluXOR = 5'b01101;
    parameter aluSRL = 5'b10000;
    parameter aluSRA = 5'b11000;
    parameter aluSLL = 5'b11001;

    reg Sign;
    always @(*) begin
        if (OpCode == 6'h00)
            Sign = ~Funct[0];
        else 
            Sign = ~OpCode[0];
    end
    
    reg [4:0] aluFunct;
    always @(*) begin
        case (Funct)
            6'b00_0000: aluFunct <= aluSLL;
            6'b00_0010: aluFunct <= aluSRL;
            6'b00_0011: aluFunct <= aluSRA;
            6'b10_0000: aluFunct <= aluADD;
            6'b10_0001: aluFunct <= aluADD;
            6'b10_0010: aluFunct <= aluSUB;
            6'b10_0011: aluFunct <= aluSUB;
            6'b10_0100: aluFunct <= aluAND;
            6'b10_0101: aluFunct <= aluOR;
            6'b10_0110: aluFunct <= aluXOR;
            6'b10_0111: aluFunct <= aluNOR;
            6'b10_1010: aluFunct <= aluSLT;
            6'b10_1011: aluFunct <= aluSLT;
            default: aluFunct <= aluADD;
        endcase
    end

    always @(*) begin
        case (OpCode)
            6'h04: ALUCtrl <= aluSUB;
            6'h0c: ALUCtrl <= aluAND;
            6'h0a: ALUCtrl <= aluSLT;
            6'h0b: ALUCtrl <= aluSLT;
            6'h00: ALUCtrl <= aluFunct;
            default: ALUCtrl <= aluADD;
        endcase
    end

    // Your code above

endmodule
