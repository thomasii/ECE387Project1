library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eepromWrite is
	port(
		clk     : in  std_logic;
		en      : in  std_logic;
		dataOut : out std_logic := '1';
		dataIn  : in  std_logic_vector(7 downto 0);
		scl     : in  std_logic;
		addr    : out integer
	);
end entity eepromWrite;

architecture RTL of eepromWrite is
	type state_type is (start, control, acknowledge, addressHigh, addressLow, data, stop);
	signal byteNum  : integer   := 0;
	signal counter  : integer   := 0;
	signal enEEPROM : std_logic := '0';
begin

	process(clk) is
		variable state           : state_type                   := start;
		variable prevState       : state_type                   := start;
		variable bitNum          : integer                      := 7;
		variable controlByte     : std_logic_vector(7 downto 0) := "10100000";
		variable addressHighByte : std_logic_vector(7 downto 0) := x"00";
		variable addressLowByte  : std_logic_vector(7 downto 0) := "10101010";
		variable dataByteTest : std_logic_vector(7 downto 0) := x"FF";

	begin
		--if (en = '1' and rising_edge(scl)) then
			--enEEPROM <= '1';
		--end if;
		
		if rising_edge(clk) then
			if (counter = 1) then
				case state is
					when start =>
						dataOut   <= '0';
						prevState := state;
						state     := control;
					when stop =>
						dataOut   <= '1';
						state     := stop;
						prevState := state;
					when others => state := state;
				end case;
			elsif (counter = 3) then
				case state is
					when control =>
						dataOut <= controlByte(bitNum);
						if (bitNum = 0) then
							prevState := state;
							state     := acknowledge;
							bitNum    := 7;
						else
							bitNum := bitNum - 1;
						end if;
					when addressHigh =>
						dataOut <= addressHighByte(bitNum);
						if (bitNum = 0) then
							prevState := state;
							state     := acknowledge;
							bitNum    := 7;
						else
							bitNum := bitNum - 1;
						end if;
					when addressLow =>
						dataOut <= addressLowByte(bitNum);
						if (bitNum = 0) then
							prevState := state;
							state     := acknowledge;
							bitNum    := 7;
						else
							bitNum := bitNum - 1;
						end if;
					when data =>
						dataOut <= dataByteTest(bitNum);
						if (bitNum = 0) then
							prevState := state;
							state     := acknowledge;
							bitNum    := 7;
						else
							bitNum := bitNum - 1;
						end if;
					when acknowledge =>
						if (prevState = control) then
							state := addressHigh;
						elsif (prevState = addressHigh) then
							state := addressLow;
						elsif (prevState = addressLow) then
							state := data;
						elsif (prevState = data) then
							if (byteNum = 63) then
								state := stop;
							else
								state   := data;
								byteNum <= byteNum + 1;
							end if;
						end if;
					when others => state := state;
				end case;
			end if;
			counter <= counter + 1;
		end if;
	end process;
	addr <= byteNum;

end architecture RTL;
