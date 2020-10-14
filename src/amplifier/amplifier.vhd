library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity amplifier is
  generic(
    -- number of bits of the input and output samples, including sign
    SAMPLE_BITS : integer := 16;
    -- max allowed gain, as amount of bit shifting
    MAX_GAIN : natural := 3
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    gain : in natural range MAX_GAIN downto 0;
    in_sample : in signed(SAMPLE_BITS-1 downto 0);
    in_sample_valid : in std_logic;
    out_sample : out signed(SAMPLE_BITS-1 downto 0);
    out_sample_valid : out std_logic
  );
end amplifier; 

architecture rtl of amplifier is
  signal in_sample_valid_p1 : std_logic;
  signal full_sample : signed(SAMPLE_BITS downto 0); -- it's one bit larger than in_sample to contain overflow
  constant max_positive : signed(SAMPLE_BITS downto 0) := "00" & (SAMPLE_BITS - 2 downto 0 => '1');
  constant max_negative : signed(SAMPLE_BITS downto 0) := "01" & (SAMPLE_BITS - 2 downto 0 => '0');
begin
  out_sample <= full_sample(SAMPLE_BITS - 1 downto 0);

  PROC_SHIFTER : process(clk)
    variable i : integer;
  begin
    if rising_edge(clk) then
      out_sample_valid <= '0';
      if rst = '1' then
        full_sample <= (others => '0');
        in_sample_valid_p1 <= '0';
      else
        in_sample_valid_p1 <= in_sample_valid;
        if in_sample_valid = '1' and in_sample_valid_p1 = '0' then
          -- Detect positive overflow: MSB-1 is 1 and MSB is 0 => shift will make it negative
          if in_sample(in_sample'high - 1) = '1' and in_sample(in_sample'high) = '0' then
            full_sample <= max_positive;
          -- Detect negative overflow: MSB-1 is 0 and MSB is 1 => shift will make it positive
          elsif in_sample(in_sample'high - 1) = '0' and in_sample(in_sample'high) = '1' then
            full_sample <= max_negative;
          else
            full_sample <= shift_left(resize(in_sample, full_sample'length), 1);
          end if;
          out_sample_valid <= '1';
        end if;
      end if;
    end if;
  end process; -- PROC_SHIFTER
end architecture;