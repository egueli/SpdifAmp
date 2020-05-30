library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AudioVisualizer is
	port(
			i_subframe: std_logic_vector(31 downto 4);
			i_subframe_strobe: std_logic;
			i_px, i_py, i_pz: std_logic;	
			o_leds: out std_logic_vector(0 to 27)
	);
end entity;

architecture rtl of AudioVisualizer is
	function reverse_any_vector(a: in std_logic_vector)
	return std_logic_vector is
		variable result: std_logic_vector(a'range);
		alias aa: std_logic_vector(a'reverse_range) is a;
	begin
		for i in aa'range loop
			result(i) := aa(i);
		end loop;
		return result;
	end;
	
	signal r_audio_sample: std_logic_vector(15 downto 0);
	signal r_audio_absolute: std_logic_vector(15 downto 0);
	signal r_channel_status: std_logic;
	signal r_parity: std_logic;

begin
	outputPayload : process(i_subframe_strobe)
	begin
		if falling_edge(i_subframe_strobe) then
			r_audio_sample <= i_subframe(27 downto 12);
			r_audio_absolute <= std_logic_vector(abs(signed(r_audio_sample)));
			r_channel_status <= i_subframe(30);
			o_leds(26) <= r_channel_status;
			r_parity <= i_subframe(31);
			o_leds(27) <= r_parity;

			if i_py = '1' then
				o_leds(0 to 10) <= r_audio_absolute(14 downto 4);
			elsif i_px = '1' or i_pz = '1' then
				o_leds(11 to 21) <= reverse_any_vector(r_audio_absolute(14 downto 4));
			end if;
		end if;
	end process;
end rtl;