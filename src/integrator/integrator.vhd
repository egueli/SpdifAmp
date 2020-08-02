library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity integrator is
  port (
    clk : in std_logic;
    rst : in std_logic;
    pulse : in std_logic;
    toggle : out std_logic
  );
end integrator; 

architecture rtl of integrator is
  signal value : std_logic;
begin
  toggle <= value;
  
  PROC_INTEGRATOR : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        value <= '0';
      else
        if pulse = '1' then
          value <= not value;
        end if;
      end if;
    end if;
  end process; -- PROC_INTEGRATOR
end architecture;