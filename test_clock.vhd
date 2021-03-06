-- Load Altera libraries for this chip
LIBRARY IEEE;
LIBRARY MAXII;
USE IEEE.STD_LOGIC_1164.ALL;
USE MAXII.MAXII_COMPONENTS.ALL;

-- Set up this testbench as an entity
entity test_spdif is
end test_spdif;

-- Create an implementation of the entity
-- (May have several per entity)
architecture tb_simple of test_spdif is

  -- Set up the signals on the 3bit_counter
  signal i_clock : std_logic;
  signal i_data : std_logic;
  signal o_strobe    : std_logic;

  -- Set up the vcc signal as 1
  signal vcc  : std_logic := '1';
  
  begin
    -- dut = device under test (same name as top project from Quartus)
    dut : entity work.SpdifAmp
      -- Map the ports from the dut to this testbench
      port map (
        i_clock => i_clock,
        i_data => i_data,
        o_strobe => o_strobe);
    
    clock : process is
      begin
        loop
          i_clock <= '0'; wait for 10 ns;
          i_clock <= '1'; wait for 10 ns;
        end loop;
    end process clock;            
    stimulus : process is
      begin
        loop
          i_data <= '0'; wait for 350 ns;
          i_data <= '1'; wait for 350 ns;
          i_data <= '0'; wait for 350 ns;
          i_data <= '1'; wait for 350 ns;
          i_data <= '0'; wait for 350 ns;
          i_data <= '1'; wait for 350 ns;
          i_data <= '0'; wait for 540 ns;
          i_data <= '1'; wait for 540 ns;
        end loop;
      end process stimulus;
end architecture tb_simple;