library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity synchronizer_tb is
end synchronizer_tb; 

library spdif_amp;

architecture sim of synchronizer_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '0';
  signal input : std_logic := '0';
  signal output : std_logic;
begin

  DUT : entity spdif_amp.synchronizer(rtl)
  port map (
    clk => clk,
    rst => rst,
    input => input,
    output => output
  );

  gen_clock(clk);

  PROC_SEQUENCER : process
  begin
    do_reset(clk, rst);

    assert output = '0'
      report "output is not 0 after reset"
      severity failure;

    input <= '1';
    wait until rising_edge(clk);
    input <= '0';

    assert output = '0'
      report "output is 1 too soon (0)"
      severity failure;    

    wait until rising_edge(clk);

    assert output = '0'
      report "output is 1 too soon (1)"
      severity failure;    

    wait until rising_edge(clk);

    assert output = '1'
      report "output is not 1 at the right time"
      severity failure;    

    wait until rising_edge(clk);

    assert output = '0'
      report "output is stuck at 1"
      severity failure;   

    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
end architecture;