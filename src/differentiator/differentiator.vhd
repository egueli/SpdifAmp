library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity differentiator is
  port (
    clk : in std_logic;
    rst : in std_logic;
    input : in std_logic;
    pulses : out std_logic
  );
end differentiator; 

architecture rtl of differentiator is
  signal input_p1 : std_logic;  
begin
  PROC_DIFFERENTIATOR : process(clk)
  begin
    if rising_edge(clk) then
      input_p1 <= input;

      if rst = '1' then
        pulses <= '0';
      else
        if input = input_p1 then
          pulses <= '0';
        else
          pulses <= '1';
        end if;
      end if;
    end if;
  end process; -- PROC_DIFFERENTIATOR
end architecture;