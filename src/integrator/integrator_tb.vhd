library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity integrator_tb is
end integrator_tb; 

architecture sim of integrator_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal pulse : std_logic := '0';
  signal toggle : std_logic;
begin
  gen_clock(clk);

  DUT : entity spdif_amp.integrator(rtl)
  port map(
    clk => clk,
    rst => rst,
    pulse => pulse,
    toggle => toggle
  );

  PROC_SEQUENCER : process
  begin
    do_reset(clk, rst);

    assert toggle = '0' severity failure;

    wait until rising_edge(clk);

    pulse <= '1';
    wait until rising_edge(clk);
    pulse <= '0';
    wait until rising_edge(clk);

    assert toggle = '1' severity failure;

    pulse <= '1';
    wait until rising_edge(clk);
    pulse <= '0';
    wait until rising_edge(clk);

    assert toggle = '0' severity failure;

    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
end architecture;