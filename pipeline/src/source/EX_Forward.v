`timescale 1ns / 1ps

module EX_Forward(EX_MEM_Rd, MEM_WB_Rd, EX_MEM_RegWrite, MEM_WB_RegWrite,
                  ID_EX_Rs, ID_EX_Rt, EX_Forward_1, EX_Forward_2);

    input EX_MEM_RegWrite, MEM_WB_RegWrite;
    input [4:0] EX_MEM_Rd, MEM_WB_Rd, ID_EX_Rs, ID_EX_Rt;

    output [1:0] EX_Forward_1, EX_Forward_2;

    assign EX_Forward_1 = (EX_MEM_RegWrite && (EX_MEM_Rd != 5'h0) && (EX_MEM_Rd == ID_EX_Rs))? 2'b01:
                          (MEM_WB_RegWrite && (MEM_WB_Rd != 5'h0) && (MEM_WB_Rd == ID_EX_Rs))? 2'b10:
                          2'b00;
    
    assign EX_Forward_2 = (EX_MEM_RegWrite && (EX_MEM_Rd != 5'h0) && (EX_MEM_Rd == ID_EX_Rt))? 2'b01:
                          (MEM_WB_RegWrite && (MEM_WB_Rd != 5'h0) && (MEM_WB_Rd == ID_EX_Rt))? 2'b10:
                          2'b00;
    

endmodule