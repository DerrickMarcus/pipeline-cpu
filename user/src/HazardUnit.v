// ./src/HazardUnit.v
module HazardUnit(
        input [5-1:0] ID_RegRs,
        input [5-1:0] ID_RegRt,
        input [1:0] ID_PCSrc,
        input ID_MemWrite,
        input branch_taken,
        input EX_MemRead,
        input EX_RegWrite,
        input [5-1:0] EX_RegWrAddr,
        input MEM_MemRead,
        input [5-1:0] MEM_RegWrAddr,

        output flush_IF,
        output stall_IF_ID
    );

    // flush has higher priority than stall
    // when to flush IF: jump hazard, branch hazard
    assign flush_IF = (ID_PCSrc == 2'b00 || (ID_PCSrc == 2'b01 && branch_taken == 0)) ? 0 : 1;

    // when to stall IF and ID: load-use hazard, data hazard caused by branch or jump
    assign stall_IF_ID =
           (!ID_MemWrite && EX_MemRead && EX_RegWrAddr != 0 && (EX_RegWrAddr == ID_RegRs || EX_RegWrAddr == ID_RegRt)) // load-use, except load-store
           ||
           (ID_MemWrite && EX_MemRead && EX_RegWrAddr != 0 && EX_RegWrAddr == ID_RegRs) // sw use the reg that lw writes in for calculating the address
           ||
           (
               ID_PCSrc == 2'b01 // data hazard caused by branch
               &&
               (
                   (EX_RegWrite && EX_RegWrAddr != 0 && (EX_RegWrAddr == ID_RegRs || EX_RegWrAddr == ID_RegRt))
                   ||
                   (MEM_MemRead && MEM_RegWrAddr != 0 && (MEM_RegWrAddr == ID_RegRs || MEM_RegWrAddr == ID_RegRt))
               )
           )
           ||
           (
               ID_PCSrc == 2'b11 // data hazad caused by jr or jalr
               &&
               (
                   (EX_RegWrite && EX_RegWrAddr != 0 && EX_RegWrAddr == ID_RegRs)
                   ||
                   (MEM_MemRead && MEM_RegWrAddr != 0 && MEM_RegWrAddr == ID_RegRs)
               )
           ) ? 1 : 0;

endmodule // HazardUnit
