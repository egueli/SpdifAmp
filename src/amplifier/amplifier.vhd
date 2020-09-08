library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity amplifier is
  generic(
    -- number of bits of the input and output samples, including sign
    SAMPLE_BITS : integer := 16;
    -- number of bit of the gain. Gain is unsigned
    GAIN_BITS : integer := 8;
    -- number of bits the gain is scaled down. 0 = no scaling, 1 = divide by 2, 2 = divide by 4 etc.
    GAIN_SCALE : integer := 4
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    gain : in unsigned(GAIN_BITS-1 downto 0);
    in_sample : in signed(SAMPLE_BITS-1 downto 0);
    out_sample : out signed(SAMPLE_BITS-1 downto 0)
  );
end amplifier; 

architecture rtl of amplifier is
  constant full_sample_high_bit : integer := SAMPLE_BITS + GAIN_BITS - 1;
  constant out_sample_high_bit : integer := full_sample_high_bit - GAIN_SCALE;
  constant out_sample_low_bit : integer := out_sample_high_bit - SAMPLE_BITS + 1;
  signal full_sample : signed(full_sample_high_bit downto 0);
begin
  full_sample <= in_sample * signed(gain);
  out_sample <= full_sample(out_sample_high_bit downto out_sample_low_bit);
end architecture;