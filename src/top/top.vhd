library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spdif_amp;

entity top is
  port (
    clk : in std_logic;
    rst_button : in std_logic;
    input : in std_logic;
    output : out std_logic
  );
end top; 

architecture str of top is
  signal rst : std_logic;
begin
  RESET : entity spdif_amp.reset(rtl)
  port map (
    clk => clk,
    rst_in => rst_button,
    rst_out => rst
  );
end architecture;