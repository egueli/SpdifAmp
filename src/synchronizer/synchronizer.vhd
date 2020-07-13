library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synchronizer is
  port (
    clk : in std_logic;
    rst : in std_logic;
    input : in std_logic;
    output : out std_logic
  );
end synchronizer; 

architecture rtl of synchronizer is
	signal data_p1 : std_logic;
	signal data_p2 : std_logic;
begin
  PROC_SYNC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        data_p1 <= '0';
        data_p2 <= '0';
      else
        data_p1 <= input;
        data_p2 <= data_p1;
      end if;
    end if;
  end process; -- PROC_SYNC
  
  output <= data_p2;
end architecture;