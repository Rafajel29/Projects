onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /FLT_TB/LPF/Clk_CI
add wave -noupdate -radix decimal /FLT_TB/LPF/Rst_RBI
add wave -noupdate -radix decimal /FLT_TB/LPF/Addr_DI
add wave -noupdate -radix decimal /FLT_TB/LPF/PAR_In_DI
add wave -noupdate -radix decimal /FLT_TB/LPF/parameter_memory
add wave -noupdate -expand -group alpha_cal -radix decimal /FLT_TB/LPF/par_FLT_RQ_D
add wave -noupdate -expand -group alpha_cal -radix decimal /FLT_TB/LPF/constant2_D
add wave -noupdate -expand -group alpha_cal -radix decimal /FLT_TB/LPF/alpha_tmp_D
add wave -noupdate -expand -group alpha_cal -radix decimal /FLT_TB/LPF/alpha_D
add wave -noupdate -expand -group a2_cal -radix decimal /FLT_TB/LPF/par_FLT_f0_D
add wave -noupdate -expand -group a2_cal -radix decimal /FLT_TB/LPF/par_FLT_RFS_norm_D
add wave -noupdate -expand -group a2_cal -radix decimal /FLT_TB/LPF/omega0_normalized_D
add wave -noupdate -expand -group a2_cal -radix decimal /FLT_TB/LPF/omega0_normalized_tmp_D
add wave -noupdate -expand -group a2_cal -radix decimal /FLT_TB/LPF/sin_out_tmp_D
add wave -noupdate -expand -group a2_cal -radix decimal /FLT_TB/LPF/sin_out_D
add wave -noupdate -expand -group a2_cal -radix decimal /FLT_TB/LPF/a2_minus_D
add wave -noupdate -expand -group a1_cal -radix decimal /FLT_TB/LPF/cos_out_tmp_D
add wave -noupdate -expand -group a1_cal -radix decimal /FLT_TB/LPF/cos_out_REG_D
add wave -noupdate -expand -group a1_cal -radix decimal /FLT_TB/LPF/cos_out_D
add wave -noupdate -expand -group a1_cal -radix decimal /FLT_TB/LPF/a1_minus_D
add wave -noupdate -radix decimal /FLT_TB/LPF/a0_D
add wave -noupdate -expand -group a0_cal -radix decimal /FLT_TB/LPF/a0_enable_S
add wave -noupdate -expand -group a0_cal -radix decimal /FLT_TB/LPF/a0_inv_tmp_D
add wave -noupdate -expand -group a0_cal -radix decimal /FLT_TB/LPF/a0_valid_S
add wave -noupdate -expand -group a0_cal -radix decimal /FLT_TB/LPF/a0_inv_REG_D
add wave -noupdate -expand -group a0_cal -radix decimal /FLT_TB/LPF/a0_inv_D
add wave -noupdate -radix decimal /FLT_TB/LPF/b0_D
add wave -noupdate -radix decimal /FLT_TB/LPF/b1_D
add wave -noupdate -radix decimal /FLT_TB/LPF/b2_D
add wave -noupdate -radix decimal /FLT_TB/LPF/FLT_Test_constant2_DO
add wave -noupdate -group input0 -radix decimal /FLT_TB/LPF/sta_FLT_In_DI
add wave -noupdate -group input0 -radix decimal /FLT_TB/LPF/sta_FLT_IN_REG_D
add wave -noupdate -group input0 -radix decimal /FLT_TB/LPF/sta_FLT_In_SD_tmp_D
add wave -noupdate -group input0 -radix decimal /FLT_TB/LPF/par_FLT_SD_D
add wave -noupdate -group input0 -radix decimal /FLT_TB/LPF/sta_FLT_OldIn0_D
add wave -noupdate -radix decimal /FLT_TB/LPF/sta_FLT_OldIn1_D
add wave -noupdate -radix decimal /FLT_TB/LPF/sta_FLT_OldIn2_D
add wave -noupdate -radix decimal /FLT_TB/LPF/sta_FLT_OldSample0_D
add wave -noupdate -radix decimal /FLT_TB/LPF/sta_FLT_OldSample1_D
add wave -noupdate -radix decimal /FLT_TB/LPF/sta_FLT_OldSample2_D
add wave -noupdate -radix decimal /FLT_TB/LPF/sta_FLT_Out_DO
add wave -noupdate -radix decimal /FLT_TB/LPF/sumx0_D
add wave -noupdate -radix decimal /FLT_TB/LPF/sumx0_RS_D
add wave -noupdate -radix decimal /FLT_TB/LPF/sumx2x1_D
add wave -noupdate -radix decimal /FLT_TB/LPF/sumy0_D
add wave -noupdate -radix decimal /FLT_TB/LPF/sumy0_tmp_D
add wave -noupdate -radix decimal /FLT_TB/LPF/sumy2y1_D
add wave -noupdate -radix decimal /FLT_TB/LPF/sumy2y1_LS_D
add wave -noupdate -radix decimal /FLT_TB/LPF/WrEn_SI
add wave -noupdate -radix decimal /FLT_TB/LPF/xb0_D
add wave -noupdate -radix decimal /FLT_TB/LPF/xb0_tmp_D
add wave -noupdate -radix decimal /FLT_TB/LPF/xb1_D
add wave -noupdate -radix decimal /FLT_TB/LPF/xb1_tmp_D
add wave -noupdate -radix decimal /FLT_TB/LPF/xb2_D
add wave -noupdate -radix decimal /FLT_TB/LPF/xb2_tmp_D
add wave -noupdate -radix decimal /FLT_TB/LPF/ya0_tmp_D
add wave -noupdate -radix decimal /FLT_TB/LPF/ya1_D
add wave -noupdate -radix decimal /FLT_TB/LPF/ya1_tmp_D
add wave -noupdate -radix decimal /FLT_TB/LPF/ya2_D
add wave -noupdate -radix decimal /FLT_TB/LPF/ya2_tmp_D
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24321 ps} 0} {{Cursor 2} {10198 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 386
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {30564 ps}
