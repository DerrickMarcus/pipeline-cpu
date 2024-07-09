// ./src/IF_ID_Reg.v

module IF_ID_Reg(
        input reset,
        input clk,
        input IF_flush,
        input IF_stall,
        input [32-1:0] IF_Instruction,
        input [32-1:0] IF_PC,
        output reg [32-1:0] ID_Instruction,
        output reg [32-1:0] ID_PC
    );

    always @(posedge clk or posedge reset) begin
        if (reset || IF_flush) begin
            ID_Instruction <= 32'b0;
            ID_PC <= 32'b0;
        end
        else if (!IF_stall) begin
            ID_Instruction <= IF_Instruction;
            ID_PC <= IF_PC;
        end
    end

endmodule // IF_ID_Reg
