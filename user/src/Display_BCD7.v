// ./src/Display_BCD7.v

module Display_BCD7(
        input reset,
        input clk,
        input [15:0] display_data,
        output reg [3:0] tube_select,
        output reg [7:0] tube_segment
    );

    reg clk_1K;
    parameter CNT = 16'd50_000; // (100M/1K)/2
    reg [15:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'd0;
            clk_1K <= 1'b0;
        end
        else begin
            count <= (count == CNT - 16'd1) ? 16'd0 : count + 16'd1;
            clk_1K <= (count == 16'd0) ? ~clk_1K : clk_1K;
        end
    end

    always @(posedge reset or posedge clk_1K) begin
        if (reset) begin
            tube_select <= 4'b0;
        end
        else begin
            case (tube_select)
                4'b1000:
                    tube_select <= 4'b0100;
                4'b0100:
                    tube_select <= 4'b0010;
                4'b0010:
                    tube_select <= 4'b0001;
                4'b0001:
                    tube_select <= 4'b1000;
                default:
                    tube_select <= 4'b1000;
            endcase
        end
    end

    reg [3:0] temp_data;
    always @(*) begin
        case (tube_select)
            4'b1000:
                temp_data = display_data[15:12];
            4'b0100:
                temp_data = display_data[11:8];
            4'b0010:
                temp_data = display_data[7:4];
            4'b0001:
                temp_data = display_data[3:0];
            default:
                temp_data = 4'b0000;
        endcase
    end

    always @(*) begin
        case (temp_data)
            4'h0:
                tube_segment <= 8'b00111111;
            4'h1:
                tube_segment <= 8'b00000110;
            4'h2:
                tube_segment <= 8'b01011011;
            4'h3:
                tube_segment <= 8'b01001111;
            4'h4:
                tube_segment <= 8'b01100110;
            4'h5:
                tube_segment <= 8'b01101101;
            4'h6:
                tube_segment <= 8'b01111101;
            4'h7:
                tube_segment <= 8'b00000111;
            4'h8:
                tube_segment <= 8'b01111111;
            4'h9:
                tube_segment <= 8'b01101111;
            4'ha:
                tube_segment <= 8'b01110111;
            4'hb:
                tube_segment <= 8'b01111100;
            4'hc:
                tube_segment <= 8'b00111001;
            4'hd:
                tube_segment <= 8'b01011110;
            4'he:
                tube_segment <= 8'b01111001;
            4'hf:
                tube_segment <= 8'b01110001;
            default:
                tube_segment <= 8'b00000000;
        endcase
    end

endmodule //Display_BCD7


