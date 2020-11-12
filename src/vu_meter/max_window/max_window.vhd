library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spdif_amp;
use spdif_amp.constants.all;

entity max_window is
  generic (
    MAX_VALUE : integer := 16;
    UPDATE_LOG2_COUNT : integer := vu_meter_update_log2_count
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    input : in integer range MAX_VALUE downto 0;
    input_valid : in std_logic;
    output : out integer range MAX_VALUE downto 0
  );
end max_window;

architecture rtl of max_window is
  signal update_count : unsigned(UPDATE_LOG2_COUNT-1 downto 0);
  signal update_count_msb_p1 : std_logic;
  signal current_max : integer range MAX_VALUE downto 0;
begin
  MAX_WINDOW_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        update_count <= (others => '0');
        update_count_msb_p1 <= '0';
        current_max <= 0;
        output <= 0;
      else
        update_count <= update_count + 1;
        update_count_msb_p1 <= update_count(update_count'high);

        -- Did a rollover happen?
        if update_count_msb_p1 = '1' and update_count(update_count'high) = '0' then
          output <= current_max;
          current_max <= 0;
        end if;
        
        if input_valid = '1' then
          if input > current_max then
            current_max <= input;
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;