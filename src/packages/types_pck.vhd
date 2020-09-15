library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types is
  subtype subframe_payload_type is std_logic_vector(27 downto 0);
end package;