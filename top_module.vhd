----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:55:14 06/05/2018 
-- Design Name: 
-- Module Name:    top_module - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module is
	port ( clk, rst : in std_logic;
			 I1 : in std_logic_vector(3 downto 0);
			 I2 : in std_logic_vector(3 downto 0);
			 segment : out std_logic_vector(7 downto 0);
			 dig : out std_logic_vector(5 downto 0));
end top_module;

architecture Behavioral of top_module is

component segment7 is
	port(SEG_INPUT1,SEG_INPUT2,SEG_INPUT3,SEG_INPUT4,SEG_INPUT5,SEG_INPUT6 : in std_logic_vector(3 downto 0);
		  segment : out std_logic_vector(7 downto 0);
		  dig : out std_logic_vector(5 downto 0);
		  clk, rst : in std_logic);
end component;

component clkdivider2 is
	port(clk,rst : in STD_LOGIC;
		  dclk : out STD_LOGIC);
end component;

type seg_in is array(0 to 2) of std_logic_vector(3 downto 0);
signal seginput1,seginput2 : seg_in;
signal inv_rst : std_logic;
signal seg_clk : std_logic;

begin
	inv_rst<=not rst;
	DVD : clkdivider2 port map(clk=>clk, rst=>inv_rst, dclk=>seg_clk);
	process(I1,I2,seginput1,seginput2)
	begin
		if I1="1111" then
			seginput1(0)<=x"1";
			seginput1(1)<=x"6";
			seginput1(2)<=x"5";
		elsif I1="1110" then
			seginput1(0)<=x"1";
			seginput1(1)<=x"6";
			seginput1(2)<=x"0";			
		elsif I1="1101" then
			seginput1(0)<=x"1";
			seginput1(1)<=x"5";
			seginput1(2)<=x"5";
		elsif I1="1100" then
			seginput1(0)<=x"1";
			seginput1(1)<=x"5";
			seginput1(2)<=x"0";
		elsif I1="1011" then
			seginput1(0)<=x"1";
			seginput1(1)<=x"1";
			seginput1(2)<=x"5";		
		elsif I1="1010" then
			seginput1(0)<=x"1";
			seginput1(1)<=x"1";
			seginput1(2)<=x"0";
		elsif I1="1001" then
			seginput1(0)<=x"1";
			seginput1(1)<=x"0";
			seginput1(2)<=x"5";
		elsif I1="1000" then
			seginput1(0)<=x"1";
			seginput1(1)<=x"0";
			seginput1(2)<=x"0";
		elsif I1="0111" then
			seginput1(0)<=x"0";
			seginput1(1)<=x"6";
			seginput1(2)<=x"5";
		elsif I1="0110" then
			seginput1(0)<=x"0";
			seginput1(1)<=x"6";
			seginput1(2)<=x"0";
		elsif I1="0101" then
			seginput1(0)<=x"0";
			seginput1(1)<=x"5";
			seginput1(2)<=x"5";
		elsif I1="0100" then
			seginput1(0)<=x"0";
			seginput1(1)<=x"5";
			seginput1(2)<=x"0";
		elsif I1="0011" then
			seginput1(0)<=x"0";
			seginput1(1)<=x"1";
			seginput1(2)<=x"5";
		elsif I1="0010" then
			seginput1(0)<=x"0";
			seginput1(1)<=x"1";
			seginput1(2)<=x"0";
		elsif I1="0001" then
			seginput1(0)<=x"0";
			seginput1(1)<=x"0";
			seginput1(2)<=x"5";
		elsif I1="0000" then
			seginput1(0)<=x"0";
			seginput1(1)<=x"0";
			seginput1(2)<=x"0";			
		end if;
		if I2="1111" then
			seginput2(0)<=x"1";
			seginput2(1)<=x"6";
			seginput2(2)<=x"5";
		elsif I2="1110" then
			seginput2(0)<=x"1";
			seginput2(1)<=x"6";
			seginput2(2)<=x"0";			
		elsif I2="1101" then
			seginput2(0)<=x"1";
			seginput2(1)<=x"5";
			seginput2(2)<=x"5";
		elsif I2="1100" then
			seginput2(0)<=x"1";
			seginput2(1)<=x"5";
			seginput2(2)<=x"0";
		elsif I2="1011" then
			seginput2(0)<=x"1";
			seginput2(1)<=x"1";
			seginput2(2)<=x"5";		
		elsif I2="1010" then
			seginput2(0)<=x"1";
			seginput2(1)<=x"1";
			seginput2(2)<=x"0";
		elsif I2="1001" then
			seginput2(0)<=x"1";
			seginput2(1)<=x"0";
			seginput2(2)<=x"5";
		elsif I2="1000" then
			seginput2(0)<=x"1";
			seginput2(1)<=x"0";
			seginput2(2)<=x"0";
		elsif I2="0111" then
			seginput2(0)<=x"0";
			seginput2(1)<=x"6";
			seginput2(2)<=x"5";
		elsif I2="0110" then
			seginput2(0)<=x"0";
			seginput2(1)<=x"6";
			seginput2(2)<=x"0";
		elsif I2="0101" then
			seginput2(0)<=x"0";
			seginput2(1)<=x"5";
			seginput2(2)<=x"5";
		elsif I2="0100" then
			seginput2(0)<=x"0";
			seginput2(1)<=x"5";
			seginput2(2)<=x"0";
		elsif I2="0011" then
			seginput2(0)<=x"0";
			seginput2(1)<=x"1";
			seginput2(2)<=x"5";
		elsif I2="0010" then
			seginput2(0)<=x"0";
			seginput2(1)<=x"1";
			seginput2(2)<=x"0";
		elsif I2="0001" then
			seginput2(0)<=x"0";
			seginput2(1)<=x"0";
			seginput2(2)<=x"5";
		elsif I2="0000" then
			seginput2(0)<=x"0";
			seginput2(1)<=x"0";
			seginput2(2)<=x"0";			
		end if;
	end process;
	SEG :	segment7 port map( SEG_INPUT1=>seginput1(0), SEG_INPUT2=>seginput1(1), SEG_INPUT3=>seginput1(2), SEG_INPUT4=>seginput2(0), SEG_INPUT5=>seginput2(1),
									 SEG_INPUT6=>seginput2(2), clk=>seg_clk, rst=>inv_rst, dig=>dig, segment=>segment); 
	
end Behavioral;

