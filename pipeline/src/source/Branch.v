`timescale 1ns / 1ps

module Branch(In1, In2, BranchOp, flag, branch_hazard);
    input [31:0] In1, In2;
    input [2:0] BranchOp;
    input [4:0] flag;

    output reg branch_hazard;

    always @(*)
        begin
            case (BranchOp)
                3'h4:       // beq
                    branch_hazard <= In1 == In2;
                3'h7:       // bgtz
                    branch_hazard <= ~(In1[31] || | In1);
                3'h6:       // blez
                    branch_hazard <= In1[31] || ~| In1;
                3'h1:       // bgez, bltz
                    branch_hazard <= (flag == 5'b00001) ? ~In1[31] :
                        (flag == 5'b0) ? In1[31] : 0;
                3'h5:       // bne
                    branch_hazard <= ~(In1 == In2);
                default:
                branch_hazard <= 0;
            endcase
        end

endmodule