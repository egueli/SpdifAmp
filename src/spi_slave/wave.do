onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /spi_slave_tb/DUT/clk
add wave -noupdate /spi_slave_tb/DUT/rst
add wave -noupdate -expand /spi_slave_tb/DUT/spi_in
add wave -noupdate /spi_slave_tb/DUT/spi_out
add wave -noupdate /spi_slave_tb/DUT/gain
add wave -noupdate /spi_slave_tb/DUT/ss_sync
add wave -noupdate /spi_slave_tb/DUT/ss_sync_p1
add wave -noupdate /spi_slave_tb/DUT/sclk_sync
add wave -noupdate /spi_slave_tb/DUT/sclk_sync_p1
add wave -noupdate /spi_slave_tb/DUT/mosi_sync
add wave -noupdate /spi_slave_tb/DUT/input_buffer
add wave -noupdate /spi_slave_tb/DUT/bit_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {16 ns}
