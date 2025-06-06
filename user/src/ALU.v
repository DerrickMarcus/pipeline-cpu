// ./src/ALU.v

module ALU(
        input [32-1:0] in1,
        input [32-1:0] in2,
        input [5-1:0] ALUCtl,
        input Sign,
        output reg [32-1:0] out
    );

    wire ss;
    assign ss = {in1[31], in2[31]};

    wire lt_31;
    assign lt_31 = (in1[30:0] < in2[30:0]);

    // lt_signed means whether (in1 < in2)
    wire lt_signed;
    assign lt_signed = (in1[31] ^ in2[31])?
           ((ss == 2'b01)? 0: 1): lt_31;


    // different ALU operations
    always @(*)
    case (ALUCtl)
        5'b00000:
            out <= in1 & in2; // and
        5'b00001:
            out <= in1 | in2; // or
        5'b00010:
            out <= in1 + in2; // add
        5'b00110:
            out <= in1 - in2; // sub
        5'b00111:
            out <= {31'h0000_0000, Sign ? lt_signed: (in1 < in2)}; // slt
        5'b01100:
            out <= ~(in1 | in2); // nor
        5'b01101:
            out <= in1 ^ in2; // xor
        5'b10000:
            out <= (in2 << in1[4:0]); // sll
        5'b11000:
            out <= (in2 >> in1[4:0]); // srl
        5'b11001:
            out <= ({{32{in2[31]}}, in2} >> in1[4:0]); // sra
        5'b11010:
            out <= in1 * in2; // mul
        default:
            out <= 32'h0000_0000;
    endcase

endmodule // ALU
