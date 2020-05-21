library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SpdifAmp is
	port(
		i_clock: in std_logic;
		i_data: in std_logic;
		o_payload_begin, o_payload_clock, o_small, o_medium, o_large: out std_logic;
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
begin
	decoder: Aes3PreambleDecoder port map (i_clock, i_data, o_payload_begin, o_payload_clock, o_small, o_medium, o_large);
end rtl;

