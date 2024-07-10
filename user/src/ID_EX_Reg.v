// ./src/ID_EX_Reg.v

module ID_EX_Reg(
        input reset,
        input clk,
        input stall_IF_ID,
        input [32-1:0] ID_PC,
        input ID_RegWrite,
        input ID_MemRead,
        input ID_MemWrite,
        input [2-1:0] ID_MemtoReg,
        input ID_ALUSrc1,
        input ID_ALUSrc2,
        input [4-1:0] ID_ALUOp,
        input [32-1:0] ID_ExtImm,
        input [32-1:0] ID_RegReadDataA,
        input [32-1:0] ID_RegReadDataB,
        input [5-1:0] ID_RegRs,
        input [5-1:0] ID_RegRt,
        input [5-1:0] ID_RegWrAddr,

        output reg [32-1:0] EX_PC,
        output reg EX_RegWrite,
        output reg EX_MemRead,
        output reg EX_MemWrite,
        output reg [2-1:0] EX_MemtoReg,
        output reg EX_ALUSrc1,
        output reg EX_ALUSrc2,
        output reg [4-1:0] EX_ALUOp,
        output reg [32-1:0] EX_ExtImm,
        output reg [32-1:0] EX_RegReadDataA,
        output reg [32-1:0] EX_RegReadDataB,
        output reg [5-1:0] EX_RegRs,
        output reg [5-1:0] EX_RegRt,
        output reg [5-1:0] EX_RegWrAddr
    );

    always @(posedge reset or posedge clk) begin
        if (reset || stall_IF_ID) begin
            EX_PC <= 32'b0;
            EX_RegWrite <= 1'b0;
            EX_MemRead <= 1'b0;
            EX_MemWrite <= 1'b0;
            EX_MemtoReg <= 2'b0;
            EX_ALUSrc1 <= 1'b0;
            EX_ALUSrc2 <= 1'b0;
            EX_ALUOp <= 4'b0;
            EX_ExtImm <= 32'b0;
            EX_RegReadDataA <= 32'b0;
            EX_RegReadDataB <= 32'b0;
            EX_RegRs <= 5'b0;
            EX_RegRt <= 5'b0;
            EX_RegWrAddr <= 5'b0;
        end
        else begin
            EX_PC <= ID_PC;
            EX_RegWrite <= ID_RegWrite;
            EX_MemRead <= ID_MemRead;
            EX_MemWrite <= ID_MemWrite;
            EX_MemtoReg <= ID_MemtoReg;
            EX_ALUSrc1 <= ID_ALUSrc1;
            EX_ALUSrc2 <= ID_ALUSrc2;
            EX_ALUOp <= ID_ALUOp;
            EX_ExtImm <= ID_ExtImm;
            EX_RegReadDataA <= ID_RegReadDataA;
            EX_RegReadDataB <= ID_RegReadDataB;
            EX_RegRs <= ID_RegRs;
            EX_RegRt <= ID_RegRt;
            EX_RegWrAddr <= ID_RegWrAddr;
        end
    end

endmodule // ID_EX_Reg
