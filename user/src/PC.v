// ./src/PC.v

module PC(
        input reset,
        input clk,
        input stall_IF_ID,
        input [1:0] ID_PCSrc,
        input [31:0] BranchAddr,
        input [31:0] JumpAddr,
        input [31:0] RegisterAddr,
        output reg [31:0] IF_PC
    );

    always @(posedge reset or posedge clk)
        if (reset)
            IF_PC <= 32'h0;
        else begin
            if (stall_IF_ID)
                IF_PC <= IF_PC;
            else
                IF_PC <=
                      (ID_PCSrc == 2'b01) ? BranchAddr :
                      (ID_PCSrc == 2'b10) ? JumpAddr :
                      (ID_PCSrc == 2'b11) ? RegisterAddr :
                      IF_PC + 32'h4;
        end

endmodule
