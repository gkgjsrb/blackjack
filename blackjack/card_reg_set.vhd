----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:41:01 06/05/2018 
-- Design Name: 
-- Module Name:    card_reg_set - Behavioral 
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
use IEEE.Numeric_Std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity card_reg_set is
	port ( rst,clk : in std_logic;
			 input : in std_logic_vector(5 downto 0);
			 card0, card1, card2, card3, card4, card5, card6, card7, card8 : out std_logic_vector(5 downto 0)
			);
end card_reg_set;

architecture Behavioral of card_reg_set is

component card_reg is
	port(input : in STD_LOGIC_VECTOR(5 downto 0);
		  clk, reset, en : in STD_LOGIC;
		  output : out STD_LOGIC_VECTOR(5 downto 0));
end component;

signal shift_card0,shift_card1,shift_card2,shift_card3,shift_card4,shift_card5,shift_card6,shift_card7,shift_card8 : std_logic_vector(5 downto 0);

begin

	REG0 : card_reg port map(input=>input, clk=>clk, reset=>rst, en=>'1', output=>shift_card0);
	REG1 : card_reg port map(input=>shift_card0, clk=>clk, reset=>rst, en=>'1', output=>shift_card1);
	REG2 : card_reg port map(input=>shift_card1, clk=>clk, reset=>rst, en=>'1', output=>shift_card2);
	REG3 : card_reg port map(input=>shift_card2, clk=>clk, reset=>rst, en=>'1', output=>shift_card3);
	REG4 : card_reg port map(input=>shift_card3, clk=>clk, reset=>rst, en=>'1', output=>shift_card4);
	REG5 : card_reg port map(input=>shift_card4, clk=>clk, reset=>rst, en=>'1', output=>shift_card5);
	REG6 : card_reg port map(input=>shift_card5, clk=>clk, reset=>rst, en=>'1', output=>shift_card6);
	REG7 : card_reg port map(input=>shift_card6, clk=>clk, reset=>rst, en=>'1', output=>shift_card7);
	REG8 : card_reg port map(input=>shift_card7, clk=>clk, reset=>rst, en=>'1', output=>shift_card8);	
	
	card0<=shift_card0;
	card1<=shift_card1;
	card2<=shift_card2;
	card3<=shift_card3;
	card4<=shift_card4;
	card5<=shift_card5;
	card6<=shift_card6;
	card7<=shift_card7;
	card8<=shift_card8;
	
end Behavioral;

