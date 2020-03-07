library ieee;
use ieee.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity adcReader is
	port(
		clk     : in  std_logic;
		adcOut  : out std_logic := '1';
		adcIn   : in  std_logic;
		adcCS   : out std_logic;
		adcData : out std_logic_vector(7 downto 0));
end entity adcReader;

architecture RTL of adcReader is
	type adcState is (cs, start, sgl, odd, msbf, nullbit, bit7, bit6, bit5, bit4, bit3, bit2, bit1, bit0, reset);
begin

	process(clk) is
		variable state : adcState := cs;
	begin
		if rising_edge(clk) then
			case state is
				when cs =>
					adcCS <= '0';
					state := start;
				when start =>
					adcOut <= '1';
					state  := sgl;
				when sgl =>
					adcOut <= '1';
					state  := odd;
				when odd =>
					adcOut <= '0';
					state  := msbf;
				when msbf =>
					adcOut <= '1';
					state  := nullbit;
				when nullbit =>
					adcOut <= '0';
					state  := bit7;
				when bit7 =>
					adcData(7) <= adcIn;
					state      := bit6;
				when bit6 =>
					adcData(6) <= adcIn;
					state      := bit5;
				when bit5 =>
					adcData(5) <= adcIn;
					state      := bit4;
				when bit4 =>
					adcData(4) <= adcIn;
					state      := bit3;
				when bit3 =>
					adcData(3) <= adcIn;
					state      := bit2;
				when bit2 =>
					adcData(2) <= adcIn;
					state      := bit1;
				when bit1 =>
					adcData(1) <= adcIn;
					state      := bit0;
				when bit0 =>
					adcData(0) <= adcIn;
					state      := reset;
				when reset =>
					adcCS <= '1';
					state := cs;
			end case;
		end if;
	end process;

end architecture RTL;
