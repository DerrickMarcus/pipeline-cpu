// ./src/ForwardingUnit.v
module ForwardingUnit(
        input [5-1:0] EX_RegRs,
        input [5-1:0] EX_RegRt,
        input MEM_RegWrite,
        input MEM_MemWrite,
        input [5-1:0] MEM_RegRt,
        input [5-1:0] MEM_RegWrAddr,
        input WB_RegWrite,
        input WB_MemRead,
        input [5-1:0] WB_RegWrAddr,

        output [1:0] ALU_forwardA,
        output [1:0] ALU_forwardB,
        output MEM_forward
    );

    // forwarding to EX stage: select ALU operands
    // ALU_forwardA/B=
    // 00: read data from the Register File
    // 01: forward ALUOut from EX_MEM to EX
    // 10: forward ALUOut from MEM_WB to EX
    // 11: forward MemReadData from MEM_WB to EX
    assign ALU_forwardA =
           (MEM_RegWrite && MEM_RegWrAddr != 0 && EX_RegRs == MEM_RegWrAddr) ? 1 :
           (WB_MemRead && WB_RegWrAddr != 0 && EX_RegRs == WB_RegWrAddr) ? 3 :
           (WB_RegWrite && WB_RegWrAddr != 0 && EX_RegRs == WB_RegWrAddr) ? 2 : 0;

    assign ALU_forwardB =
           (MEM_RegWrite && MEM_RegWrAddr != 0 && EX_RegRt == MEM_RegWrAddr) ? 1 :
           (WB_MemRead && WB_RegWrAddr != 0 && EX_RegRt == WB_RegWrAddr) ? 3 :
           (WB_RegWrite && WB_RegWrAddr != 0 && EX_RegRt == WB_RegWrAddr) ? 2 : 0;

    // forwarding to MEM stage: select the data to be written to the Data Memory
    // MEM_forward=
    // 0: read data from the Register File
    // 1: forward MemReadData from MEM_WB to MEM
    assign MEM_forward =
           (WB_MemRead && MEM_MemWrite && WB_RegWrAddr != 0 && MEM_RegRt == WB_RegWrAddr) ? 1 : 0;

endmodule // ForwardingUnit
