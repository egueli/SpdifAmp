library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Aes3BaseDecoder is
	port(
		i_clock: in std_logic;
		i_data: in std_logic;
		o_large, o_medium, o_small: out std_logic;
		o_strobe: out std_logic
	);
end Aes3BaseDecoder;
 
architecture rtl of Aes3BaseDecoder is
	component Synchronizer is
		port(
			i_clock, i_data : in std_logic;
			o_data : out std_logic
		);
	end component;
	component StrobeGenerator is
		generic(
			strobe_length: integer := 3
		);
		port(
			i_clock: in std_logic;
			i_toggles: in std_logic;
			o_strobe: out std_logic
		);
	end component;
	signal r_data_synced : std_logic := '0';
   signal r_last_data : std_logic := '0';
	signal r_count : std_logic_vector (4 downto 0);
   constant c_zeros : std_logic_vector(r_count'range) := (others => '0');

begin
	syncer: Synchronizer port map (i_clock, i_data, r_data_synced);
	dataStrobe: StrobeGenerator port map (i_clock, r_data_synced, o_strobe);

	SyncFinder : process(i_clock, r_count, r_last_data)
	begin		
		if rising_edge(i_clock) then
			if r_data_synced = r_last_data then
				r_count <= r_count + 1;
			else
				if r_count > 21 then
					o_large <= '1';
					o_medium <= '0';
					o_small <= '0';
				elsif r_count > 13 then
					o_large <= '0';
					o_medium <= '1';
					o_small <= '0';
				elsif r_count > 6 then
					o_large <= '0';
					o_medium <= '0';
					o_small <= '1';
				end if;
				
				r_count <= c_zeros;
				r_last_data <= r_data_synced;
			end if;		
		end if;
	end process SyncFinder;
	
end rtl;

