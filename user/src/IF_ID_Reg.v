// ./src/IF_ID_Reg.v

module IF_ID_Reg(
        input reset,
        input clk,
        input flush_IF,
        input stall_IF_ID,
        input [32-1:0] IF_Instruction,
        input [32-1:0] IF_PC,
        output reg [32-1:0] ID_Instruction,
        output reg [32-1:0] ID_PC
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ID_Instruction <= 32'b0;
            ID_PC <= 32'b0;
        end
        else begin
            if (flush_IF && !stall_IF_ID) begin
                ID_Instruction <= 32'b0;
                ID_PC <= 32'b0;
            end
            else if (stall_IF_ID) begin
                ID_Instruction <= ID_Instruction;
                ID_PC <= ID_PC;
            end
            else begin
                ID_Instruction <= IF_Instruction;
                ID_PC <= IF_PC;
            end
        end
    end

endmodule // IF_ID_Reg
