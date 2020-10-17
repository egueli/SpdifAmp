library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;
use spdif_amp_sim.sim_constants.all;

entity amplifier_tb is
  generic(
    SAMPLE_BITS : integer := 16
  );
end amplifier_tb; 

architecture sim of amplifier_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '0';
  signal gain : natural range 3 downto 0;
  signal in_sample : signed(SAMPLE_BITS-1 downto 0);
  signal in_sample_valid : std_logic := '0';
  signal out_sample : signed(SAMPLE_BITS-1 downto 0);
  signal out_sample_valid : std_logic;
begin
  DUT : entity spdif_amp.amplifier(rtl)
  generic map (
    SAMPLE_BITS => SAMPLE_BITS
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
    procedure check_amplification(
      constant in_sample_num : integer;
      constant gain_num : natural range 3 downto 0;
      constant expected_out_sample : integer
    ) is
    begin
      gain <= gain_num;
      in_sample <= to_signed(in_sample_num, SAMPLE_BITS);
      in_sample_valid <= '1';
      wait until rising_edge(clk);
      in_sample_valid <= '0';
      wait until rising_edge(out_sample_valid) for 10 * clock_period;

      assert out_sample_valid = '1'
        report "out sample is not valid when expected"
        severity failure;

      assert out_sample = expected_out_sample
        report "for input " & integer'image(in_sample_num) & 
        ", out sample is not " & integer'image(expected_out_sample) &
        " as expected but " & integer'image(to_integer(out_sample))
        severity failure;
    end procedure;
  begin
    do_reset(clk, rst);

    -- Check unity gain
    check_amplification(100, 0, 100);
    check_amplification(0, 0, 0);
    check_amplification(-100, 0, -100);
    check_amplification(32767, 0, 32767);
    check_amplification(-32768, 0, -32768);

    -- Check amplification
    check_amplification(100, 1, 200);
    check_amplification(-100, 1, -200);
    check_amplification(16383, 1, 32766);
    check_amplification(-16384, 1, -32768);
    check_amplification(100, 2, 400);
    check_amplification(100, 3, 800);
    
    -- Check amplification saturation
    check_amplification(16384, 1, 32767); -- and not 32768 due to saturation
    check_amplification(-16385, 1, -32768); -- and not -32770 due to saturation
    check_amplification(32767, 1, 32767); -- extreme inputs will be extremely saturated
    check_amplification(-32768, 1, -32768);
    
    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
end architecture;