onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /subframe_processor_tb/DUT/clk
add wave -noupdate /subframe_processor_tb/DUT/rst
add wave -noupdate /subframe_processor_tb/DUT/in_subframe
add wave -noupdate /subframe_processor_tb/DUT/in_subframe_valid
add wave -noupdate /subframe_processor_tb/DUT/out_subframe
add wave -noupdate /subframe_processor_tb/DUT/out_subframe_valid
add wave -noupdate /subframe_processor_tb/DUT/parity_check_in_valid
add wave -noupdate /subframe_processor_tb/DUT/parity_check_input
add wave -noupdate /subframe_processor_tb/DUT/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {1 us}
