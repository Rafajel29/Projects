#######################################################################
# Copyright (C) 2019 Oscar Castaneda (oc66@cornell.edu), ETH Zurich,
#                    and University of Bologna
# This script is used specifically for Cornell ECE5746.
# Do not share or distribute this script.
# Do not post it in a public repository.
#######################################################################

set CLK_UNCERTAINTY 0.02

set_clock_uncertainty   $CLK_UNCERTAINTY [get_clocks Clk_clk]
