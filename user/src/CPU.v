// ./src/CPU.v

module CPU(
        input reset,
        input clk,
        // input [32-1:0] Device_Read_Data,
        // output MemRead,
        // output MemWrite,
        // output [32-1:0] MemBus_Address,
        // output [32-1:0] MemBus_Write_Data,
        output [3:0] Tube_display,
        output [7:0] Tube_segment
    );

    // all stage registers begin
    wire [4:0] flush;
    wire [4:0] stall;
    // IF
    wire [31:0] IF_Instruction;
    reg [31:0] IF_PC;
    // ID
    wire [31:0] ID_Instruction;
    wire [31:0] ID_PC;
    wire [1:0] ID_PCSrc;
    wire ID_RegWrite;
    wire [1:0] ID_RegDst;
    wire ID_MemRead;
    wire ID_MemWrite;
    wire [1:0] ID_MemtoReg;
    wire ID_ALUSrc1;
    wire ID_ALUSrc2;
    wire ID_ExtOp;
    wire ID_LuOp;
    wire [3:0] ID_ALUOp;
    wire [31:0] ID_ExtImm;
    wire [31:0] ID_RegReadDataA;
    wire [31:0] ID_RegReadDataB;
    wire [4:0] ID_RegRs;
    wire [4:0] ID_RegRt;
    wire [4:0] ID_RegWrAddr;
    // EX
    wire [31:0] EX_PC;
    wire EX_RegWrite;
    wire EX_MemRead;
    wire EX_MemWrite;
    wire [1:0] EX_MemtoReg;
    wire EX_ALUSrc1;
    wire EX_ALUSrc2;
    wire [3:0] EX_ALUOp;
    wire [31:0] EX_ExtImm;
    wire [31:0] EX_RegReadDataA;
    wire [31:0] EX_RegReadDataB;
    wire [4:0] EX_RegRs;
    wire [4:0] EX_RegRt;
    wire [4:0] EX_RegWrAddr;
    wire [31:0] EX_ALUOut;
    // MEM
    wire [31:0] MEM_PC;
    wire MEM_RegWrite;
    wire MEM_MemRead;
    wire MEM_MemWrite;
    wire [1:0] MEM_MemtoReg;
    wire [31:0] MEM_ALUOut;
    wire [31:0] MEM_MemReadData;
    wire [31:0] MEM_RegRtData;
    wire [4:0] MEM_RegRt;
    wire [4:0] MEM_RegWrAddr;
    // WB
    wire [31:0] WB_PC;
    wire WB_RegWrite;
    wire WB_MemRead;
    wire [1:0] WB_MemtoReg;
    wire [31:0] WB_ALUOut;
    wire [31:0] WB_MemReadData;
    wire [4:0] WB_RegWrAddr;
    wire [31:0] WB_RegWriteData;
    // all stage registers end

    // IF stage
    wire [31:0] IF_PC_plus_4;
    wire [31:0] IF_PC_next;

    assign IF_PC_plus_4 = IF_PC + 32'h0000_0004;

    wire [31:0] BranchAddr;
    wire [31:0] JumpAddr;
    wire [31:0] RegisterAddr;

    // calculate the next PC
    assign IF_PC_next =
           (ID_PCSrc == 2'b01) ? BranchAddr :
           (ID_PCSrc == 2'b10) ? JumpAddr :
           (ID_PCSrc == 2'b11) ? RegisterAddr :
           IF_PC_plus_4;

    // update PC
    always @(posedge reset or posedge clk)
        if (reset)
            IF_PC <= 32'h0000_0000;
        else
            IF_PC <= IF_PC_next;

    // Instruction Memory
    InstructionMemory u_InstructionMemory(
                          .Address(IF_PC),
                          .Instruction(IF_Instruction)
                      );

    // register IF_ID
    IF_ID_Reg u_IF_ID_Reg(
                  .reset(reset),
                  .clk(clk),
                  .IF_flush(flush[4]),
                  .IF_stall(stall[4]),
                  .IF_Instruction(IF_Instruction),
                  .IF_PC(IF_PC),
                  .ID_Instruction(ID_Instruction),
                  .ID_PC(ID_PC)
              );

    // ID stage and WB stage

    // decode to generate control signals
    Control u_Control(
                .OpCode(ID_Instruction[31:26]),
                .Funct(ID_Instruction[5:0]),
                .PCSrc(ID_PCSrc),
                .RegWrite(ID_RegWrite),
                .RegDst(ID_RegDst),
                .MemRead(ID_MemRead),
                .MemWrite(ID_MemWrite),
                .MemtoReg(ID_MemtoReg),
                .ALUSrc1(ID_ALUSrc1),
                .ALUSrc2(ID_ALUSrc2),
                .ExtOp(ID_ExtOp),
                .LuOp(ID_LuOp),
                .ALUOp(ID_ALUOp)
            );

    // write and read data from RegisterFile
    assign ID_RegRs = ID_Instruction[25:21];
    assign ID_RegRt = ID_Instruction[20:16];
    assign ID_RegWrAddr =
           (ID_RegDst == 2'b00) ? ID_Instruction[20:16] :
           (ID_RegDst == 2'b01) ? ID_Instruction[15:11] : 5'b11111;
    assign WB_RegWriteData =
           (WB_MemtoReg == 2'b01) ?  WB_MemReadData :
           (WB_MemtoReg == 2'b10) ? (WB_PC + 32'h0000_0004) : WB_ALUOut;

    RegisterFile u_RegisterFile(
                     .reset(reset),
                     .clk(clk),
                     .RegWrite(WB_RegWrite),
                     .Read_register1(ID_RegRs),
                     .Read_register2(ID_RegRt),
                     .Write_register(WB_RegWrAddr),
                     .Write_data(WB_RegWriteData),
                     .Read_data1(ID_RegReadDataA),
                     .Read_data2(ID_RegReadDataB)
                 );

    // extend immediate: sign or zero or lui
    assign ID_ExtImm =
           ID_LuOp ? {ID_Instruction[15:0], 16'h0000} :
           { ID_ExtOp ? {16{ID_Instruction[15]}}: 16'h0000, ID_Instruction[15:0]};

    // forward to solve the data hazard caused by branch or jump
    wire branch_jump_forward1;
    wire branch_jump_forward2;

    BranchJumpForwarding u_BranchJumpForwarding(
                             .MEM_RegWrite(MEM_RegWrite),
                             .MEM_RegWrAddr(MEM_RegWrAddr),
                             .ID_RegRs(ID_RegRs),
                             .ID_RegRt(ID_RegRt),
                             .Forward1(branch_jump_forward1),
                             .Forward2(branch_jump_forward2)
                         );

    // resolve branch in advance
    wire [31:0] branch_in1;
    wire [31:0] branch_in2;
    assign branch_in1 = branch_jump_forward1 ? MEM_ALUOut : ID_RegReadDataA;
    assign branch_in2 = branch_jump_forward2 ? MEM_ALUOut : ID_RegReadDataB;
    wire branch_taken;

    BranchResolve u_BranchResolve(
                      .OpCode_RegImm(ID_Instruction[31:26]),
                      .Inst_Rt(ID_Instruction[20:16]),
                      .in1(branch_in1),
                      .in2(branch_in2),
                      .branch_taken(branch_taken)
                  );

    // solve control hazard
    HazardUnit u_HazardUnit(
                   .ID_RegRs(ID_RegRs),
                   .ID_RegRt(ID_RegRt),
                   .ID_PCSrc(ID_PCSrc),
                   .branch_taken(branch_taken),
                   .EX_MemRead(EX_MemRead),
                   .EX_RegWrite(EX_RegWrite),
                   .EX_RegWrAddr(EX_RegWrAddr),
                   .MEM_MemRead(MEM_MemRead),
                   .MEM_RegWrAddr(MEM_RegWrAddr),
                   .flush(flush),
                   .stall(stall)
               );

    assign BranchAddr = ID_PC + 32'h0000_0004 + (branch_taken ? {ID_ExtImm[29:0], 2'b00} : 32'h0000_0000);
    assign JumpAddr = {ID_PC[31:28], ID_Instruction[25:0], 2'b00};
    assign RegisterAddr = branch_in1;

    // register ID_EX
    ID_EX_Reg u_ID_EX_Reg(
                  .reset(reset),
                  .clk(clk),
                  .ID_flush(flush[3]),
                  .ID_stall(stall[3]),
                  .ID_PC(ID_PC),
                  .ID_RegWrite(ID_RegWrite),
                  .ID_MemRead(ID_MemRead),
                  .ID_MemWrite(ID_MemWrite),
                  .ID_MemtoReg(ID_MemtoReg),
                  .ID_ALUSrc1(ID_ALUSrc1),
                  .ID_ALUSrc2(ID_ALUSrc2),
                  .ID_ALUOp(ID_ALUOp),
                  .ID_ExtImm(ID_ExtImm),
                  .ID_RegReadDataA(ID_RegReadDataA),
                  .ID_RegReadDataB(ID_RegReadDataB),
                  .ID_RegRs(ID_RegRs),
                  .ID_RegRt(ID_RegRt),
                  .ID_RegWrAddr(ID_RegWrAddr),
                  .EX_PC(EX_PC),
                  .EX_RegWrite(EX_RegWrite),
                  .EX_MemRead(EX_MemRead),
                  .EX_MemWrite(EX_MemWrite),
                  .EX_MemtoReg(EX_MemtoReg),
                  .EX_ALUSrc1(EX_ALUSrc1),
                  .EX_ALUSrc2(EX_ALUSrc2),
                  .EX_ALUOp(EX_ALUOp),
                  .EX_ExtImm(EX_ExtImm),
                  .EX_RegReadDataA(EX_RegReadDataA),
                  .EX_RegReadDataB(EX_RegReadDataB),
                  .EX_RegRs(EX_RegRs),
                  .EX_RegRt(EX_RegRt),
                  .EX_RegWrAddr(EX_RegWrAddr)
              );

    // EX stage
    wire [4:0] EX_ALUCtl;
    wire EX_Sign;
    ALUControl u_ALUControl(
                   .ALUOp(EX_ALUOp),
                   .Funct(EX_ExtImm[5:0]),
                   .ALUCtl(EX_ALUCtl),
                   .Sign(EX_Sign)
               );

    // forward to update register data read in the last cycle
    wire [1:0] ALU_forwardA;
    wire [1:0] ALU_forwardB;
    wire MEM_forward;

    ForwardingUnit u_ForwardingUnit(
                       .EX_RegRs(EX_RegRs),
                       .EX_RegRt(EX_RegRt),
                       .MEM_RegWrite(MEM_RegWrite),
                       .MEM_MemWrite(MEM_MemWrite),
                       .MEM_RegRt(MEM_RegRt),
                       .MEM_RegWrAddr(MEM_RegWrAddr),
                       .WB_RegWrite(WB_RegWrite),
                       .WB_MemRead(WB_MemRead),
                       .WB_RegWrAddr(WB_RegWrAddr),
                       .ALU_forwardA(ALU_forwardA),
                       .ALU_forwardB(ALU_forwardB),
                       .MEM_forward(MEM_forward)
                   );

    wire [31:0] EX_RegRsData;
    wire [31:0] EX_RegRtData;
    assign EX_RegRsData =
           (ALU_forwardA == 2'b01) ? MEM_ALUOut :
           (ALU_forwardA == 2'b10) ? WB_ALUOut :
           (ALU_forwardA == 2'b11) ? WB_MemReadData : EX_RegReadDataA;
    assign EX_RegRtData =
           (ALU_forwardB == 2'b01) ? MEM_ALUOut :
           (ALU_forwardB == 2'b10) ? WB_ALUOut :
           (ALU_forwardB == 2'b11) ? WB_MemReadData : EX_RegReadDataB;

    // select the ALU operands
    wire [31:0] ALU_in1;
    wire [31:0] ALU_in2;
    assign ALU_in1 = EX_ALUSrc1 ? {27'h0, EX_ExtImm[10:6]} : EX_RegRsData; // EX_shamt = EX_ExtImm[10:6]
    assign ALU_in2 = EX_ALUSrc2 ? EX_ExtImm : EX_RegRtData;

    ALU u_ALU(
            .in1(ALU_in1),
            .in2(ALU_in2),
            .ALUCtl(EX_ALUCtl),
            .Sign(EX_Sign),
            .out(EX_ALUOut)
        );

    // register EX_MEM
    EX_MEM_Reg u_EX_MEM_Reg(
                   .reset(reset),
                   .clk(clk),
                   .EX_flush(flush[2]),
                   .EX_stall(stall[2]),
                   .EX_PC(EX_PC),
                   .EX_RegWrite(EX_RegWrite),
                   .EX_MemRead(EX_MemRead),
                   .EX_MemWrite(EX_MemWrite),
                   .EX_MemtoReg(EX_MemtoReg),
                   .EX_ALUOut(EX_ALUOut),
                   .EX_RegRtData(EX_RegRtData),
                   .EX_RegRt(EX_RegRt),
                   .EX_RegWrAddr(EX_RegWrAddr),
                   .MEM_PC(MEM_PC),
                   .MEM_RegWrite(MEM_RegWrite),
                   .MEM_MemRead(MEM_MemRead),
                   .MEM_MemWrite(MEM_MemWrite),
                   .MEM_MemtoReg(MEM_MemtoReg),
                   .MEM_ALUOut(MEM_ALUOut),
                   .MEM_RegRtData(MEM_RegRtData),
                   .MEM_RegRt(MEM_RegRt),
                   .MEM_RegWrAddr(MEM_RegWrAddr)
               );

    // MEM stage
    wire [31:0] MEM_MemWriteData;
    assign MEM_MemWriteData = MEM_forward ? WB_MemReadData : MEM_RegRtData;


    // assign Device_Read_Data = MEM_MemReadData;
    // assign MemRead = MEM_MemRead;
    // assign MemWrite = MEM_MemWrite;
    // assign MemBus_Address = MEM_ALUOut;
    // assign MemBus_Write_Data = MEM_MemWriteData;
    DataMemory u_DataMemory(
                   .reset(reset),
                   .clk(clk),
                   .MemRead(MEM_MemRead),
                   .MemWrite(MEM_MemWrite),
                   .Address(MEM_ALUOut),
                   .Write_data(MEM_MemWriteData),
                   .Read_data(MEM_MemReadData),
                   .Tube_display(Tube_display),
                   .Tube_segment(Tube_segment)
               );

    // register MEM_WB
    MEM_WB_Reg u_MEM_WB_Reg(
                   .reset(reset),
                   .clk(clk),
                   .MEM_flush(flush[1]),
                   .MEM_stall(stall[1]),
                   .MEM_PC(MEM_PC),
                   .MEM_RegWrite(MEM_RegWrite),
                   .MEM_MemRead(MEM_MemRead),
                   .MEM_MemtoReg(MEM_MemtoReg),
                   .MEM_ALUOut(MEM_ALUOut),
                   .MEM_MemReadData(MEM_MemReadData),
                   .MEM_RegWrAddr(MEM_RegWrAddr),
                   .WB_PC(WB_PC),
                   .WB_RegWrite(WB_RegWrite),
                   .WB_MemRead(WB_MemRead),
                   .WB_MemtoReg(WB_MemtoReg),
                   .WB_ALUOut(WB_ALUOut),
                   .WB_MemReadData(WB_MemReadData),
                   .WB_RegWrAddr(WB_RegWrAddr)
               );

    // WB stage
    // already finished in u_RegisterFile

endmodule // CPU
