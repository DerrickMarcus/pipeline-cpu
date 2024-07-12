// ./sim/testbench.v

module testbench();

    reg reset;
    reg clk;
    // wire MemRead;
    // wire MemWrite;
    // wire [31:0] MemBus_Address;
    // wire [31:0] MemBus_Write_Data;
    // wire [31:0] Device_Read_Data;
    wire [3:0] tube_select;
    wire [7:0] tube_segment;

    CPU u_CPU(
            .reset(reset),
            .clk(clk),
            // .MemBus_Address(MemBus_Address),
            // .Device_Read_Data(Device_Read_Data),
            // .MemBus_Write_Data(MemBus_Write_Data),
            // .MemRead(MemRead),
            // .MemWrite(MemWrite)
            .tube_select(tube_select),
            .tube_segment(tube_segment)
        );

    initial begin
        reset = 1;
        clk = 1;
        #100 reset = 0;
    end

    always #50 clk = ~clk; // T=100ns, f=10MHz

endmodule
