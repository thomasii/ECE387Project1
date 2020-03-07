library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
	port(
		clk : in std_logic;
		rst : in std_logic
	);
end entity fsm;

architecture RTL of fsm is
	type state_type is (start, control0, control1, control2, control3, control4, control5, control6, control7, low0, low1, low2, low3, low4, low5, low6, low7);
begin

	process(clk, rst) is
		variable state : state_type := start;
	begin
		if rst = '1' then
			state := start;
		elsif rising_edge(clk) then
			case state is
				when start =>
					state := control0;
				when control0 =>
					state := control1;
				when control1 =>
					state := start;
			end case;
		end if;
	end process;

end architecture RTL;
