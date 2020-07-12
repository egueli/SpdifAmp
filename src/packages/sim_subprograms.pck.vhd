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
end package body;