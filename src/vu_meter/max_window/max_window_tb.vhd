library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity max_window_tb is
end max_window_tb;

architecture sim of max_window_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';

  signal input : integer range 10 downto 0 := 0;
  signal input_valid : std_logic := '0';
  signal output : integer range 10 downto 0;

  constant update_log2_count : integer := 4;
begin

  gen_clock(clk);

  DUT : entity spdif_amp.max_window(rtl)
  generic map (
    MAX_VALUE => 10,
    UPDATE_LOG2_COUNT => update_log2_count
  )
  port map (
    clk => clk,
    rst => rst,
    input => input,
    input_valid => input_valid,
    output => output
  );

  SEQUENCER_PROC : process
    procedure wait_update is
    begin
      for i in 0 to 2**update_log2_count loop
        wait until rising_edge(clk);
      end loop;   
    end procedure;
  begin
    do_reset(clk, rst);
    
    input <= 3;
    input_valid <= '1';
    wait until rising_edge(clk);
    input <= 1;
    wait until rising_edge(clk);
    input_valid <= '0';

    wait_update;
    assert output = 3
      report "Wanted output 3, got a different value"
      severity error;
    
    wait_update;
    assert output = 0
      report "Wanted output 0 after period with no inputs, got a different value"
      severity error;
    
    finish;
  end process;

end architecture;