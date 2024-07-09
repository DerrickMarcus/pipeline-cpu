// ./src/ALUControl.v

module ALUControl(
        input [4-1:0] ALUOp,
        input [6-1:0] Funct,
        output reg [5-1:0] ALUCtl,
        output Sign
    );

    // funct number for different operation
    parameter aluAND = 5'b00000;
    parameter aluOR  = 5'b00001;
    parameter aluADD = 5'b00010;
    parameter aluSUB = 5'b00110;
    parameter aluSLT = 5'b00111;
    parameter aluNOR = 5'b01100;
    parameter aluXOR = 5'b01101;
    parameter aluSLL = 5'b10000;
    parameter aluSRL = 5'b11000;
    parameter aluSRA = 5'b11001;
    parameter aluMUL = 5'b11010;

    // Sign means whether the ALU treats the input as a signed number or an unsigned number
    assign Sign = (ALUOp[2:0] == 3'b010) ? ~Funct[0] : ~ALUOp[3];

    // set aluFunct
    reg [4:0] aluFunct;
    always @(*)
    case (Funct)
        6'b00_0000:
            aluFunct <= aluSLL; // 0x0,sll
        6'b00_0010:
            aluFunct <= aluSRL; // 0x2,srl
        6'b00_0011:
            aluFunct <= aluSRA; // 0x3,sra
        6'b10_0000:
            aluFunct <= aluADD; // 0x20,add
        6'b10_0001:
            aluFunct <= aluADD; // 0x21,addu
        6'b10_0010:
            aluFunct <= aluSUB; // 0x22,sub
        6'b10_0011:
            aluFunct <= aluSUB; // 0x23,subu
        6'b10_0100:
            aluFunct <= aluAND; // 0x24,and
        6'b10_0101:
            aluFunct <= aluOR; // 0x25,or
        6'b10_0110:
            aluFunct <= aluXOR; // 0x26,xor
        6'b10_0111:
            aluFunct <= aluNOR; // 0x27,nor
        6'b10_1010:
            aluFunct <= aluSLT; // 0x2a,slt
        6'b10_1011:
            aluFunct <= aluSLT; // 0x2b,sltu
        default:
            aluFunct <= aluADD;
    endcase

    // set ALUCtrl
    always @(*)
    case (ALUOp[2:0])
        3'b000:
            ALUCtl <= aluADD; // lw,sw,lui,addi,addiu
        // 3'b001:
        //     ALUCtl <= aluSUB; // beq
        3'b100:
            ALUCtl <= aluAND; // andi
        3'b011:
            ALUCtl <= aluOR; // ori
        3'b101:
            ALUCtl <= aluSLT; // slti,sltiu
        3'b010:
            ALUCtl <= aluFunct; // R type
        3'b110:
            ALUCtl <= aluMUL; // mul
        default:
            ALUCtl <= aluADD;
    endcase


endmodule // ALUControl
