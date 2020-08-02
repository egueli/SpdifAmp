library spdif_amp;
use spdif_amp.constants.all;

package sim_constants is
  constant clock_period : time := 1 sec / clock_frequency;

  -- Clock period for a suitable AES3 stream. This must be a multiple of clock_period.
  constant aes3_clock_period : time := clock_period * 4;

  -- Typical frequency of AES3 subframes for 44100Hz sampling rate
  constant aes3_subframe_frequency : real := 44100.0 * 2;

  constant aes3_subframe_period : time := 1000 ms * (1.0 / aes3_subframe_frequency);

  constant pll_phase_bits : integer := 24;
end package;