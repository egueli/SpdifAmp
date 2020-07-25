library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity deserializer is
  generic (
    NUM_BITS : natural := 28
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    input : in std_logic;
    in_valid : in std_logic;
    output : out std_logic_vector((NUM_BITS - 1) downto 0);
    out_valid : out std_logic
  );
end deserializer; 

architecture rtl of deserializer is
  constant MSB : natural := NUM_BITS - 1;
  signal data : std_logic_vector(MSB downto 0);
  signal count : integer range 0 to MSB;
  signal out_valid_n1 : std_logic;
begin
  PROC_DESERIALIZER : process(clk)
  begin
    if rising_edge(clk) then
      out_valid_n1 <= '0';
      if rst = '1' then
        data <= (others => '0');  
        count <= 0;
        output <= (others => '0');
        out_valid <= '0';
      else
        output <= data;
        out_valid <= out_valid_n1;
        if in_valid = '1' then
          data <= data(MSB-1 downto 0) & input;
          if count = MSB then
            out_valid_n1 <= '1';
          else
            count <= count + 1;
          end if;
        end if;
      end if;
    end if;
  end process; -- PROC_DESERIALIZER
end architecture;