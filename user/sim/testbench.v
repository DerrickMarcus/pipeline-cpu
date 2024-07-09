// ./sim/testbench.v

module testbench();

    reg reset;
    reg clk;
    wire MemRead;
    wire MemWrite;
    wire [31:0] MemBus_Address;
    wire [31:0] MemBus_Write_Data;
    wire [31:0] Device_Read_Data;

    CPU u_CPU(
            .reset(reset),
            .clk(clk),
            .MemBus_Address(MemBus_Address),
            .Device_Read_Data(Device_Read_Data),
            .MemBus_Write_Data(MemBus_Write_Data),
            .MemRead(MemRead),
            .MemWrite(MemWrite)
        );

    initial begin
        reset = 1;
        clk = 1;
        #100 reset = 0;
    end

    always #50 clk = ~clk;

endmodule
