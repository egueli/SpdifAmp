library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp;
use spdif_amp.types.all;

library spdif_amp_sim;
use spdif_amp_sim.sim_subprograms.all;
use spdif_amp_sim.sim_constants.all;

entity top_tb is
end top_tb; 

architecture sim of top_tb is
  signal clk : std_logic := '1';
  signal rst_button : std_logic := '1';
  signal input : std_logic := '0';
  signal output : std_logic;

  constant one_bit_duration : time := 354 ns;
  constant half_bit_duration : time := one_bit_duration / 2;
  constant one_half_bit_duration : time := one_bit_duration + half_bit_duration;

begin
  gen_clock(clk);

  DUT : entity spdif_amp.top(str)
  port map (
    clk => clk,
    rst_button => rst_button,
    input => input,
    output => output,
    red_leds => open,
    green_leds => open,
    spi_in => (others => '0'),
    spi_out => open,
    debug_pins => open
  );

  PROC_SEQUENCER : process
    procedure toggle_large is
    begin
      input <= not input;
      wait for one_half_bit_duration;
    end procedure;
    procedure toggle_medium is
    begin
      input <= not input;
      wait for one_bit_duration;
    end procedure;
    procedure toggle_small is
    begin
      input <= not input;
      wait for half_bit_duration;
    end procedure;

    procedure send_subframe_preamble(
      constant subframe_type : subframe_type_t
    ) is
    begin
      case subframe_type is
        when TYPE_X =>
          toggle_large;
          toggle_large;
          toggle_small;
          toggle_small;
        
        when TYPE_Y =>
          toggle_large;
          toggle_medium;
          toggle_small;
          toggle_medium;
          
        when TYPE_Z =>
          toggle_large;
          toggle_small;
          toggle_small;
          toggle_large; 
      
      end case;
    end procedure;

    procedure send_subframe_payload(
      constant payload : subframe_payload_t
    ) is
    begin
      for i in 0 to 27 loop
        if payload(i) = '1' then
          toggle_small;
          toggle_small;         
        else
          toggle_medium;
        end if;
      end loop;
    end procedure;
  begin
    rst_button <= '0';
    wait until rising_edge(clk);
    rst_button <= '1';

    wait until rising_edge(clk);

    -- We need to send a few dummy subframes to allow the PLL to get in sync
    PLL_SYNC : for i in 0 to 50 loop
      send_subframe_preamble(TYPE_Z);
      send_subframe_payload((27 downto 0 => '0'));
    end loop; -- PLL_SYNC

    report "Z subframe with first half of payload bits to 1";
    send_subframe_preamble(TYPE_Z);
    send_subframe_payload((0 to 13 => '1', 14 to 27 => '0'));

    report "Y subframe with second half of payload bits to 1";
    send_subframe_preamble(TYPE_Y);
    send_subframe_payload((0 to 13 => '0', 14 to 27 => '1'));

    report "X subframe with all payload bits to 0";
    send_subframe_preamble(TYPE_X);
    send_subframe_payload((0 to 27 => '0'));

    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
end architecture;