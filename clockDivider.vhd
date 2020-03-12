library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity clockDivider500KHz is
	port(
		CLK_50MHz : in  std_logic;
		clk       : out std_logic);
end clockDivider500KHz;

architecture Behavior of clockDivider500KHz is
	signal counter  : integer;
	signal CLK_50HZ : std_logic;

begin
	process(CLK_50MHz)
	begin
		if rising_edge(CLK_50MHz) then
			if counter < 25000 then
				counter <= counter + 1;
			else
				CLK_50HZ <= not CLK_50HZ;
				counter  <= 0;
			end if;
		end if;
	end process;

	clk <= CLK_50HZ;
end Behavior;
