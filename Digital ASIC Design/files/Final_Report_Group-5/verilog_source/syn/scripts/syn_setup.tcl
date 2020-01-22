set NUM_CORES 2
set DESIGN_NAME "work"

#Technology library paths
set ROOT_PATH "/work/global/brg/install/adk-pkgs/saed-90nm/pkgs/"
set LIB_PATH "$ROOT_PATH/SAED_EDK90nm_01252011/SAED_EDK90nm"

#Set search path
set snps  [getenv "SYNOPSYS"]
set search_path  [lappend search_path "${snps}/libraries/syn"]
set search_path  [lappend search_path "${snps}"]

#Cells Technology Kit
set search_path  [lappend search_path "$LIB_PATH/Digital_Standard_cell_Library/synopsys/models"]

#Target library files
set TARGET_LIBRARY_FILES         "saed90nm_typ.db"

set ADDITIONAL_LINK_LIB_FILES    ""

set SYMB_LIB                     "$LIB_PATH/Digital_Standard_cell_Library/synopsys/icons/saed90nm.sdb"

set MW_REFERENCE_LIB_DIRS        "$LIB_PATH/Digital_Standard_cell_Library/process/astro/fram/saed90nm_fr"

#Milkyway technology file
set TECH_FILE                    "$LIB_PATH/Technology_Kit/techfile/saed90nm_1p9m.tf"

#Mapping file for TLUplus
set MAP_FILE                     "$LIB_PATH/Digital_Standard_cell_Library/process/star_rcxt/saed90nm.map"
#MAX TLUplus file
set TLUPLUS_MAX_FILE             "$LIB_PATH/Digital_Standard_cell_Library/process/star_rcxt/tluplus/saed90nm_1p9m_1t_Cmax.tluplus"
#MIN TLUplus file
set TLUPLUS_MIN_FILE             "$LIB_PATH/Digital_Standard_cell_Library/process/star_rcxt/tluplus/saed90nm_1p9m_1t_Cmin.tluplus"

set MW_POWER_NET                 "VDD"
set MW_POWER_PORT                "VDD"
set MW_GROUND_NET                "VSS"
set MW_GROUND_PORT               "VSS"

set MIN_ROUTING_LAYER            "M2"
set MAX_ROUTING_LAYER            "M9"

#Site Specific Variables
set SYNTH_LIB "dw_foundation.sldb dft_jtag.sldb  dft_lbist.sldb  dft_mbist.sldb  standard.sldb"

#Central cache of analyzed libraries to save some runtime and disk space
set alib_library_analysis_path .

#Define path for the designed library, so the analyzed files are saved in the work directory
define_design_lib work -path ./work

set default_schematic_options "-size infinite"

set mv_power_net         ${MW_POWER_NET}
set mw_ground_net        ${MW_GROUND_NET}
set mw_logic1_net        ${MW_POWER_NET}
set mw_logic0_net        ${MW_GROUND_NET}
set mw_power_port        ${MW_POWER_NET}
set mw_ground_port       ${MW_GROUND_NET}

set mw_reference_library ${MW_REFERENCE_LIB_DIRS}
set mw_design_library    ${DESIGN_NAME}_LIB


if {$synopsys_program_name == "dc_shell"} {
  set target_library      ${TARGET_LIBRARY_FILES}
  set synthetic_library   "$SYNTH_LIB"
  set link_library        "* $target_library $ADDITIONAL_LINK_LIB_FILES $SYNTH_LIB"
  set physical_library    ""
  set symbol_library      "$SYMB_LIB" 

  if {[shell_is_in_topographical_mode]} {
    #Only create new Milkyway design library if it doesn't already exist
    if {![file isdirectory $mw_design_library ]} {
      create_mw_lib   -technology $TECH_FILE -mw_reference_library $mw_reference_library $mw_design_library
    } else {
      #If Milkyway design library already exists, ensure that it is consistent with specified Milkyway reference libraries
      set_mw_lib_reference $mw_design_library -mw_reference_library $mw_reference_library
    }

    open_mw_lib     $mw_design_library

    check_library

    set_tlu_plus_files -max_tluplus $TLUPLUS_MAX_FILE \
                       -min_tluplus $TLUPLUS_MIN_FILE \
                       -tech2itf_map $MAP_FILE

    check_tlu_plus_files
  }

}

#Variables in order to align SYNTHESIS and ICC environments
set derive_default_routing_layer_direction true
set case_analysis_with_logic_constants     true

set timing_enable_multiple_clocks_per_reg true
set enable_recovery_removal_arcs          true
set power_keep_tns                        true
