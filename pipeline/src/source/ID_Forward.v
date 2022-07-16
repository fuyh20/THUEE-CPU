`timescale 1ns / 1ps

module ID_Forward(EX_MEM_Rd, MEM_WB_Rd, EX_MEM_RegWrite, MEM_WB_RegWrite,
                  IF_ID_Rs, IF_ID_Rt, ID_Forward_1, ID_Forward_2);

    input EX_MEM_RegWrite, MEM_WB_RegWrite;
    input [4:0] EX_MEM_Rd, MEM_WB_Rd, IF_ID_Rs, IF_ID_Rt;

    output [1:0] ID_Forward_1;
    output ID_Forward_2;

    assign ID_Forward_1 = (EX_MEM_RegWrite && (EX_MEM_Rd != 5'h0) && (EX_MEM_Rd == IF_ID_Rs))? 2'b01:
                          (MEM_WB_RegWrite && (MEM_WB_Rd != 5'h0) && (MEM_WB_Rd == IF_ID_Rs))? 2'b10:
                          2'b00;

    assign ID_Forward_2 = (MEM_WB_RegWrite && (MEM_WB_Rd != 5'h0) && (MEM_WB_Rd == IF_ID_Rt));


endmodule