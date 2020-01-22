#######################################################################
# Copyright (C) 2019 Oscar Castaneda (oc66@cornell.edu), ETH Zurich,
#                    and University of Bologna
# This script is used specifically for Cornell ECE5746.
# Do not share or distribute this script.
# Do not post it in a public repository.
#######################################################################

setNanoRouteMode -droutePostRouteSpreadWire true
routeDesign -wireOpt

#TODO: Do drc verification here

saveDesign save/${DESIGNNAME}_postRouteOpt.enc

timedesign -postRoute       -expandedViews -outDir reports/07_timedesign_final
timedesign -postRoute -hold -expandedViews -outDir reports/07_timedesign_final

deleteEmptyModule

source scripts/update_mmmc_sdc_signoff.tcl

timedesign -postRoute       -expandedViews -outDir reports/08_timedesign_final
timedesign -postRoute -hold -expandedViews -outDir reports/08_timedesign_final

write_lef_abstract out/${DESIGNNAME}.lef -stripePin

set_global timing_recompute_sdf_in_setuphold_mode true
write_sdf -precision 4 -min_period_edges posedge -recompute_parallel_arcs -nonegchecks \
          -min_view [lindex [all_hold_analysis_views]  0] \
          -typ_view [lindex [all_setup_analysis_views]  0] \
          -max_view [lindex [all_setup_analysis_views]  0] \
          out/${DESIGNNAME}.sdf.gz
          
#For simulation
saveNetlist out/${DESIGNNAME}.v -excludeLeafCell

# To create the GDS file that we would submit for fabrication, you would run commands like the ones below.
# However, here we comment this part out, as this is an education library that we cannot send for fabrication
#(plus the size of these files is quite large!)

#setStreamOutMode -SEvianames true -specifyViaName %t_%v -virtualConnection false
#streamOut "/work/local/ece5746/students/${DESIGNFULL}.gds.gz"

saveDesign save/${DESIGNNAME}_final.enc
