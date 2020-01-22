#!/bin/sh

module load synopsys-dc-2016.12

#dc_shell-xg-t -topo -64 -output_log_file dc_syn.log -f scripts/synth.tcl
dc_shell-xg-t -output_log_file dc_syn.log -f scripts/synth.tcl
