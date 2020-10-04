library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types is
  subtype subframe_payload_t is std_logic_vector(27 downto 0);

  type subframe_type_t is (TYPE_X, TYPE_Y, TYPE_Z);

  type spi_slave_in_t is record
    sclk : std_logic;
    ss : std_logic;
    mosi : std_logic;
  end record spi_slave_in_t;

  type spi_slave_out_t is record
    miso : std_logic;
  end record spi_slave_out_t;
end package;