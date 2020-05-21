library ieee;
use ieee.std_logic_1164.all;

entity BiphaseMarkDecoder is
	port(
		i_clock: in std_logic;
		i_strobe: in std_logic;
		i_short: in std_logic;
		i_long: in std_logic;
		o_strobe: out std_logic;
		o_data: out std_logic
	);
end BiphaseMarkDecoder;

architecture rtl of BiphaseMarkDecoder is
	component StrobeGenerator is
		generic(
			strobe_length: integer := 3
		);
		port(
			i_clock: in std_logic;
			i_toggles: in std_logic;
			o_strobe: out std_logic
		);
	end component;	
	
	type t_state is (IDLE, ONE_FIRST_PULSE);
	signal r_state: t_state := IDLE;
	
	signal r_strobe_out : std_logic := '0';
begin
	StateMachine : process(i_strobe)
	begin
		if falling_edge(i_strobe) then
			case r_state is
			when IDLE =>
				if i_short = '1' then
					r_state <= ONE_FIRST_PULSE;
				elsif i_long = '1' then
					o_data <= '0';
					r_strobe_out <= not r_strobe_out;
				end if;
			
			when ONE_FIRST_PULSE =>
				if i_short = '1' then
					o_data <= '1';
					r_strobe_out <= not r_strobe_out;
				end if;
				r_state <= IDLE;					
			end case;
		end if;
	end process;
	
	dataOutStrobe: StrobeGenerator port map (i_clock, r_strobe_out, o_strobe);
end architecture;