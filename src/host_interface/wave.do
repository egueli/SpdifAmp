onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /host_interface_tb/DUT/clk
add wave -noupdate /host_interface_tb/DUT/rst
add wave -noupdate -expand /host_interface_tb/DUT/spi_in
add wave -noupdate /host_interface_tb/DUT/spi_out
add wave -noupdate /host_interface_tb/DUT/gain
add wave -noupdate /host_interface_tb/DUT/ss_sync
add wave -noupdate /host_interface_tb/DUT/ss_sync_p1
add wave -noupdate /host_interface_tb/DUT/sclk_sync
add wave -noupdate /host_interface_tb/DUT/sclk_sync_p1
add wave -noupdate /host_interface_tb/DUT/mosi_sync
add wave -noupdate /host_interface_tb/DUT/input_buffer
add wave -noupdate /host_interface_tb/DUT/bit_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37 ns} 0}
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
WaveRestoreZoom {0 ns} {861 ns}
