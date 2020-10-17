onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /amplifier_tb/DUT/clk
add wave -noupdate /amplifier_tb/DUT/rst
add wave -noupdate /amplifier_tb/DUT/gain
add wave -noupdate /amplifier_tb/DUT/in_sample
add wave -noupdate /amplifier_tb/DUT/in_sample_valid
add wave -noupdate /amplifier_tb/DUT/out_sample
add wave -noupdate /amplifier_tb/DUT/out_sample_valid
add wave -noupdate /amplifier_tb/DUT/in_sample_valid_p1
add wave -noupdate /amplifier_tb/DUT/accumulator
add wave -noupdate /amplifier_tb/DUT/shift_count
add wave -noupdate /amplifier_tb/DUT/state
add wave -noupdate /amplifier_tb/DUT/msb
add wave -noupdate /amplifier_tb/DUT/msb_1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {420 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 213
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
WaveRestoreZoom {0 ns} {294 ns}
