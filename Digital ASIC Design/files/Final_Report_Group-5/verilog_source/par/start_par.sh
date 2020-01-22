#!/bin/sh

export INNOVUS="/opt/cadence"
ver_num="171"
export INNOVUS_EXT_BIN="${INNOVUS}/EXT${ver_num}/bin"
export PATH="${PATH}:${INNOVUS_EXT_BIN}"
export SETUP_CADENCE_EXT="yes"

module load innovus-171

innovus -64 -overwrite
