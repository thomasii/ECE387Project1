library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity clockDivide4 is
	port(
		CLK_50MHz : in  std_logic;
		clk       : out std_logic);
end clockDivide4;

architecture Behavior of clockDivide4 is
	signal counter  : integer;
	signal CLK_50HZ : std_logic;

begin
	Prescaler : process(CLK_50MHz)
	begin
		if rising_edge(CLK_50MHz) then
			if counter < 200 then
				counter <= counter + 1;
			else
				CLK_50HZ <= not CLK_50HZ;
				counter  <= 0;
			end if;
		end if;
	end process Prescaler;

	clk <= CLK_50HZ;
end Behavior;
