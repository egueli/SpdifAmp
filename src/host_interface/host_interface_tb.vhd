library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity host_interface_tb is
end host_interface_tb;

architecture sim of host_interface_tb is

  constant clk_hz : integer := 100e6;
  constant clk_period : time := 1 sec / clk_hz;

  signal clk : std_logic := '1';
  signal rst : std_logic := '1';

  signal sclk : std_logic := '0';
  signal ss : std_logic := '0';
  signal mosi : std_logic := '0';
begin
  DUT : entity spdif_amp.host_interface(rtl)
  port map (
    clk => clk,
    rst => rst,
    spi_in => (
      ss => ss,
      sclk => sclk,
      mosi => mosi
    ),
    spi_out => open
  );

  gen_clock(clk);

  SEQUENCER_PROC : process
    procedure send_bit(constant value : std_logic) is
    begin
      sclk <= '0';
      wait until rising_edge(clk);
      mosi <= value;
      wait until rising_edge(clk);
      sclk <= '1';
      wait until rising_edge(clk);      
    end procedure;
  begin
    do_reset(clk, rst);

    ss <= '1';
    wait until rising_edge(clk);

    send_bit('1');
    send_bit('0');
    send_bit('1');
    send_bit('0');
    send_bit('0');
    send_bit('1');
    send_bit('0');
    send_bit('1');

    for i in 0 to 3 loop
      wait until rising_edge(clk);
    end loop;

    finish;
  end process;

end architecture;