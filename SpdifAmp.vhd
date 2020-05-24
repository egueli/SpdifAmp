library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity SpdifAmp is
	port(
		i_clock: in std_logic;
		i_data: in std_logic;
		o_leds: out std_logic_vector(27 downto 0);
		o_leds_strobe: out std_logic
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
	component StrobeGenerator is
		generic(
			strobe_length: integer := 3
		);
		port(
			i_clock: in std_logic;
			i_toggles: in std_logic;
			o_strobe: out std_logic
		);
	end component StrobeGenerator;
		
	signal r_small, r_medium, r_large: std_logic;
	signal r_payload_clock_bmc: std_logic;
	
	signal r_payload_begin: std_logic;
	signal r_payload_clock: std_logic;
	signal r_payload_data: std_logic;
	signal r_py: std_logic;
	signal r_subframe: std_logic_vector(31 downto 4);
	signal r_subframe_strobe: std_logic;
	signal r_subframe_strobe_toggles: std_logic := '0';

begin
	preambleDecoder: Aes3PreambleDecoder port map (
		i_clock => i_clock, 
		i_data => i_data, 
		o_payload_begin => r_payload_begin,
		o_payload_clock => r_payload_clock_bmc,
		o_small => r_small, 
		o_medium => r_medium,
		o_large => r_large, 
		o_px => open,
		o_py => r_py,
		o_pz => open);
		
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
	
	outputPayload : process(r_subframe_strobe)
	begin
		if falling_edge(r_subframe_strobe) then
			if r_py = '1' then
				o_leds <= r_subframe(31 downto 4);
				r_subframe_strobe_toggles <= not r_subframe_strobe_toggles;
			end if;
		end if;
	end process;
	
	payloadStrobe : StrobeGenerator port map (
		i_clock => i_clock,
		i_toggles => r_subframe_strobe_toggles,
		o_strobe => o_leds_strobe
	);
end rtl;

