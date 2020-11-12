onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /max_window_tb/DUT/clk
add wave -noupdate /max_window_tb/DUT/rst
add wave -noupdate /max_window_tb/DUT/input
add wave -noupdate /max_window_tb/DUT/input_valid
add wave -noupdate /max_window_tb/DUT/output
add wave -noupdate /max_window_tb/DUT/update_count
add wave -noupdate /max_window_tb/DUT/update_count_msb_p1
add wave -noupdate /max_window_tb/DUT/current_max
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
