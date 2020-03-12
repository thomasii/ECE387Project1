library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eepromWrite is
	port(
		clk     : in  std_logic;
		en      : in  std_logic;
		dataOut : out std_logic := '1';
		dataIn  : in  std_logic_vector(7 downto 0);
		scl     : out std_logic;
		addr    : out integer
	);
end entity eepromWrite;

architecture RTL of eepromWrite is
	type state_type is (start, control, acknowledge, addressHigh, addressLow, data, stop);
	signal byteNum : integer := 0;
	signal counter : integer := 0;
	--signal enEEPROM : std_logic := '0';
begin

	process(clk, en) is
		variable state           : state_type                   := start;
		variable prevState       : state_type                   := start;
		variable bitNum          : integer                      := 7;
		constant controlByte     : std_logic_vector(7 downto 0) := "10100000";
		constant addressHighByte : std_logic_vector(7 downto 0) := x"00";
		constant addressLowByte  : std_logic_vector(7 downto 0) := x"00";
		constant dataByteTest    : std_logic_vector(7 downto 0) := "00000000";

	begin
		if rising_edge(clk) and en = '1' then
			case counter is
				when 0 =>
					scl     <= '1';
					counter <= counter + 1;
				when 1 =>
					scl     <= '1';
					counter <= counter + 1;
					case state is
						when start =>
							dataOut   <= '0';
							prevState := start;
							state     := control;
						when stop =>    -- @suppress "Dead state "stop": state does not have outgoing transitions"
							dataOut   <= '1';
							state     := stop;
							prevState := stop;
						when acknowledge =>
							dataOut <= '0';
							case prevState is
								when control =>
									state := addressHigh;
								when addressHigh =>
									state := addressLow;
								when addressLow =>
									state := data;
								when data =>
									if (byteNum + 1) <= 63 then
										state   := data;
										byteNum <= byteNum + 1;
									else
										state := stop;
									end if;
								when others => state := state;
							end case;
						when others => state := state;
					end case;
				when 2 =>
					scl     <= '0';
					counter <= counter + 1;
				when 3 =>
					scl     <= '0';
					counter <= 0;
					case state is
						when control =>
							dataOut <= controlByte(bitNum); -- this
							if (bitNum - 1) >= 0 then
								bitNum := bitNum - 1;
							else
								prevState := control;
								state     := acknowledge;
								bitNum    := 7;
							end if;
						when addressHigh =>
							dataOut <= addressHighByte(bitNum);
							if (bitNum - 1) >= 0 then
								bitNum := bitNum - 1;
							else
								prevState := addressHigh;
								state     := acknowledge;
								bitNum    := 7;
							end if;
						when addressLow =>
							dataOut <= addressLowByte(bitNum);
							if (bitNum - 1) >= 0 then
								bitNum := bitNum - 1;
							else
								prevState := addressLow;
								state     := acknowledge;
								bitNum    := 7;
							end if;
						when data =>
							dataOut <= dataByteTest(bitNum);
							if (bitNum - 1) >= 0 then
								bitNum := bitNum - 1;
							else
								prevState := data;
								state     := acknowledge;
								bitNum    := 7;
							end if;

						when others => state := state;
					end case;
				when others => state := state; -- @suppress "Dead state "stop": state does not have outgoing transitions"
			end case;
		end if;
	end process;
	addr <= byteNum;

end architecture RTL;
