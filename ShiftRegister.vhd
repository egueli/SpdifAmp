library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftRegister is
	generic(n_bits : integer := 28);
	port(
		i_clock: in std_logic;
		i_data: in std_logic;
		i_strobe: in std_logic;
		i_reset: in std_logic;
		o_output: out std_logic_vector((n_bits - 1) downto 0);
		o_strobe: out std_logic
	);
end ShiftRegister;

architecture rtl of ShiftRegister is
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

	signal r_remaining : integer range 0 to n_bits := n_bits;
	signal r_register : std_logic_vector((n_bits - 1) downto 0) := (others => '0');
	signal r_strobe : std_logic := '0';
begin
	countAndStrobe : process(i_reset, i_strobe)
	begin
		if i_reset = '1' then
			r_remaining <= n_bits;
		elsif falling_edge(i_strobe) then
			if r_remaining = 1 then
				r_strobe <= not r_strobe;
			else
				r_remaining <= r_remaining - 1;
			end if;
		end if;
	end process;
	
	strobe : StrobeGenerator port map (
		 i_clock => i_clock,
		 i_toggles => r_strobe,
		 o_strobe => o_strobe
	);
	
	doShift : process(i_strobe)
	begin
		if falling_edge(i_strobe) then
			r_register <= i_data & r_register((n_bits - 1) downto 1);
		end if;
	end process;
	
	o_output <= r_register;
end rtl;
