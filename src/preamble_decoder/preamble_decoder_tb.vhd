library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity preamble_decoder_tb is
end preamble_decoder_tb; 

architecture sim of preamble_decoder_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal small : std_logic := '0';
  signal medium : std_logic := '0';
  signal large : std_logic := '0';
  signal valid : std_logic := '0';
  signal type_x : std_logic;
  signal type_y : std_logic;
  signal type_z : std_logic;
  signal payload_begin : std_logic;
  signal payload_pulse_valid : std_logic;
  signal payload_pulse_small : std_logic;
  signal payload_pulse_medium : std_logic;
begin
  gen_clock(clk);

  DUT : entity spdif_amp.preamble_decoder(rtl)
  port map (
    clk => clk,
    rst => rst,
    small => small,
    medium => medium,
    large => large,
    valid => valid,
    type_x => type_x,
    type_y => type_y,
    type_z => type_z,
    payload_begin => payload_begin,
    payload_pulse_valid => payload_pulse_valid,
    payload_pulse_small => payload_pulse_small,
    payload_pulse_medium => payload_pulse_medium
  );

  PROC_SEQUENCER : process
    procedure do_pulse(p_large : std_logic; p_medium : std_logic; p_small : std_logic) is
    begin
      large <= p_large;
      medium <= p_medium;
      small <= p_small;      
      valid <= '1';
      wait until rising_edge(clk);
    end procedure;

    procedure do_large_pulse is
    begin
      do_pulse('1', '0', '0');
    end procedure;
    procedure do_medium_pulse is
    begin
      do_pulse('0', '1', '0');
    end procedure;
    procedure do_small_pulse is
    begin
      do_pulse('0', '0', '1');
    end procedure;
    procedure do_no_pulse is
    begin
      valid <= '0';
      wait until rising_edge(clk);
    end procedure;

  begin
    do_reset(clk, rst);

    -- preamble
    do_large_pulse; -- sync
    do_small_pulse;
    do_no_pulse; -- rest a bit, should still work
    do_small_pulse;
    do_large_pulse;

    -- payload
    do_medium_pulse;
    do_medium_pulse;
    do_small_pulse;
    do_small_pulse;
    do_small_pulse;
    do_small_pulse;
    do_large_pulse;
    do_medium_pulse;

    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
end architecture;