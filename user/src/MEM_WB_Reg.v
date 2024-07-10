// ./src/MEM_EX_Reg.v
module MEM_WB_Reg(
        input reset,
        input clk,
        // input MEM_flush,
        // input MEM_stall,
        input [32-1:0] MEM_PC,
        input MEM_RegWrite,
        input MEM_MemRead,
        input [2-1:0] MEM_MemtoReg,
        input [32-1:0] MEM_ALUOut,
        input [32-1:0] MEM_MemReadData,
        input [5-1:0] MEM_RegWrAddr,

        output reg [32-1:0] WB_PC,
        output reg WB_RegWrite,
        output reg WB_MemRead,
        output reg [2-1:0] WB_MemtoReg,
        output reg [32-1:0] WB_ALUOut,
        output reg [32-1:0] WB_MemReadData,
        output reg [5-1:0] WB_RegWrAddr
    );

    always @(posedge reset or posedge clk) begin
        if (reset) begin
            WB_PC <= 32'b0;
            WB_RegWrite <= 1'b0;
            WB_MemRead <= 1'b0;
            WB_MemtoReg <= 2'b0;
            WB_ALUOut <= 32'b0;
            WB_MemReadData <= 32'b0;
            WB_RegWrAddr <= 5'b0;
        end
        else begin
            WB_PC <= MEM_PC;
            WB_RegWrite <= MEM_RegWrite;
            WB_MemRead <= MEM_MemRead;
            WB_MemtoReg <= MEM_MemtoReg;
            WB_ALUOut <= MEM_ALUOut;
            WB_MemReadData <= MEM_MemReadData;
            WB_RegWrAddr <= MEM_RegWrAddr;
        end
    end

endmodule // MEM_WB_Reg
