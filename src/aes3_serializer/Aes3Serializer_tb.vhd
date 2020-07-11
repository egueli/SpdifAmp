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
  signal i_clock : std_logic := '0';
  signal i_pulse_clock : std_logic := '0';
  signal i_payload : std_logic_vector(31 downto 4) := (others => 'X');
  signal i_strobe : std_logic := '0';
  signal i_px : std_logic := '0';
  signal i_py : std_logic := '0';
  signal i_pz : std_logic := '0';
  signal o_output : std_logic;
begin
  gen_clock(i_clock);
  i_pulse_clock <= not i_pulse_clock after aes3_clock_period / 2;

  DUT : entity spdif_amp.Aes3Serializer(rtl)
	port map (
		i_clock => i_clock,
    i_pulse_clock => i_pulse_clock,
		i_payload => i_payload,
		i_strobe => i_strobe,
		i_px => i_px,
		i_py => i_py,
		i_pz => i_pz,
		o_output => o_output
  );
  
  PROC_SEQUENCER : process
  begin
    wait for 1 us;
    print_test_ok;
    finish;    
  end process; -- PROC_SEQUENCER
end architecture;