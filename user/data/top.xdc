# ./data/top.xdc

# create_clock -name clk -period 20.000 [get_ports clk]
create_clock -period 20.000 -name CLK -waveform {0.000 10.000} [get_ports clk]


# create_clock -period 10.000 -name CLK -waveform {0.000 5.000} [get_ports clk]

set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports clk]
set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS33} [get_ports reset]

# LED=tube_segment
set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS33} [get_ports {tube_segment[0]}]
set_property -dict {PACKAGE_PIN P5 IOSTANDARD LVCMOS33} [get_ports {tube_segment[1]}]
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports {tube_segment[2]}]
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports {tube_segment[3]}]
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports {tube_segment[4]}]
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {tube_segment[5]}]
set_property -dict {PACKAGE_PIN W4 IOSTANDARD LVCMOS33} [get_ports {tube_segment[6]}]
set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports {tube_segment[7]}]

# SEL=tube_select
set_property -dict {PACKAGE_PIN Y3 IOSTANDARD LVCMOS33} [get_ports {tube_select[0]}]
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports {tube_select[1]}]
set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {tube_select[2]}]
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports {tube_select[3]}]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {reset}]
