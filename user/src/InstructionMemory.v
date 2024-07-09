// ./src/InstructionMemory.v

module InstructionMemory(
        input [32-1:0] Address,
        output reg [32-1:0] Instruction
    );

    always @(*)
    case (Address[9:2])
        // -------- Set Binary Instruction Below
        8'd0:
            Instruction <= 32'h24040000;
        8'd1:
            Instruction <= 32'h8c850000;
        8'd2:
            Instruction <= 32'h20840004;
        8'd3:
            Instruction <= 32'h24080000;
        8'd4:
            Instruction <= 32'h0c100006;
        8'd5:
            Instruction <= 32'h08100005;
        8'd6:
            Instruction <= 32'h23bdfff4;
        8'd7:
            Instruction <= 32'hafbf0008;
        8'd8:
            Instruction <= 32'hafa40004;
        8'd9:
            Instruction <= 32'hafa50000;
        8'd10:
            Instruction <= 32'h24090001;
        8'd11:
            Instruction <= 32'h0125082a;
        8'd12:
            Instruction <= 32'h10200006;
        8'd13:
            Instruction <= 32'h00093021;
        8'd14:
            Instruction <= 32'h0c100018;
        8'd15:
            Instruction <= 32'h00023821;
        8'd16:
            Instruction <= 32'h0c100028;
        8'd17:
            Instruction <= 32'h21290001;
        8'd18:
            Instruction <= 32'h0810000b;
        8'd19:
            Instruction <= 32'h8fa50000;
        8'd20:
            Instruction <= 32'h8fa40004;
        8'd21:
            Instruction <= 32'h8fbf0008;
        8'd22:
            Instruction <= 32'h23bd000c;
        8'd23:
            Instruction <= 32'h03e00008;
        8'd24:
            Instruction <= 32'h00065080;
        8'd25:
            Instruction <= 32'h008a5020;
        8'd26:
            Instruction <= 32'h8d4b0000;
        8'd27:
            Instruction <= 32'h20ccffff;
        8'd28:
            Instruction <= 32'h29810000;
        8'd29:
            Instruction <= 32'h14200008;
        8'd30:
            Instruction <= 32'h21080001;
        8'd31:
            Instruction <= 32'h000c6880;
        8'd32:
            Instruction <= 32'h008d6820;
        8'd33:
            Instruction <= 32'h8dae0000;
        8'd34:
            Instruction <= 32'h016e082a;
        8'd35:
            Instruction <= 32'h10200002;
        8'd36:
            Instruction <= 32'h218cffff;
        8'd37:
            Instruction <= 32'h0810001c;
        8'd38:
            Instruction <= 32'h21820001;
        8'd39:
            Instruction <= 32'h03e00008;
        8'd40:
            Instruction <= 32'h00065080;
        8'd41:
            Instruction <= 32'h008a5020;
        8'd42:
            Instruction <= 32'h8d4b0000;
        8'd43:
            Instruction <= 32'h20ccffff;
        8'd44:
            Instruction <= 32'h0187082a;
        8'd45:
            Instruction <= 32'h14200006;
        8'd46:
            Instruction <= 32'h000c6880;
        8'd47:
            Instruction <= 32'h008d6820;
        8'd48:
            Instruction <= 32'h8dae0000;
        8'd49:
            Instruction <= 32'hadae0004;
        8'd50:
            Instruction <= 32'h218cffff;
        8'd51:
            Instruction <= 32'h0810002c;
        8'd52:
            Instruction <= 32'h00076880;
        8'd53:
            Instruction <= 32'h008d6820;
        8'd54:
            Instruction <= 32'hadab0000;
        8'd55:
            Instruction <= 32'h03e00008;
        // -------- Set Binary Instruction Above
        default:
            Instruction <= 32'h00000000;
    endcase

endmodule // InstructionMemory
