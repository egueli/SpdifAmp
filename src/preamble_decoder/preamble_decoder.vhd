library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity preamble_decoder is
  port (
    clk : in std_logic;
    rst : in std_logic;
    small : in std_logic;
    medium : in std_logic;
    large : in std_logic;
    valid : in std_logic;
    type_x : out std_logic;
    type_y : out std_logic;
    type_z : out std_logic;
    payload_begin : out std_logic;
    payload_pulse_valid : out std_logic;
    payload_pulse_small : out std_logic;
    payload_pulse_medium : out std_logic
  );
end preamble_decoder; 

architecture rtl of preamble_decoder is
  type state_type is (IDLE, GOT_SYNC, PX1, PX2, PY1, PY2, PZ1, PZ2, PAYLOAD);
  signal state : state_type := IDLE;
begin
  PROC_PREAMBLE_FSM : process(clk)
    procedure on_payload_begin is
    begin
      state <= PAYLOAD;    
      payload_begin <= '1';  
    end procedure;
  begin
    if rising_edge(clk) then
      payload_begin <= '0';

      if rst = '1' then
        state <= IDLE;        
        type_x <= '0';
        type_y <= '0';
        type_z <= '0';
      else
        case state is
          when IDLE =>
            type_x <= '0';
            type_y <= '0';
            type_z <= '0';
            if large = '1' then
              state <= GOT_SYNC;
            end if;  
        
          when GOT_SYNC =>
            type_x <= '0';
            type_y <= '0';
            type_z <= '0';
            if large = '1' then
              state <= PX1;
              type_x <= '1';
            elsif medium = '1' then
              state <= PY1;
              type_y <= '1';
            elsif small = '1' then
              state <= PZ1;
              type_z <= '1';
            end if;

          when PX1 =>
            if small = '1' then
              state <= PX2;
            else
              state <= IDLE;
            end if;

          when PX2 =>
            if small = '1' then
              on_payload_begin;
            else
              state <= IDLE;
            end if;

          when PY1 =>
            if small = '1' then
              state <= PY2;
            else
              state <= IDLE;
            end if;

          when PY2 =>
            if medium = '1' then
              on_payload_begin;
            else
              state <= IDLE;
            end if;

          when PZ1 =>
            if small = '1' then
              state <= PZ2;
            else
              state <= IDLE;
            end if;
          
          when PZ2 =>
            if large = '1' then
              on_payload_begin;
            else
              state <= IDLE;
            end if;
            
          when PAYLOAD =>
            if large = '1' then
              state <= GOT_SYNC;
            elsif medium = '1' then
              payload_pulse_medium <= '1';
              payload_pulse_valid <= '1';
            elsif small = '1' then
              payload_pulse_small <= '1';
              payload_pulse_valid <= '1';
            end if;
        end case;
      end if;
    end if;
  end process; -- PROC_PREAMBLE_FSM
end architecture;