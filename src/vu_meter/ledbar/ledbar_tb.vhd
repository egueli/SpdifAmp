library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

library spdif_amp;

entity ledbar_tb is
end ledbar_tb;

architecture sim of ledbar_tb is
  signal input : integer range 16 downto 0;
  signal output : std_logic_vector(10-1 downto 0);
begin
  DUT : entity spdif_amp.ledbar(rtl)
  port map (
    input => input,
    output => output
  );

  SEQUENCER_PROC : process
    procedure check(
      constant value : integer;
      constant leds : std_logic_vector
    ) is
    begin
      input <= value;
      wait for 1 ns;
      assert output = leds
        report "With input " & to_string(value) & 
        ", output LEDs are not " & to_string(leds)
        severity failure;      
    end procedure;
  begin

    check(0,  "0000000000");
    check(1,  "0000000001");
    check(2,  "0000000001");
    check(3,  "0000000001");
    check(4,  "0000000001");
    check(5,  "0000000001");
    check(6,  "0000000001");
    check(7,  "0000000001");
    check(8,  "0000000011");
    check(9,  "0000000111");
    check(10, "0000001111");
    check(11, "0000011111");
    check(12, "0000111111");
    check(13, "0001111111");
    check(14, "0011111111");
    check(15, "0111111111");
    check(16, "1111111111");

    finish;
  end process;

end architecture;