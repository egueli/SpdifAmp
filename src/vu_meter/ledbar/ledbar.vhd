library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ledbar is
  generic (
    MAX_INPUT : integer := 16;
    NUM_LEDS : integer := 10
  );
  port (
    input : in integer range MAX_INPUT downto 0;
    output : out std_logic_vector(NUM_LEDS-1 downto 0)
  );
end ledbar;

architecture rtl of ledbar is
  constant underflow : integer := MAX_INPUT - NUM_LEDS;
  begin
  LED_BAR_PROC : process(input)
    variable turned_on : integer range NUM_LEDS downto 0;
  begin
    if input = 0 then
      turned_on := 0;
    elsif input <= underflow then
      turned_on := 1;
    else 
      turned_on := input - underflow;
    end if;

    output <= (others => '0');
    for i in 1 to NUM_LEDS loop
      if i <= turned_on then
        output(i-1) <= '1';
      end if;
    end loop;
  end process;
end architecture;