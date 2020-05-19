library ieee;
use ieee.std_logic_1164.all;

entity Synchronizer is
	port(
		i_clock, i_data : in std_logic;
		o_data : out std_logic
	);
end entity;

architecture rtl of Synchronizer is
	signal r_data_d1 : std_logic := '0';
	signal r_data_d2 : std_logic := '0';
begin
	synchronizer : process(i_clock)
	begin
		if rising_edge(i_clock) then
			r_data_d1 <= i_data;
			r_data_d2 <= r_data_d1;
		end if;
	end process;
	o_data <= r_data_d2;
end rtl;
