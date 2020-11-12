library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

library spdif_amp;

entity magnitude_tb is
end magnitude_tb;

architecture sim of magnitude_tb is
  constant clk_hz : integer := 100e6;
  constant clk_period : time := 1 sec / clk_hz;

  signal clk : std_logic := '1';
  signal value : signed(15 downto 0) := (others => '0');
  signal magnitude : integer range 16 downto 0;
begin
  clk <= not clk after clk_period / 2;

  DUT : entity spdif_amp.magnitude(rtl)
  port map (
    value => value,
    magnitude => magnitude
  );

  SEQUENCER_PROC : process
    procedure check(
      constant in_value : integer;
      constant expected_output : integer range 16 downto 0
    ) is
    begin
      wait for clk_period;
      value <= to_signed(in_value, 16);
      wait for clk_period;
      
      assert magnitude = expected_output
        report "magnitude(" & integer'image(in_value) &
        ") = " & integer'image(magnitude) &
        " but expected " & integer'image(expected_output)
        severity failure;
    end procedure;
  begin
    wait for clk_period * 10;

    check(0, 0);
    check(1, 1);
    check(2, 2);
    check(3, 2);
    check(4, 3);
    check(8, 4);
    check(15, 4);
    check(16, 5);
    check(32, 6);
    check(64, 7);
    check(128, 8);
    check(255, 8);
    check(256, 9);
    check(-1, 1);
    check(-2, 2);
    check(-3, 2);
    check(-4, 3);
    check(-8, 4);
    check(-15, 4);
    check(-16, 5);
    check(-255, 8);
    check(-256, 9);
    check(-32767, 15);
    check(-32768, 16);

    finish;
  end process;

end architecture;
