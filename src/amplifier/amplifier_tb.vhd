library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;

entity amplifier_tb is
  generic(
    SAMPLE_BITS : integer := 16;
    GAIN_BITS : integer := 8;
    GAIN_SCALE : integer := 4
  );
end amplifier_tb; 

architecture sim of amplifier_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '0';
  signal gain : unsigned(GAIN_BITS-1 downto 0);
  signal in_sample : signed(SAMPLE_BITS-1 downto 0);
  signal in_sample_valid : std_logic := '0';
  signal out_sample : signed(SAMPLE_BITS-1 downto 0);
  signal out_sample_valid : std_logic;
begin
  DUT : entity spdif_amp.amplifier(rtl)
  generic map (
    SAMPLE_BITS => SAMPLE_BITS,
    GAIN_BITS => GAIN_BITS,
    GAIN_SCALE => GAIN_SCALE
  )
  port map (
    clk => clk,
    rst => rst,
    gain => gain,
    in_sample => in_sample,
    in_sample_valid => in_sample_valid,
    out_sample => out_sample,
    out_sample_valid => out_sample_valid
  );

  gen_clock(clk);

  PROC_SEQUENCER : process
  begin
    do_reset(clk, rst);

    gain <= shift_left(to_unsigned(1, GAIN_BITS), GAIN_SCALE); -- unitary gain
    in_sample <= to_signed(100, SAMPLE_BITS);
    in_sample_valid <= '1';
    wait until rising_edge(clk);
    in_sample_valid <= '0';
    wait until rising_edge(clk);

    assert out_sample_valid = '1'
      report "out sample is not valid when expected"
      severity failure;

    assert out_sample = 100
      report "out sample is not 100 as expected: " & integer'image(to_integer(out_sample))
      severity failure;

    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
end architecture;