library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library spdif_amp;

entity subframe_processor is
  port (
    clk : in std_logic;
    rst : in std_logic;
    in_subframe : in std_logic_vector(27 downto 0);
    in_subframe_valid : in std_logic;
    out_subframe : out std_logic_vector(27 downto 0);
    out_subframe_valid : out std_logic
  );
end subframe_processor;

architecture rtl of subframe_processor is
  signal parity_check_in_valid : std_logic;
  signal parity_check_input : std_logic_vector(27 downto 0);

  type state_type is (IDLE, WAIT_PARITY_CHECK, WAIT_AMPLIFICATION, WAIT_PARITY_GEN);
  signal state : state_type;
begin
  PARITY_CHECK : entity spdif_amp.parity(rtl)
  generic map(NUM_BITS => 28)
  port map(
    clk => clk,
    rst => rst,
    input => parity_check_input,
    valid => parity_check_in_valid,
    out_parity => open,
    out_valid => open
  );

  FSM_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        state <= IDLE;
      else
        case state is
          when IDLE =>
            if in_subframe_valid = '1' then
              parity_check_in_valid <= '1';
              parity_check_input <= in_subframe;
              state <= WAIT_PARITY_CHECK;
            end if;
          when WAIT_PARITY_CHECK =>
          when WAIT_AMPLIFICATION =>
          when WAIT_PARITY_GEN =>
  
        end case;
      end if;
    end if;
  end process;

  PROCESSOR_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        out_subframe_valid <= '0';
        
      else
        
        
      end if;
    end if;
  end process;
end architecture;