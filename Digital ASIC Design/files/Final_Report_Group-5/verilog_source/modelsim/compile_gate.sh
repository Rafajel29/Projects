#/bin/bash
module load mentor-modelsim-de-10.7a

rm -rf work
vlib work

vlog -work work \
     -v "/work/global/brg/install/adk-pkgs/saed-90nm/pkgs/SAED_EDK90nm_01252011/SAED_EDK90nm/Digital_Standard_cell_Library/verilog/saed90nm.v" \
	 ../par/out/FLT_120.0ns.v
vlog -work work ../tb/FLT_POST_TB.v
