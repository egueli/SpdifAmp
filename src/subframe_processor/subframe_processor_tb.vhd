library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity subframe_processor_tb is
end subframe_processor_tb;

architecture sim of subframe_processor_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
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
    out_subframe => out_subframe,
    out_subframe_valid => out_subframe_valid
  );

  SEQUENCER_PROC : process
  begin
    do_reset(clk, rst);

    wait until rising_edge(clk);
    assert false
      report "Replace this with your test cases"
      severity failure;

    finish;
  end process;

end architecture;