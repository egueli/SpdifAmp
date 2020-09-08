onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/DUT/clk
add wave -noupdate /top_tb/DUT/rst_button
add wave -noupdate /top_tb/DUT/input
add wave -noupdate /top_tb/DUT/output
add wave -noupdate /top_tb/DUT/rst
add wave -noupdate /top_tb/DUT/subframe_type_x
add wave -noupdate /top_tb/DUT/subframe_type_y
add wave -noupdate /top_tb/DUT/subframe_type_z
add wave -noupdate /top_tb/DUT/subframe_payload
add wave -noupdate /top_tb/DUT/subframe_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 46
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ns} {20886 ns}
