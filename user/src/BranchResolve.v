// ./src/BranchResolve.v

module BranchResolve(
        input [3-1:0] BranchType,
        input [32-1:0] in1,
        input [32-1:0] in2,
        output reg branch_taken
    );

    always @(*) begin
        case (BranchType)
            3'h1:
                branch_taken <= (in1 == in2); // beq
            3'h2:
                branch_taken <= (in1 != in2); // bne
            3'h3:
                branch_taken <= (in1[31] == 1 || in1 == 0); // blez
            3'h4:
                branch_taken <= (in1[31] == 0 && in1 != 0); // bgtz
            3'h5:
                branch_taken <= (in1[31] == 1); // bltz
            3'h6:
                branch_taken <= (in1[31] == 0); // bgez
            default:
                branch_taken <= 0;
        endcase
    end

endmodule // BranchResolve
