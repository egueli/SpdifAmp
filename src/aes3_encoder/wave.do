onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /aes3_encoder_tb/DUT/clk
add wave -noupdate /aes3_encoder_tb/DUT/rst
add wave -noupdate /aes3_encoder_tb/DUT/payload
add wave -noupdate /aes3_encoder_tb/DUT/type_x
add wave -noupdate /aes3_encoder_tb/DUT/type_y
add wave -noupdate /aes3_encoder_tb/DUT/type_z
add wave -noupdate /aes3_encoder_tb/DUT/subframe_valid
add wave -noupdate /aes3_encoder_tb/DUT/output
add wave -noupdate /aes3_encoder_tb/DUT/pll_clock
add wave -noupdate /aes3_encoder_tb/DUT/pll_phase
add wave -noupdate /aes3_encoder_tb/DUT/serializer_clock
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
