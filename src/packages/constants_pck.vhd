package constants is
  -- FPGA board frequency in Hz
  constant clock_frequency : real := 50.0e6;

  -- VU-meter update frequency, as log2 scale from FPGA clock
  constant vu_meter_update_log2_count : integer := 18;
end package;