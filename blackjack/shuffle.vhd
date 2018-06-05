----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:05:41 06/05/2018 
-- Design Name: 
-- Module Name:    shuffle - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shuffle is
	port ( rst,clk : in std_logic;
			 card0, card1, card2, card3, card4, card5, card6, card7, card8, card9, card10, card11, card12, card13,
			card14, card15, card16, card17, card18, card19, card20, card21, card22, card23, card24, card25, card26 : out std_logic_vector(5 downto 0)
			);
end shuffle;

architecture Behavioral of shuffle is

component card_reg is
	port(input : in STD_LOGIC_VECTOR(5 downto 0);
		  clk, reset, en : in STD_LOGIC;
		  output : out STD_LOGIC_VECTOR(5 downto 0));
end component;

component LFSR is
	port(clk,rst,en : in std_logic;
		  cnt : out std_logic_vector(5 downto 0)
		  );	
end component;

component status_reg is
	port(input : in STD_LOGIC_VECTOR(63 downto 0);
		  clk, reset, en : in STD_LOGIC;
		  output : out STD_LOGIC_VECTOR(63 downto 0));
end component;

component bcd_counter is
	port(	clk,rst : std_logic;
			cnt : out std_logic_vector(4 downto 0)
		  );
end component;

type card_set is array(26 downto 0) of std_logic_vector(5 downto 0); 
signal shift_card : card_set;
signal lf_result : std_logic_vector(5 downto 0);
signal input : std_logic_vector(5 downto 0);
signal status_output : std_logic_vector(63 downto 0);
signal status_input : std_logic_vector(63 downto 0);
signal proper : std_logic;
signal cnt_data : std_logic_vector(4 downto 0);

begin
	
	LF0 : LFSR port map(clk=>clk,rst=>rst,en=>'1',cnt=>lf_result);
	SR : status_reg port map(clk=>proper, reset=>rst, en=>'1',input=>status_input,output=>status_output);
	CNT : bcd_counter port map(clk=>proper, rst=>rst, cnt=>cnt_data);
	
	process(lf_result,input,status_output,status_input,proper,cnt_data)
		variable input_tmp : integer range 0 to 63;  
		variable cnt_tmp : integer range 0 to 31;
	begin
		cnt_tmp:=conv_integer(cnt_data);
		input<=lf_result;
		input_tmp:=conv_integer(input);
		status_input<=status_output;
		proper<='0';
		while cnt_tmp<26 loop
		input<=lf_result;
		input_tmp:=conv_integer(input);
			if input_tmp<64 then
				if status_output(input_tmp)='0' then
					status_input<=status_output;
					status_input(input_tmp)<='1';
					proper<='1';
				else
					status_input<=status_output;
					proper<='0';
				end if;
			else
				status_input<=status_output;
				proper<='0';
			end if;
		end loop;
	end process;
	
	REG0 : card_reg port map(input=>input, clk=>proper, reset=>rst, en=>'1', output=>shift_card(0));
	REG1 : card_reg port map(input=>shift_card(0), clk=>proper, reset=>rst, en=>'1', output=>shift_card(1));
	REG2 : card_reg port map(input=>shift_card(1), clk=>proper, reset=>rst, en=>'1', output=>shift_card(2));
	REG3 : card_reg port map(input=>shift_card(2), clk=>proper, reset=>rst, en=>'1', output=>shift_card(3));
	REG4 : card_reg port map(input=>shift_card(3), clk=>proper, reset=>rst, en=>'1', output=>shift_card(4));
	REG5 : card_reg port map(input=>shift_card(4), clk=>proper, reset=>rst, en=>'1', output=>shift_card(5));
	REG6 : card_reg port map(input=>shift_card(5), clk=>proper, reset=>rst, en=>'1', output=>shift_card(6));
	REG7 : card_reg port map(input=>shift_card(6), clk=>proper, reset=>rst, en=>'1', output=>shift_card(7));
	REG8 : card_reg port map(input=>shift_card(7), clk=>proper, reset=>rst, en=>'1', output=>shift_card(8));
	REG9 : card_reg port map(input=>shift_card(8), clk=>proper, reset=>rst, en=>'1', output=>shift_card(9));
	REG10 : card_reg port map(input=>shift_card(9), clk=>proper, reset=>rst, en=>'1', output=>shift_card(10));
	REG11 : card_reg port map(input=>shift_card(10), clk=>proper, reset=>rst, en=>'1', output=>shift_card(11));
	REG12 : card_reg port map(input=>shift_card(11), clk=>proper, reset=>rst, en=>'1', output=>shift_card(12));
	REG13 : card_reg port map(input=>shift_card(12), clk=>proper, reset=>rst, en=>'1', output=>shift_card(13));
	REG14 : card_reg port map(input=>shift_card(13), clk=>proper, reset=>rst, en=>'1', output=>shift_card(14));
	REG15 : card_reg port map(input=>shift_card(14), clk=>proper, reset=>rst, en=>'1', output=>shift_card(15));
	REG16 : card_reg port map(input=>shift_card(15), clk=>proper, reset=>rst, en=>'1', output=>shift_card(16));
	REG17 : card_reg port map(input=>shift_card(16), clk=>proper, reset=>rst, en=>'1', output=>shift_card(17));
	REG18 : card_reg port map(input=>shift_card(17), clk=>proper, reset=>rst, en=>'1', output=>shift_card(18));
	REG19 : card_reg port map(input=>shift_card(18), clk=>proper, reset=>rst, en=>'1', output=>shift_card(19));
	REG20 : card_reg port map(input=>shift_card(19), clk=>proper, reset=>rst, en=>'1', output=>shift_card(20));
	REG21 : card_reg port map(input=>shift_card(20), clk=>proper, reset=>rst, en=>'1', output=>shift_card(21));
	REG22 : card_reg port map(input=>shift_card(21), clk=>proper, reset=>rst, en=>'1', output=>shift_card(22));
	REG23 : card_reg port map(input=>shift_card(22), clk=>proper, reset=>rst, en=>'1', output=>shift_card(23));
	REG24 : card_reg port map(input=>shift_card(23), clk=>proper, reset=>rst, en=>'1', output=>shift_card(24));
	REG25 : card_reg port map(input=>shift_card(24), clk=>proper, reset=>rst, en=>'1', output=>shift_card(25));
	REG26 : card_reg port map(input=>shift_card(25), clk=>proper, reset=>rst, en=>'1', output=>shift_card(26));
	
	card0<=shift_card(0);
	card1<=shift_card(1);
	card2<=shift_card(2);
	card3<=shift_card(3);
	card4<=shift_card(4);
	card5<=shift_card(5);
	card6<=shift_card(6);
	card7<=shift_card(7);
	card8<=shift_card(8);
	card9<=shift_card(9);
	card10<=shift_card(10);
	card11<=shift_card(11);	
	card12<=shift_card(12);
	card13<=shift_card(13);
	card14<=shift_card(14);
	card15<=shift_card(15);
	card16<=shift_card(16);
	card17<=shift_card(17);
	card18<=shift_card(18);
	card19<=shift_card(19);
	card20<=shift_card(20);
	card21<=shift_card(21);
	card22<=shift_card(22);
	card23<=shift_card(23);
	card24<=shift_card(24);
	card25<=shift_card(25);
	card26<=shift_card(26);
	
end Behavioral;
