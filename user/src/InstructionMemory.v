// ./src/InstructionMemory.v

module InstructionMemory(
        input [32-1:0] Address,
        output reg [32-1:0] Instruction
    );

    always @(*)
    case (Address[9:2])
        // -------- Set Binary Instruction Below
        8'd0:
            Instruction <= 32'h01512000;
        // -------- Set Binary Instruction Above
        default:
            Instruction <= 32'h00000000;
    endcase

endmodule // InstructionMemory
