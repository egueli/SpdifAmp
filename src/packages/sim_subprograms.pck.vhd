library ieee;
use ieee.std_logic_1164.all;

use std.textio.all;

library spdif_amp_sim;
use spdif_amp_sim.sim_constants.all;

package sim_subprograms is

  -- print "Test: OK"
  procedure print_test_ok;

  -- Generate the clock signal
  procedure gen_clock(signal clk : inout std_logic);

  -- Generate reset signal
  procedure do_reset(signal clk : in std_logic; signal rst : out std_logic);
end package;

package body sim_subprograms is

  procedure print_test_ok is
    variable str : line;
  begin
    write(str, string'("Test: OK"));
    writeline(output, str);
  end procedure;

  procedure gen_clock(signal clk : inout std_logic) is
  begin
    clk <= not clk after clock_period / 2;
  end procedure;

  procedure do_reset(signal clk : in std_logic; signal rst : out std_logic) is
  begin
    rst <= '1';
    LONG_RESET : for i in 0 to 10 loop
      wait until rising_edge(clk);
    end loop; -- LONG_RESET
    rst <= '0';
    wait until rising_edge(clk);
  end procedure;
end package body;