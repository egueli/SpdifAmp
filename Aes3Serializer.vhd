library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Aes3Serializer is
	port(
		i_pulse_clock: in std_logic;
		i_payload: in std_logic_vector(31 downto 4);
		i_strobe: in std_logic;
		i_px: in std_logic;
		i_py: in std_logic;
		i_pz: in std_logic;
		o_output: out std_logic
	);
end Aes3Serializer;

architecture rtl of Aes3Serializer is
	function make_preamble(
		pulse_count : integer;
		x : std_logic;
		y : std_logic;
		z : std_logic
	) return std_logic is
		constant PREAMBLE_X : std_logic_vector(0 to 7) := "11100010";
		constant PREAMBLE_Y : std_logic_vector(0 to 7) := "11100100";
		constant PREAMBLE_Z : std_logic_vector(0 to 7) := "11101000";
	begin
		if x = '1' then
			return PREAMBLE_X(pulse_count);
		elsif y = '1' then
			return PREAMBLE_Y(pulse_count);
		else
			return PREAMBLE_Z(pulse_count);
		end if;
	end function;
	
	signal r_payload : std_logic_vector(31 downto 4) := (others => '0');
	signal r_pulse_count: integer range 0 to 63 := 0;
	
begin
	serializer : process(i_pulse_clock, i_strobe) is
	begin
		if i_strobe = '1' then
			r_pulse_count <= 0;
			r_payload <= i_payload;
		elsif rising_edge(i_pulse_clock) then
			r_pulse_count <= (r_pulse_count + 1) mod 64;
			case r_pulse_count is
				when 0 to 7 => o_output <= make_preamble(r_pulse_count, i_px, i_py, i_pz);
				when others => o_output <= r_payload(r_pulse_count / 2);
			end case;
		end if;
	end process;
end rtl;