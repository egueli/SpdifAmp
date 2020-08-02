library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;
use spdif_amp_sim.sim_constants.all;

entity aes3_encoder_tb is
end aes3_encoder_tb; 

architecture sim of aes3_encoder_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal payload : std_logic_vector(27 downto 0) := (others => '0');
  signal type_x : std_logic := '0';
  signal type_y : std_logic := '0';
  signal type_z : std_logic := '0';
  signal subframe_valid : std_logic := '0';
  signal output : std_logic;
begin

  gen_clock(clk);

  DUT : entity spdif_amp.aes3_encoder(str)
  port map (
    clk => clk,
    rst => rst,
    payload => payload,
    type_x => type_x,
    type_y => type_y,
    type_z => type_z,
    subframe_valid => subframe_valid,
    output => output
  );

  PROC_SUBFRAME_STREAM : process
    variable t : time;
  begin
    t := now;

    subframe_valid <= '1';
    wait until rising_edge(clk);
    subframe_valid <= '0';

    -- Since the pulse took one clock period, wait enough to make the next pulse
    -- at exactly the subframe period.
    wait for (aes3_subframe_period - (now - t));
  end process; -- PROC_SUBFRAME_STREAM

  PROC_SEQUENCER : process
  begin
    do_reset(clk, rst);

    type_x <= '1';

    wait for 2 ms;

    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
end architecture;