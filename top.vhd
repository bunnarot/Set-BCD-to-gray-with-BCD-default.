----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:36:17 10/16/2017 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is

Port(
	clk : in std_logic;
	rstb : in std_logic;
	I : in std_logic;
	O : out std_logic_vector(6 downto 0);
	com : out std_logic_vector(3 downto 0)
);

end top;

architecture Behavioral of top is
	component CLK1ms is
		Port(
			clk : in std_logic;
			rstb : in std_logic;
			o1ms : out std_logic
		);
	end component CLK1ms;
	component CLK1s is
		Port(
			clk : in std_logic;
			rstb : in std_logic;
			iclk1ms : in std_logic;
			o1s : out std_logic
		);
	end component CLK1s;
	component BCD is
		Port(
			I : in std_logic_vector(3 downto 0);
			O : out std_logic_vector(6 downto 0)
		);
	end component BCD;
	component debouce is
		Port(
			clk : in std_logic;
			rstb : in std_logic;
			i1ms : in std_logic;
			I : in std_logic;
			O : out std_logic
		);
	end component debouce;
	component ScanDigit is
		Port(
			clk : in std_logic;
			rstb : in std_logic;
			
			i1ms : in std_logic;
			
			idigit1 : in std_logic_vector(3 downto 0);
			idigit2 : in std_logic_vector(3 downto 0);
			idigit3 : in std_logic_vector(3 downto 0);
			idigit4 : in std_logic_vector(3 downto 0);
			
			odigit : out std_logic_vector(3 downto 0);
			odata : out std_logic_vector(3 downto 0)
		);
	end component ScanDigit;
	signal wdigit : std_logic_vector(3 downto 0);
	signal rCnt : std_logic_vector(3 downto 0);
	signal rCnt2 : std_logic_vector(3 downto 0);
	signal w1ms : std_logic;
	signal w1s : std_logic;
	signal wO : std_logic;
begin

	u_rCnt : Process(clk,rstb)
	Begin
		if(rstb = '0') then
			rCnt <= (others => '0');
		elsif(rising_edge(clk)) then
			if(wO = '1') then
				rCnt <= rCnt + 1;
			else
				rCnt <= rCnt;
			end if;
		end if;
	End Process;
	
	u_rCnt2 : Process(clk,rstb)
	Begin
		if(rstb='0') then
			rcnt2 <= (others => '0');
		elsif(rising_edge(clk)) then
			if(w1s = '1' and rCnt = rcnt2) then
				rcnt2 <= rcnt2;
			elsif(w1s = '1') then
				rcnt2 <= rcnt2 - 1;
			else
				rcnt2 <= rcnt2;
			end if;
		end if;
	end Process;
	
	u_CLK1ms : CLK1ms
	Port Map(
		clk 	=> clk,
		rstb 	=> rstb,
		o1ms 	=> w1ms
	);
	
	u_CLK1s : CLK1s
	Port Map(
		clk 		=> clk,
		rstb 		=> rstb,
		iclk1ms 	=> w1ms,
		o1s 		=> w1s
	);
	
	u_Debouce : debouce
	Port Map(
		clk 	=> clk,
		rstb 	=> rstb,
		i1ms 	=> w1ms,
		I 		=> I,
		O 		=> wO
	);
	
	u_ScanDigit : ScanDigit
	Port Map(
		clk 		=> clk,
		rstb 		=> rstb,
		i1ms 		=> w1ms,
		
		idigit1 	=> rCnt,
		idigit2 	=> rCnt2,
		idigit3 	=> "0000",
		idigit4 	=> "0000",
		
		odigit 	=> com,
		odata 	=> wdigit
	);
	
	u_BCD : BCD
	Port Map(
		I => wdigit,
		O => O
	);

end Behavioral;

