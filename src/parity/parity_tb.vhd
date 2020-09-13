library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity parity_tb is
end parity_tb;

architecture sim of parity_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal input : std_logic_vector(15 downto 0) := (others => '0');
  signal valid : std_logic := '0';
  signal out_parity : std_logic;
  signal out_valid : std_logic;
begin
  gen_clock(clk);

  DUT : entity spdif_amp.parity(rtl)
  port map (
    clk => clk,
    rst => rst,
    input => input,
    valid => valid,
    out_parity => out_parity,
    out_valid => out_valid
  );

  SEQUENCER_PROC : process
    procedure send_input(input_to_send : unsigned(input'range)) is
    begin
      input <= std_logic_vector(input_to_send);
      valid <= '1';
      wait until rising_edge(clk);
      valid <= '0';
      wait until rising_edge(clk);

      assert out_valid = '1'
        report "Output not valid when expected"
        severity failure;
    end procedure;
  begin
    do_reset(clk, rst);

    send_input(to_unsigned(0, 16));
    assert out_parity = '0'
    report "parity is not 0 with all zeros input"
    severity failure;
    
    send_input(to_unsigned(1, 16));
    assert out_parity = '1'
      report "parity is not 1 with one bit set"
      severity failure;

    send_input(to_unsigned(16#5555#, 16));
    assert out_parity = '0'
      report "parity is not 0 with even amount of ones"
      severity failure;

    send_input(to_unsigned(16#4555#, 16));
    assert out_parity = '1'
      report "parity is not 1 with odd amount of ones"
      severity failure;
      
    finish;
  end process;

end architecture;