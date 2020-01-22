#######################################################################
# Copyright (C) 2019 Oscar Castaneda (oc66@cornell.edu), ETH Zurich,
#                    and University of Bologna
# This script is used specifically for Cornell ECE5746.
# Do not share or distribute this script.
# Do not post it in a public repository.
#######################################################################

#######################################################################
#Placement
#######################################################################

setRouteMode -earlyGlobalMinRouteLayer 2
setRouteMode -earlyGlobalMaxRouteLayer 9

setPlaceMode -place_global_cong_effort high \
             -place_global_timing_effort medium \
             -place_global_clock_gate_aware true \
             -place_global_clock_power_driven true \
             -place_detail_legalization_inst_gap 1 \
             -place_global_reorder_scan false
             
setAnalysisMode -analysisType onChipVariation -cppr both

place_opt_design -out_dir reports/01_placed_opt_design_prects

setTieHiLoMode -cell {TIEH TIEL} -maxDistance 20 -maxFanout 10
addTieHiLo -prefix TIEHILOW

checkPlace

timeDesign -preCTS -expandedViews -outDir reports/01_timedesign_prects

saveDesign save/${DESIGNNAME}_placed.enc
