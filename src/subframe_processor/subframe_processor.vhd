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
    gain : in natural range 3 downto 0;
    out_subframe : out std_logic_vector(27 downto 0);
    out_subframe_valid : out std_logic
  );
end subframe_processor;

architecture rtl of subframe_processor is
  signal incoming_subframe : std_logic_vector(27 downto 0);
  -- TODO store subframe type as well
  signal parity_check_in_valid : std_logic;
  signal parity_check_valid : std_logic;
  signal parity_check : std_logic;

  signal amplify_sample_valid : std_logic;
  signal amplified_sample_valid : std_logic;
  signal amplified_sample : signed(19 downto 0);
  
  type state_type is (IDLE, WAIT_PARITY_CHECK, WAIT_AMPLIFICATION, WAIT_PARITY_GEN);
  signal state : state_type;
begin
  INPUT_PARITY_CHECK : entity spdif_amp.parity(rtl)
  generic map(NUM_BITS => 28)
  port map(
    clk => clk,
    rst => rst,
    input => incoming_subframe,
    valid => parity_check_in_valid,
    out_parity => parity_check,
    out_valid => parity_check_valid
  );

  AMPLIFIER : entity spdif_amp.amplifier(rtl)
  generic map(SAMPLE_BITS => 20)
  port map(
    clk => clk,
    rst => rst,
    gain => gain,
    in_sample => signed(incoming_subframe(23 downto 4)),
    in_sample_valid => amplify_sample_valid,
    out_sample => amplified_sample,
    out_sample_valid => amplified_sample_valid
  );

  FSM_PROC : process(clk)
  begin
    if rising_edge(clk) then
      out_subframe_valid <= '0';
      parity_check_in_valid <= '0';
      amplify_sample_valid <= '0';
      if rst = '1' then
        state <= IDLE;
        incoming_subframe <= (others => '0');
        out_subframe <= (others => '0');
      else
        case state is
          when IDLE =>
            if in_subframe_valid = '1' then
              -- We got a new subframe process. Check its parity.
              parity_check_in_valid <= '1';
              incoming_subframe <= in_subframe;
              state <= WAIT_PARITY_CHECK;
            end if;

          when WAIT_PARITY_CHECK =>
            if parity_check_valid = '1' then
              -- We got the parity result of the incoming subframe.
              if parity_check = '1' then
                -- Parity check failed. Emit an all-zero subframe and wait for another one.
                out_subframe <= (others => '0');
                out_subframe_valid <= '1';
                state <= IDLE;
              else
                -- Parity check OK. Amplify the sample.
                amplify_sample_valid <= '1';
                state <= WAIT_AMPLIFICATION;
              end if;
            end if;

          when WAIT_AMPLIFICATION =>
            if amplified_sample_valid = '1' then
              out_subframe(3 downto 0) <= incoming_subframe(3 downto 0);
              out_subframe(23 downto 4) <= std_logic_vector(amplified_sample);
              out_subframe(27 downto 23) <= incoming_subframe(27 downto 23);
              out_subframe_valid <= '1';
              state <= IDLE;
            end if;

          when WAIT_PARITY_GEN =>
        end case;
      end if;
    end if;
  end process;
end architecture;