library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity biphase_decoder is
  port (
    clk : in std_logic;
    rst : in std_logic;
    short : in std_logic;
    long : in std_logic;
    pulse_in : in std_logic;
    value : out std_logic;
    valid : out std_logic
  );
end biphase_decoder; 

architecture rtl of biphase_decoder is
  type state_type is (IDLE, WAIT_SECOND_PULSE);
  signal state : state_type;
begin
  PROC_BIPHASE_DECODER : process(clk)
  begin
    if rising_edge(clk) then
      value <= '0';
      valid <= '0';

      if rst = '1' then
        state <= IDLE;
      else
        if pulse_in = '1' then
          case state is
          when IDLE =>
            if short = '1' then
              state <= WAIT_SECOND_PULSE;	
            elsif long = '1' then
              value <= '0';
              valid <= '1';
            end if;
          
          when WAIT_SECOND_PULSE =>
            state <= IDLE;
            if short = '1' then
              value <= '1';
              valid <= '1';
            end if;
          end case;
        end if;
      end if;
    end if;
  end process; -- PROC_BIPHASE_DECODER
end architecture;