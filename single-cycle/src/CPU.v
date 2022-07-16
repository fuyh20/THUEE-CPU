
//module CPU(reset, clk);
//    input reset, clk;

 module CPU(reset, clk, regChoose, led, an, digitalTube);
     input reset, clk;
     input [1:0] regChoose;
     output [7:0] led, digitalTube;
     output [3:0] an;

// module CPU(reset, clk_i, sysclk, regChoose, led, an, digitalTube);
//     input reset, clk_i, sysclk;
//     input [1:0] regChoose;
//     output [7:0] led, digitalTube;
//     output [3:0] an;

    //--------------Your code below-----------------------

    reg [31:0] PC;
    wire [31:0]Instruction;
    wire [1:0] PCSrc;
    wire Branch;
    wire RegWrite;
    wire [1:0] RegDst;
    wire MemRead;
    wire MemWrite;
    wire [1:0] MemtoReg;
    wire ALUSrc1;
    wire ALUSrc2;
    wire ExtOp;
    wire LuOp;
    wire [4:0] Write_register;
    wire [31:0] DataBusA, DataBusB, DataBusW;
    wire [31:0] PC_4;
    wire [31:0] in1, in2, out;
    wire Zero;
    wire [4:0] ALUCtrl;
    wire Sign;
    wire [31:0] Read_data;
    
    assign PC_4 = PC + 32'd4;
    assign DataBusW = (MemtoReg == 2'b00)? out:
                      (MemtoReg == 2'b01)? Read_data: PC_4;
    assign Write_register = (RegDst == 2'b00)? Instruction[20:16]:
                            (RegDst == 2'b01)? Instruction[15:11]: 5'b11111;

    InstructionMemory instructionMemory(PC, Instruction);
    Control control(
        Instruction[31:26], Instruction[5:0], PCSrc, Branch, 
        RegWrite, RegDst, MemRead, MemWrite, MemtoReg, ALUSrc1,
        ALUSrc2, ExtOp, LuOp);
    RegisterFile registerFile(reset, clk, RegWrite, Instruction[25:21], 
                              Instruction[20:16], Write_register, DataBusW, 
                              DataBusA, DataBusB);
    
    wire [31:0] ExtOut;
    wire [31:0] LuOut;
    assign ExtOut = {ExtOp? {16{Instruction[15]}}: 16'h0, Instruction[15:0]};
    assign LuOut = LuOp? {Instruction[15:0], 16'h0}: ExtOut;

    ALUControl ALUControl(Instruction[31:26], Instruction[5:0], ALUCtrl, Sign);

    assign in1 = ALUSrc1? {27'h0, Instruction[10:6]}: DataBusA;
    assign in2 = ALUSrc2? LuOut: DataBusB;
    ALU ALU(in1, in2, ALUCtrl, Sign, out, Zero);

    DataMemory dataMemory(reset, clk, out, DataBusB, Read_data, MemRead, MemWrite);

    wire [31:0] JumpTarget;
    wire [31:0] BranchTarget;
    assign JumpTarget = {PC_4[31:28], Instruction[25:0], 2'b00};
    assign BranchTarget = (Branch & Zero)? PC_4 + {LuOut[29:0], 2'b00}: PC_4;

    wire [31:0] PC_next;
    assign PC_next = (PCSrc == 2'b00)? BranchTarget:
                     (PCSrc == 2'b01)? JumpTarget: DataBusA;

    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'h00000000;
        else
            PC <= PC_next;
    end
    
    //--------------Your code above-----------------------

// 数�?�实验演示部�?
    // wire clk;
    reg [15:0] regData;
    // debounce xbounce(.clk(sysclk), .key_i(clk_i), .key_o(clk));
    assign led = PC[7:0];

     always @(*) begin
         case(regChoose)
             2'b00: regData <= registerFile.RF_data[4][15:0];
             2'b01: regData <= registerFile.RF_data[2][15:0];
             2'b10: regData <= registerFile.RF_data[29][15:0];
             2'b11: regData <= registerFile.RF_data[31][15:0];
             default: regData <= 16'h0;
         endcase
     end

//     Display Display(reset, sysclk, regData, an, digitalTube);
     Display Display(reset, clk, regData, an, digitalTube);

endmodule
