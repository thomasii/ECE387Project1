library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eepromWrite is
	port(
		clk     : in  std_logic;
		--en      : in  std_logic;
		dataOut : out std_logic;
		--dataIn  : in  std_logic_vector(7 downto 0);
		scl     : out std_logic
		--rst     : in  std_logic
		--addr    : out integer
	);
end entity eepromWrite;

architecture RTL of eepromWrite is
	signal byteNum : integer                      := 0;
	signal counter : integer                      := 0;
	signal sda     : std_logic                    := '1';
	signal state   : std_logic_vector(2 downto 0) := "000";
	signal tmp     : std_logic                    := '0';
	signal count   : integer                      := 0;
	signal fpgaClk : std_logic;
	--signal enEEPROM : std_logic := '0';
begin

	

	process(fpgaClk) is
		variable prevState       : std_logic_vector(2 downto 0) := "000";
		variable bitNum          : integer                      := 7;
		constant controlByte     : std_logic_vector(7 downto 0) := "10100000";
		constant addressHighByte : std_logic_vector(7 downto 0) := x"00";
		constant addressLowByte  : std_logic_vector(7 downto 0) := x"00";
		constant dataByteTest    : std_logic_vector(7 downto 0) := "00000000";

	begin
		if rising_edge(clk) then
			case counter is
				when 0 =>
					scl     <= '1';
					sda     <= sda;
					counter <= counter + 1;
				when 1 =>
					scl     <= '1';
					counter <= counter + 1;
					case state is
						when "000" =>
							sda       <= '0';
							prevState := "000";
							state     <= "001";
						when "110" =>   -- @suppress "Dead state "stop": state does not have outgoing transitions"
							sda       <= '1';
							state     <= "110";
							prevState := "110";

						when "001" =>
							state <= "001";
							sda   <= sda;
						when "010" =>
							state <= "010";
							sda   <= sda;
						when "011" =>
							state <= "011";
							sda   <= sda;
						when "100" =>
							state <= "100";
							sda   <= sda;
						when "101" =>
							state <= "101";
							sda   <= sda;
						when others =>
							state <= "000";
							sda   <= sda;
					end case;
				when 2 =>
					sda     <= sda;
					scl     <= '0';
					counter <= counter + 1;
				when 3 =>
					scl     <= '0';
					counter <= 0;
					case state is
						when "001" =>
							sda <= controlByte(bitNum); -- this
							if (bitNum - 1) >= 0 then
								bitNum := bitNum - 1;
							else
								prevState := "001";
								state     <= "010";
								bitNum    := 7;
							end if;
						when "011" =>
							sda <= addressHighByte(bitNum);
							if (bitNum - 1) >= 0 then
								bitNum := bitNum - 1;
							else
								prevState := "011";
								state     <= "010";
								bitNum    := 7;
							end if;
						when "100" =>
							sda <= addressLowByte(bitNum);
							if (bitNum - 1) >= 0 then
								bitNum := bitNum - 1;
							else
								prevState := "100";
								state     <= "010";
								bitNum    := 7;
							end if;
						when "101" =>
							sda <= dataByteTest(bitNum);
							if (bitNum - 1) >= 0 then
								bitNum := bitNum - 1;
							else
								prevState := "101";
								state     <= "010";
								bitNum    := 7;
							end if;
						when "010" =>
							sda <= '0';
							case prevState is
								when "001" =>
									state <= "011";
								when "011" =>
									state <= "100";
								when "100" =>
									state <= "101";
								when "101" =>
									if (byteNum + 1) <= 63 then
										state   <= "101";
										byteNum <= byteNum + 1;
									else
										state <= "110";
									end if;
								when others => state <= state;
							end case;
						when "000" =>
							state <= "000";
							sda   <= sda;
						when "110" =>
							state <= "000";
							sda   <= sda;
						when others =>
							state <= "000";
							sda   <= sda;
					end case;
				when others => state <= state; -- @suppress "Dead state "stop": state does not have outgoing transitions"
			end case;
		end if;
	end process;
	--addr    <= byteNum;
	dataOut <= sda;

end architecture RTL;
