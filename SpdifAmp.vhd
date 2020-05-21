library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SpdifAmp is
	port(
		i_clock: in std_logic;
		i_data: in std_logic;
		o_payload_begin, o_payload_clock, o_payload_data: out std_logic;
		o_px, o_py, o_pz: out std_logic
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
	
	signal r_small, r_medium, r_large: std_logic;
	signal r_payload_clock: std_logic;
begin
	preambleDecoder: Aes3PreambleDecoder port map (
		i_clock, 
		i_data, 
		o_payload_begin, r_payload_clock, r_small, r_medium, r_large, 
		o_px, o_py, o_pz);
		
	bmcDecoder: BiphaseMarkDecoder port map (
		i_clock, 
		r_payload_clock, 
		r_small, 
		r_medium, 
		o_payload_clock, 
		o_payload_data);
end rtl;

