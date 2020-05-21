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
	component Aes3BaseDecoder is
		port(
			i_clock: in std_logic;
			i_data: in std_logic;
			o_large, o_medium, o_small: out std_logic;
			o_strobe: out std_logic
		);
	end component;
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
	
	signal r_strobe_in, r_large, r_medium, r_small: std_logic;
	signal r_payload_begin : std_logic := '0';
	signal r_payload_clock : std_logic := '0';
	
	type t_state is (WS, SY, PX1, PX2, PY1, PY2, PZ1, PZ2, PL);
	signal r_state : t_state := WS;
begin
	decoder: Aes3BaseDecoder port map (i_clock, i_data, r_large, r_medium, r_small, r_strobe_in);
	payloadBeginStrobe: StrobeGenerator port map (i_clock, r_payload_begin, o_payload_begin);
	payloadClockStrobe: StrobeGenerator port map (i_clock, r_payload_clock, o_payload_clock);
	
	PreambleStateMachine : process(r_strobe_in)
	begin
		if falling_edge(r_strobe_in) then
			o_small <= r_small;
			o_medium <= r_medium;
			o_large <= r_large;
			case r_state is
				when WS =>
					o_px <= '0';
					o_py <= '0';
					o_pz <= '0';
					if r_large = '1' then
						r_state <= SY;
					end if;
					
				when SY =>
					o_px <= '0';
					o_py <= '0';
					o_pz <= '0';
					if r_large = '1' then
						r_state <= PX1;
					elsif r_medium = '1' then
						r_state <= PY1;
					elsif r_small = '1' then
						r_state <= PZ1;
					end if;
					
				when PX1 =>
					o_px <= '1';
					o_py <= '0';
					o_pz <= '0';
					if r_small = '1' then
						r_state <= PX2;
					else
						r_state <= WS;
					end if;
					
				when PX2 =>
					o_px <= '1';
					o_py <= '0';
					o_pz <= '0';
					if r_small = '1' then
						r_payload_begin <= not r_payload_begin;
						r_state <= PL;
					else
						r_state <= WS;
					end if;
					
				when PY1 =>
					o_px <= '0';
					o_py <= '1';
					o_pz <= '0';
					if r_small = '1' then
						r_state <= PY2;
					else
						r_state <= WS;
					end if;
					
				when PY2 =>
					o_px <= '0';
					o_py <= '1';
					o_pz <= '0';
					if r_medium = '1' then
						r_payload_begin <= not r_payload_begin;
						r_state <= PL;
					else
						r_state <= WS;
					end if;
					
				when PZ1 =>
					o_px <= '0';
					o_py <= '0';
					o_pz <= '1';
					if r_small = '1' then
						r_state <= PZ2;
					else
						r_state <= WS;
					end if;
					
				when PZ2 =>
					o_px <= '0';
					o_py <= '0';
					o_pz <= '1';
					if r_large = '1' then
						r_payload_begin <= not r_payload_begin;
						r_state <= PL;
					else
						r_state <= WS;
					end if;
					
				when PL =>
					if r_large = '1' then
						r_state <= SY;
					else
						r_payload_clock <= not r_payload_clock;
					end if;
			end case;
		end if;
	end process PreambleStateMachine;
end rtl;

