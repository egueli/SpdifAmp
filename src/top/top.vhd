library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spdif_amp;

entity top is
  port (
    clk : in std_logic;
    rst_button : in std_logic;
    input : in std_logic;
    output : out std_logic
  );
end top; 

architecture str of top is
  signal rst : std_logic;

  signal subframe_type_x : std_logic;
  signal subframe_type_y : std_logic;
  signal subframe_type_z : std_logic;
  signal subframe_in_payload : std_logic_vector(27 downto 0);
  signal subframe_in_valid : std_logic;
  signal subframe_out_payload : std_logic_vector(27 downto 0);
  signal subframe_out_valid : std_logic;
begin
  RESET : entity spdif_amp.reset(rtl)
  port map (
    clk => clk,
    rst_in => rst_button,
    rst_out => rst
  );

  DECODER : entity spdif_amp.aes3_decoder(str)
  port map (
    clk => clk,
    rst => rst,
    input => input,
    subframe_type_x => subframe_type_x,
    subframe_type_y => subframe_type_y,
    subframe_type_z => subframe_type_z,
    subframe_payload => subframe_in_payload,
    subframe_valid => subframe_in_valid
  );

  PROCESSOR : entity spdif_amp.subframe_processor(rtl)
  port map(
    clk => clk,
    rst => rst,
    in_subframe => subframe_in_payload,
    in_subframe_valid => subframe_in_valid,
    gain => 0,
    out_subframe => subframe_out_payload,
    out_subframe_valid => subframe_out_valid
  );

  ENCODER : entity spdif_amp.aes3_encoder(str)
  port map (
    clk => clk,
    rst => rst,
    payload => subframe_out_payload,
    type_x => subframe_type_x,
    type_y => subframe_type_y,
    type_z => subframe_type_z,
    subframe_valid => subframe_out_valid,
    output => output
  );
end architecture;