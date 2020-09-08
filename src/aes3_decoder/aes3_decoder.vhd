library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spdif_amp;

entity aes3_decoder is
  port (
    clk : in std_logic;
    rst : in std_logic;
    input : in std_logic;

    subframe_type_x : out std_logic;
    subframe_type_y : out std_logic;
    subframe_type_z : out std_logic;
    subframe_payload : out std_logic_vector(27 downto 0);
    subframe_valid : out std_logic
  );
end aes3_decoder; 

architecture str of aes3_decoder is
  signal synchronized_input : std_logic;
  signal input_pulses : std_logic;

  signal input_large_pulse : std_logic;
  signal input_medium_pulse : std_logic;
  signal input_small_pulse : std_logic;
  signal input_valid_pulse : std_logic;

  signal input_subframe_type_x : std_logic;
  signal input_subframe_type_y : std_logic;
  signal input_subframe_type_z : std_logic;
  signal input_payload_begin : std_logic;
  signal input_payload_pulse_valid : std_logic;
  signal input_payload_pulse_small : std_logic;
  signal input_payload_pulse_medium : std_logic;

  signal input_payload_bit_value : std_logic;
  signal input_payload_bit_valid : std_logic;
begin
  SYNCHRONIZER : entity spdif_amp.synchronizer(rtl)
  port map (
    clk => clk,
    rst => rst,
    input => input,
    output => synchronized_input
  );

  DIFFERENTIATOR : entity spdif_amp.differentiator(rtl)
  port map(
    clk => clk,
    rst => rst,
    input => synchronized_input,
    pulses => input_pulses
  );

  DISCRIMINATOR : entity spdif_amp.discriminator(rtl)
  port map (
    clk => clk,
    rst => rst,
    pulses => input_pulses,
    large => input_large_pulse,
    medium => input_medium_pulse,
    small => input_small_pulse,
    valid => input_valid_pulse
  );

  PREAMBLE_DECODER : entity spdif_amp.preamble_decoder(rtl)
  port map (
    clk => clk,
    rst => rst,
    small => input_small_pulse,
    medium => input_medium_pulse,
    large => input_large_pulse,
    valid => input_valid_pulse,
    type_x => subframe_type_x,
    type_y => subframe_type_y,
    type_z => subframe_type_z,
    payload_begin => input_payload_begin,
    payload_pulse_valid => input_payload_pulse_valid,
    payload_pulse_small => input_payload_pulse_small,
    payload_pulse_medium => input_payload_pulse_medium
  );

  BIPHASE_DECODER : entity spdif_amp.biphase_decoder(rtl)
  port map (
    clk => clk,
    rst => rst,
    short => input_payload_pulse_small,
    long => input_payload_pulse_medium,
    pulse_in => input_payload_pulse_valid,
    value => input_payload_bit_value,
    valid => input_payload_bit_valid
  );

  DESERIALIZER : entity spdif_amp.deserializer(rtl)
  generic map (
    NUM_BITS => 28
  )
  port map (
    clk => clk,
    rst => rst,
    clear => input_payload_begin,
    input => input_payload_bit_value,
    in_valid => input_payload_bit_valid,
    output => subframe_payload,
    out_valid => subframe_valid
  );

end architecture;