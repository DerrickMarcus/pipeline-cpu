// ./src/Control.v

module Control(
        input [6-1:0] OpCode,
        input [6-1:0] Funct,
        //  input [5-1:0] Inst_Rt,
        //  output [3-1:0] Branch,
        output [2-1:0] PCSrc,
        output RegWrite,
        output [2-1:0] RegDst,
        output MemRead,
        output MemWrite,
        output [2-1:0] MemtoReg,
        output ALUSrc1,
        output ALUSrc2,
        output ExtOp,
        output LuOp,
        output [4-1:0] ALUOp
    );

    // PCSrc: 1-branch. 2-j,jal. 3-jr,jalr. 0-else
    assign PCSrc[1:0] =
           (OpCode == 6'h04 || OpCode == 6'h05 || OpCode == 6'h06 || OpCode == 6'h7 || OpCode == 6'h01) ? 1 :
           (OpCode == 6'h02 || OpCode == 6'h03) ? 2 :
           (OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09)) ? 3 : 0;

    //     // Branch: 1-beq. 2-bne. 3-blez. 4-bgtz. 5-bltz, 6-bgez. 0-else
    //     // if Branch decision in ID, comment this part
    //     assign Branch[2:0] =
    //            (OpCode == 6'h04) ? 1 :
    //            (OpCode == 6'h05) ? 2 :
    //            (OpCode == 6'h06) ? 3 :
    //            (OpCode == 6'h07) ? 4 :
    //            (OpCode == 6'h01 && Inst_Rt == 6'h00) ? 5 :
    //            (OpCode == 6'h01 && Inst_Rt == 6'h01) ? 6 : 0;

    // RegWrite: 0-sw,beq,j,jr. 1-else
    assign RegWrite =
           (OpCode == 6'h2b || OpCode == 6'h04 || OpCode == 6'h02 || (OpCode == 6'h0 && Funct == 6'h08)) ? 0 : 1;

    // RegDst: 0-I type:lw,lui,addi,addiu,andi,ori,slti,sltiu.
    // 1-R type(including jalr). 2-jal.
    assign RegDst[1:0] =
           (OpCode == 6'h23 || OpCode == 6'h0f || OpCode == 6'h08 || OpCode == 6'h09 || OpCode == 6'h0c || OpCode == 6'h0d || OpCode == 6'h0a || OpCode == 6'h0b) ? 0 :
           (OpCode == 6'h03) ? 2 : 1;

    // MemRead: 1-lw. 0-else
    assign MemRead = (OpCode == 6'h23) ? 1 : 0;

    // MemWrite: 1-sw. 0-else
    assign MemWrite = (OpCode == 6'h2b) ? 1 : 0;

    // MemtoReg: 1-lw. 2-jal,jalr. 0-else
    assign MemtoReg[1:0] = (OpCode == 6'h23) ? 1 :
           (OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09)) ? 2 : 0;

    // ALUSrc1: 1-sll,srl,sra. 0-else
    assign ALUSrc1 =
           (OpCode == 6'h00 && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03)) ? 1 : 0;

    // ALUSrc2: 1-I type:lw,sw,lui,addi,addiu,andi,ori,slti,sltiu. 0-else
    assign ALUSrc2 =
           (OpCode == 6'h23 || OpCode == 6'h2b || OpCode == 6'h0f || OpCode == 6'h08 || OpCode == 6'h09 || OpCode == 6'h0c || OpCode == 6'h0d || OpCode == 6'h0a || OpCode == 6'h0b) ? 1 : 0;

    // ExtOp: 0-andi,ori. 1-else
    assign ExtOp = (OpCode == 6'h0c || OpCode == 6'h0d) ? 0 : 1;

    // LuOp: 1-lui. 0-else
    assign LuOp = (OpCode == 6'h0f) ? 1 : 0;

    // set ALUOp
    assign ALUOp[2:0] =
           (OpCode == 6'h00) ? 3'b010 : // R type
           //     (OpCode == 6'h04) ? 3'b001 : // beq
           (OpCode == 6'h0c) ? 3'b100 : // andi
           (OpCode == 6'h0d) ? 3'b011 : // ori
           (OpCode == 6'h0a || OpCode == 6'h0b) ? 3'b101 : // slti,sltiu
           (OpCode == 6'h1c && Funct == 6'h02) ? 3'b110 : // mul
           3'b000; // lw,sw,lui,addi,addiu

    assign ALUOp[3] = OpCode[0];

endmodule // Control
