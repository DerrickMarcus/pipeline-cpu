// ./src/InstructionMemory.v

module InstructionMemory(
        input [32-1:0] Address,
        output reg [32-1:0] Instruction
    );

    always @(*)
    case (Address[9:2])
        // -------- Set Binary Instruction Below

        8'd0:
            Instruction <= 32'h20040000;
        8'd1:
            Instruction <= 32'h20050020;
        8'd2:
            Instruction <= 32'h20100000;
        8'd3:
            Instruction <= 32'h8c880000;
        8'd4:
            Instruction <= 32'h8c890004;
        8'd5:
            Instruction <= 32'h71095002;
        8'd6:
            Instruction <= 32'h020a8020;
        8'd7:
            Instruction <= 32'h20840008;
        8'd8:
            Instruction <= 32'h10850001;
        8'd9:
            Instruction <= 32'h08100003;
        8'd10:
            Instruction <= 32'hacb00000;
        8'd11:
            Instruction <= 32'h0810000b;

        // -------- Set Binary Instruction Above
        default:
            Instruction <= 32'h00000000;
    endcase

endmodule // InstructionMemory
