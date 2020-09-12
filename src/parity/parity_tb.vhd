library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity parity_tb is
end parity_tb;

architecture sim of parity_tb is

  constant clk_hz : integer := 100e6;
  constant clk_period : time := 1 sec / clk_hz;

  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal input : std_logic_vector(15 downto 0) := (others => '0');
  signal out_parity : std_logic;
begin
  gen_clock(clk);

  DUT : entity spdif_amp.parity(rtl)
  port map (
    clk => clk,
    rst => rst,
    input => input,
    out_parity => out_parity
  );

  SEQUENCER_PROC : process
  begin
    do_reset(clk, rst);

    input <= (others => '0');
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    
    assert out_parity = '0'
    report "parity is not 0 with all zeros input"
    severity failure;
    
    input <= (0 => '1', others => '0');
    wait until rising_edge(clk);
    wait until rising_edge(clk);

    assert out_parity = '1'
      report "parity is not 1 with one bit set"
      severity failure;


    input <= std_logic_vector(to_unsigned(16#5555#, 16));
    wait until rising_edge(clk);
    wait until rising_edge(clk);

    assert out_parity = '0'
      report "parity is not 0 with even amount of ones"
      severity failure;


    input <= std_logic_vector(to_unsigned(16#4555#, 16));
    wait until rising_edge(clk);
    wait until rising_edge(clk);

    assert out_parity = '1'
      report "parity is not 1 with odd amount of ones"
      severity failure;
    finish;
  end process;

end architecture;