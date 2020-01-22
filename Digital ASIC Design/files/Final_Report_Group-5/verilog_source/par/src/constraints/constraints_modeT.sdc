#######################################################################
# Copyright (C) 2019 Oscar Castaneda (oc66@cornell.edu), ETH Zurich,
#                    and University of Bologna
# This script is used specifically for Cornell ECE5746.
# Do not share or distribute this script.
# Do not post it in a public repository.
#######################################################################

#Create clock
set CLK_PERIOD  [expr 4*$CLK_PNR]
set IN_DEL_MIN  0.1
set IN_DEL_MAX  0.1
set OUT_DEL_MIN 0.0
set OUT_DEL_MAX 0.0

create_clock -name Clk_clk -period $CLK_PERIOD [ get_ports Clk_CI ]
set_clock_transition 0.2  [get_clocks Clk_clk]
set_propagated_clock [get_clocks Clk_clk]

set_input_delay   -min [expr $IN_DEL_MIN ] -clock Clk_clk [remove_from_collection [get_ports *I] [get_ports {Clk_CI}]]
set_input_delay   -max [expr $IN_DEL_MAX ] -clock Clk_clk [remove_from_collection [get_ports *I] [get_ports {Clk_CI}]]
set_output_delay  -min [expr $OUT_DEL_MIN] -clock Clk_clk [get_ports *O]
set_output_delay  -max [expr $OUT_DEL_MAX] -clock Clk_clk [get_ports *O]

#Drivers and loads
set_driving_cell -no_design_rule -lib_cell INVX4 -pin ZN -from_pin INP [all_inputs]
set_load             0.01 [get_ports *O]
