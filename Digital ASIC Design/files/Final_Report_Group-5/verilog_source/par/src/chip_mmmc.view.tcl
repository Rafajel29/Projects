#######################################################################
# Copyright (C) 2019 Oscar Castaneda (oc66@cornell.edu), ETH Zurich,
#                    and University of Bologna
# This script is used specifically for Cornell ECE5746.
# Do not share or distribute this script.
# Do not post it in a public repository.
#######################################################################

set cell_path "/work/global/brg/install/adk-pkgs/saed-90nm/pkgs/SAED_EDK90nm_01252011/SAED_EDK90nm/Digital_Standard_cell_Library/synopsys/models"

create_library_set -name l_wc \
   -timing \
    [list $cell_path/saed90nm_max.lib]
	
create_library_set -name l_tc \
   -timing \
    [list $cell_path/saed90nm_typ.lib]
	
create_library_set -name l_bc \
   -timing \
    [list $cell_path/saed90nm_min.lib ]
   
# RC corners
# Here, usually a captable or QRC file is provided. However, we do not have those available for the educational library.
create_rc_corner -name rc_typical
create_rc_corner -name rc_worst    -T 125
create_rc_corner -name rc_best     -T 0

# Delay corners

create_delay_corner -name dc_typ -library_set l_tc -rc_corner rc_typical
update_delay_corner -name dc_typ -library_set l_tc -rc_corner rc_typical -power_domain PD_CORE

create_delay_corner -name dc_max -library_set l_wc -rc_corner rc_worst
update_delay_corner -name dc_max -library_set l_wc -rc_corner rc_worst -power_domain PD_CORE

create_delay_corner -name dc_min -library_set l_bc -rc_corner rc_best
update_delay_corner -name dc_min -library_set l_bc -rc_corner rc_best -power_domain PD_CORE

#Constraint mode
create_constraint_mode -name func_mode \
                       -sdc_files [list src/constraints/constraints_mode0.sdc \
                                        src/constraints/latencies_mode0_prects.sdc \
                                  ]
                                  
create_constraint_mode -name hold_mode \
                       -sdc_files [list src/constraints/constraints_modeH.sdc \
                                        src/constraints/latencies_mode0_prects.sdc \
                                  ]
                                  
create_constraint_mode -name test_mode \
                       -sdc_files [list src/constraints/constraints_modeT.sdc \
                                        src/constraints/latencies_mode0_prects.sdc \
                                  ]                                                                                                      
                                                                    
# Analysis views
create_analysis_view -name func_tc -constraint_mode func_mode -delay_corner dc_typ
create_analysis_view -name func_wc -constraint_mode func_mode -delay_corner dc_max

create_analysis_view -name hold_tc     -constraint_mode hold_mode -delay_corner dc_typ
create_analysis_view -name hold_wc     -constraint_mode hold_mode -delay_corner dc_max
create_analysis_view -name hold_bc     -constraint_mode hold_mode -delay_corner dc_min

create_analysis_view -name test_wc -constraint_mode test_mode -delay_corner dc_max

# Specify analysis views to use
set_analysis_view -setup {func_wc func_tc test_wc} -hold {hold_bc hold_tc hold_wc}
