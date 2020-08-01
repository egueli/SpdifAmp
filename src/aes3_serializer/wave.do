onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /aes3_serializer_tb/DUT/i_clock
add wave -noupdate /aes3_serializer_tb/DUT/pulse_clock
add wave -noupdate /aes3_serializer_tb/DUT/i_payload
add wave -noupdate /aes3_serializer_tb/DUT/i_valid
add wave -noupdate /aes3_serializer_tb/DUT/i_px
add wave -noupdate /aes3_serializer_tb/DUT/i_py
add wave -noupdate /aes3_serializer_tb/DUT/i_pz
add wave -noupdate /aes3_serializer_tb/DUT/o_output
add wave -noupdate /aes3_serializer_tb/DUT/pulse_clock_p1
add wave -noupdate /aes3_serializer_tb/DUT/r_payload
add wave -noupdate /aes3_serializer_tb/DUT/r_px
add wave -noupdate /aes3_serializer_tb/DUT/r_py
add wave -noupdate /aes3_serializer_tb/DUT/r_pz
add wave -noupdate /aes3_serializer_tb/DUT/r_pulse_count
add wave -noupdate /aes3_serializer_tb/DUT/r_output_toggle
add wave -noupdate /aes3_serializer_tb/DUT/r_output
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {126 ns} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ns} {1193 ns}
