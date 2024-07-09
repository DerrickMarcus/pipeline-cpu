// ./src/BranchJumpForwarding.v

module BranchJumpForwarding(
        input MEM_RegWrite,
        input [5-1:0] MEM_RegWrAddr,
        input [5-1:0] ID_RegRs,
        input [5-1:0] ID_RegRt,

        output Forward1,
        output Forward2
    );
    // solve data hazard when branch and jump instructions read Register Files
    // used to update PC in the ID stage
    // 0: no forwarding
    // 1: forward from EX_MEM to ID
    assign Forward1 =
           (MEM_RegWrite && MEM_RegWrAddr != 0 && ID_RegRs == MEM_RegWrAddr) ? 1 : 0;

    assign Forward2 =
           (MEM_RegWrite && MEM_RegWrAddr != 0 && ID_RegRt == MEM_RegWrAddr) ? 1 : 0;

endmodule // BranchJumpForwarding
