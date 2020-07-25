library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp;
library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity deserializer_tb is
end deserializer_tb; 

architecture sim of deserializer_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal input : std_logic := '0';
  signal in_valid : std_logic := '0';
  signal output : std_logic_vector(3 downto 0);
  signal out_valid : std_logic;
begin
  gen_clock(clk);

  DUT : entity spdif_amp.deserializer(rtl)
  generic map (
    NUM_BITS => 4
  )
  port map (
    clk => clk,
    rst => rst,
    input => input,
    in_valid => in_valid,
    output => output,
    out_valid => out_valid
  );

  PROC_SEQUENCER : process
  begin
    do_reset(clk, rst);

    wait until rising_edge(clk);

    input <= '1';
    in_valid <= '1';
    wait until rising_edge(clk);
    input <= '0';
    in_valid <= '1';
    wait until rising_edge(clk);
    input <= '1';
    in_valid <= '1';
    wait until rising_edge(clk);
    input <= '0';
    in_valid <= '1';
    wait until rising_edge(clk);

    input <= 'X';
    in_valid <= '0';
    wait until rising_edge(clk);

    wait until rising_edge(clk);

    assert out_valid = '1'
      report "Output not valid after sending the right amount of bits"
      severity failure;
    
    assert output = "1010"
      report "Output different than expected"
      severity failure;

    rst <= '1';
    wait until rising_edge(clk);
    rst <= '0';



    input <= '0';
    in_valid <= '1';
    wait until rising_edge(clk);
    input <= '0';
    in_valid <= '1';
    wait until rising_edge(clk);
    input <= 'X';
    in_valid <= '0';
    wait until rising_edge(clk);
    input <= '1';
    in_valid <= '1';
    wait until rising_edge(clk);
    input <= '1';
    in_valid <= '1';
    wait until rising_edge(clk);

    input <= 'X';
    in_valid <= '0';
    wait until rising_edge(clk);
    
    wait until rising_edge(clk);

    assert out_valid = '1'
      report "Output not valid after sending the right amount of bits"
      severity failure;
    
    assert output = "0011"
      report "Output different than expected"
      severity failure;

    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
end architecture;