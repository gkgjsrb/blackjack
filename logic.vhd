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
use IEEE.STD_LOGIC_arith.ALL;
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
			p1_win, p2_win : out std_logic_vector(1 downto 0);
			p1_finish, p2_finish, d_finish, d_stand : out std_logic;
			p1_card0,p1_card1,p1_card2,p1_card3,p1_card4,p1_card5,p1_card6,p1_card7,p1_card8 : out std_logic_vector(5 downto 0);
			p2_card0,p2_card1,p2_card2,p2_card3,p2_card4,p2_card5,p2_card6,p2_card7,p2_card8 : out std_logic_vector(5 downto 0);
			d_card0,d_card1,d_card2,d_card3,d_card4,d_card5,d_card6,d_card7,d_card8 : out std_logic_vector(5 downto 0)	
			);
end logic;

architecture Behavioral of logic is

component card_reg_set is
	port ( rst,clk,en : in std_logic;
			 input : in std_logic_vector(5 downto 0);
			 card0, card1, card2, card3, card4, card5, card6, card7, card8 : out std_logic_vector(5 downto 0)
			);
end component;
component bcd_counter is
	port(	clk,rst, en : std_logic;
			cnt : out std_logic_vector(4 downto 0)
		  );
end component;
component bcd_counter2 is
	port(	clk,rst, en : std_logic;
			cnt : out std_logic_vector(3 downto 0)
		  );
end component;
component sum_reg is
	port(input : in STD_LOGIC_VECTOR(4 downto 0);
		  clk, reset, en : in STD_LOGIC;
		  output : out STD_LOGIC_VECTOR(4 downto 0));
end component;
component ace_counter is
	port(	clk,rst, en : std_logic;
			cnt : out std_logic_vector(1 downto 0)
		  );
end component;

