library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp;
library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity discriminator_tb is
end discriminator_tb; 

architecture sim of discriminator_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal pulses : std_logic := '0';
  signal large : std_logic;
  signal medium : std_logic;
  signal small : std_logic;
  signal valid : std_logic;
begin
  DUT : entity spdif_amp.discriminator(rtl)
  port map (
    clk => clk,
    rst => rst,
    pulses => pulses,
    large => large,
    medium => medium,
    small => small,
    valid => valid
  );

  gen_clock(clk);

  PROC_SEQUENCER : process
    procedure send_pulse is
    begin
      pulses <= '1';
      wait until rising_edge(clk);
      pulses <= '0';
      wait until rising_edge(clk); 
    end procedure;
  begin
    do_reset(clk, rst);

    send_pulse;
    SMALL_PULSE : for i in 0 to 8 loop
      wait until rising_edge(clk);
    end loop; -- SMALL_PULSE
    send_pulse;

    assert valid = '1'
      report "not valid after small pulse"
      severity failure;
    
    assert small = '1' and medium = '0' and large = '0'
      report "small pulse not correctly identified"
      severity failure;

    MEDIUM_PULSE : for i in 0 to 16 loop
      wait until rising_edge(clk);
    end loop; -- MEDIUM_PULSE
    send_pulse;

    assert valid = '1'
      report "not valid after medium pulse"
      severity failure;
    
    assert small = '0' and medium = '1' and large = '0'
      report "medium pulse not correctly identified"
      severity failure;
    
    LARGE_PULSE : for i in 0 to 25 loop
      wait until rising_edge(clk);
    end loop; -- LARGE_PULSE
    send_pulse;

    assert valid = '1'
      report "not valid after large pulse"
      severity failure;
    
    assert small = '0' and medium = '0' and large = '1'
      report "large pulse not correctly identified"
      severity failure;


    TOO_LARGE_PULSE : for i in 0 to 50 loop
      wait until rising_edge(clk);
      assert valid = '0'
        report "valid while it shouldn't be"
        severity failure;
    end loop; -- TOO_LARGE_PULSE
    send_pulse;
    TOO_SMALL_PULSE : for i in 0 to 2 loop
      wait until rising_edge(clk);
      assert valid = '0'
        report "valid while it shouldn't be"
        severity failure;
    end loop; -- TOO_SMALL_PULSE
    send_pulse;
    NO_VALID : for i in 0 to 50 loop
      wait until rising_edge(clk);
      assert valid = '0'
        report "valid while it shouldn't be"
        severity failure;      
    end loop; -- NO_VALID

    send_pulse;
    MEDIUM_PULSE_AFTER_INVALID : for i in 0 to 16 loop
      wait until rising_edge(clk);
    end loop; -- MEDIUM_PULSE_AFTER_INVALID
    send_pulse;

    assert valid = '1'
      report "not valid after medium pulse"
      severity failure;
    
    assert small = '0' and medium = '1' and large = '0'
      report "medium pulse not correctly identified"
      severity failure;

    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
end architecture;