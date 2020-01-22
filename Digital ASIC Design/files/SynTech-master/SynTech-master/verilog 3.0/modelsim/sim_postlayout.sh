#/bin/bash
module load mentor-modelsim-de-10.7a

vsim -gui -lib work -voptargs="+acc" \
     -sdftyp LPF=../par/out/FLT_120.0ns.sdf.gz +sdf_verbose \
     -v2k_int_delays +no_glitch_msg \
     FLT_POST_TB &
