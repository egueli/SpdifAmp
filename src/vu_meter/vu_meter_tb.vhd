library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

library spdif_amp;

entity vu_meter_tb is
end vu_meter_tb;

architecture sim of vu_meter_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
begin
  gen_clock(clk);

  DUT : entity spdif_amp.vu_meter(str)
  port map (
    clk => clk,
    rst => rst,
    in_sample => (others => '0'),
    in_sample_valid => '0'
  );

  SEQUENCER_PROC : process
  begin
    do_reset(clk, rst);

    wait until rising_edge(clk);


    finish;
  end process;

end architecture;