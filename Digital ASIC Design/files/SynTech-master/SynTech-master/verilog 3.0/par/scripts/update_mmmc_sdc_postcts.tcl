#######################################################################
# Copyright (C) 2019 Oscar Castaneda (oc66@cornell.edu), ETH Zurich,
#                    and University of Bologna
# This script is used specifically for Cornell ECE5746.
# Do not share or distribute this script.
# Do not post it in a public repository.
#######################################################################

update_constraint_mode -name func_mode \
                       -sdc_files [list src/constraints/constraints_mode0.sdc \
                                        src/constraints/latencies_mode0_postcts.sdc \
                                  ]
                                  
update_constraint_mode -name hold_mode \
                       -sdc_files [list src/constraints/constraints_modeH.sdc \
                                        src/constraints/latencies_mode0_postcts.sdc \
                                  ]

update_constraint_mode -name test_mode \
                       -sdc_files [list src/constraints/constraints_modeT.sdc \
                                        src/constraints/latencies_mode0_postcts.sdc \
                                  ]                                                                    

set_analysis_view -update_timing
