library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity reg8by64 is
	Port(clk   : in  std_logic;
	     dataD : in  std_logic_vector(7 downto 0);
	     selA  : in  integer;
	     selD  : in  integer;
	     we    : in  std_logic;
	     dataA : out std_logic_vector(7 downto 0)
	     );
end reg8by64;

architecture behavior of reg8by64 is
	type regFile is array (63 downto 0) of std_logic_vector(7 downto 0);
	signal registers : regFile;
begin

	process(clk)
	begin
		if rising_edge(clk) then
			dataA <= registers(selA);
			if (we = '1') then
				registers(selD) <= dataD;
			end if;
		end if;
	end process;
end behavior;
