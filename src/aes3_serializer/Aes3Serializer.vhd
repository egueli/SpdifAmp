library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Aes3Serializer is
	port(
		i_clock: in std_logic;
		pulse_clock: in std_logic;
		i_payload: in std_logic_vector(31 downto 4);
		i_valid: in std_logic;
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
		constant PREAMBLE_X : std_logic_vector(0 to 7) := "10010011";
		constant PREAMBLE_Y : std_logic_vector(0 to 7) := "10010110";
		constant PREAMBLE_Z : std_logic_vector(0 to 7) := "10011100";
	begin
		if x = '1' then
			return PREAMBLE_X(pulse_count);
		elsif y = '1' then
			return PREAMBLE_Y(pulse_count);
		else
			return PREAMBLE_Z(pulse_count);
		end if;
	end function;
	
	-- The AES3 pulse clock, delayed by one clock period
	signal pulse_clock_p1: std_logic := '0';
	signal r_payload : std_logic_vector(31 downto 4) := (others => '0');
	signal r_px, r_py, r_pz: std_logic;
	signal r_pulse_count: integer range 0 to 63 := 0;
	signal r_output_toggle: std_logic := '0';
	signal r_output: std_logic := '0';
begin
	serializer : process(i_clock) is
	begin
		if rising_edge(i_clock) then
			if i_valid = '1' then
				r_pulse_count <= 0;
				r_payload <= i_payload;
				r_px <= i_px;
				r_py <= i_py;
				r_pz <= i_pz;
			else
				pulse_clock_p1 <= pulse_clock;
				
				if pulse_clock_p1 = '0' and pulse_clock = '1' then
					r_pulse_count <= (r_pulse_count + 1) mod 64;
					case r_pulse_count is
						when 0 to 7 => r_output_toggle <= make_preamble(r_pulse_count, r_px, r_py, r_pz);
						when others => 
							if (r_pulse_count mod 2) = 0 then
								r_output_toggle <= '1';
							else
								r_output_toggle <= r_payload(r_pulse_count / 2);
							end if;
					end case;
					
					if r_output_toggle = '1' then
						r_output <= not r_output;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	o_output <= r_output;
end rtl;