signal en, en1, en2, en3, ena1, ena2, ena3 : std_logic;
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
signal p1a,p2a,da : std_logic_vector(1 downto 0);
signal p1_input_sum, p2_input_sum, d_input_sum, p1_output_sum, p2_output_sum, d_output_sum : std_logic_vector(4 downto 0);

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
	
	S1 : sum_reg port map(reset=>rst, clk=>clk, input=>p1_input_sum, en=>'1', output=>p1_output_sum);
	S2 : sum_reg port map(reset=>rst, clk=>clk, input=>p2_input_sum, en=>'1', output=>p2_output_sum);
	SD : sum_reg port map(reset=>rst, clk=>clk, input=>d_input_sum , en=>'1', output=>d_output_sum);
	AC1 : ace_counter port map(clk=>clk, rst=>rst, en=>ena1, cnt=>p1a);
	AC2 : ace_counter port map(clk=>clk, rst=>rst, en=>ena2, cnt=>p2a);
	ACD : ace_counter port map(clk=>clk, rst=>rst, en=>ena3, cnt=>da);
	CR1 : card_reg_set port map(rst=>rst,clk=>clk,input=>p1_input,en=>en1,card0=>p1_set(0),card1=>p1_set(1),card2=>p1_set(2),card3=>p1_set(3),card4=>p1_set(4),card5=>p1_set(5),card6=>p1_set(6),card7=>p1_set(7),card8=>p1_set(8));
	CR2 : card_reg_set port map(rst=>rst,clk=>clk,input=>p2_input,en=>en2,card0=>p2_set(0),card1=>p2_set(1),card2=>p2_set(2),card3=>p2_set(3),card4=>p2_set(4),card5=>p2_set(5),card6=>p2_set(6),card7=>p2_set(7),card8=>p2_set(8));
	CRD : card_reg_set port map(rst=>rst,clk=>clk,input=>d_input,en=>en3,card0=>d_set(0),card1=>d_set(1),card2=>d_set(2),card3=>d_set(3),card4=>d_set(4),card5=>d_set(5),card6=>d_set(6),card7=>d_set(7),card8=>d_set(8));
	CC : bcd_counter port map(rst=>rst,clk=>clk,en=>en,cnt=>c_cnt);
	P1C : bcd_counter2 port map(rst=>rst,clk=>clk,en=>en1,cnt=>p1_cnt);
	P2C : bcd_counter2 port map(rst=>rst,clk=>clk,en=>en2,cnt=>p2_cnt);
	DC : bcd_counter2 port map(rst=>rst,clk=>clk,en=>en3,cnt=>d_cnt);
	
	--카드를 분배하고 합 결정
	process(state,hit,stand,en,en1,en2,en3,p1_cnt,p2_cnt,d_cnt,p1_input,p2_input,d_input,sel_card,p1a,p2a,da)
		variable cnt_tmp : integer range 0 to 26;
		variable p1_tmp : integer range 0 to 30;
		variable p2_tmp : integer range 0 to 30;
		variable d_tmp : integer range 0 to 30;
	begin
		cnt_tmp:=conv_integer(c_cnt);
		if state="00" then
			if p1_cnt="00" or p1_cnt="01" then
				en<='1';
				en1<='1';
				en2<='0';
				en3<='0';
				p1_input<=sel_card(cnt_tmp);
				p1_tmp:=conv_integer(p1_output_sum);
				if p1_input="000000" or p1_input="001101" or p1_input="011010" or p1_input="100111" then
					p1_tmp:=p1_tmp+1;
					ena1<='1';
				elsif p1_input="000001" or p1_input="001110" or p1_input="011011" or p1_input="101000" then
					p1_tmp:=p1_tmp+2;
					ena1<='0';
				elsif p1_input="000010" or p1_input="001111" or p1_input="011100" or p1_input="101001" then
					p1_tmp:=p1_tmp+3;
					ena1<='0';
				elsif p1_input="000011" or p1_input="010000" or p1_input="011101" or p1_input="101010" then
					p1_tmp:=p1_tmp+4;
					ena1<='0';
				elsif p1_input="000100" or p1_input="010001" or p1_input="011110" or p1_input="101011" then
					p1_tmp:=p1_tmp+5;
					ena1<='0';
				elsif p1_input="000101" or p1_input="010010" or p1_input="011111" or p1_input="101100" then
					p1_tmp:=p1_tmp+6;
					ena1<='0';
				elsif p1_input="000110" or p1_input="010011" or p1_input="100000" or p1_input="101101" then
					p1_tmp:=p1_tmp+7;
					ena1<='0';
				elsif p1_input="000111" or p1_input="010100" or p1_input="100001" or p1_input="101110" then
					p1_tmp:=p1_tmp+8;
					ena1<='0';				
				elsif p1_input="001000" or p1_input="010101" or p1_input="100010" or p1_input="101111" then
					p1_tmp:=p1_tmp+9;
					ena1<='0';
				else
					ena1<='0';
					if p1a="10" then
						p1_tmp:=12;
					else
						p1_tmp:=p1_tmp+10;
					end if;								
				end if;
				p1_input_sum<=conv_std_logic_vector(p1_tmp,5);
			elsif p2_cnt="00" or p2_cnt="01" then
				en<='1';
				en1<='0';
				en2<='1';
				en3<='0';
				p2_input<=sel_card(cnt_tmp);
				p2_tmp:=conv_integer(p2_output_sum);
				if p2_input="000000" or p2_input="001101" or p2_input="011010" or p2_input="100111" then
					p2_tmp:=p2_tmp+1;
					ena2<='1';
				elsif p2_input="000001" or p2_input="001110" or p2_input="011011" or p2_input="101000" then
					p2_tmp:=p2_tmp+2;
					ena2<='0';
				elsif p2_input="000010" or p2_input="001111" or p2_input="011100" or p2_input="101001" then
					p2_tmp:=p2_tmp+3;
					ena2<='0';
				elsif p2_input="000011" or p2_input="010000" or p2_input="011101" or p2_input="101010" then
					p2_tmp:=p2_tmp+4;
					ena2<='0';
				elsif p2_input="000100" or p2_input="010001" or p2_input="011110" or p2_input="101011" then
					p2_tmp:=p2_tmp+5;
					ena2<='0';
				elsif p2_input="000101" or p2_input="010010" or p2_input="011111" or p2_input="101100" then
					p2_tmp:=p2_tmp+6;
					ena2<='0';
				elsif p2_input="000110" or p2_input="010011" or p2_input="100000" or p2_input="101101" then
					p2_tmp:=p2_tmp+7;
					ena2<='0';
				elsif p2_input="000111" or p2_input="010100" or p2_input="100001" or p2_input="101110" then
					p2_tmp:=p2_tmp+8;
					ena2<='0';
				elsif p2_input="001000" or p2_input="010101" or p2_input="100010" or p2_input="101111" then
					p2_tmp:=p2_tmp+9;
					ena2<='0';
				else
					ena2<='0';
					if p2a="10" then
						p2_tmp:=12;
					else
						p2_tmp:=p2_tmp+10;
					end if;								
				end if;
				p2_input_sum<=conv_std_logic_vector(p2_tmp,5);
			elsif d_cnt="00" or d_cnt="01" then
				en<='1';
				en1<='0';
				en2<='0';
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
					ena3<='0';
					if da="10" then
						d_tmp:=12;
					else
						d_tmp:=d_tmp+10;
					end if;								
				end if;
				p1_input_sum<=conv_std_logic_vector(d_tmp,5);
			else
				en<='0';
				en1<='0';
				en2<='0';
				en3<='0';
			end if;			
		elsif state="01" then
			if hit='1' then
				en<='1';
				en1<='1';
				en2<='0';
				en3<='0';
				p1_input<=sel_card(cnt_tmp);
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
					p1_input_sum<=conv_std_logic_vector(21,5);
					p1_finish<='1';
				elsif p1_tmp<21 then
					if p1_input="000000" or p1_input="001101" or p1_input="011010" or p1_input="100111" then
						if p1_tmp<=11 then
							p1_tmp:=p1_tmp+10;
							p1_input_sum<=conv_std_logic_vector(p1_tmp,5);
						else
							p1_tmp:=p1_tmp;
							p1_input_sum<=conv_std_logic_vector(p1_tmp,5);
						end if;
					else
						p1_input_sum<=conv_std_logic_vector(p1_tmp,5);
					end if;
				elsif p1_tmp>21 then
					p1_input_sum<=conv_std_logic_vector(0,5);
					p1_finish<='1';
				end if;
			elsif stand='1' then
				en<='0';
				en1<='0';
				en2<='0';
				en3<='0';
				p1_finish<='1';
			end if;
		elsif state="10" then
			if hit='1' then
				en<='1';
				en1<='0';
				en2<='1';
				en3<='0';
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
					p2_input_sum<=conv_std_logic_vector(21,5);
					p2_finish<='1';
				elsif p2_tmp<21 then
					if p2_input="000000" or p2_input="001101" or p2_input="011010" or p2_input="100111" then
						if p2_tmp<=11 then
							p2_tmp:=p2_tmp+10;
							p2_input_sum<=conv_std_logic_vector(p2_tmp,5);
						else
							p2_tmp:=p2_tmp;
							p2_input_sum<=conv_std_logic_vector(p2_tmp,5);
						end if;
					else
						p2_input_sum<=conv_std_logic_vector(p2_tmp,5);
					end if;
				elsif p2_tmp>21 then
					p2_input_sum<=conv_std_logic_vector(0,5);
					p2_finish<='1';
				end if;			
			elsif stand='1' then
				en<='0';
				en1<='0';
				en2<='0';
				en3<='0';
				p2_finish<='1';
			end if;	
		elsif state="11" then
				d_tmp:=conv_integer(d_output_sum);
				if d_tmp>=17 then
					d_stand<='1';
				else
					en<='1';
					en1<='0';
					en2<='0';
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
					d_input_sum<=conv_std_logic_vector(21,5);
					d_finish<='1';
					elsif d_tmp<21 then
						if d_input="000000" or d_input="001101" or d_input="011010" or d_input="100111" then
							if d_tmp<=11 then
								d_tmp:=d_tmp+10;
								d_input_sum<=conv_std_logic_vector(d_tmp,5);
							else
								d_tmp:=d_tmp;
								d_input_sum<=conv_std_logic_vector(d_tmp,5);
							end if;
						else
							d_input_sum<=conv_std_logic_vector(d_tmp,5);
						end if;
					elsif d_tmp>21 then
						d_input_sum<=conv_std_logic_vector(0,5);
						d_finish<='1';
					end if;					
				end if;
		end if;
	end process;

	process(p1_output_sum,p2_output_sum,d_output_sum)
		variable p1_tmp : integer range 0 to 30;
		variable p2_tmp : integer range 0 to 30;
		variable d_tmp : integer range 0 to 30;
	begin
		p1_tmp:=conv_integer(p1_output_sum);	
		p2_tmp:=conv_integer(p2_output_sum);
		d_tmp:=conv_integer(d_output_sum);
		if p1_tmp=21 then
			p1_win<="10";
		elsif p1_tmp>d_tmp or p1_tmp=d_tmp then
			p1_win<="01";
		elsif p1_tmp<d_tmp then
			p1_win<="00";
		end if;
		if p2_tmp=21 then
			p2_win<="10";
		elsif p2_tmp>d_tmp or p2_tmp=d_tmp then
			p2_win<="01";
		elsif p2_tmp<d_tmp then
			p2_win<="00";
		end if;		
	end process;

	p1_card0<=p1_set(0);
	p1_card1<=p1_set(1);
	p1_card2<=p1_set(2);
	p1_card3<=p1_set(3);
	p1_card4<=p1_set(4);
	p1_card5<=p1_set(5);
	p1_card6<=p1_set(6);
	p1_card7<=p1_set(7);
	p1_card8<=p1_set(8);

	p2_card0<=p2_set(0);
	p2_card1<=p2_set(1);
	p2_card2<=p2_set(2);
	p2_card3<=p2_set(3);
	p2_card4<=p2_set(4);
	p2_card5<=p2_set(5);
	p2_card6<=p2_set(6);
	p2_card7<=p2_set(7);
	p2_card8<=p2_set(8);
	
	d_card0<=d_set(0);
	d_card1<=d_set(1);
	d_card2<=d_set(2);
	d_card3<=d_set(3);
	d_card4<=d_set(4);
	d_card5<=d_set(5);
	d_card6<=d_set(6);
	d_card7<=d_set(7);
	d_card8<=d_set(8);	

end Behavioral;

