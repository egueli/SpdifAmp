library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity parity is
  generic (
    NUM_BITS : integer := 16
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    input : in std_logic_vector(NUM_BITS-1 downto 0);
    out_parity : out std_logic
  );
end parity;

architecture rtl of parity is
begin
  PARITY_PROC : process(clk)
    variable i : integer;
    variable result : std_logic;
  begin
    if rising_edge(clk) then
      if rst = '1' then
        out_parity <= '0';
      else
        result := '0';
        for i in input'range loop
          result := result xor input(i);
        end loop;
        out_parity <= result;
      end if;
    end if;
  end process;
end architecture;