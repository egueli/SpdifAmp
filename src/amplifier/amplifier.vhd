library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity amplifier is
  generic(
    SAMPLE_BITS : integer := 16;
    GAIN_BITS : integer := 8;
    GAIN_OFFSET : integer := 4
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

begin

end architecture;