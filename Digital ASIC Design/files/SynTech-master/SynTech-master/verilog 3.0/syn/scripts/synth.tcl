################################################################################################################################
set DESIGN_NAME "FLT"
#Set up number of cores
set_host_option -max_core $NUM_CORES

#Clean previous designs
remove_design -designs
sh rm -rf work/*


################################################################################################################################

#Analyze design
#Verilog files
analyze -library work -format verilog { \
	../src/FF.v \
	../src/DW_div_seq.v\
	/opt/synopsys/M-2016.12/synopsys-dc-M-2016.12/dw/dw02/src_ver/DW_sincos.v\
	../src/FLT.v \
}


#Elaborate design (with default parameters)
elaborate ${DESIGN_NAME} -library work

current_design ${DESIGN_NAME}

################################################################################################################################

#Define constraints

set CLK_PERIOD  120.0
#set CLK_UNCERT  0.0
#set CLK_LAT_MAX 1
#set CLK_LAT_MIN 0.9
#set IN_DEL_MIN  0.2
#set IN_DEL_MAX  0.2
#set OUT_DEL_MIN 0.2
#set OUT_DEL_MAX 0.2
#
#create_clock           Clk_CI        -period $CLK_PERIOD
#set_clock_uncertainty  $CLK_UNCERT  [ get_clocks Clk_CI ]
#set_clock_transition   0.2          [ get_clocks Clk_CI ]
#set_clock_latency -max $CLK_LAT_MAX [ get_clocks Clk_CI ]
#set_clock_latency -min $CLK_LAT_MIN [ get_clocks Clk_CI ]
#
#set_input_delay   -min [expr $IN_DEL_MIN ] -clock Clk_CI [remove_from_collection [all_inputs] [get_ports {Clk_CI}]]
#set_input_delay   -max [expr $IN_DEL_MAX ] -clock Clk_CI [remove_from_collection [all_inputs] [get_ports {Clk_CI}]]
#set_output_delay  -min [expr $OUT_DEL_MIN] -clock Clk_CI [all_outputs]
#set_output_delay  -max [expr $OUT_DEL_MAX] -clock Clk_CI [all_outputs]
#
##set_driving_cell -no_design_rule -library sc9mcpp140_cln28hpc_base_svt_c30_ss_cworst_max_0p81v_125c -lib_cell INV_X1M_A9PP140TS_C30 -pin Y [all_inputs]
#set_driving_cell saed90nm_typ -lib_cell INVX4 -pin ZN [all_inputs]
#set_load 0.01 [all_outputs]

create_clock Clk_CI -period $CLK_PERIOD;
set_clock_transition 0.2 [get_clocks Clk_CI];
set_input_delay 0.2 -clock Clk_CI [remove_from_collection [all_inputs] [get_ports Clk_CI]];
set_driving_cell -library saed90nm_typ -lib_cell INVX4 -pin ZN [all_inputs];
set_load 0.01 [all_outputs];


################################################################################################################################

#Compile design
compile_ultra -no_autoungroup


check_design

################################################################################################################################

#Reports
report_timing -max_paths 5 > ./reports/${DESIGN_NAME}_${CLK_PERIOD}ns_timing_max.rpt
report_timing -delay min -max_paths 5 > ./reports/${DESIGN_NAME}_${CLK_PERIOD}ns_timing_min.rpt
report_area -physical -hierarchy > ./reports/${DESIGN_NAME}_${CLK_PERIOD}ns_area.rpt
#report_power -net -cell -hierarchy > ./reports/${DESIGN_NAME}_${CLK_PERIOD}ns_power.rpt

################################################################################################################################

#Add dummy nets for unconnected pins /Not used in quentin nor mr wolf
define_name_rules verilog -add_dummy_nets
define_name_rules verilog -replacement_char x
define_name_rules verilog -case_insensitive

#Save the design database
write -format ddc -hierarchy -output ./outputs/${DESIGN_NAME}_${CLK_PERIOD}ns.ddc  
#Change names for Verilog
change_names -rule verilog -hierarchy

write_sdc -nosplit ./outputs/${DESIGN_NAME}_${CLK_PERIOD}ns.sdc
write -format verilog -hierarchy -output ./outputs/${DESIGN_NAME}_${CLK_PERIOD}ns.v
write_parasitics -format distributed -output ./outputs/${DESIGN_NAME}_${CLK_PERIOD}ns.spef 
write_sdf ./outputs/${DESIGN_NAME}_${CLK_PERIOD}ns.sdf
