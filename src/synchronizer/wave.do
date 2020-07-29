onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synchronizer_tb/DUT/clk
add wave -noupdate /synchronizer_tb/DUT/rst
add wave -noupdate /synchronizer_tb/DUT/input
add wave -noupdate /synchronizer_tb/DUT/output
add wave -noupdate /synchronizer_tb/DUT/data_p1
add wave -noupdate /synchronizer_tb/DUT/data_p2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 46
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
WaveRestoreZoom {0 ns} {20886 ns}
