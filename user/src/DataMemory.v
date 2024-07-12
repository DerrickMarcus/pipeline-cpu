// ./src/DataMemory.v

module DataMemory(
        input reset,
        input clk,
        input MemRead,
        input MemWrite,
        input [32-1:0] Address,
        input [32-1:0] Write_data,
        output [32-1:0] Read_data,
        output reg [4-1:0] tube_select, // select which tube to display
        output reg [8-1:0] tube_segment // 8-segment digital tube
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
    assign Read_data = (MemRead == 0) ? 32'h0000_0000 :
           (Address == 32'h4000_0010) ? {20'h0, tube_select, tube_segment} :
           //    (Address == 32'h4000_0018) ? {24'h0, UART_TXD} :
           //    (Address == 32'h4000_001C) ? {24'h0, UART_RXD} :
           //    (Address == 32'h4000_0020) ? {23'h0, UART_CON} :
           RAM_data[Address[RAM_SIZE_BIT + 1 : 2]];

    // write Write_data to RAM_data at clock posedge
    integer i;
    always @(posedge reset or posedge clk) begin
        if (reset) begin
            // -------- Set Data Memory Configuration Below
            tube_select <= 4'h0;
            tube_segment <= 8'h0;

            RAM_data[0] <= 32'h00000014; // 20
            RAM_data[1] <= 32'h000041a8; // 16808
            RAM_data[2] <= 32'h00003af2; // 15090
            RAM_data[3] <= 32'h0000acda; // 44250
            RAM_data[4] <= 32'h00000c2b; // 3115
            RAM_data[5] <= 32'h0000b783; // 46979
            RAM_data[6] <= 32'h0000dac9; // 56009
            RAM_data[7] <= 32'h00008ed9; // 36569
            RAM_data[8] <= 32'h000009ff; // 2559
            RAM_data[9] <= 32'h00002f44; // 12100
            RAM_data[10] <= 32'h0000044e; // 1102
            RAM_data[11] <= 32'h00009899; // 39065
            RAM_data[12] <= 32'h00003c56; // 15446
            RAM_data[13] <= 32'h0000128d; // 4749
            RAM_data[14] <= 32'h0000dbe3; // 56291
            RAM_data[15] <= 32'h0000d4b4; // 54452
            RAM_data[16] <= 32'h00003748; // 14152
            RAM_data[17] <= 32'h00003918; // 14616
            RAM_data[18] <= 32'h00004112; // 16658
            RAM_data[19] <= 32'h0000c399; // 50073
            RAM_data[20] <= 32'h00004955; // 18773
            for (i = 21; i < RAM_SIZE; i = i + 1) begin
                RAM_data[i] <= 32'h00000000;
            end

            // -------- Set Data Memory Configuration Above
        end

        else if (MemWrite) begin
            if (Address == 32'h4000_0010) begin
                tube_select <= Write_data[11:8];
                tube_segment <= Write_data[7:0];
            end
            // else if (Address == 32'h4000_0018) begin
            //     UART_TXD <= Write_data[7:0];
            // end
            // else if (Address == 32'h4000_001C) begin
            //     UART_RXD <= Write_data[7:0];
            // end
            // else if (Address == 32'h4000_0020) begin
            //     UART_CON <= Write_data[7:0];
            // end
            else if (Address < 32'h4000_0000) begin
                RAM_data[Address[RAM_SIZE_BIT + 1 : 2]] <= Write_data;
            end
        end
    end

endmodule // DataMemory
