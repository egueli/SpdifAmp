library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spdif_amp;

entity aes3_encoder is
  port (
    clk : in std_logic;
    rst : in std_logic;
    payload : in std_logic_vector(27 downto 0);
    type_x : in std_logic;
    type_y : in std_logic;
    type_z : in std_logic;
    subframe_valid : in std_logic;
    output : out std_logic
  );
end aes3_encoder; 

architecture str of aes3_encoder is
  constant pll_bits : integer := 24;
  constant pll_msb : integer := pll_bits - 1;

  signal pll_clock : std_logic;
  signal pll_phase : unsigned(pll_msb downto 0);
  signal serializer_clock : std_logic;
begin
  PLL_CLOCK_GENERATOR : entity spdif_amp.integrator(rtl)
  port map (
    clk => clk,
    rst => rst,
    pulse => subframe_valid,
    toggle => pll_clock
  );

  PLL : entity spdif_amp.pll(rtl)
  generic map (
    PHASE_BITS => pll_bits,
    LGCOEFF => 10,
    INITIAL_PHASE_STEP => to_unsigned(0, pll_bits)
  )
  port map (
    clk => clk,
    rst => rst,
    input => pll_clock,
    phase => pll_phase,
    error => open
  );

  -- The serializer will make one subframe every 128 pulses,
  -- so use the 7th most significant PLL phase bit, it is 2**7 times
  -- faster than the input subframe clock.
  serializer_clock <= pll_phase(pll_msb - 7);

  SERIALIZER : entity spdif_amp.aes3_serializer(rtl)
	port map (
		i_clock => clk,
    pulse_clock => serializer_clock,
		i_payload => payload,
		i_valid => subframe_valid,
		i_px => type_x,
		i_py => type_y,
		i_pz => type_z,
		o_output => output
  );
end architecture;