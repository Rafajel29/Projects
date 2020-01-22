#######################################################################
# Copyright (C) 2019 Oscar Castaneda (oc66@cornell.edu), ETH Zurich,
#                    and University of Bologna
# This script is used specifically for Cornell ECE5746.
# Do not share or distribute this script.
# Do not post it in a public repository.
#######################################################################

update_delay_corner -name DC_all_wc_0v81 -library_set LS_wc_0v81_125 -rc_corner worst_rc -power_domain PD_CORE

update_delay_corner -name DC_all_bc_0v99 -library_set LS_bc_0v99_125 -rc_corner best_rc -power_domain PD_CORE