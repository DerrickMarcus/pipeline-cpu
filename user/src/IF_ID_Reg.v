// ./src/IF_ID_Reg.v

module IF_ID_Reg(
        input reset,
        input clk,
        input flush_IF,
        input stall_IF_ID,
        input [32-1:0] IF_PC,
        input [32-1:0] IF_Instruction,
        output reg [32-1:0] ID_PC,
        output reg [32-1:0] ID_Instruction
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ID_PC <= 32'b0;
            ID_Instruction <= 32'b0;
        end
        else begin
            if (flush_IF && !stall_IF_ID) begin
                ID_PC <= 32'b0;
                ID_Instruction <= 32'b0;
            end
            else if (stall_IF_ID) begin
                ID_PC <= ID_PC;
                ID_Instruction <= ID_Instruction;
            end
            else begin
                ID_PC <= IF_PC;
                ID_Instruction <= IF_Instruction;
            end
        end
    end

endmodule // IF_ID_Reg
