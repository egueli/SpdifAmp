library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity amplifier is
  generic(
    -- number of bits of the input and output samples, including sign
    SAMPLE_BITS : integer := 16;
    -- max allowed gain, as amount of bit shifting
    MAX_GAIN : natural := 3
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    gain : in natural range MAX_GAIN downto 0;
    in_sample : in signed(SAMPLE_BITS-1 downto 0);
    in_sample_valid : in std_logic;
    out_sample : out signed(SAMPLE_BITS-1 downto 0);
    out_sample_valid : out std_logic
  );
end amplifier; 

architecture rtl of amplifier is
  signal in_sample_valid_p1 : std_logic;
  signal accumulator : signed(SAMPLE_BITS downto 0); -- it's one bit larger than in_sample to contain overflow
  signal shift_count : integer range MAX_GAIN downto 0;
  type state_type is (
    IDLE,        -- wait for a valid input sample
    PLAN,        -- decide if continue shifting or output something
    SHIFT,       -- do a multiplication/shift step
    OUT_SAT_MAX, -- finished, output max saturated value
    OUT_SAT_MIN, -- finished, output min saturated value
    OUT_AMPLIFY  -- finished, output amplified value
    );
  signal state : state_type;
  signal msb : std_logic;
  signal msb_1 : std_logic;
  constant max_positive : signed(SAMPLE_BITS-1 downto 0) := '0' & (SAMPLE_BITS - 2 downto 0 => '1');
  constant max_negative : signed(SAMPLE_BITS-1 downto 0) := '1' & (SAMPLE_BITS - 2 downto 0 => '0');
begin
  msb <= accumulator(accumulator'high);
  msb_1 <= accumulator(accumulator'high - 1);

  PROC_SHIFTER : process(clk)
  begin
    if rising_edge(clk) then
      out_sample_valid <= '0';
      if rst = '1' then
        accumulator <= (others => '0');
        in_sample_valid_p1 <= '0';
        shift_count <= 0;
        state <= IDLE;
        out_sample <= (others => '0');
      else
        in_sample_valid_p1 <= in_sample_valid;
        case state is        
          when IDLE =>
            if in_sample_valid = '1' and in_sample_valid_p1 = '0' then
              shift_count <= gain;
              state <= PLAN;
              accumulator <= resize(in_sample, accumulator'length);
            end if;            
        
          when PLAN =>
            if msb_1 = '1' and msb = '0' then
              state <= OUT_SAT_MAX;
            elsif msb_1 = '0' and msb = '1' then
              state <= OUT_SAT_MIN;
            elsif shift_count = 0 then
              state <= OUT_AMPLIFY;
            else
              state <= SHIFT;
            end if;

          when SHIFT =>
            accumulator <= shift_left(accumulator, 1);
            shift_count <= shift_count - 1;
            state <= PLAN;

          when OUT_SAT_MAX =>
            out_sample <= max_positive;
            out_sample_valid <= '1';
            state <= IDLE;

          when OUT_SAT_MIN =>
            out_sample <= max_negative;
            out_sample_valid <= '1';
            state <= IDLE;

          when OUT_AMPLIFY =>
            out_sample <= accumulator(SAMPLE_BITS-1 downto 0);
            out_sample_valid <= '1';
            state <= IDLE;
        end case;
      end if;
    end if;
  end process; -- PROC_SHIFTER
end architecture;