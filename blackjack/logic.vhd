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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity logic is
	port (clk, rst, hit, stand : in std_logic;
			state : in std_logic_vector(1 downto 0);		
			p1_fail, p2_fail, d_fail, d_stand : out std_logic
			);
end logic;

architecture Behavioral of logic is

component LFSR is
	port(clk,rst,en : in std_logic;
		  cnt : out std_logic_vector(1 downto 0)
		  );	
end component;

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

component status_reg is
	port(input : in STD_LOGIC_VECTOR(51 downto 0);
		  clk, reset, en : in STD_LOGIC;
		  output : out STD_LOGIC_VECTOR(51 downto 0));
end component;

constant card_num : integer:=52;

signal p1_result : std_logic;
signal p2_result : std_logic;
signal lf0_result : std_logic_vector(1 downto 0);
signal lf1_result : std_logic_vector(1 downto 0);
signal lf2_result : std_logic_vector(1 downto 0);
signal status_output : std_logic_vector(51 downto 0);
signal status_input : std_logic_vector(51 downto 0);

begin
	LF0 : LFSR port map(clk=>clk,rst=>rst,en=>hit,cnt=>lf0_result);
	LF1 : LFSR port map(clk=>clk,rst=>rst,en=>hit,cnt=>lf1_result);
	LF2 : LFSR port map(clk=>clk,rst=>rst,en=>hit,cnt=>lf2_result);
--	CR1 : card_reg_set port map(rst=>rst,clk=>hit,
--	CR2 : card_reg_set port map(rst=>rst,clk=>hit,
--	CRD : card_reg_set port map(rst=>rst,clk=>hit,
	SR : status_reg port map(clk=>clk,reset=>rst,en=>'1',input=>status_input,output=>status_output);
	
	--초기 카드 분배
	process(state,lf0_result,lf1_result,lf2_result)
	begin
		if state="00" then
			if	lf1_result="11" then
				if lf0_result="00" then					
					status_input<=status_output or x"80000000000";
				elsif lf0_result="01" then
					status_input<=status_output or x"4000000";
				elsif lf0_result="01" then
					status_input<=status_output or x"2000";
				elsif lf0_result="01" then
					status_input<=status_output or x"1";
				end if;
			elsif lf1_result="00" then
				if lf0_result="00" then
					if lf2_result="00" then
					elsif lf2_result="01" then
					elsif lf2_result="10" then
					elsif lf2_result="11" then
					end if;
				elsif lf0_result="01" then
					if lf2_result="00" then
					elsif lf2_result="01" then
					elsif lf2_result="10" then
					elsif lf2_result="11" then
					end if;				
				elsif lf0_result="01" then
					if lf2_result="00" then
					elsif lf2_result="01" then
					elsif lf2_result="10" then
					elsif lf2_result="11" then
					end if;								
				elsif lf0_result="01" then
					if lf2_result="00" then
					elsif lf2_result="01" then
					elsif lf2_result="10" then
					elsif lf2_result="11" then
					end if;				
				end if;
			end if;
		end if;
	end process;
	
	--카드를 분배하고 합 결정
--	process(state,hit,stand)
--	begin
--		if state="01" then
--			if hit='1' then
--				--get card
--			elsif stand='1' then
--				
--			end if;
--		elsif state="10" then
--			if hit='1' then
--				--get card			
--			elsif stand='1' then
--			
--			end if;		
--		elsif state="11" then
--		
--		end if;
--	end process;
	
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

