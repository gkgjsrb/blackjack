----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:46:25 06/05/2018 
-- Design Name: 
-- Module Name:    logic - Behavioral 
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

entity logic is
	port (in_card0, in_card1, in_card2, in_card3, in_card4, in_card5, in_card6, in_card7, in_card8, in_card9,
			in_card10, in_card11, in_card12, in_card13, in_card14, in_card15, in_card16, in_card17, in_card18, in_card19,
			in_card20, in_card21, in_card22, in_card23, in_card24, in_card25, in_card26 : in std_logic_vector(5 downto 0);
			clk, rst, hit, stand : in std_logic;
			state : in std_logic_vector(1 downto 0);		
			p1_fail, p2_fail, d_fail, d_stand : out std_logic
			);
end logic;

architecture Behavioral of logic is

component card_reg_set is
	port ( rst,clk : in std_logic;
			 input : in std_logic_vector(5 downto 0);
			 card0, card1, card2, card3, card4, card5, card6, card7, card8 : out std_logic_vector(5 downto 0)
			);
end component;

component money_reg is
	port(input : in STD_LOGIC_VECTOR(9 downto 0);
		  clk, reset, en : in STD_LOGIC;
		  output : out STD_LOGIC_VECTOR(9 downto 0));
end component;

component bcd_counter2 is
	port(	clk,rst, en : std_logic;
			cnt : out std_logic_vector(3 downto 0)
		  );
end component;

component bcd_counter is
	port(	clk,rst, en : std_logic;
			cnt : out std_logic_vector(4 downto 0)
		  );
end component;

component card_reg is
	port(input : in STD_LOGIC_VECTOR(5 downto 0);
		  clk, reset, en : in STD_LOGIC;
		  output : out STD_LOGIC_VECTOR(5 downto 0));
end component;

component status_reg is
	port(input : in STD_LOGIC_VECTOR(63 downto 0);
		  clk, reset, en : in STD_LOGIC;
		  output : out STD_LOGIC_VECTOR(63 downto 0));
end component;

signal p1_result : std_logic;
signal p2_result : std_logic;
signal p1_sum, p2_sum, d_sum : std_logic_vector(5 downto 0);
signal en, en1, en2, en3 : std_logic;
signal p1_input : std_logic_vector(5 downto 0);
signal p2_input : std_logic_vector(5 downto 0);
signal d_input : std_logic_vector(5 downto 0);
type all_card is array(26 downto 0) of std_logic_vector(5 downto 0);
signal sel_card : all_card;
type card_set is array(8 downto 0) of std_logic_vector(5 downto 0);  
signal p1_set,p2_set,d_set : card_set;
signal p1_cnt : std_logic_vector(3 downto 0);
signal p2_cnt : std_logic_vector(3 downto 0);
signal d_cnt : std_logic_vector(3 downto 0);
signal c_cnt : std_logic_vector(4 downto 0);
signal p1_input_sum, p2_input_sum, d_input_sum, p1_output_sum, p2_output_sum, d_output_sum : std_logic_vector(5 downto 0);
signal status_output1,status_output2,status_output3 : std_logic_vector(63 downto 0);
signal status_input1,status_input2,status_input3 : std_logic_vector(63 downto 0);

