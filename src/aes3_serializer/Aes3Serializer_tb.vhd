library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

library spdif_amp;

library spdif_amp_sim;
use spdif_amp_sim.sim_constants.all;
use spdif_amp_sim.sim_subprograms.all;

entity Aes3Serializer_tb is
end Aes3Serializer_tb; 

architecture sim of Aes3Serializer_tb is
  signal i_clock : std_logic := '1';
  signal pulse_clock : std_logic := '0';
  signal i_payload : std_logic_vector(31 downto 4) := (others => 'X');
  signal i_valid : std_logic := '0';
  signal i_px : std_logic := '0';
  signal i_py : std_logic := '0';
  signal i_pz : std_logic := '0';
  signal o_output : std_logic;
begin
  gen_clock(i_clock);
  pulse_clock <= not pulse_clock after aes3_clock_period / 2;

  DUT : entity spdif_amp.Aes3Serializer(rtl)
	port map (
		i_clock => i_clock,
    pulse_clock => pulse_clock,
		i_payload => i_payload,
		i_valid => i_valid,
		i_px => i_px,
		i_py => i_py,
		i_pz => i_pz,
		o_output => o_output
  );
  
  PROC_SEQUENCER : process
  begin

    wait_start : for i in 0 to 10 loop
      wait until rising_edge(i_clock);
    end loop; -- wait_start

    i_payload <= (others => '0');
    i_px <= '1';
    i_py <= '0';
    i_pz <= '0';

    i_valid <= '1';
    wait until rising_edge(i_clock);
    i_valid <= '0';
    i_payload <= (others => 'X');

    -- wait to do two full frames, see what happens in the output between the first and the second
    wait for aes3_clock_period * 128;
    print_test_ok;
    finish;    
  end process; -- PROC_SEQUENCER
end architecture;