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
  signal clk : std_logic;
  signal rst : std_logic;
  signal input : std_logic;
  signal pulses : std_logic;
begin

  DUT : entity spdif_amp.differentiator(rtl)
  port map(
    clk => clk,
    rst => rst,
    input => input,
    pulses => pulses
  );

  print_test_ok;
  finish;
end architecture;