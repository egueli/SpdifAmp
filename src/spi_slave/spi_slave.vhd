library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spdif_amp;
use spdif_amp.types.all;

entity spi_slave is
  port (
    clk : in std_logic;
    rst : in std_logic;
    spi_in : in spi_slave_in_t;
    spi_out : out spi_slave_out_t
  );
end spi_slave;

architecture rtl of spi_slave is
  signal ss_sync : std_logic;
  signal sclk_sync : std_logic;
  signal sclk_sync_p1 : std_logic;
  signal mosi_sync : std_logic;

  signal input_buffer : std_logic_vector(7 downto 0);

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

  SHIFT_IN_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        input_buffer <= (others => '0');
        spi_out.miso <= '0';
      else
        if ss_sync = '0' then
          sclk_sync_p1 <= sclk_sync;
          if sclk_sync_p1 = '0' and sclk_sync = '1' then
            input_buffer <= input_buffer(6 downto 0) & mosi_sync;
            spi_out.miso <= input_buffer(7);
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;