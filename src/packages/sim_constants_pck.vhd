library spdif_amp;
use spdif_amp.constants.all;

package sim_constants is
  constant clock_period : time := 1 sec / clock_frequency;

  -- Clock period for a suitable AES3 stream. This must be a multiple of clock_period.
  constant aes3_clock_period : time := clock_period * 4;
end package;