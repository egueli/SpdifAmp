library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;
use spdif_amp_sim.sim_constants.all;


entity pll_tb is
end pll_tb; 

architecture sim of pll_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal input : std_logic := '0';
  signal phase : unsigned((pll_phase_bits - 1) downto 0);
  signal error : signed(1 downto 0);
begin
  gen_clock(clk);

  DUT : entity spdif_amp.pll(rtl)
  generic map(
    PHASE_BITS => pll_phase_bits,
    LGCOEFF => 10,
    INITIAL_PHASE_STEP => to_unsigned(0, pll_phase_bits)
  )
  port map(
    clk => clk,
    rst => rst,
    input => input,
    phase => phase,
    error => error
  );

  -- Set up the PLL reference clock
  input <= not input after aes3_subframe_period / 2;

  PROC_SEQUENCER : process
  begin
    do_reset(clk, rst);

    wait for 2 ms; 

    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
end architecture;