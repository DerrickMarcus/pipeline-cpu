// ./src/GenerateCLK.v
// Generate a clock 20ns from 100MHz sysclk
module GenerateCLK(
        input sysclk,
        input reset,
        output reg clk
    );
    always @(posedge sysclk or posedge reset) begin
        if (reset) begin
            clk <= 1;
        end
        else begin
            clk <= ~clk;
        end
    end

endmodule
