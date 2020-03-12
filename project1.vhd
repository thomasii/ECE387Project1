library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project1 is
	port(
		clk       : in  std_logic;
		adcOut    : out std_logic := '1';
		adcIn     : in  std_logic;
		adcCS     : out std_logic;
		adcClk    : out std_logic;
		eepromClk : out std_logic;
		eepromOut : out std_logic;
		rst       : in  std_logic
	);
end entity;

architecture behavior of project1 is

	component clockDivide4 is
		port(
			CLK_50MHz : in  std_logic;
			clk       : out std_logic);
	end component clockDivide4;

	component clockDivider500KHz is
		port(
			CLK_50MHz : in  std_logic;
			clk       : out std_logic);
	end component clockDivider500KHz;

	component adcReader
		port(
			clk      : in  std_logic;
			adcOut   : out std_logic;
			adcIn    : in  std_logic;
			adcCS    : out std_logic;
			eepromEn : out std_logic;
			regWen   : out std_logic;
			addrOut  : out integer;
			adcData  : out std_logic_vector(7 downto 0)
		);
	end component adcReader;

	component EEPROMWRITE
		port(
			clk     : in  std_logic;
			en      : in  std_logic;
			dataOut : out std_logic;
			dataIn  : in  std_logic_vector(7 downto 0);
			scl     : out std_logic;
			addr    : out integer
		);
	end component EEPROMWRITE;

	component reg8by64 is
		Port(clk   : in  std_logic;
		     dataD : in  std_logic_vector(7 downto 0);
		     selA  : in  integer;
		     selD  : in  integer;
		     we    : in  std_logic;
		     dataA : out std_logic_vector(7 downto 0)
		    );
	end component reg8by64;

	signal fpgaClk  : std_logic;
	signal eepromEn : std_logic := '1';
	signal regWen   : std_logic;
	signal addrD    : integer;
	signal addrA    : integer;
	signal dataA    : std_logic_vector(7 downto 0);
	signal adcData  : std_logic_vector(7 downto 0);
begin
	clockDivideFPGA : clockDivider500KHz
		port map(
			CLK_50MHz => clk,
			clk       => fpgaClk
		);

	--clockDivideEEPROM : clockDivide4
	--port map(
	--CLK_50MHz => clk,
	--clk       => sclClk
	--	);

	adc : adcReader
		port map(
			clk      => fpgaClk,
			adcOut   => adcOut,
			adcIn    => adcIn,
			adcCS    => adcCS,
			eepromEn => eepromEn,
			regWen   => regWen,
			addrOut  => addrD,
			adcData  => adcData
		);

	regFile : reg8by64
		port map(
			clk   => fpgaClk,
			dataD => adcData,
			selA  => addrA,
			selD  => addrD,
			we    => regWen,
			dataA => dataA
		);

	eeprom : EEPROMWRITE
		port map(
			clk     => fpgaClk,
			en      => eepromEn,
			dataOut => eepromOut,
			dataIn  => dataA,
			scl     => eepromClk,
			addr    => addrA
		);
	adcClk <= fpgaClk;
end behavior;
