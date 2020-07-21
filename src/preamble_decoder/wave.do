onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /preamble_decoder_tb/DUT/clk
add wave -noupdate /preamble_decoder_tb/DUT/rst
add wave -noupdate /preamble_decoder_tb/DUT/small
add wave -noupdate /preamble_decoder_tb/DUT/medium
add wave -noupdate /preamble_decoder_tb/DUT/large
add wave -noupdate /preamble_decoder_tb/DUT/valid
add wave -noupdate /preamble_decoder_tb/DUT/state
add wave -noupdate /preamble_decoder_tb/DUT/type_x
add wave -noupdate /preamble_decoder_tb/DUT/type_y
add wave -noupdate /preamble_decoder_tb/DUT/type_z
add wave -noupdate /preamble_decoder_tb/DUT/payload_begin
add wave -noupdate /preamble_decoder_tb/DUT/payload_pulse_valid
add wave -noupdate /preamble_decoder_tb/DUT/payload_pulse_small
add wave -noupdate /preamble_decoder_tb/DUT/payload_pulse_medium
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {314 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 82
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
WaveRestoreZoom {0 ns} {628 ns}
