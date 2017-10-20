----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:11:38 10/16/2017 
-- Design Name: 
-- Module Name:    debouce - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouce is

Port(
	clk : in std_logic;
	rstb : in std_logic;
	i1ms : in std_logic;
	I : in std_logic;
	O : out std_logic
);

end debouce;

architecture Behavioral of debouce is
	signal rCnt : std_logic_vector(2 downto 0);
	signal rDebouce : std_logic_vector(3 downto 0);
	signal rTick : std_logic;
begin

	-- out zone --
	-- O <= '1' when rDebouce = "1100" else '0';
	--------------
	
	-- register zone --
	u_rTick : Process(clk,rstb)
	Begin
		if(rstb = '0') then
			rTick <= '0';
			O <= '0';
		elsif(rising_edge(clk)) then
			if(rTick = '1' and rDebouce = "1100") then
				rTick <= '1';
				O <= '0';
			elsif(rTick = '0' and rDebouce = "1100") then
				rTick <= '1';
				O <= '1';
			else
				rTick <= '0';
				O <= '0';
			end if;
		end if;
	End Process;
	
	u_rCnt : Process(clk,rstb)
	Begin
		if(rstb = '0') then
			rCnt <= (others => '0');
			rDebouce <= (others => '0');
		elsif(rising_edge(clk)) then
			if(i1ms = '1' and rcnt = 4) then
				rCnt <= (others => '0');
				rDebouce <= rDebouce(2 downto 0) & I;
			elsif(i1ms = '1') then
				rCnt <= rCnt + 1;
				rDebouce <= rDebouce;
			else
				rCnt <= rCnt;
				rDebouce <= rDebouce;
			end if;
		end if;
	End Process;
	--------------------

end Behavioral;

