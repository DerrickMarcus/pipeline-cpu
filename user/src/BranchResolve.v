// ./src/BranchResolve.v

module BranchResolve(
        input [6-1:0] OpCode_RegImm,
        input [5-1:0] Inst_Rt,
        input [32-1:0] in1,
        input [32-1:0] in2,
        output reg branch_taken
    );

    always @(*) begin
        case (OpCode_RegImm)
            6'h04:
                branch_taken <= (in1 == in2); // beq
            6'h05:
                branch_taken <= (in1 != in2); // bne
            6'h06:
                branch_taken <= (in1[31] == 1 || in1 == 0); // blez
            6'h07:
                branch_taken <= (in1[31] == 0 && in1 != 0); // bgtz
            6'h01:
                if (Inst_Rt == 5'h01)
                    branch_taken <= (in1[31] == 0); // bgez
                else if (Inst_Rt == 5'h00)
                    branch_taken <= (in1[31] == 1); // bltz
                else
                    branch_taken <= 0;
            default:
                branch_taken <= 0;
        endcase
    end

endmodule // BranchResolve
