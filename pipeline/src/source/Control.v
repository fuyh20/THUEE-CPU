`timescale 1ns / 1ps

module Control(OpCode, Funct, ImmSrc, PCSrc, BranchOp, RegDst, ALUSrc,
               ALUOp, ExtOp, RegWrite, MemWrite, MemRead, MemToReg, jump_hazard, is_lb);

    input [5:0] OpCode, Funct;
    output ImmSrc, RegWrite, MemWrite, MemRead, ExtOp, jump_hazard, is_lb;
    output [2:0] ALUSrc, BranchOp;
    output [1:0] PCSrc;
    output [3:0] ALUOp;
    output [1:0] MemToReg, RegDst;
    
    wire is_R;
    assign is_R = (OpCode == 6'h00);

    assign ImmSrc = ~(OpCode == 6'h0f);
    assign ExtOp = (~is_R && (OpCode != 6'h0c) && (OpCode != 6'h0d) && (OpCode !=6'h0e));

    assign PCSrc = (OpCode == 6'h02 || OpCode == 6'h03)? 2'b01:
                   (OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09))? 2'b10:
                   2'b00;

    assign BranchOp = ((OpCode == 6'h1) || (OpCode == 6'h4) || (OpCode == 6'h5) || (OpCode == 6'h6) || (OpCode == 6'h7)) ? OpCode[2:0]:
                      3'h0;
    
    assign RegWrite = (~((OpCode == 6'h2b) || (| BranchOp) || (OpCode == 6'h02) || (OpCode == 6'h00 && Funct == 6'h08)));

    assign MemRead = (OpCode == 6'h23 || OpCode == 6'h20);
    assign MemWrite = (OpCode == 6'h2b);
    assign is_lb = (OpCode == 6'h20);

    assign RegDst = (OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09))? 2'b10:
                    is_R? 2'b01:
                    2'b00;
    
    assign ALUOp[3] = OpCode[0];
    assign ALUOp[2:0] = (OpCode == 6'h00)? 3'b001:
                        (OpCode == 6'h0c)? 3'b010:
                        (OpCode == 6'h0d)? 3'b011:
                        (OpCode == 6'h0e)? 3'b100:
                        (OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101:
                        3'b000;

    assign ALUSrc[1:0] = (is_R && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03))? 2'b01:
                         (OpCode == 6'h0f)? 2'b10:
                         2'b00;
    assign ALUSrc[2] = ~is_R;

    assign MemToReg = (OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09))? 2'b10:
                      (OpCode == 6'h23 || OpCode == 6'h20)? 2'b01:
                      2'b00;
    
    assign jump_hazard = (OpCode == 6'h02) || (OpCode == 6'h03) || (is_R && (Funct == 6'h08 || Funct == 6'h09));

endmodule