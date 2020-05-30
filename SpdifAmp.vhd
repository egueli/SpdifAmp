library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SpdifAmp is
	port(
		i_clock: in std_logic;
		i_data: in std_logic;
		o_leds: out std_logic_vector(0 to 27)
	);
end SpdifAmp;
 
architecture rtl of SpdifAmp is
	component Aes3PreambleDecoder is
		port(
			i_clock: in std_logic;
			i_data: in std_logic;
			o_payload_begin, o_payload_clock, o_small, o_medium, o_large: out std_logic;
			o_px, o_py, o_pz: out std_logic
		);
	end component Aes3PreambleDecoder;
	component BiphaseMarkDecoder is
		port(
			i_clock: in std_logic;
			i_strobe: in std_logic;
			i_short: in std_logic;
			i_long: in std_logic;
			o_strobe: out std_logic;
			o_data: out std_logic
		);
	end component BiphaseMarkDecoder;
	component ShiftRegister is
		generic(n_bits : integer := 28);
		port(
			i_clock: in std_logic;
			i_data: in std_logic;
			i_strobe: in std_logic;
			i_reset: in std_logic;
			o_output: out std_logic_vector((n_bits - 1) downto 0);
			o_strobe: out std_logic
		);
	end component ShiftRegister;
	component AudioVisualizer is
	port(
			i_subframe: std_logic_vector(31 downto 4);
			i_subframe_strobe: std_logic;
			i_px, i_py, i_pz: std_logic;	
			o_leds: out std_logic_vector(0 to 27)
	);
	end component;
		
	signal r_small, r_medium, r_large: std_logic;
	signal r_payload_clock_bmc: std_logic;
	signal r_px, r_py, r_pz: std_logic;
	
	signal r_payload_begin: std_logic;
	signal r_payload_clock: std_logic;
	signal r_payload_data: std_logic;
	signal r_subframe: std_logic_vector(31 downto 4);
	signal r_subframe_strobe: std_logic;

begin
	preambleDecoder: Aes3PreambleDecoder port map (
		i_clock => i_clock, 
		i_data => i_data, 
		o_payload_begin => r_payload_begin,
		o_payload_clock => r_payload_clock_bmc,
		o_small => r_small, 
		o_medium => r_medium,
		o_large => r_large, 
		o_px => r_px,
		o_py => r_py,
		o_pz => r_pz);
		
	bmcDecoder: BiphaseMarkDecoder port map (
		i_clock, 
		r_payload_clock_bmc, 
		r_small, 
		r_medium, 
		r_payload_clock, 
		r_payload_data);
		
	payloadShiftRegister: ShiftRegister port map (
		i_clock => i_clock,
		i_data => r_payload_data,
		i_strobe => r_payload_clock,
		i_reset => r_payload_begin,
		o_output => r_subframe(31 downto 4),
		o_strobe => r_subframe_strobe
		);
	
	visualizer : AudioVisualizer port map(
		i_subframe => r_subframe,
		i_subframe_strobe => r_subframe_strobe,
		i_px => r_px,
		i_py => r_py,
		i_pz => r_pz,
		o_leds => o_leds
	);
		
end rtl;
