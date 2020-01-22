#######################################################################
# Copyright (C) 2019 Oscar Castaneda (oc66@cornell.edu), ETH Zurich,
#                    and University of Bologna
# This script is used specifically for Cornell ECE5746.
# Do not share or distribute this script.
# Do not post it in a public repository.
#######################################################################

#######################################################################
#  Design Setings
#######################################################################

#TODO: Name of Verilog file produced by synthesis
set DESIGNNAME "FLT_120.0ns"
#TODO: Full name of top-level module in previously indicated Verilog file
set DESIGNFULL FLT
#TODO: Clock constraint for place and route
set CLK_PNR 120

set reportDir reports
set savePrefix ${DESIGNNAME}

#######################################################################
#  General Settings
#######################################################################

setMultiCpuUsage -localCpu 4

setLibraryUnit -time 1ns
setLibraryUnit -cap  1pf

#######################################################################
#  Load Config and Floorplan
#######################################################################

source src/chip.globals
init_design

set_interactive_constraint_modes [all_constraint_modes -active]

#######################################################################
#FLOORPLANNING
#######################################################################

#TODO: Define area for the chip (do not change margins of 14.08)
floorPlan -site unit -d 700 700 14.08 14.08 14.08 14.08
 
#TODO: Change pins
setPinAssignMode -pinEditInBatch True
editPin -cell ${DESIGNFULL} -fixOverlap 1 -spreadDirection clockwise        -edge 0 -layer 3 -spreadType start -unit TRACK -spacing 40 -offsetStart 15 -pin {Addr_DI* PAR_In_DI*}
editPin -cell ${DESIGNFULL} -fixOverlap 1 -spreadDirection clockwise        -edge 1 -layer 3 -spreadType start -unit TRACK -spacing 14 -offsetStart 15 -pin {sta_FLT_In_DI* }
editPin -cell ${DESIGNFULL} -fixOverlap 1 -spreadDirection clockwise        -edge 2 -layer 3 -spreadType start -unit TRACK -spacing 150 -offsetStart 15 -pin {WrEn_SI Clk_CI Rst_RBI}
editPin -cell ${DESIGNFULL} -fixOverlap 1 -spreadDirection clockwise        -edge 3 -layer 3 -spreadType start -unit TRACK -spacing 20 -offsetStart 15 -pin {sta_FLT_Out_DO* FLT_Test_constant2_DO*}


setPinAssignMode -pinEditInBatch False

#######################################################################
#Power Planning
#######################################################################

read_power_intent -cpf src/chip.cpf
commit_power_intent

#Add EndCaps
setEndCapMode -rightEdge DCAP -leftEdge DCAP
addEndCap -powerDomain PD_CORE

#######################################################################
#Power ring and power grid
#######################################################################

deleteAllPowerPreroutes
clearDrc

set cellHeight 2.88
set routeGridH 0.32
set routeGridV 0.32

#Core ring parameters

set pgcr1LayerH M1
set pgcr1LayerV M2
set pgcr2LayerH M3
set pgcr2LayerV M4
set pgcr3LayerH M5
set pgcr3LayerV M6
set pgcr4LayerH M7
set pgcr4LayerV M8

#Manufacturing grid of 0.005
set pgcrSpacing 2.24
set pgcrWidth   4.48
set pgcrOffset  1.92

set pgcrNet "VDD VSS"

#Core grid parameters

set pgcgLayerH $pgcr4LayerH
set pgcgLayerV $pgcr4LayerV

set pgcgNet "VDD VSS"

#Core rings        
addRing -width $pgcrWidth \
        -spacing $pgcrSpacing \
        -offset $pgcrOffset \
        -layer [list bottom $pgcr4LayerH top $pgcr4LayerH right $pgcr4LayerV left $pgcr4LayerV] \
        -nets $pgcrNet \
        -type core_rings \
        -follow core \
        -threshold 0
        
addRing -width $pgcrWidth \
        -spacing $pgcrSpacing \
        -offset $pgcrOffset \
        -layer [list bottom $pgcr3LayerH top $pgcr3LayerH right $pgcr3LayerV left $pgcr3LayerV] \
        -nets $pgcrNet \
        -type core_rings \
        -follow core \
        -threshold 0

addRing -width $pgcrWidth \
        -spacing $pgcrSpacing \
        -offset $pgcrOffset \
        -layer [list bottom $pgcr2LayerH top $pgcr2LayerH right $pgcr2LayerV left $pgcr2LayerV] \
        -nets $pgcrNet \
        -type core_rings \
        -follow core \
        -threshold 0
        
addRing -width $pgcrWidth \
        -spacing $pgcrSpacing \
        -offset $pgcrOffset \
        -layer [list bottom $pgcr1LayerH top $pgcr1LayerH right $pgcr1LayerV left $pgcr1LayerV] \
        -nets $pgcrNet \
        -type core_rings \
        -follow core \
        -threshold 0
          
#Power route for standard cell rows
sroute -connect { corePin } \
       -allowLayerChange 1 \
       -allowJogging 1 \
       -crossoverViaLayerRange [list $pgcr1LayerV $pgcr2LayerV ] \
       -targetViaLayerRange [list $pgcr1LayerV $pgcr2LayerV ] \
       -nets $pgcrNet \
       -corePinWidth 0.160 \
       -corePinLayer $pgcr1LayerH

#Horizontal stripes
addStripe -nets {VDD VSS} \
          -layer $pgcgLayerH \
		  -direction horizontal \
		  -width 0.64 \
		  -spacing 2.24 \
		  -set_to_set_distance 5.76 \
		  -start_from top -start_offset 1.12 \
		  -switch_layer_over_obs false \
		  -max_same_layer_jog_length 2

#Vertical stripes
addStripe -nets {VDD VSS} \
          -layer $pgcgLayerV \
		  -direction vertical \
		  -width 3.2 \
		  -spacing 8.6 \
		  -set_to_set_distance 23.04 \
		  -start_from left \
		  -start_offset 5.6 \
		  -switch_layer_over_obs false \
		  -max_same_layer_jog_length 2
