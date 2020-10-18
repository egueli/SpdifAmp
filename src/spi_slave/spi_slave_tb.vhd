library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity spi_slave_tb is
end spi_slave_tb;

architecture sim of spi_slave_tb is

  constant clk_hz : integer := 100e6;
  constant clk_period : time := 1 sec / clk_hz;

  signal clk : std_logic := '1';
  signal rst : std_logic := '1';

begin

  clk <= not clk after clk_period / 2;

  DUT : entity spdif_amp.spi_slave(rtl)
  port map (
    clk => clk,
    rst => rst,
    spi_in => (
      ss => '1',
      sclk => '0',
      mosi => '0'
    ),
    spi_out => open
  );

  gen_clock(clk);

  SEQUENCER_PROC : process
  begin
    do_reset(clk, rst);

    wait for clk_period * 10;
    assert false
      report "Replace this with your test cases"
      severity failure;

    finish;
  end process;

end architecture;