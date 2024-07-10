// ./src/GenerateClk_1Hz.v
// generate a 1Hz clock from the 100MHz system clock

`timescale 1ns / 1ps

module GenerateClk_1Hz(
        input clk,
        input reset,
        output reg clk_1Hz
    );

    parameter CNT = 32'd50_000_000; // (100M/1)/2
    reg [31:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 32'd0;
            clk_1Hz <= 1'b0;
        end
        else begin
            count <= (count == CNT - 32'd1) ? 32'd0 : count + 32'd1;
            clk_1Hz <= (count == 32'd0) ? ~clk_1Hz : clk_1Hz;
        end
    end

endmodule
