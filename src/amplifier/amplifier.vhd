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
  signal full_sample : signed(in_sample'range);
begin
  out_sample <= full_sample;

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
          for i in 0 to MAX_GAIN loop
            if gain = i then
              full_sample <= shift_left(in_sample, i);
            end if;
          end loop;
          out_sample_valid <= '1';
        end if;
      end if;
    end if;
  end process; -- PROC_SHIFTER
end architecture;