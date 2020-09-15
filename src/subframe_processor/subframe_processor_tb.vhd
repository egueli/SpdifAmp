library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

library spdif_amp;
use spdif_amp.types.all;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;
use spdif_amp_sim.sim_constants.all;

entity subframe_processor_tb is
end subframe_processor_tb;

architecture sim of subframe_processor_tb is
  signal clk : std_logic := '1';
  signal rst : std_logic := '1';
  signal gain : natural range 3 downto 0 := 0;
  signal in_subframe : std_logic_vector(27 downto 0) := (others => '0');
  signal in_subframe_valid : std_logic := '0';
  signal out_subframe : std_logic_vector(27 downto 0);
  signal out_subframe_valid : std_logic;
begin

  gen_clock(clk);

  DUT : entity spdif_amp.subframe_processor(rtl)
  port map (
    clk => clk,
    rst => rst,
    in_subframe => in_subframe,
    in_subframe_valid => in_subframe_valid,
    gain => gain,
    out_subframe => out_subframe,
    out_subframe_valid => out_subframe_valid
  );

  SEQUENCER_PROC : process
    procedure check_processor(
      constant input : subframe_payload_type;
      constant expected_output : subframe_payload_type
    ) is
    begin
      in_subframe <= input;
      in_subframe_valid <= '1';
      wait until rising_edge(clk);
      in_subframe_valid <= '0';
      wait until rising_edge(clk);

      wait until out_subframe_valid'event for clock_period * 10;

      assert out_subframe_valid = '1'
        report "out subframe is not valid when expected"
        severity failure;
      
      assert out_subframe = expected_output
        report "out subframe is different than expected: expected " 
          & to_hstring(expected_output)
          & " actual "
          & to_hstring(out_subframe)
        severity failure;
      
    end procedure;

    procedure check_processor(
      constant input : integer;
      constant expected_output : integer
    ) is
    begin
      check_processor(
        std_logic_vector(to_unsigned(input, in_subframe'length)),
        std_logic_vector(to_unsigned(expected_output, out_subframe'length))
        );
    end procedure;

    function sample_subframe(
      constant sample : integer
    ) return subframe_payload_type is
      constant sample_bits : std_logic_vector(19 downto 0) := std_logic_vector(to_unsigned(sample, 20));
    begin
      return (
        27 => xor sample_bits,
        26 downto 24 => '0',
        23 downto 4 => sample_bits,
        3 downto 0 => '0'
      );
    end function;
  begin
    do_reset(clk, rst);

    report "tests with unity gain, so samples aren't altered";

    report "all-zero subframes go as-is";
    check_processor(16#0000000#, 16#0000000#);
    report "non-zero subframes with correct parity go as-is";
    check_processor(16#A55AA55#, 16#A55AA55#);
    report "non-zero subframes with wrong parity are cleared";
    check_processor(16#A55AA54#, 16#0000000#);

    report "tests with 2x gain";
    gain <= 1;
    report "amplification that doesn't change parity";
    check_processor(sample_subframe(16#00400#), sample_subframe(16#00800#));
    report "amplification that does change parity";
    check_processor(sample_subframe(16#FFC00#), sample_subframe(16#FF800#));


    finish;
  end process;

end architecture;