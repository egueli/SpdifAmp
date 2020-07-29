library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity biphase_decoder_tb is
end biphase_decoder_tb; 

architecture sim of biphase_decoder_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal short : std_logic := '0';
  signal long : std_logic := '0';
  signal pulse_in : std_logic := '0';
  signal value : std_logic;
  signal valid : std_logic;
begin
  gen_clock(clk);

  DUT : entity spdif_amp.biphase_decoder(rtl)
  port map (
    clk => clk,
    rst => rst,
    short => short,
    long => long,
    pulse_in => pulse_in,
    value => value,
    valid => valid
  );

  PROC_SEQUENCER : process
  procedure do_pulse(p_long : std_logic; p_short : std_logic) is
    begin
      long <= p_long;
      short <= p_short;      
      pulse_in <= '1';
      wait until rising_edge(clk);
    end procedure;

    procedure do_long_pulse is
    begin
      do_pulse('1', '0');
    end procedure;
    procedure do_short_pulse is
    begin
      do_pulse('0', '1');
    end procedure;
  begin
    do_reset(clk, rst);

    do_short_pulse;
    do_short_pulse;
    do_long_pulse;

    wait until rising_edge(clk);

    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
end architecture;