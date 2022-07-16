`timescale 1ns / 1ps

module Hazard(reset, branch_hazard, jump_hazard, ID_EX_MemRead,
              ID_EX_Rt, IF_ID_Rs, IF_ID_Rt, PC_Wen, IF_Flush, IF_Wen, ID_Flush);

    input reset, branch_hazard, jump_hazard, ID_EX_MemRead;
    input [4:0] ID_EX_Rt, IF_ID_Rs, IF_ID_Rt;

    output PC_Wen, IF_Flush, IF_Wen, ID_Flush;

    wire load_use_hazard;
    assign load_use_hazard = reset? 1'b0: (ID_EX_MemRead && (ID_EX_Rt != 0) && ((ID_EX_Rt == IF_ID_Rs) || (ID_EX_Rt == IF_ID_Rt)));

    assign PC_Wen = ~load_use_hazard;
    assign IF_Wen = ~load_use_hazard;

    assign IF_Flush = reset? 1'b0: (jump_hazard || branch_hazard);
    assign ID_Flush = reset? 1'b0: (branch_hazard || load_use_hazard);

endmodule