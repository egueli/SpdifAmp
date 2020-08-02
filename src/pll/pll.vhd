library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pll is
  generic (
    PHASE_BITS : integer;
    LGCOEFF : integer;
    INITIAL_PHASE_STEP : unsigned
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    input : in std_logic;
    phase : out unsigned((PHASE_BITS - 1) downto 0);
    error : out signed(1 downto 0)
  );
end pll; 

architecture rtl of pll is
  constant MSB : integer := PHASE_BITS - 1;

  -- How much we correct our phase by is a function of our loop
  -- coefficient, here represented by 2^{-i_lgcoeff}.  
  constant phase_correction : unsigned(MSB downto 0) := to_unsigned(2**(MSB - LGCOEFF), PHASE_BITS);

	-- The frequency correction needs to be the phase_correction squared
  -- divided by four in order to get a critically damped loop
  constant freq_correction : unsigned(MSB downto 0) := to_unsigned(2**(MSB - 2 - LGCOEFF * 2), PHASE_BITS);
    
  signal agreed_output : std_logic;
  signal lead : std_logic;
  signal phase_err : std_logic;
  signal ctr : unsigned(MSB downto 0);
  signal r_step : unsigned(MSB downto 0);
begin
  PROC_PLL : process(clk)
  begin

    -- Any disagreement between the high order counter bit and the input
    -- is a phase error that we will need to correct
    phase_err <= ctr(MSB) xor input;

    -- Output the internal phase
    phase <= ctr;

    if rising_edge(clk) then
      if rst = '1' then
        agreed_output <= '0';
        ctr <= (others => '0');
        r_step <= INITIAL_PHASE_STEP;
      else
        -- Any time the input and our counter agree, let's keep track of that
        -- bit.  We'll need it in a moment in order to know which signal
        -- changed first.        
        if input = '1' and ctr(MSB) = '1' then
          agreed_output <= '1';
        elsif input = '0' and ctr(MSB) = '0' then
          agreed_output <= '0';
        end if;

        -- Lead is true if the counter changes before the input
        -- changes, false otherwise
        if agreed_output = '1' then
          -- We were last high.  Lead is true now
          -- if the counter goes low before the input
          lead <= (not ctr(MSB)) and input;
        else
          -- The last time we agreed, both the counter
          -- and the input were low.   This will be
          -- true if the counter goes high before the input
          lead <= ctr(MSB) and (not input);
        end if;    
      
        -- If we match, then just step the counter forward
        -- by one delta phase amount
        if phase_err = '0' then
          ctr <= ctr + r_step;
        elsif lead = '1' then
          -- Otherwise we don't match.  We need to adjust our
          -- counter based upon how far off we are.
          -- If the counter is ahead of the input, then we should
          -- slow it down a touch.
          ctr <= ctr + r_step - phase_correction;
        else
		      -- Likewise, if the counter is falling behind the input,
		      -- then we need to speed it up.
          ctr <= ctr + r_step + phase_correction;
        end if;

        -- We'll apply this frequency correction, either slowing
        -- down or speeding up the frequency, any time there is a phase error.
        if phase_err = '1' then
          if lead  = '1' then
            r_step <= r_step - freq_correction;
          else
            r_step <= r_step + freq_correction;
          end if;
        end if;

        if phase_err = '0' then
          error <= to_signed(0, 2);
        elsif lead = '1' then
          error <= to_signed(-1, 2);
        else
          error <= to_signed(1, 2);
        end if;
      end if;
    end if;
  end process; -- PROC_PLL
end architecture;