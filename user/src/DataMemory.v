// ./src/DataMemory.v

module DataMemory(
        input reset,
        input clk,
        input MemRead,
        input MemWrite,
        input [32-1:0] Address,
        input [32-1:0] Write_data,
        output [32-1:0] Read_data,
        output reg [4-1:0] Tube_display, // select which tube to display
        output reg [8-1:0] Tube_segment // 8-segment digital tube
        // output [8-1:0] UART_TXD,
        // output [8-1:0] UART_RXD,
        // output [9-1:0] UART_CON
    );

    // RAM size is 512 words, each word is 32 bits, valid address is 9 bits
    parameter RAM_SIZE = 512;
    parameter RAM_SIZE_BIT = 9; // 2^9 = 512

    // RAM_data is an array of 512 32-bit registers
    reg [31:0] RAM_data [RAM_SIZE - 1: 0];

    // read data from RAM_data as Read_data
    // assign Read_data = MemRead ? RAM_data[Address[RAM_SIZE_BIT + 1 : 2]] : 32'h00000000;
    assign Read_data = (MemRead == 0) ? 32'h00000000 :
           (Address == 32'h40000010) ? {20'h0, Tube_display, Tube_segment} :
           //    (Address == 32'h40000018) ? {24'h0, UART_TXD} :
           //    (Address == 32'h4000001C) ? {24'h0, UART_RXD} :
           //    (Address == 32'h40000020) ? {23'h0, UART_CON} :
           RAM_data[Address[RAM_SIZE_BIT + 1 : 2]];

    // write Write_data to RAM_data at clock posedge
    integer i;
    always @(posedge reset or posedge clk) begin
        if (reset) begin
            // -------- Set Data Memory Configuration Below
            Tube_display <= 4'h0;
            Tube_segment <= 8'h00;
            RAM_data[0] <= 32'h00000014;
            RAM_data[1] <= 32'h000041a8;
            RAM_data[2] <= 32'h00003af2;
            RAM_data[3] <= 32'h0000acda;
            RAM_data[4] <= 32'h00000c2b;
            RAM_data[5] <= 32'h0000b783;
            RAM_data[6] <= 32'h0000dac9;
            RAM_data[7] <= 32'h00008ed9;
            RAM_data[8] <= 32'h000009ff;
            RAM_data[9] <= 32'h00002f44;
            RAM_data[10] <= 32'h0000044e;
            RAM_data[11] <= 32'h00009899;
            RAM_data[12] <= 32'h00003c56;
            RAM_data[13] <= 32'h0000128d;
            RAM_data[14] <= 32'h0000dbe3;
            RAM_data[15] <= 32'h0000d4b4;
            RAM_data[16] <= 32'h00003748;
            RAM_data[17] <= 32'h00003918;
            RAM_data[18] <= 32'h00004112;
            RAM_data[19] <= 32'h0000c399;
            RAM_data[20] <= 32'h00004955;
            for (i = 21; i < RAM_SIZE; i = i + 1) begin
                RAM_data[i] <= 32'h00000000;
            end
            // -------- Set Data Memory Configuration Above
        end

        else if (MemWrite) begin
            if (Address == 32'h40000010) begin
                Tube_display <= Write_data[11:8];
                Tube_segment <= Write_data[7:0];
            end
            // else if (Address == 32'h40000018) begin
            //     UART_TXD <= Write_data[7:0];
            // end
            // else if (Address == 32'h4000001C) begin
            //     UART_RXD <= Write_data[7:0];
            // end
            // else if (Address == 32'h40000020) begin
            //     UART_CON <= Write_data[7:0];
            // end
            else if (Address < 32'h40000000) begin
                RAM_data[Address[RAM_SIZE_BIT + 1 : 2]] <= Write_data;
            end
        end
    end

endmodule // DataMemory
