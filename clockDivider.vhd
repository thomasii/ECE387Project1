library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity clockDivider is
	port(
		CLK_50MHz : in  std_logic;
		clk       : out std_logic);
end clockDivider;

architecture Behavior of clockDivider is
	signal counter  : std_logic_vector(24 downto 0);
	signal CLK_50HZ : std_logic;

begin
	Prescaler : process(CLK_50MHz)
	begin
		if CLK_50MHz'event and CLK_50MHz = '1' then
			if counter < "111" then
				counter <= counter + 1;
			else
				CLK_50HZ <= not CLK_50HZ;
				counter  <= (others => '0');
			end if;
		end if;
	end process Prescaler;

	clk <= CLK_50HZ;
end Behavior;
