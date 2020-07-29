library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp;
library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity differentiator_tb is
end differentiator_tb; 

architecture sim of differentiator_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '0';
  signal input : std_logic := '0';
  signal pulses : std_logic;
begin

  DUT : entity spdif_amp.differentiator(rtl)
  port map(
    clk => clk,
    rst => rst,
    input => input,
    pulses => pulses
  );

  gen_clock(clk);

  PROC_SEQUENCER : process
  begin
    do_reset(clk, rst);

    assert pulses = '0'
      report "pulse output is not 0 after reset"
      severity failure;

    input <= '1';
    wait until rising_edge(clk); -- send input
    wait until rising_edge(clk); -- wait to detect change

    assert pulses = '1'
      report "pulse output is not 1 for transition from 0 to 1"
      severity failure;

    wait until rising_edge(clk);

    assert pulses = '0'
      report "pulse output is not 0 after stable 1"
      severity failure;

    input <= '0';
    wait until rising_edge(clk); -- send input
    wait until rising_edge(clk); -- wait to detect change

    assert pulses = '1'
      report "pulse output is not 1 for transition from 1 to 0"
      severity failure;

    wait until rising_edge(clk);

    assert pulses = '0'
      report "pulse output is not 0 after stable 0"
      severity failure;
  
    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER

end architecture;