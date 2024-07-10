// ./src/EX_MEM_Reg.v

module EX_MEM_Reg(
        input reset,
        input clk,
        // input EX_flush,
        // input EX_stall,
        input [32-1:0] EX_PC,
        input EX_RegWrite,
        input EX_MemRead,
        input EX_MemWrite,
        input [2-1:0] EX_MemtoReg,
        input [32-1:0] EX_ALUOut,
        input [32-1:0] EX_RegRtData,
        input [5-1:0] EX_RegRt,
        input [5-1:0] EX_RegWrAddr,

        output reg [32-1:0] MEM_PC,
        output reg MEM_RegWrite,
        output reg MEM_MemRead,
        output reg MEM_MemWrite,
        output reg [2-1:0] MEM_MemtoReg,
        output reg [32-1:0] MEM_ALUOut,
        output reg [32-1:0] MEM_RegRtData,
        output reg [5-1:0] MEM_RegRt,
        output reg [5-1:0] MEM_RegWrAddr
    );

    always @(posedge reset or posedge clk) begin
        if (reset) begin
            MEM_PC <= 32'b0;
            MEM_RegWrite <= 1'b0;
            MEM_MemRead <= 1'b0;
            MEM_MemWrite <= 1'b0;
            MEM_MemtoReg <= 2'b0;
            MEM_ALUOut <= 32'b0;
            MEM_RegRtData <= 32'b0;
            MEM_RegRt <= 5'b0;
            MEM_RegWrAddr <= 5'b0;
        end
        else begin
            MEM_PC <= EX_PC;
            MEM_RegWrite <= EX_RegWrite;
            MEM_MemRead <= EX_MemRead;
            MEM_MemWrite <= EX_MemWrite;
            MEM_MemtoReg <= EX_MemtoReg;
            MEM_ALUOut <= EX_ALUOut;
            MEM_RegRtData <= EX_RegRtData;
            MEM_RegRt <= EX_RegRt;
            MEM_RegWrAddr <= EX_RegWrAddr;
        end
    end

endmodule // EX_MEM_Reg