begin

	sel_card(0)<=in_card0;
	sel_card(1)<=in_card1;
	sel_card(2)<=in_card2;
	sel_card(3)<=in_card3;
	sel_card(4)<=in_card4;
	sel_card(5)<=in_card5;
	sel_card(6)<=in_card6;
	sel_card(7)<=in_card7;
	sel_card(8)<=in_card8;
	sel_card(9)<=in_card9;
	sel_card(10)<=in_card10;
	sel_card(11)<=in_card11;
	sel_card(12)<=in_card12;
	sel_card(13)<=in_card13;
	sel_card(14)<=in_card14;
	sel_card(15)<=in_card15;
	sel_card(16)<=in_card16;
	sel_card(17)<=in_card17;
	sel_card(18)<=in_card18;
	sel_card(19)<=in_card19;
	sel_card(20)<=in_card20;
	sel_card(21)<=in_card21;
	sel_card(22)<=in_card22;
	sel_card(23)<=in_card23;
	sel_card(24)<=in_card24;
	sel_card(25)<=in_card25;
	sel_card(26)<=in_card26;

	S1 : card_reg port map(reset=>rst, clk=>clk, input=>p1_input_sum, en=>'1', output=>p1_output_sum);
	S2 : card_reg port map(reset=>rst, clk=>clk, input=>p2_input_sum, en=>'1', output=>p2_output_sum);
	SD : card_reg port map(reset=>rst, clk=>clk, input=>d_input_sum , en=>'1', output=>d_output_sum);
	CR1 : card_reg_set port map(rst=>rst,clk=>hit,input=>p1_input,card0=>p1_set(0),card1=>p1_set(1),card2=>p1_set(2),card3=>p1_set(3),card4=>p1_set(4),card5=>p1_set(5),card6=>p1_set(6),card7=>p1_set(7),card8=>p1_set(8));
	CR2 : card_reg_set port map(rst=>rst,clk=>hit,input=>p2_input,card0=>p2_set(0),card1=>p2_set(1),card2=>p2_set(2),card3=>p2_set(3),card4=>p2_set(4),card5=>p2_set(5),card6=>p2_set(6),card7=>p2_set(7),card8=>p2_set(8));
	CRD : card_reg_set port map(rst=>rst,clk=>hit,input=>d_input,card0=>d_set(0),card1=>d_set(1),card2=>d_set(2),card3=>d_set(3),card4=>d_set(4),card5=>d_set(5),card6=>d_set(6),card7=>d_set(7),card8=>d_set(8));
	DS : status_reg port map(clk=>clk, reset=>rst, en=>'1', input=>status_input3, output=>status_output3);
	CC : bcd_counter port map(rst=>rst,clk=>clk,en=>en,cnt=>c_cnt);
	P1C : bcd_counter2 port map(rst=>rst,clk=>clk,en=>en1,cnt=>p1_cnt);
	P2C : bcd_counter2 port map(rst=>rst,clk=>clk,en=>en2,cnt=>p2_cnt);
	DC : bcd_counter2 port map(rst=>rst,clk=>clk,en=>en3,cnt=>d_cnt);
	
	--카드를 분배하고 합 결정
	process(state,hit,stand,en,en1,en2,en3,p1_cnt,p2_cnt,d_cnt,p1_input,p2_input,d_input,sel_card)
		variable status_tmp : integer range 0 to 63;
		variable cnt_tmp : integer range 0 to 26;
		variable p1_tmp : integer range 0 to 31;
		variable p2_tmp : integer range 0 to 31;
		variable d_tmp : integer range 0 to 31;
		variable card_tmp : integer range 0 to 11;
	begin
		cnt_tmp:=conv_integer(c_cnt);
		if state="00" then
			if p1_cnt="00" or p1_cnt="01" then
				en<='1';
				en1<='1';
				p1_input<=sel_card(cnt_tmp);
			end if;
			if p2_cnt="00" or p2_cnt="01" then
				en<='1';
				en2<='1';
				p2_input<=sel_card(cnt_tmp);
			end if;
			if d_cnt="00" or d_cnt="01" then
				en<='1';
				en3<='1';
				d_input<=sel_card(cnt_tmp);
			end if;			
		elsif state="01" then
			if hit='1' then
				en<='1';
				en1<='1';
				p1_input<=sel_card(cnt_tmp);
				status_tmp:=conv_integer(p1_input);
				p1_tmp:=conv_integer(p1_output_sum);
				if p1_input="000000" or p1_input="001101" or p1_input="011010" or p1_input="100111" then
					p1_tmp:=p1_tmp+1;
				elsif p1_input="000001" or p1_input="001110" or p1_input="011011" or p1_input="101000" then
					p1_tmp:=p1_tmp+2;
				elsif p1_input="000010" or p1_input="001111" or p1_input="011100" or p1_input="101001" then
					p1_tmp:=p1_tmp+3;
				elsif p1_input="000011" or p1_input="010000" or p1_input="011101" or p1_input="101010" then
					p1_tmp:=p1_tmp+4;
				elsif p1_input="000100" or p1_input="010001" or p1_input="011110" or p1_input="101011" then
					p1_tmp:=p1_tmp+5;
				elsif p1_input="000101" or p1_input="010010" or p1_input="011111" or p1_input="101100" then
					p1_tmp:=p1_tmp+6;
				elsif p1_input="000110" or p1_input="010011" or p1_input="100000" or p1_input="101101" then
					p1_tmp:=p1_tmp+7;
				elsif p1_input="000111" or p1_input="010100" or p1_input="100001" or p1_input="101110" then
					p1_tmp:=p1_tmp+8;
				elsif p1_input="001000" or p1_input="010101" or p1_input="100010" or p1_input="101111" then
					p1_tmp:=p1_tmp+9;
				else 
					p1_tmp:=p1_tmp+10;					
				end if;
				if p1_tmp=21 then
					p1_input_sum<=conv_std_logic_vector(21,6);
				elsif p1_tmp<21 then
					if p1_input="000000" or p1_input="001101" or p1_input="011010" or p1_input="100111" then
						if p1_tmp<11 then
							p1_tmp:=p1_tmp+10;
							p1_input_sum<=conv_std_logic_vector(p1_tmp,6);
						else
							p1_tmp:=p1_tmp;
							p1_input_sum<=conv_std_logic_vector(p1_tmp,6);
						end if;
					else
						p1_input_sum<=conv_std_logic_vector(p1_tmp,6);
					end if;
					p1_input_sum<=conv_std_logic_vector(p1_tmp,6);
				elsif p1_tmp>21 then
					p2_input_sum<=conv_std_logic_vector(0,6);
					p1_fail<='1';
				end if;
			elsif stand='1' then
				en<='0';
				en1<='0';
			end if;
		elsif state="10" then
			if hit='1' then
				en<='1';
				en2<='1';
				p2_input<=sel_card(cnt_tmp);			
				p2_tmp:=conv_integer(p2_output_sum);
				if p2_input="000000" or p2_input="001101" or p2_input="011010" or p2_input="100111" then
					p2_tmp:=p2_tmp+1;
				elsif p2_input="000001" or p2_input="001110" or p2_input="011011" or p2_input="101000" then
					p2_tmp:=p2_tmp+2;
				elsif p2_input="000010" or p2_input="001111" or p2_input="011100" or p2_input="101001" then
					p2_tmp:=p2_tmp+3;
				elsif p2_input="000011" or p2_input="010000" or p2_input="011101" or p2_input="101010" then
					p2_tmp:=p2_tmp+4;
				elsif p2_input="000100" or p2_input="010001" or p2_input="011110" or p2_input="101011" then
					p2_tmp:=p2_tmp+5;
				elsif p2_input="000101" or p2_input="010010" or p2_input="011111" or p2_input="101100" then
					p2_tmp:=p2_tmp+6;
				elsif p2_input="000110" or p2_input="010011" or p2_input="100000" or p2_input="101101" then
					p2_tmp:=p2_tmp+7;
				elsif p2_input="000111" or p2_input="010100" or p2_input="100001" or p2_input="101110" then
					p2_tmp:=p2_tmp+8;
				elsif p2_input="001000" or p2_input="010101" or p2_input="100010" or p2_input="101111" then
					p2_tmp:=p2_tmp+9;
				else 
					p2_tmp:=p2_tmp+10;					
				end if;
				if p2_tmp=21 then
					p2_input_sum<=conv_std_logic_vector(21,6);
				elsif p2_tmp<21 then
					if p2_input="000000" or p2_input="001101" or p2_input="011010" or p2_input="100111" then
						if p2_tmp<11 then
							p2_tmp:=p2_tmp+10;
							p2_input_sum<=conv_std_logic_vector(p2_tmp,6);
						else
							p2_tmp:=p2_tmp;
							p2_input_sum<=conv_std_logic_vector(p2_tmp,6);
						end if;
					else
						p2_input_sum<=conv_std_logic_vector(p2_tmp,6);
					end if;
					p2_input_sum<=conv_std_logic_vector(p2_tmp,6);
				elsif p2_tmp>21 then
					p2_input_sum<=conv_std_logic_vector(0,6);
					p2_fail<='1';
				end if;			
			elsif stand='1' then
				en<='0';
				en2<='0';			
			end if;		
		elsif state="11" then		
				d_tmp:=conv_integer(d_output_sum);
				if d_tmp>=17 then
					d_stand<='1';
				else
					en<='1';
					en3<='1';
					d_input<=sel_card(cnt_tmp);
					d_tmp:=conv_integer(d_output_sum);
					if d_input="000000" or d_input="001101" or d_input="011010" or d_input="100111" then
						d_tmp:=d_tmp+1;
					elsif d_input="000001" or d_input="001110" or d_input="011011" or d_input="101000" then
						d_tmp:=d_tmp+2;
					elsif d_input="000010" or d_input="001111" or d_input="011100" or d_input="101001" then
						d_tmp:=d_tmp+3;
					elsif d_input="000011" or d_input="010000" or d_input="011101" or d_input="101010" then
						d_tmp:=d_tmp+4;
					elsif d_input="000100" or d_input="010001" or d_input="011110" or d_input="101011" then
						d_tmp:=d_tmp+5;
					elsif d_input="000101" or d_input="010010" or d_input="011111" or d_input="101100" then
						d_tmp:=d_tmp+6;
					elsif d_input="000110" or d_input="010011" or d_input="100000" or d_input="101101" then
						d_tmp:=d_tmp+7;
					elsif d_input="000111" or d_input="010100" or d_input="100001" or d_input="101110" then
						d_tmp:=d_tmp+8;
					elsif d_input="001000" or d_input="010101" or d_input="100010" or d_input="101111" then
						d_tmp:=d_tmp+9;
					else 
						d_tmp:=d_tmp+10;					
					end if;
					if d_tmp=21 then
					d_input_sum<=conv_std_logic_vector(21,6);
					elsif d_tmp<21 then
						if d_input="000000" or d_input="001101" or d_input="011010" or d_input="100111" then
							if d_tmp<11 then
								d_tmp:=d_tmp+10;
								d_input_sum<=conv_std_logic_vector(d_tmp,6);
							else
								d_tmp:=d_tmp;
								d_input_sum<=conv_std_logic_vector(d_tmp,6);
							end if;
						else
							d_input_sum<=conv_std_logic_vector(d_tmp,6);
						end if;
						d_input_sum<=conv_std_logic_vector(d_tmp,6);
					elsif d_tmp>21 then
						d_input_sum<=conv_std_logic_vector(0,6);
						d_fail<='1';
					end if;					
				end if;
		end if;
	end process;
	
	-- 승패 결정
--	process(p1_result,p2_result)
--	begin
--		
--	end process;

	--금액을 결과에 따라 증감
--	process(p1_result,p2_result)
--	begin
--		if p1_result='1' then
--			--금액을 더함
--		elsif p1_result='0' then
--			--금액을 뺌
--		end if;
--		if p2_result='1' then
--			--금액을 더함
--		elsif p2_result='0' then
--			--금액을 뺌
--		end if;	
--	end process;

end Behavioral;

