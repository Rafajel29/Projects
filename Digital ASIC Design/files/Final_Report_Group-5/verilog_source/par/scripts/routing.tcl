#######################################################################
# Copyright (C) 2019 Oscar Castaneda (oc66@cornell.edu), ETH Zurich,
#                    and University of Bologna
# This script is used specifically for Cornell ECE5746.
# Do not share or distribute this script.
# Do not post it in a public repository.
#######################################################################

#######################################################################
#Clock Tree Synthesis
#######################################################################

source scripts/update_mmmc_sdc_postcts.tcl

setNanoRouteMode -routeBottomRoutingLayer 2
setNanoRouteMode -routeTopRoutingLayer    9

set_ccopt_property buffer_cells [ list NBUFFX2 \
                                       NBUFFX4 \
                                       NBUFFX8 \
                                       NBUFFX16 \
                                       NBUFFX32 ]

set_ccopt_property inverter_cells [ list INVX1 \
                                         INVX2 \
                                         INVX4 \
                                         INVX8 \
                                         INVX16 \
                                         INVX32 ]

set_ccopt_property clock_gating_cells [ list CGLPPRX2 \
                                             CGLPPRX8 ]

set_ccopt_property source_max_capacitance 3pf

create_ccopt_clock_tree_spec -file scripts/ccopt.tcl
source scripts/ccopt.tcl

ccopt_design -outDir reports/02_timedesign_ccopt

report_ccopt_clock_trees -filename reports/clock_trees.rpt
report_ccopt_skew_groups -filename reports/skew_groups.rpt

timeDesign       -postCTS -expandedViews -outDir reports/03_timedesign_postcts
timeDesign -hold -postCTS -expandedViews -outDir reports/03_timedesign_postcts

optDesign -postCTS -hold
optDesign -postCTS -hold

timeDesign       -postCTS -expandedViews -outDir reports/04_timedesign_postctsOpt
timeDesign -hold -postCTS -expandedViews -outDir reports/04_timedesign_postctsOpt

saveDesign save/${DESIGNNAME}_cts.enc

#######################################################################
#Route
#######################################################################

set fillers "SHFILL128 SHFILL64 SHFILL3 SHFILL2 SHFILL1"
addFiller -cell $fillers -prefix FILLCORE

setNanoRouteMode -routeBottomRoutingLayer 2
setNanoRouteMode -routeTopRoutingLayer    9
setNanoRouteMode -routeAntennaCellName "ANTENNA"
setNanoRouteMode -quiet -routeInsertAntennaDiode true

setNanoRouteMode -quiet -routeWithTimingDriven   true
setNanoRouteMode -quiet -routeWithSiDriven       true
setNanoRouteMode -quiet -routeWithViaInPin true

routeDesign -globalDetail

deleteFiller -prefix FILLCORE

setExtractRCMode -engine postRoute
setExtractRCMode -effortLevel low
setDelayCalMode -siAware false

saveDesign save/${DESIGNNAME}_route.enc

#######################################################################
#Time optimization
#######################################################################

source scripts/update_mmmc_sdc_postroute.tcl

timedesign -postRoute       -expandedViews -outDir reports/05_timedesign_postroute
timedesign -postRoute -hold -expandedViews -outDir reports/05_timedesign_postroute

optDesign -postRoute -setup -hold
optDesign -postRoute -hold

setNanoRouteMode -quiet -routeWithTimingDriven false
checkRoute
addFiller -cell $fillers -prefix FILLCORE
ecoRoute -target
checkFiller

timedesign -postRoute       -expandedViews -outDir reports/06_timedesign_postrouteOpt
timedesign -postRoute -hold -expandedViews -outDir reports/06_timedesign_postrouteOpt

#search and repair loop to fix remaining drc violations

verify_drc -limit 100000
setNanoRouteMode -reset
setNanoRouteMode -routeWithECO true
setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -routeAntennaCellName "ANTENNA"
globalDetailRoute

verify_drc -limit 100000
ecoRoute -fix_drc

#end of loop

saveDesign save/${DESIGNNAME}_fixdrc.enc 
