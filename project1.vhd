library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project1 is
	port(
		clk     : in  std_logic;
		adcOut  : out std_logic := '1';
		adcIn   : in  std_logic;
		adcCS   : out std_logic;
		adcData : out std_logic_vector(7 downto 0);
		adcClk : out std_logic;
		rst     : in  std_logic
	);
end entity;

architecture behavior of project1 is

	component clockDivider is
		port(
			CLK_50MHz : in  std_logic;
			clk       : out std_logic);
	end component clockDivider;

	component adcReader is
		port(
			clk     : in  std_logic;
			adcOut  : out std_logic := '1';
			adcIn   : in  std_logic;
			adcCS   : out std_logic;
			adcData : out std_logic_vector(7 downto 0)
			);
	end component adcReader;

	signal adcClock : std_logic;
begin
	clockDivide : clockDivider port map(clk, adcClock);
	adc : adcReader port map(adcClock, adcOut, adcIn, adcCS, adcData);
	adcClk <= adcClock;
end behavior;
