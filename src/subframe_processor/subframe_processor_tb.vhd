library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;
use spdif_amp_sim.sim_constants.all;

entity subframe_processor_tb is
end subframe_processor_tb;

architecture sim of subframe_processor_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal gain : natural range 3 downto 0 := 0;
  signal in_subframe : std_logic_vector(27 downto 0) := (others => '0');
  signal in_subframe_valid : std_logic := '0';
  signal out_subframe : std_logic_vector(27 downto 0);
  signal out_subframe_valid : std_logic;
begin

  gen_clock(clk);

  DUT : entity spdif_amp.subframe_processor(rtl)
  port map (
    clk => clk,
    rst => rst,
    in_subframe => in_subframe,
    in_subframe_valid => in_subframe_valid,
    gain => gain,
    out_subframe => out_subframe,
    out_subframe_valid => out_subframe_valid
  );

  SEQUENCER_PROC : process
    procedure check_processor(
      constant input : integer;
      constant expected_output : integer
    ) is
    begin
      in_subframe <= std_logic_vector(to_unsigned(input, in_subframe'length));
      in_subframe_valid <= '1';
      wait until rising_edge(clk);
      in_subframe_valid <= '0';
      wait until rising_edge(clk);

      wait until out_subframe_valid'event for clock_period * 10;

      assert out_subframe_valid = '1'
        report "out subframe is not valid when expected"
        severity failure;
      
      assert out_subframe = std_logic_vector(to_unsigned(expected_output, out_subframe'length))
        report "out subframe is different than expected"
        severity failure;
      
    end procedure;
  begin
    do_reset(clk, rst);

    -- begin tests with unity gain, so samples aren't altered.

    -- all-zero subframes go as-is
    check_processor(16#0000000#, 16#0000000#);
    -- non-zero subframes with correct parity go as-is
    check_processor(16#A55AA55#, 16#A55AA55#);
    -- non-zero subframes with wrong parity are cleared
    check_processor(16#A55AA54#, 16#0000000#);

    finish;
  end process;

end architecture;