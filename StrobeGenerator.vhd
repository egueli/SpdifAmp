library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity StrobeGenerator is
	generic(
		strobe_length: integer := 3
	);
	port(
		i_clock: in std_logic;
		i_toggles: in std_logic;
		o_strobe: out std_logic
	);
end StrobeGenerator;

architecture rtl of StrobeGenerator is
	signal r_last_state: std_logic := '0';
	signal r_count : integer range 0 to (strobe_length-1) := 0;
begin
	Strobe : process(i_clock)
	begin
		if rising_edge(i_clock) then
			if i_toggles /= r_last_state then
				r_count <= strobe_length - 1;
				o_strobe <= '1';
			elsif r_count /= 0 then
				r_count <= r_count - 1;
				o_strobe <= '1';
			else
				o_strobe <= '0';
			end if;
			r_last_state <= i_toggles;
		end if;
	end process;
end architecture rtl;