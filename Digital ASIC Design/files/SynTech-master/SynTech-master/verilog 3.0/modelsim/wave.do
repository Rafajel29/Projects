onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /FLT_POST_TB/Clk_C
add wave -noupdate -radix decimal /FLT_POST_TB/WrEn_S
add wave -noupdate -radix decimal /FLT_POST_TB/Rst_RB
add wave -noupdate -radix decimal /FLT_POST_TB/PAR_In_D
add wave -noupdate -radix decimal /FLT_POST_TB/FLT_Out_DE
add wave -noupdate -radix decimal /FLT_POST_TB/FLT_Out_D
add wave -noupdate -radix decimal /FLT_POST_TB/FLT_In_D
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3504228 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 254
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
configure wave -timelineunits ps
update
WaveRestoreZoom {3400791 ps} {3588341 ps}
