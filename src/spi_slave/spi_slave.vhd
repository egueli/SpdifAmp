library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spdif_amp;
use spdif_amp.types.all;

entity spi_slave is
  port (
    clk : in std_logic;
    rst : in std_logic;
    -- SPI input. The SS signal is active high.
    spi_in : in spi_slave_in_t;
    spi_out : out spi_slave_out_t;
    gain : out integer range 3 downto 0
  );
end spi_slave;

architecture rtl of spi_slave is
  signal ss_sync : std_logic;
  signal ss_sync_p1 : std_logic;
  signal sclk_sync : std_logic;
  signal sclk_sync_p1 : std_logic;
  signal mosi_sync : std_logic;

  signal input_buffer : std_logic_vector(7 downto 0);
  signal bit_count : natural range 7 downto 0;
begin
  SS_SCLK : entity spdif_amp.synchronizer(rtl)
  port map (
    clk => clk,
    rst => rst,
    input => spi_in.ss,
    output => ss_sync
  );

  SYNC_SCLK : entity spdif_amp.synchronizer(rtl)
  port map (
    clk => clk,
    rst => rst,
    input => spi_in.sclk,
    output => sclk_sync
  );

  SYNC_MOSI : entity spdif_amp.synchronizer(rtl)
  port map (
    clk => clk,
    rst => rst,
    input => spi_in.mosi,
    output => mosi_sync
  );

  spi_out.miso <= '0';

  SHIFT_IN_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        input_buffer <= (others => '0');
        ss_sync_p1 <= '0';
        sclk_sync_p1 <= '0';
      else
        ss_sync_p1 <= ss_sync;
        if ss_sync = '1' then
          if ss_sync_p1 = '0' then
            -- Reset communicatione once SS goes low
            bit_count <= 7;
          end if;
          sclk_sync_p1 <= sclk_sync;
          if sclk_sync_p1 = '0' and sclk_sync = '1' then
            -- Receiving data one bit at a time
            input_buffer <= input_buffer(6 downto 0) & mosi_sync;
            bit_count <= bit_count - 1;
          end if;
          
          if bit_count = 0 then
            -- A full byte has been received, use it
            gain <= to_integer(unsigned(input_buffer(1 downto 0)));
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;