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

  signal gain : integer range 3 downto 0;
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
    spi_out => open,
    gain => gain
  );

  gen_clock(clk);

  SEQUENCER_PROC : process
    procedure send_bit(constant value : std_logic) is
    begin
      sclk <= '0';
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      mosi <= value;
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      wait until rising_edge(clk);
      sclk <= '1';
      wait until rising_edge(clk);      
      wait until rising_edge(clk);      
      wait until rising_edge(clk);      
    end procedure;

    procedure send_byte(constant value : std_logic_vector(7 downto 0)) is
    begin
      for i in 7 downto 0 loop
        send_bit(value(i));
      end loop;
    end procedure;

    procedure verify_gain(
      constant command : std_logic_vector(7 downto 0);
      constant expected_gain : integer
    ) is
    begin
      send_byte(command);

      for i in 0 to 3 loop
        wait until rising_edge(clk);
      end loop;
  
      assert gain = expected_gain
        report "verify_gain(cmd=" & 
          to_hstring(command) & "h, expGain=" &
          to_string(expected_gain) & ") but gain=" &
          to_string(gain)
        severity failure;
    end procedure;
  begin
    do_reset(clk, rst);

    ss <= '1';
    wait until rising_edge(clk);
  
    -- Verify gain settings. Bits 7 to 2 are random.
    verify_gain(x"00", 0);
    verify_gain(x"FC", 0);
    verify_gain(x"A5", 1);
    verify_gain(x"22", 2);
    verify_gain(x"0F", 3);

    -- with SS low, keep the previous gain
    ss <= '0';
    wait until rising_edge(clk);
    verify_gain(x"01", 3);
    
    -- with SS high again, apply gain.
    ss <= '1';
    wait until rising_edge(clk);
    verify_gain(x"01", 1);
    
    finish;
  end process;

end architecture;