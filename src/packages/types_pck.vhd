library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types is
  subtype subframe_payload_t is std_logic_vector(27 downto 0);

  type subframe_type_t is (TYPE_X, TYPE_Y, TYPE_Z);
end package;