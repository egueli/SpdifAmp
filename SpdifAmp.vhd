library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SpdifAmp is
	port(
		i_clock: in std_logic;
		i_data: in std_logic;
		o_leds: out std_logic_vector(0 to 27)
	);
end SpdifAmp;
 
architecture rtl of SpdifAmp is
	constant c_pll_phase_bits : integer := 32;
	constant c_pll_phase_ratio : real := 50.0e6 / (2.0 ** c_pll_phase_bits);
	constant c_pll_initial_frequency : integer := 3000000;
	constant c_pll_initial_step : integer := integer(real(c_pll_initial_frequency) / c_pll_phase_ratio);

	component Aes3PreambleDecoder is
		port(
			i_clock: in std_logic;
			i_data: in std_logic;
			o_payload_begin, o_payload_clock, o_small, o_medium, o_large: out std_logic;
			o_px, o_py, o_pz: out std_logic;
			o_pulse_count: out integer range 0 to 63
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
	component SDPLL is
		generic(
			PHASE_BITS : integer := c_pll_phase_bits
		);
		port(
			i_clk: in std_logic;
			i_ld: in std_logic;
			i_step: in std_logic_vector((c_pll_phase_bits - 2) downto 0);
			i_ce: in std_logic;
			i_input: in std_logic;
			i_lgcoeff: in std_logic_vector(4 downto 0);
			o_phase: out std_logic_vector((c_pll_phase_bits - 1) downto 0);
			o_err: out std_logic_vector(1 downto 0)
		);
	end component SDPLL;
	component AudioVisualizer is
	port(
			i_subframe: std_logic_vector(31 downto 4);
			i_subframe_strobe: std_logic;
			i_px, i_py, i_pz: std_logic;	
			o_leds: out std_logic_vector(0 to 27)
	);
	end component;
		
	signal r_small, r_medium, r_large: std_logic;
	signal r_payload_clock_bmc: std_logic;
	signal r_px, r_py, r_pz: std_logic;
	
	signal r_payload_begin: std_logic;
	signal r_payload_clock: std_logic;
	signal r_payload_data: std_logic;
	signal r_subframe: std_logic_vector(31 downto 4);
	signal r_subframe_strobe: std_logic;
	signal r_pulse_count: integer range 0 to 63;
    signal r_pulse_count_bits: std_logic_vector(5 downto 0);
	signal r_pll_input: std_logic;
	signal r_pll_phase: std_logic_vector((c_pll_phase_bits - 1) downto 0);
    signal r_sample_clock: std_logic;
begin
	preambleDecoder: Aes3PreambleDecoder port map (
		i_clock => i_clock, 
		i_data => i_data, 
		o_payload_begin => r_payload_begin,
		o_payload_clock => r_payload_clock_bmc,
		o_small => r_small, 
		o_medium => r_medium,
		o_large => r_large, 
		o_px => r_px,
		o_py => r_py,
		o_pz => r_pz,
		o_pulse_count => r_pulse_count);
		
    r_pulse_count_bits <= std_logic_vector(to_unsigned(r_pulse_count, 6));
	
	sampleClock : process(r_payload_begin) is
    begin
		if rising_edge(r_payload_begin) then
			r_sample_clock <= r_py;
		end if;
    end process;
		
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

	o_leds(0) <= i_data;
	-- o_leds(0 to 5) <= std_logic_vector(to_unsigned(r_pulse_count, 6));
		
	r_pll_input <= r_sample_clock;
	o_leds(1) <= r_pll_input;
	
	encoder_pll: SDPLL generic map (
		PHASE_BITS => c_pll_phase_bits
	)
	port map (
		i_clk => i_clock,
		i_ld => '0',
		i_step => "0000000000000000000000000000000",
		i_ce => '1',
		i_input => r_pll_input,
		i_lgcoeff => std_logic_vector(to_unsigned(10, 5)),
		o_phase => r_pll_phase,
		o_err => open
	);
	
	o_leds(2) <= r_pll_phase(31);
	o_leds(3) <= r_pll_phase(27);
	o_leds(4) <= r_pll_phase(26);
	o_leds(5) <= r_pll_phase(25);
	o_leds(6) <= r_pll_phase(24);
	
	-- o_leds(6 to 13) <= r_pll_phase((c_pll_phase_bits - 1) downto (c_pll_phase_bits - 8));
end rtl;
