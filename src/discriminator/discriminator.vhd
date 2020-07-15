library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity discriminator is
  port (
    clk : in std_logic;
    rst : in std_logic;
    input : in std_logic;
    large : out std_logic;
    medium : out std_logic;
    small : out std_logic;
    valid : out std_logic
  );
end discriminator; 

architecture rtl of discriminator is
  signal input_p1 : std_logic;
  signal transition : std_logic;

  subtype pulse_count_type is integer range 0 to 31;
  signal pulse_count : pulse_count_type;
begin
  PROC_PULSE_DISCRIMINATOR : process(clk)
  begin
    if rising_edge(clk) then
      transition <= '0';
      large <= '0';            
      small <= '0';            
      medium <= '0';  
      valid <= '0';
      input_p1 <= input;

      if rst = '1' then
        pulse_count <= 0;
        input_p1 <= input;
      else
        if input_p1 = input then
          if pulse_count < pulse_count_type'high then
            pulse_count <= pulse_count + 1;
          else
            -- pulse_count timeout; don't increment and send error (s/m/l=0)          
            valid <= '1';            
          end if;
        else
          pulse_count <= 0;
          if pulse_count > 21 then
            large <= '1';
          elsif pulse_count > 13 then
            medium <= '1';
          elsif pulse_count > 6 then
            small <= '1';
          end if;
        end if;
      end if;
    end if;
  end process; -- PROC_PULSE_DISCRIMINATOR
end architecture;