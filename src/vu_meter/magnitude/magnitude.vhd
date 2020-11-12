library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity magnitude is
  generic (
    NUM_BITS : integer := 16
  );
  port (
    value : in signed(NUM_BITS-1 downto 0);
    magnitude : out integer range NUM_BITS downto 0
  );
end magnitude;

architecture rtl of magnitude is
  function mag(
    input : unsigned(NUM_BITS-1 downto 0)
  )
  return integer is
    variable highest_one : integer range NUM_BITS-1 downto 0 := 0;
  begin
    if input = to_unsigned(0, NUM_BITS) then
      return 0;
    else 
      for i in 0 to NUM_BITS-1 loop
        if input(i) = '1' then
          highest_one := i;
        end if;
      end loop;
      return highest_one + 1;
    end if;
  end function;

  signal absolute_s : signed(NUM_BITS-1 downto 0);
  signal absolute_u : unsigned(NUM_BITS-1 downto 0);
begin
  absolute_s <= abs(value);
  absolute_u <= unsigned(absolute_s);
  magnitude <= mag(absolute_u);
end architecture;
