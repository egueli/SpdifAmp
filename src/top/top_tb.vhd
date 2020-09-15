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
    output => output
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

    procedure send_subframe_z_0 is
    begin
      send_subframe_preamble(TYPE_Z);
  
      -- send a payload made of all zeros
      ALL_ZEROS : for i in 1 to 28 loop
        toggle_medium;
      end loop; -- ALL_ZEROS
    end procedure;
    procedure send_subframe_y_1 is
    begin
      send_subframe_preamble(TYPE_Y);
  
      -- send a payload made of all ones
      ALL_ONES : for i in 1 to 28 loop
        toggle_small;
        toggle_small;
      end loop; -- ALL_ZEROS
    end procedure;
  begin
    rst_button <= '0';
    wait until rising_edge(clk);
    rst_button <= '1';

    wait until rising_edge(clk);

    -- We need to send a few dummy subframes to allow the PLL to get in sync
    PLL_SYNC : for i in 0 to 50 loop
      send_subframe_z_0;    
    end loop; -- PLL_SYNC

    -- Now send two different subframes; manually check that the clock is stable
    send_subframe_y_1;
    send_subframe_z_0;
    send_subframe_y_1;
    send_subframe_z_0;
    send_subframe_y_1;
    send_subframe_z_0;


    print_test_ok;
    finish;
  end process; -- PROC_SEQUENCER
end architecture;