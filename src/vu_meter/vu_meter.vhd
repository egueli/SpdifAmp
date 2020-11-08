library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spdif_amp;
use spdif_amp.constants.all;

entity vu_meter is
  generic (
    -- number of bits of the input samples, including sign
    SAMPLE_BITS : integer := 16;
    NUM_LEDS : integer := 10
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    in_sample : in signed(SAMPLE_BITS-1 downto 0);
    in_sample_valid : in std_logic;
    out_leds : out std_logic_vector(NUM_LEDS-1 downto 0)
  );
end vu_meter;

architecture str of vu_meter is
  signal magnitude : integer range SAMPLE_BITS downto 0;
  signal envelope : integer range SAMPLE_BITS downto 0;

begin
  MAGNITUDE_FUNC : entity spdif_amp.magnitude(rtl)
  generic map(
    NUM_BITS => SAMPLE_BITS
  )
  port map(
    value => in_sample,
    magnitude => magnitude
  );

  MAX_WINDOW_PROC : entity spdif_amp.max_window(rtl)
  generic map(
    MAX_VALUE => SAMPLE_BITS,
    UPDATE_LOG2_COUNT => vu_meter_update_log2_count
  )
  port map(
    clk => clk,
    rst => rst,
    input => magnitude,
    input_valid => in_sample_valid,
    output => envelope
  );

  LED_BAR_FUNC : entity spdif_amp.ledbar(rtl)
  generic map(
    MAX_INPUT => SAMPLE_BITS,
    NUM_LEDS => NUM_LEDS
  )
  port map(
    input => envelope,
    output => out_leds
  );
end architecture;