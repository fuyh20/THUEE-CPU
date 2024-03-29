
module Control(OpCode, Funct,
    PCSrc, Branch, RegWrite, RegDst, 
    MemRead, MemWrite, MemtoReg, 
    ALUSrc1, ALUSrc2, ExtOp, LuOp);
    input [5:0] OpCode;
    input [5:0] Funct;
    output [1:0] PCSrc;
    output Branch;
    output RegWrite;
    output [1:0] RegDst;
    output MemRead;
    output MemWrite;
    output [1:0] MemtoReg;
    output ALUSrc1;
    output ALUSrc2;
    output ExtOp;
    output LuOp;

    // Your code below

    assign PCSrc = (OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09))? 2'b10:
	               (OpCode == 6'h02 || OpCode == 6'h03)? 2'b01: 2'b00;

    assign Branch = (OpCode == 6'h04)? 1: 0;
    assign RegWrite = (OpCode == 6'h2b || OpCode == 6'h04 || OpCode == 6'h02 || (OpCode == 6'h00 && Funct == 6'h08))? 0: 1;
    assign RegDst = (OpCode == 6'h03)? 2'b10:
                    (OpCode == 6'h2b || OpCode == 6'h00 || OpCode == 6'h04 || OpCode == 6'h02)? 2'b01: 2'b00;
    assign MemRead = (OpCode == 6'h23)? 1: 0;
    assign MemWrite = (OpCode == 6'h2b)? 1: 0;
    assign MemtoReg = (OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09))? 2'b10:
                      (OpCode == 6'h23)? 2'b01: 2'b00;
    assign ALUSrc1 = (OpCode == 6'h00 && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03))? 1: 0;
    assign ALUSrc2 = (OpCode == 6'h04 || OpCode == 6'h02 || OpCode == 6'h03 || OpCode == 6'h00)? 0: 1;
    assign ExtOp = (OpCode == 6'h0c)? 0: 1;
    assign LuOp = (OpCode == 6'h0f)? 1: 0;


    // Your code above  


endmodule