----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:37:32 05/31/2018 
-- Design Name: 
-- Module Name:    LCD - Behavioral 
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

entity LCD is
	Port ( 
				CLK, RSTB : in std_logic;
				data_in, data_in2, data_in3, data_in4, data_in5, data_in6, data_in7, data_in8, data_in9, data_in10,
				data_in11, data_in12, data_in13, data_in14, data_in15, data_in16, data_in17, data_in18,data_in19,data_in20,
				data_in21,data_in22,data_in23,data_in24,data_in25,data_in26,data_in27,data_in28,data_in29,data_in30: in  STD_LOGIC_VECTOR (7 downto 0);
				data_addr, data_addr2, data_addr3, data_addr4, data_addr5, data_addr6, data_addr7, data_addr8, data_addr9,data_addr10,
				data_addr11, data_addr12, data_addr13, data_addr14, data_addr15, data_addr16, data_addr17, data_addr18,data_addr19, 
				data_addr20,data_addr21,data_addr22,data_addr23,data_addr24,data_addr25, data_addr26,data_addr27,data_addr28,
				data_addr29, data_addr30 : out  STD_LOGIC_VECTOR (7 downto 0);
				data_out : out  STD_LOGIC_VECTOR (15 downto 0);
				p1_c1, p1_c2, p1_c3 ,p1_c4 ,p1_c5, p1_c6 : in std_logic_vector(5 downto 0);
				p2_c1, p2_c2, p2_c3 ,p2_c4 ,p2_c5, p2_c6 : in std_logic_vector(5 downto 0);
				d_c1, d_c2, d_c3 ,d_c4 ,d_c5, d_c6 : in std_logic_vector(5 downto 0);
				de : out std_logic
				);
end LCD;

architecture Behavioral of LCD is

constant tHP : integer := 1056; --Hsync Period
constant tHW  : integer := 1;   -- Hsync Pulse Width
constant tHBP : integer := 45;   -- Hsync Back Porch
constant tHV  : integer := 800;   -- Horizontal valid data width
constant tHFP : integer := (tHP-tHW-tHBP-tHV);   -- Horizontal Front Port
constant tVP  : integer := 635;   -- Vsync Period
constant tVW  : integer := 1;   -- Vsync Pulse Width
constant tVBP : integer := 22;   -- Vsync Back Portch
constant tW   : integer := 480;   -- Vertical valid data width
constant tVFP : integer := (tVP-tVW-tVBP-tW);   -- Vertical Front Porch

signal hsync_cnt  : integer range 0 to (tHP+tHW);
signal vsync_cnt  : integer range 0 to tVP;

signal de_i: std_logic;

signal rgb_data : std_logic_vector(15 downto 0);
type r_set is array(29 downto 0) of std_logic_vector(4 downto 0);
signal r_data : r_set;
type g_set is array(29 downto 0) of std_logic_vector(5 downto 0);
signal g_data : g_set;
type b_set is array(29 downto 0) of std_logic_vector(4 downto 0);
signal b_data : b_set;
type addr_set is array(29 downto 0) of std_logic_vector(7 downto 0);
signal addrcnt : addr_set;

begin
process(CLK, RSTB)         --  sync 계산
   begin
      if(RSTB = '0')then
         hsync_cnt<= 0;
         vsync_cnt<= 0;
      elsif(rising_edge(CLK)) then
         if(hsync_cnt=tHP)then
            hsync_cnt<=0;
         else
            hsync_cnt<= hsync_cnt + 1;
         end if;
         if(hsync_cnt=tHP)then
            if(vsync_cnt=tVP)then
               vsync_cnt<=0;
            else
               vsync_cnt<=vsync_cnt + 1;
            end if;
         end if;
      end if;   
end process;

process(CLK, RSTB,vsync_cnt,hsync_cnt)         --Data Enable
   begin
      if(RSTB = '0')then
         de_i<='0';
      elsif(rising_edge(CLK)) then
         if ((vsync_cnt >= (tVW + tVBP)) and (vsync_cnt <= (tVW + tVBP + tW ))) then
            if(hsync_cnt=(tHBP)) then
               de_i<='1';
            elsif(hsync_cnt=(tHV+tHBP)) then
               de_i<='0';
            else
               de_i<=de_i;
            end if;
         else
            de_i<='0';
         end if;
      end if;
 end process;
process(data_in)
	begin
		if data_in = "11111111" then
			b_data(0) <= data_in(7 downto 5) & "11";
			g_data(0) <= data_in(4 downto 2) & "111";
			r_data(0) <= data_in(1 downto 0) & "111";
		else
			b_data(0) <= data_in(7 downto 5) & "00";
			g_data(0) <= data_in(4 downto 2) & "000";
			r_data(0) <= data_in(1 downto 0) & "000";
		end if;
end process;
process(data_in2)
	begin
		if data_in2 = "11111111" then
			b_data(1) <= data_in2(7 downto 5) & "11";
			g_data(1) <= data_in2(4 downto 2) & "111";
			r_data(1) <= data_in2(1 downto 0) & "111";
		else
			b_data(1) <= data_in2(7 downto 5) & "00";
			g_data(1) <= data_in2(4 downto 2) & "000";
			r_data(1) <= data_in2(1 downto 0) & "000";
		end if;
end process;
process(data_in3)
	begin
		if data_in3 = "11111111" then
			b_data(2) <= data_in3(7 downto 5) & "11";
			g_data(2) <= data_in3(4 downto 2) & "111";
			r_data(2) <= data_in3(1 downto 0) & "111";
		else
			b_data(2) <= data_in3(7 downto 5) & "00";
			g_data(2) <= data_in3(4 downto 2) & "000";
			r_data(2) <= data_in3(1 downto 0) & "000";
		end if;
end process;
process(data_in4)
	begin
		if data_in4 = "11111111" then
			b_data(3) <= data_in4(7 downto 5) & "11";
			g_data(3) <= data_in4(4 downto 2) & "111";
			r_data(3) <= data_in4(1 downto 0) & "111";
		else
			b_data(3) <= data_in4(7 downto 5) & "00";
			g_data(3) <= data_in4(4 downto 2) & "000";
			r_data(3) <= data_in4(1 downto 0) & "000";
		end if;
end process;
process(data_in5)
	begin
		if data_in5 = "11111111" then
			b_data(4) <= data_in5(7 downto 5) & "11";
			g_data(4) <= data_in5(4 downto 2) & "111";
			r_data(4) <= data_in5(1 downto 0) & "111";
		else
			b_data(4) <= data_in5(7 downto 5) & "00";
			g_data(4) <= data_in5(4 downto 2) & "000";
			r_data(4) <= data_in5(1 downto 0) & "000";
		end if;
end process;
process(data_in6)
	begin
		if data_in6 = "11111111" then
			b_data(5) <= data_in6(7 downto 5) & "11";
			g_data(5) <= data_in6(4 downto 2) & "111";
			r_data(5) <= data_in6(1 downto 0) & "111";
		else
			b_data(5) <= data_in6(7 downto 5) & "00";
			g_data(5) <= data_in6(4 downto 2) & "000";
			r_data(5) <= data_in6(1 downto 0) & "000";
		end if;
end process;
process(data_in7)
	begin
		if data_in7 = "11111111" then
			b_data(6) <= data_in7(7 downto 5) & "11";
			g_data(6) <= data_in7(4 downto 2) & "111";
			r_data(6) <= data_in7(1 downto 0) & "111";
		else
			b_data(6) <= data_in7(7 downto 5) & "00";
			g_data(6) <= data_in7(4 downto 2) & "000";
			r_data(6) <= data_in7(1 downto 0) & "000";
		end if;
end process;
process(data_in8)
	begin
		if data_in8 = "11111111" then
			b_data(7) <= data_in8(7 downto 5) & "11";
			g_data(7) <= data_in8(4 downto 2) & "111";
			r_data(7) <= data_in8(1 downto 0) & "111";
		else
			b_data(7) <= data_in8(7 downto 5) & "00";
			g_data(7) <= data_in8(4 downto 2) & "000";
			r_data(7) <= data_in8(1 downto 0) & "000";
		end if;
end process;
process(data_in9)
	begin
		if data_in9 = "11111111" then
			b_data(8) <= data_in9(7 downto 5) & "11";
			g_data(8) <= data_in9(4 downto 2) & "111";
			r_data(8) <= data_in9(1 downto 0) & "111";
		else
			b_data(8) <= data_in9(7 downto 5) & "00";
			g_data(8) <= data_in9(4 downto 2) & "000";
			r_data(8) <= data_in9(1 downto 0) & "000";
		end if;
end process;
process(data_in10)
	begin
		if data_in10 = "11111111" then
			b_data(9) <= data_in10(7 downto 5) & "11";
			g_data(9) <= data_in10(4 downto 2) & "111";
			r_data(9) <= data_in10(1 downto 0) & "111";
		else
			b_data(9) <= data_in10(7 downto 5) & "00";
			g_data(9) <= data_in10(4 downto 2) & "000";
			r_data(9) <= data_in10(1 downto 0) & "000";
		end if;
end process;
process(data_in11)
	begin
		if data_in11 = "11111111" then
			b_data(10) <= data_in11(7 downto 5) & "11";
			g_data(10) <= data_in11(4 downto 2) & "111";
			r_data(10) <= data_in11(1 downto 0) & "111";
		else
			b_data(10) <= data_in11(7 downto 5) & "00";
			g_data(10) <= data_in11(4 downto 2) & "000";
			r_data(10) <= data_in11(1 downto 0) & "000";
		end if;
end process;
process(data_in12)
	begin
		if data_in12 = "11111111" then
			b_data(11) <= data_in12(7 downto 5) & "11";
			g_data(11) <= data_in12(4 downto 2) & "111";
			r_data(11) <= data_in12(1 downto 0) & "111";
		else
			b_data(11) <= data_in12(7 downto 5) & "00";
			g_data(11) <= data_in12(4 downto 2) & "000";
			r_data(11) <= data_in12(1 downto 0) & "000";
		end if;
end process;
process(data_in13)
	begin
		if data_in13 = "11111111" then
			b_data(12) <= data_in13(7 downto 5) & "11";
			g_data(12) <= data_in13(4 downto 2) & "111";
			r_data(12) <= data_in13(1 downto 0) & "111";
		else
			b_data(12) <= data_in13(7 downto 5) & "00";
			g_data(12) <= data_in13(4 downto 2) & "000";
			r_data(12) <= data_in13(1 downto 0) & "000";
		end if;
end process;
process(data_in14)
	begin
		if data_in14 = "11111111" then
			b_data(13) <= data_in14(7 downto 5) & "11";
			g_data(13) <= data_in14(4 downto 2) & "111";
			r_data(13) <= data_in14(1 downto 0) & "111";
		elsif data_in14 = "00000011" then
			b_data(13) <= data_in14(7 downto 5) & "00";
			g_data(13) <= data_in14(4 downto 2) & "000";
			r_data(13) <= data_in14(1 downto 0) & "111";
		else
			b_data(13) <= data_in14(7 downto 5) & "00";
			g_data(13) <= data_in14(4 downto 2) & "000";
			r_data(13) <= data_in14(1 downto 0) & "000";
		end if;
end process;
process(data_in15)
	begin
		if data_in15 = "11111111" then
			b_data(14) <= data_in15(7 downto 5) & "11";
			g_data(14) <= data_in15(4 downto 2) & "111";
			r_data(14) <= data_in15(1 downto 0) & "111";
		elsif data_in15 = "00000011" then
			b_data(14) <= data_in15(7 downto 5) & "00";
			g_data(14) <= data_in15(4 downto 2) & "000";
			r_data(14) <= data_in15(1 downto 0) & "111";
		else
			b_data(14) <= data_in15(7 downto 5) & "00";
			g_data(14) <= data_in15(4 downto 2) & "000";
			r_data(14) <= data_in15(1 downto 0) & "000";
		end if;
end process;
process(data_in16)
	begin
		if data_in16 = "11111111" then
			b_data(15) <= data_in16(7 downto 5) & "11";
			g_data(15) <= data_in16(4 downto 2) & "111";
			r_data(15) <= data_in16(1 downto 0) & "111";
		elsif data_in16 = "00000011" then
			b_data(15) <= data_in16(7 downto 5) & "00";
			g_data(15) <= data_in16(4 downto 2) & "000";
			r_data(15) <= data_in16(1 downto 0) & "111";
		else
			b_data(15) <= data_in16(7 downto 5) & "00";
			g_data(15) <= data_in16(4 downto 2) & "000";
			r_data(15) <= data_in16(1 downto 0) & "000";
		end if;
end process;
process(data_in17)
	begin
		if data_in17 = "11111111" then
			b_data(16) <= data_in17(7 downto 5) & "11";
			g_data(16) <= data_in17(4 downto 2) & "111";
			r_data(16) <= data_in17(1 downto 0) & "111";
		elsif data_in17 = "00000011" then
			b_data(16) <= data_in17(7 downto 5) & "00";
			g_data(16) <= data_in17(4 downto 2) & "000";
			r_data(16) <= data_in17(1 downto 0) & "111";
		else
			b_data(16) <= data_in17(7 downto 5) & "00";
			g_data(16) <= data_in17(4 downto 2) & "000";
			r_data(16) <= data_in17(1 downto 0) & "000";
		end if;
end process;
process(data_in18)
	begin
		if data_in18 = "11111111" then
			b_data(17) <= data_in18(7 downto 5) & "11";
			g_data(17) <= data_in18(4 downto 2) & "111";
			r_data(17) <= data_in18(1 downto 0) & "111";
		elsif data_in18 = "00000011" then
			b_data(17) <= data_in18(7 downto 5) & "00";
			g_data(17) <= data_in18(4 downto 2) & "000";
			r_data(17) <= data_in18(1 downto 0) & "111";
		else
			b_data(17) <= data_in18(7 downto 5) & "00";
			g_data(17) <= data_in18(4 downto 2) & "000";
			r_data(17) <= data_in18(1 downto 0) & "000";
		end if;
end process;
process(data_in19)
	begin
		if data_in19 = "11111111" then
			b_data(18) <= data_in19(7 downto 5) & "11";
			g_data(18) <= data_in19(4 downto 2) & "111";
			r_data(18) <= data_in19(1 downto 0) & "111";
		elsif data_in19 = "00000011" then
			b_data(18) <= data_in19(7 downto 5) & "00";
			g_data(18) <= data_in19(4 downto 2) & "000";
			r_data(18) <= data_in19(1 downto 0) & "111";
		else
			b_data(18) <= data_in19(7 downto 5) & "00";
			g_data(18) <= data_in19(4 downto 2) & "000";
			r_data(18) <= data_in19(1 downto 0) & "000";
		end if;
end process;
process(data_in20)
	begin
		if data_in20 = "11111111" then
			b_data(19) <= data_in20(7 downto 5) & "11";
			g_data(19) <= data_in20(4 downto 2) & "111";
			r_data(19) <= data_in20(1 downto 0) & "111";
		elsif data_in20 = "00000011" then
			b_data(19) <= data_in20(7 downto 5) & "00";
			g_data(19) <= data_in20(4 downto 2) & "000";
			r_data(19) <= data_in20(1 downto 0) & "111";
		else
			b_data(19) <= data_in20(7 downto 5) & "00";
			g_data(19) <= data_in20(4 downto 2) & "000";
			r_data(19) <= data_in20(1 downto 0) & "000";
		end if;
end process;
process(data_in21)
	begin
		if data_in21 = "11111111" then
			b_data(20) <= data_in21(7 downto 5) & "11";
			g_data(20) <= data_in21(4 downto 2) & "111";
			r_data(20) <= data_in21(1 downto 0) & "111";
		elsif data_in21 = "00000011" then
			b_data(20) <= data_in21(7 downto 5) & "00";
			g_data(20) <= data_in21(4 downto 2) & "000";
			r_data(20) <= data_in21(1 downto 0) & "111";
		else
			b_data(20) <= data_in21(7 downto 5) & "00";
			g_data(20) <= data_in21(4 downto 2) & "000";
			r_data(20) <= data_in21(1 downto 0) & "000";
		end if;
end process;
process(data_in22)
	begin
		if data_in22 = "11111111" then
			b_data(21) <= data_in22(7 downto 5) & "11";
			g_data(21) <= data_in22(4 downto 2) & "111";
			r_data(21) <= data_in22(1 downto 0) & "111";
		elsif data_in22 = "00000011" then
			b_data(21) <= data_in22(7 downto 5) & "00";
			g_data(21) <= data_in22(4 downto 2) & "000";
			r_data(21) <= data_in22(1 downto 0) & "111";
		else
			b_data(21) <= data_in22(7 downto 5) & "00";
			g_data(21) <= data_in22(4 downto 2) & "000";
			r_data(21) <= data_in22(1 downto 0) & "000";
		end if;
end process;
process(data_in23)
	begin
		if data_in23 = "11111111" then
			b_data(22) <= data_in23(7 downto 5) & "11";
			g_data(22) <= data_in23(4 downto 2) & "111";
			r_data(22) <= data_in23(1 downto 0) & "111";
		elsif data_in23 = "00000011" then
			b_data(22) <= data_in23(7 downto 5) & "00";
			g_data(22) <= data_in23(4 downto 2) & "000";
			r_data(22) <= data_in23(1 downto 0) & "111";
		else
			b_data(22) <= data_in23(7 downto 5) & "00";
			g_data(22) <= data_in23(4 downto 2) & "000";
			r_data(22) <= data_in23(1 downto 0) & "000";
		end if;
end process;
process(data_in24)
	begin
		if data_in24 = "11111111" then
			b_data(23) <= data_in24(7 downto 5) & "11";
			g_data(23) <= data_in24(4 downto 2) & "111";
			r_data(23) <= data_in24(1 downto 0) & "111";
		elsif data_in24 = "00000011" then
			b_data(23) <= data_in24(7 downto 5) & "00";
			g_data(23) <= data_in24(4 downto 2) & "000";
			r_data(23) <= data_in24(1 downto 0) & "111";
		else
			b_data(23) <= data_in24(7 downto 5) & "00";
			g_data(23) <= data_in24(4 downto 2) & "000";
			r_data(23) <= data_in24(1 downto 0) & "000";
		end if;
end process;
process(data_in25)
	begin
		if data_in25 = "11111111" then
			b_data(24) <= data_in25(7 downto 5) & "11";
			g_data(24) <= data_in25(4 downto 2) & "111";
			r_data(24) <= data_in25(1 downto 0) & "111";
		elsif data_in25 = "00000011" then
			b_data(24) <= data_in25(7 downto 5) & "00";
			g_data(24) <= data_in25(4 downto 2) & "000";
			r_data(24) <= data_in25(1 downto 0) & "111";
		else
			b_data(24) <= data_in25(7 downto 5) & "00";
			g_data(24) <= data_in25(4 downto 2) & "000";
			r_data(24) <= data_in25(1 downto 0) & "000";
		end if;
end process;
process(data_in26)
	begin
		if data_in26 = "11111111" then
			b_data(25) <= data_in26(7 downto 5) & "11";
			g_data(25) <= data_in26(4 downto 2) & "111";
			r_data(25) <= data_in26(1 downto 0) & "111";
		elsif data_in26 = "00000011" then
			b_data(25) <= data_in26(7 downto 5) & "00";
			g_data(25) <= data_in26(4 downto 2) & "000";
			r_data(25) <= data_in26(1 downto 0) & "111";
		else
			b_data(25) <= data_in26(7 downto 5) & "00";
			g_data(25) <= data_in26(4 downto 2) & "000";
			r_data(25) <= data_in26(1 downto 0) & "000";
		end if;
end process;
process(data_in27)
	begin
		if data_in27 = "11111111" then
			b_data(26) <= data_in27(7 downto 5) & "11";
			g_data(26) <= data_in27(4 downto 2) & "111";
			r_data(26) <= data_in27(1 downto 0) & "111";
		else
			b_data(26) <= data_in27(7 downto 5) & "00";
			g_data(26) <= data_in27(4 downto 2) & "000";
			r_data(26) <= data_in27(1 downto 0) & "000";
		end if;
end process;
process(data_in28)
	begin
		if data_in28 = "11111111" then
			b_data(27) <= data_in28(7 downto 5) & "11";
			g_data(27) <= data_in28(4 downto 2) & "111";
			r_data(27) <= data_in28(1 downto 0) & "111";
		else
			b_data(27) <= data_in28(7 downto 5) & "00";
			g_data(27) <= data_in28(4 downto 2) & "000";
			r_data(27) <= data_in28(1 downto 0) & "000";
		end if;
end process;
process(data_in29)
	begin
		if data_in29 = "11111111" then
			b_data(28) <= data_in29(7 downto 5) & "11";
			g_data(28) <= data_in29(4 downto 2) & "111";
			r_data(28) <= data_in29(1 downto 0) & "111";
		elsif data_in29 = "00000011" then
			b_data(28) <= data_in29(7 downto 5) & "00";
			g_data(28) <= data_in29(4 downto 2) & "000";
			r_data(28) <= data_in29(1 downto 0) & "111";
		else
			b_data(28) <= data_in29(7 downto 5) & "00";
			g_data(28) <= data_in29(4 downto 2) & "000";
			r_data(28) <= data_in29(1 downto 0) & "000";
		end if;
end process;
process(data_in30)
	begin
		if data_in30 = "11111111" then
			b_data(29) <= data_in30(7 downto 5) & "11";
			g_data(29) <= data_in30(4 downto 2) & "111";
			r_data(29) <= data_in30(1 downto 0) & "111";
		elsif data_in30 = "00000011" then
			b_data(29) <= data_in30(7 downto 5) & "00";
			g_data(29) <= data_in30(4 downto 2) & "000";
			r_data(29) <= data_in30(1 downto 0) & "111";
		else
			b_data(29) <= data_in30(7 downto 5) & "00";
			g_data(29) <= data_in30(4 downto 2) & "000";
			r_data(29) <= data_in30(1 downto 0) & "000";
		end if;
end process;

 process(CLK, RSTB, vsync_cnt, hsync_cnt)         --출력할 이미지. R,G,B가 화면상에 번갈아 출력
   begin
      if (RSTB='0')then
			rgb_data <= (others => '0');
			addrcnt(0)<= (others => '0');
			addrcnt(1)<= (others => '0');
			addrcnt(2)<= (others => '0');
			addrcnt(3)<= (others => '0');
			addrcnt(4)<= (others => '0');
			addrcnt(5)<= (others => '0');
			addrcnt(6)<= (others => '0');
			addrcnt(7)<= (others => '0');
			addrcnt(8)<= (others => '0');
			addrcnt(9)<= (others => '0');
			addrcnt(10)<= (others => '0');
			addrcnt(11)<= (others => '0');
			addrcnt(12)<= (others => '0');
			addrcnt(13)<= (others => '0');
			addrcnt(14)<= (others => '0');
			addrcnt(15)<= (others => '0');
			addrcnt(16)<= (others => '0');
			addrcnt(17)<= (others => '0');
			addrcnt(18)<= (others => '0');
			addrcnt(19)<= (others => '0');
			addrcnt(20)<= (others => '0');
			addrcnt(21)<= (others => '0');
			addrcnt(22)<= (others => '0');
			addrcnt(23)<= (others => '0');
			addrcnt(24)<= (others => '0');
			addrcnt(25)<= (others => '0');
			addrcnt(26)<= (others => '0');
			addrcnt(27)<= (others => '0');
			addrcnt(28)<= (others => '0');
			addrcnt(29)<= (others => '0');
      elsif (rising_edge(CLK)) then
			if vsync_cnt = 0 then
				addrcnt(0)<= (others => '0');
				addrcnt(1)<= (others => '0');
				addrcnt(2)<= (others => '0');
				addrcnt(3)<= (others => '0');
				addrcnt(4)<= (others => '0');
				addrcnt(5)<= (others => '0');
				addrcnt(6)<= (others => '0');
				addrcnt(7)<= (others => '0');
				addrcnt(8)<= (others => '0');
				addrcnt(9)<= (others => '0');
				addrcnt(10)<= (others => '0');
				addrcnt(11)<= (others => '0');
				addrcnt(12)<= (others => '0');
				addrcnt(13)<= (others => '0');
				addrcnt(14)<= (others => '0');
				addrcnt(15)<= (others => '0');
				addrcnt(16)<= (others => '0');
				addrcnt(17)<= (others => '0');
				addrcnt(18)<= (others => '0');
				addrcnt(19)<= (others => '0');
				addrcnt(20)<= (others => '0');
				addrcnt(21)<= (others => '0');
				addrcnt(22)<= (others => '0');
				addrcnt(23)<= (others => '0');
				addrcnt(24)<= (others => '0');
				addrcnt(25)<= (others => '0');
				addrcnt(26)<= (others => '0');
				addrcnt(27)<= (others => '0');
				addrcnt(28)<= (others => '0');
				addrcnt(29)<= (others => '0');
			elsif ( ( vsync_cnt >= (tVW + tVBP-1 ) ) and ( vsync_cnt <= (tVW + tVBP + 51) ) )then 
				rgb_data <= "00000" & "001110" & "00000";
			elsif ( ( vsync_cnt >= (tVW + tVBP +52 ) ) and ( vsync_cnt <= (tVW + tVBP + 66) ) )then 
				if ((hsync_cnt >= (tHW + tHBP +100 ) ) and ( hsync_cnt <= (tHW + tHBP +110)) ) then
					if (d_c1 >= "000000" )and (d_c1 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
						if addrcnt(26) = x"a4" then
							addrcnt(26) <= (others => '0');
						end if;
					elsif (d_c1 >= "001101" )and (d_c1 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
					elsif (d_c1 >= "011010" )and (d_c1 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
					elsif (d_c1 >= "100111" )and (d_c1 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +111 ) ) and ( hsync_cnt <= (tHW + tHBP +160)) ) then
					rgb_data <= (others => '1');
				else
					rgb_data <= "00000" & "001110" & "00000";
				end if;
			elsif ( ( vsync_cnt >= (tVW + tVBP +67 ) ) and ( vsync_cnt <= (tVW + tVBP + 68) ) )then 
				if ((hsync_cnt >= (tHW + tHBP +100 ) ) and ( hsync_cnt <= (tHW + tHBP +110)) ) then
					rgb_data <= (others => '1');
				elsif ((hsync_cnt >= (tHW + tHBP +111 ) ) and ( hsync_cnt <= (tHW + tHBP +160)) ) then
					rgb_data <= (others => '1');
				else
					rgb_data <= "00000" & "001110" & "00000";
				end if;
			elsif ( ( vsync_cnt >= (tVW + tVBP +69 ) ) and ( vsync_cnt <= (tVW + tVBP + 83) ) )then 
				if ((hsync_cnt >= (tHW + tHBP +100 ) ) and ( hsync_cnt <= (tHW + tHBP +110)) ) then
					if (d_c1 = "000000" )or (d_c1 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
						if addrcnt(0) = x"a4" then
							addrcnt(0) <= (others => '0');
						end if;
					elsif (d_c1 = "000001" )or (d_c1 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
					elsif (d_c1 = "000010" )or (d_c1 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
					elsif (d_c1 = "000011" )or (d_c1 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
					elsif (d_c1 = "000100" )or (d_c1 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);
					elsif (d_c1 = "000101" )or (d_c1 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);
					elsif (d_c1 = "000110" )or (d_c1 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);
					elsif (d_c1 = "000111" )or (d_c1 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);
					elsif (d_c1 = "001000" )or (d_c1 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
					elsif (d_c1 = "001001" )or (d_c1 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);
					elsif (d_c1 = "001010" )or (d_c1 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);
					elsif (d_c1 = "001011" )or (d_c1 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);
					elsif (d_c1 = "001100" )or (d_c1 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
					elsif (d_c1 = "011010" )or (d_c1 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
					elsif (d_c1 = "011011" )or (d_c1 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
					elsif (d_c1 = "011100" )or (d_c1 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
					elsif (d_c1 = "011101" )or (d_c1 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
					elsif (d_c1 = "011110" )or (d_c1 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);
					elsif (d_c1 = "011111" )or (d_c1 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);
					elsif (d_c1 = "100000" )or (d_c1 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
					elsif (d_c1 = "100001" )or (d_c1 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
					elsif (d_c1 = "100010" )or (d_c1 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
					elsif (d_c1 = "100011" )or (d_c1 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);
					elsif (d_c1 = "100100" )or (d_c1 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
					elsif (d_c1 = "100101" )or (d_c1 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
					elsif (d_c1 = "100110" )or (d_c1 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +111 ) ) and ( hsync_cnt <= (tHW + tHBP +160)) ) then
					rgb_data <= (others => '1');
				else
					rgb_data <= "00000" & "001110" & "00000";
				end if;
			elsif ( ( vsync_cnt >= (tVW + tVBP +84 ) ) and ( vsync_cnt <= (tVW + tVBP + 153) ) )then 
				if ((hsync_cnt >= (tHW + tHBP +100 ) ) and ( hsync_cnt <= (tHW + tHBP +160)) ) then
					rgb_data <= (others => '1');
				else
					rgb_data <= "00000" & "001110" & "00000";
				end if;
			elsif ( ( vsync_cnt >= (tVW + tVBP +154 ) ) and ( vsync_cnt <= (tVW + tVBP + 238) ) )then 
				rgb_data <= "00000" & "001110" & "00000";
			elsif ( ( vsync_cnt >= (tVW + tVBP+239 ) ) and ( vsync_cnt <= (tVW + tVBP + 240) ) )then --가운데 가로 줄
				rgb_data <= (others => '1');
			elsif ( ( vsync_cnt >= (tVW + tVBP+241 ) ) and ( vsync_cnt <= (tVW + tVBP + 289) ) )then 
				if( (hsync_cnt >= (tHW + tHBP +399 ) ) and ( hsync_cnt <= (tHW + tHBP +400)) ) then --가운데 세로줄
					rgb_data <= (others => '1');
				else
					rgb_data <= "00000" & "001110" & "00000";
				end if;
			elsif (( vsync_cnt >= (tVW + tVBP + 290) ) and ( vsync_cnt <= (tVW + tVBP + 304) ) ) then --플레이어 문양
				if ((hsync_cnt >= (tHW + tHBP +100 ) ) and ( hsync_cnt <= (tHW + tHBP +110)) ) then -- p1
					if (p1_c1 >= "000000" )and (p1_c1 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
						if(((p1_c2 >= "000000" )and (p1_c2 <= "001100")) or ((p1_c3 >= "000000" )and (p1_c3 <= "001100")) or ((p1_c4 >= "000000" )and (p1_c4 <= "001100"))
						or ((p1_c5 >= "000000" )and (p1_c5 <= "001100"))or ((p1_c6 >= "000000" )and (p1_c6 <= "001100"))or ((p2_c1 >= "000000" )and (p2_c1 <= "001100"))
						or ((p2_c2 >= "000000" )and (p2_c2 <= "001100"))) then
							if addrcnt(26) = x"0a" then
								addrcnt(26) <= (others => '0');
							elsif addrcnt(26) = x"15" then
								addrcnt(26) <= x"0b";
							elsif addrcnt(26) = x"20" then
								addrcnt(26) <= x"16";
							elsif addrcnt(26) = x"2b" then
								addrcnt(26) <= x"21";
							elsif addrcnt(26) = x"36" then
								addrcnt(26) <= x"2c";
							elsif addrcnt(26) = x"41" then
								addrcnt(26) <= x"37";
							elsif addrcnt(26) = x"4c" then
								addrcnt(26) <= x"42";
							elsif addrcnt(26) = x"57" then
								addrcnt(26) <= x"4d";
							elsif addrcnt(26) = x"62" then
								addrcnt(26) <= x"58";
							elsif addrcnt(26) = x"6d" then
								addrcnt(26) <= x"63";
							elsif addrcnt(26) = x"78" then
								addrcnt(26) <= x"6e";
							elsif addrcnt(26) = x"83" then
								addrcnt(26) <= x"79";
							elsif addrcnt(26) = x"8e" then
								addrcnt(26) <= x"84";
							elsif addrcnt(26) = x"99" then
								addrcnt(26) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 >= "001101" )and (p1_c1 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
						if(((p1_c2 >= "001101" )and (p1_c2 <= "011001")) or ((p1_c3 >= "001101" )and (p1_c3 <= "011001")) or ((p1_c4 >= "001101" )and (p1_c4 <= "011001"))
						or ((p1_c5 >= "001101" )and (p1_c5 <= "011001"))or ((p1_c6 >= "001101" )and (p1_c6 <= "011001"))or ((p2_c1 >= "001101" )and (p2_c1 <= "011001"))
						or ((p2_c2 >= "001101" )and (p2_c2 <= "011001"))) then
							if addrcnt(27) = x"0a" then
								addrcnt(27) <= (others => '0');
							elsif addrcnt(27) = x"15" then
								addrcnt(27) <= x"0b";
							elsif addrcnt(27) = x"20" then
								addrcnt(27) <= x"16";
							elsif addrcnt(27) = x"2b" then
								addrcnt(27) <= x"21";
							elsif addrcnt(27) = x"36" then
								addrcnt(27) <= x"2c";
							elsif addrcnt(27) = x"41" then
								addrcnt(27) <= x"37";
							elsif addrcnt(27) = x"4c" then
								addrcnt(27) <= x"42";
							elsif addrcnt(27) = x"57" then
								addrcnt(27) <= x"4d";
							elsif addrcnt(27) = x"62" then
								addrcnt(27) <= x"58";
							elsif addrcnt(27) = x"6d" then
								addrcnt(27) <= x"63";
							elsif addrcnt(27) = x"78" then
								addrcnt(27) <= x"6e";
							elsif addrcnt(27) = x"83" then
								addrcnt(27) <= x"79";
							elsif addrcnt(27) = x"8e" then
								addrcnt(27) <= x"84";
							elsif addrcnt(27) = x"99" then
								addrcnt(27) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 >= "011010" )and (p1_c1 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
						if(((p1_c2 >= "011010" )and (p1_c2 <= "100110")) or ((p1_c3 >= "011010" )and (p1_c3 <= "100110")) or ((p1_c4 >= "011010" )and (p1_c4 <= "100110"))
						or ((p1_c5 >= "011010" )and (p1_c5 <= "100110"))or ((p1_c6 >= "011010" )and (p1_c6 <= "100110"))or ((p2_c1 >= "011010" )and (p2_c1 <= "100110"))
						or ((p2_c2 >= "011010" )and (p2_c2 <= "100110"))) then
							if addrcnt(28) = x"0a" then
								addrcnt(28) <= (others => '0');
							elsif addrcnt(28) = x"15" then
								addrcnt(28) <= x"0b";
							elsif addrcnt(28) = x"20" then
								addrcnt(28) <= x"16";
							elsif addrcnt(28) = x"2b" then
								addrcnt(28) <= x"21";
							elsif addrcnt(28) = x"36" then
								addrcnt(28) <= x"2c";
							elsif addrcnt(28) = x"41" then
								addrcnt(28) <= x"37";
							elsif addrcnt(28) = x"4c" then
								addrcnt(28) <= x"42";
							elsif addrcnt(28) = x"57" then
								addrcnt(28) <= x"4d";
							elsif addrcnt(28) = x"62" then
								addrcnt(28) <= x"58";
							elsif addrcnt(28) = x"6d" then
								addrcnt(28) <= x"63";
							elsif addrcnt(28) = x"78" then
								addrcnt(28) <= x"6e";
							elsif addrcnt(28) = x"83" then
								addrcnt(28) <= x"79";
							elsif addrcnt(28) = x"8e" then
								addrcnt(28) <= x"84";
							elsif addrcnt(28) = x"99" then
								addrcnt(28) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 >= "100111" )and (p1_c1 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
						if(((p1_c2 >= "100111" )and (p1_c2 <= "110011")) or ((p1_c3 >= "100111" )and (p1_c3 <= "110011")) or ((p1_c4 >= "100111" )and (p1_c4 <= "110011"))
						or ((p1_c5 >= "100111" )and (p1_c5 <= "110011"))or ((p1_c6 >= "100111" )and (p1_c6 <= "110011"))or ((p2_c1 >= "100111" )and (p2_c1 <= "110011"))
						or ((p2_c2 >= "100111" )and (p2_c2 <= "110011"))) then
							if addrcnt(29) = x"0a" then
								addrcnt(29) <= (others => '0');
							elsif addrcnt(29) = x"15" then
								addrcnt(29) <= x"0b";
							elsif addrcnt(29) = x"20" then
								addrcnt(29) <= x"16";
							elsif addrcnt(29) = x"2b" then
								addrcnt(29) <= x"21";
							elsif addrcnt(29) = x"36" then
								addrcnt(29) <= x"2c";
							elsif addrcnt(29) = x"41" then
								addrcnt(29) <= x"37";
							elsif addrcnt(29) = x"4c" then
								addrcnt(29) <= x"42";
							elsif addrcnt(29) = x"57" then
								addrcnt(29) <= x"4d";
							elsif addrcnt(29) = x"62" then
								addrcnt(29) <= x"58";
							elsif addrcnt(29) = x"6d" then
								addrcnt(29) <= x"63";
							elsif addrcnt(29) = x"78" then
								addrcnt(29) <= x"6e";
							elsif addrcnt(29) = x"83" then
								addrcnt(29) <= x"79";
							elsif addrcnt(29) = x"8e" then
								addrcnt(29) <= x"84";
							elsif addrcnt(29) = x"99" then
								addrcnt(29) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +111 ) ) and ( hsync_cnt <= (tHW + tHBP +121)) ) then
					if (p1_c2 >= "000000" )and (p1_c2 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
						if(((p1_c3 >= "000000" )and (p1_c3 <= "001100")) or ((p1_c4 >= "000000" )and (p1_c4 <= "001100"))
						or ((p1_c5 >= "000000" )and (p1_c5 <= "001100"))or ((p1_c6 >= "000000" )and (p1_c6 <= "001100"))or ((p2_c1 >= "000000" )and (p2_c1 <= "001100"))
						or ((p2_c2 >= "000000" )and (p2_c2 <= "001100"))) then
							if addrcnt(26) = x"0a" then
								addrcnt(26) <= (others => '0');
							elsif addrcnt(26) = x"15" then
								addrcnt(26) <= x"0b";
							elsif addrcnt(26) = x"20" then
								addrcnt(26) <= x"16";
							elsif addrcnt(26) = x"2b" then
								addrcnt(26) <= x"21";
							elsif addrcnt(26) = x"36" then
								addrcnt(26) <= x"2c";
							elsif addrcnt(26) = x"41" then
								addrcnt(26) <= x"37";
							elsif addrcnt(26) = x"4c" then
								addrcnt(26) <= x"42";
							elsif addrcnt(26) = x"57" then
								addrcnt(26) <= x"4d";
							elsif addrcnt(26) = x"62" then
								addrcnt(26) <= x"58";
							elsif addrcnt(26) = x"6d" then
								addrcnt(26) <= x"63";
							elsif addrcnt(26) = x"78" then
								addrcnt(26) <= x"6e";
							elsif addrcnt(26) = x"83" then
								addrcnt(26) <= x"79";
							elsif addrcnt(26) = x"8e" then
								addrcnt(26) <= x"84";
							elsif addrcnt(26) = x"99" then
								addrcnt(26) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 >= "001101" )and (p1_c2 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
						if(((p1_c3 >= "001101" )and (p1_c3 <= "011001")) or ((p1_c4 >= "001101" )and (p1_c4 <= "011001"))
						or ((p1_c5 >= "001101" )and (p1_c5 <= "011001"))or ((p1_c6 >= "001101" )and (p1_c6 <= "011001"))or ((p2_c1 >= "001101" )and (p2_c1 <= "011001"))
						or ((p2_c2 >= "001101" )and (p2_c2 <= "011001"))) then
							if addrcnt(27) = x"0a" then
								addrcnt(27) <= (others => '0');
							elsif addrcnt(27) = x"15" then
								addrcnt(27) <= x"0b";
							elsif addrcnt(27) = x"20" then
								addrcnt(27) <= x"16";
							elsif addrcnt(27) = x"2b" then
								addrcnt(27) <= x"21";
							elsif addrcnt(27) = x"36" then
								addrcnt(27) <= x"2c";
							elsif addrcnt(27) = x"41" then
								addrcnt(27) <= x"37";
							elsif addrcnt(27) = x"4c" then
								addrcnt(27) <= x"42";
							elsif addrcnt(27) = x"57" then
								addrcnt(27) <= x"4d";
							elsif addrcnt(27) = x"62" then
								addrcnt(27) <= x"58";
							elsif addrcnt(27) = x"6d" then
								addrcnt(27) <= x"63";
							elsif addrcnt(27) = x"78" then
								addrcnt(27) <= x"6e";
							elsif addrcnt(27) = x"83" then
								addrcnt(27) <= x"79";
							elsif addrcnt(27) = x"8e" then
								addrcnt(27) <= x"84";
							elsif addrcnt(27) = x"99" then
								addrcnt(27) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 >= "011010" )and (p1_c2 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
						if(((p1_c3 >= "011010" )and (p1_c3 <= "100110")) or ((p1_c4 >= "011010" )and (p1_c4 <= "100110"))
						or ((p1_c5 >= "011010" )and (p1_c5 <= "100110"))or ((p1_c6 >= "011010" )and (p1_c6 <= "100110"))or ((p2_c1 >= "011010" )and (p2_c1 <= "100110"))
						or ((p2_c2 >= "011010" )and (p2_c2 <= "100110"))) then
							if addrcnt(28) = x"0a" then
								addrcnt(28) <= (others => '0');
							elsif addrcnt(28) = x"15" then
								addrcnt(28) <= x"0b";
							elsif addrcnt(28) = x"20" then
								addrcnt(28) <= x"16";
							elsif addrcnt(28) = x"2b" then
								addrcnt(28) <= x"21";
							elsif addrcnt(28) = x"36" then
								addrcnt(28) <= x"2c";
							elsif addrcnt(28) = x"41" then
								addrcnt(28) <= x"37";
							elsif addrcnt(28) = x"4c" then
								addrcnt(28) <= x"42";
							elsif addrcnt(28) = x"57" then
								addrcnt(28) <= x"4d";
							elsif addrcnt(28) = x"62" then
								addrcnt(28) <= x"58";
							elsif addrcnt(28) = x"6d" then
								addrcnt(28) <= x"63";
							elsif addrcnt(28) = x"78" then
								addrcnt(28) <= x"6e";
							elsif addrcnt(28) = x"83" then
								addrcnt(28) <= x"79";
							elsif addrcnt(28) = x"8e" then
								addrcnt(28) <= x"84";
							elsif addrcnt(28) = x"99" then
								addrcnt(28) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 >= "100111" )and (p1_c2 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
						if(((p1_c3 >= "100111" )and (p1_c3 <= "110011")) or ((p1_c4 >= "100111" )and (p1_c4 <= "110011"))
						or ((p1_c5 >= "100111" )and (p1_c5 <= "110011"))or ((p1_c6 >= "100111" )and (p1_c6 <= "110011"))or ((p2_c1 >= "100111" )and (p2_c1 <= "110011"))
						or ((p2_c2 >= "100111" )and (p2_c2 <= "110011"))) then
							if addrcnt(29) = x"0a" then
								addrcnt(29) <= (others => '0');
							elsif addrcnt(29) = x"15" then
								addrcnt(29) <= x"0b";
							elsif addrcnt(29) = x"20" then
								addrcnt(29) <= x"16";
							elsif addrcnt(29) = x"2b" then
								addrcnt(29) <= x"21";
							elsif addrcnt(29) = x"36" then
								addrcnt(29) <= x"2c";
							elsif addrcnt(29) = x"41" then
								addrcnt(29) <= x"37";
							elsif addrcnt(29) = x"4c" then
								addrcnt(29) <= x"42";
							elsif addrcnt(29) = x"57" then
								addrcnt(29) <= x"4d";
							elsif addrcnt(29) = x"62" then
								addrcnt(29) <= x"58";
							elsif addrcnt(29) = x"6d" then
								addrcnt(29) <= x"63";
							elsif addrcnt(29) = x"78" then
								addrcnt(29) <= x"6e";
							elsif addrcnt(29) = x"83" then
								addrcnt(29) <= x"79";
							elsif addrcnt(29) = x"8e" then
								addrcnt(29) <= x"84";
							elsif addrcnt(29) = x"99" then
								addrcnt(29) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +122 ) ) and ( hsync_cnt <= (tHW + tHBP +132)) ) then
					if (p1_c3 >= "000000" )and (p1_c3 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
						if(((p1_c4 >= "000000" )and (p1_c4 <= "001100"))
						or ((p1_c5 >= "000000" )and (p1_c5 <= "001100"))or ((p1_c6 >= "000000" )and (p1_c6 <= "001100"))or ((p2_c1 >= "000000" )and (p2_c1 <= "001100"))
						or ((p2_c2 >= "000000" )and (p2_c2 <= "001100"))) then
							if addrcnt(26) = x"0a" then
								addrcnt(26) <= (others => '0');
							elsif addrcnt(26) = x"15" then
								addrcnt(26) <= x"0b";
							elsif addrcnt(26) = x"20" then
								addrcnt(26) <= x"16";
							elsif addrcnt(26) = x"2b" then
								addrcnt(26) <= x"21";
							elsif addrcnt(26) = x"36" then
								addrcnt(26) <= x"2c";
							elsif addrcnt(26) = x"41" then
								addrcnt(26) <= x"37";
							elsif addrcnt(26) = x"4c" then
								addrcnt(26) <= x"42";
							elsif addrcnt(26) = x"57" then
								addrcnt(26) <= x"4d";
							elsif addrcnt(26) = x"62" then
								addrcnt(26) <= x"58";
							elsif addrcnt(26) = x"6d" then
								addrcnt(26) <= x"63";
							elsif addrcnt(26) = x"78" then
								addrcnt(26) <= x"6e";
							elsif addrcnt(26) = x"83" then
								addrcnt(26) <= x"79";
							elsif addrcnt(26) = x"8e" then
								addrcnt(26) <= x"84";
							elsif addrcnt(26) = x"99" then
								addrcnt(26) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 >= "001101" )and (p1_c3 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
						if(((p1_c4 >= "001101" )and (p1_c4 <= "011001"))
						or ((p1_c5 >= "001101" )and (p1_c5 <= "011001"))or ((p1_c6 >= "001101" )and (p1_c6 <= "011001"))or ((p2_c1 >= "001101" )and (p2_c1 <= "011001"))
						or ((p2_c2 >= "001101" )and (p2_c2 <= "011001"))) then
							if addrcnt(27) = x"0a" then
								addrcnt(27) <= (others => '0');
							elsif addrcnt(27) = x"15" then
								addrcnt(27) <= x"0b";
							elsif addrcnt(27) = x"20" then
								addrcnt(27) <= x"16";
							elsif addrcnt(27) = x"2b" then
								addrcnt(27) <= x"21";
							elsif addrcnt(27) = x"36" then
								addrcnt(27) <= x"2c";
							elsif addrcnt(27) = x"41" then
								addrcnt(27) <= x"37";
							elsif addrcnt(27) = x"4c" then
								addrcnt(27) <= x"42";
							elsif addrcnt(27) = x"57" then
								addrcnt(27) <= x"4d";
							elsif addrcnt(27) = x"62" then
								addrcnt(27) <= x"58";
							elsif addrcnt(27) = x"6d" then
								addrcnt(27) <= x"63";
							elsif addrcnt(27) = x"78" then
								addrcnt(27) <= x"6e";
							elsif addrcnt(27) = x"83" then
								addrcnt(27) <= x"79";
							elsif addrcnt(27) = x"8e" then
								addrcnt(27) <= x"84";
							elsif addrcnt(27) = x"99" then
								addrcnt(27) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 >= "011010" )and (p1_c3 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
						if(((p1_c4 >= "011010" )and (p1_c4 <= "100110"))
						or ((p1_c5 >= "011010" )and (p1_c5 <= "100110"))or ((p1_c6 >= "011010" )and (p1_c6 <= "100110"))or ((p2_c1 >= "011010" )and (p2_c1 <= "100110"))
						or ((p2_c2 >= "011010" )and (p2_c2 <= "100110"))) then
							if addrcnt(28) = x"0a" then
								addrcnt(28) <= (others => '0');
							elsif addrcnt(28) = x"15" then
								addrcnt(28) <= x"0b";
							elsif addrcnt(28) = x"20" then
								addrcnt(28) <= x"16";
							elsif addrcnt(28) = x"2b" then
								addrcnt(28) <= x"21";
							elsif addrcnt(28) = x"36" then
								addrcnt(28) <= x"2c";
							elsif addrcnt(28) = x"41" then
								addrcnt(28) <= x"37";
							elsif addrcnt(28) = x"4c" then
								addrcnt(28) <= x"42";
							elsif addrcnt(28) = x"57" then
								addrcnt(28) <= x"4d";
							elsif addrcnt(28) = x"62" then
								addrcnt(28) <= x"58";
							elsif addrcnt(28) = x"6d" then
								addrcnt(28) <= x"63";
							elsif addrcnt(28) = x"78" then
								addrcnt(28) <= x"6e";
							elsif addrcnt(28) = x"83" then
								addrcnt(28) <= x"79";
							elsif addrcnt(28) = x"8e" then
								addrcnt(28) <= x"84";
							elsif addrcnt(28) = x"99" then
								addrcnt(28) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 >= "100111" )and (p1_c3 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
						if(((p1_c4 >= "100111" )and (p1_c4 <= "110011"))
						or ((p1_c5 >= "100111" )and (p1_c5 <= "110011"))or ((p1_c6 >= "100111" )and (p1_c6 <= "110011"))or ((p2_c1 >= "100111" )and (p2_c1 <= "110011"))
						or ((p2_c2 >= "100111" )and (p2_c2 <= "110011"))) then
							if addrcnt(29) = x"0a" then
								addrcnt(29) <= (others => '0');
							elsif addrcnt(29) = x"15" then
								addrcnt(29) <= x"0b";
							elsif addrcnt(29) = x"20" then
								addrcnt(29) <= x"16";
							elsif addrcnt(29) = x"2b" then
								addrcnt(29) <= x"21";
							elsif addrcnt(29) = x"36" then
								addrcnt(29) <= x"2c";
							elsif addrcnt(29) = x"41" then
								addrcnt(29) <= x"37";
							elsif addrcnt(29) = x"4c" then
								addrcnt(29) <= x"42";
							elsif addrcnt(29) = x"57" then
								addrcnt(29) <= x"4d";
							elsif addrcnt(29) = x"62" then
								addrcnt(29) <= x"58";
							elsif addrcnt(29) = x"6d" then
								addrcnt(29) <= x"63";
							elsif addrcnt(29) = x"78" then
								addrcnt(29) <= x"6e";
							elsif addrcnt(29) = x"83" then
								addrcnt(29) <= x"79";
							elsif addrcnt(29) = x"8e" then
								addrcnt(29) <= x"84";
							elsif addrcnt(29) = x"99" then
								addrcnt(29) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +133 ) ) and ( hsync_cnt <= (tHW + tHBP +143)) ) then
					if (p1_c4 >= "000000" )and (p1_c4 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
						if(((p1_c5 >= "000000" )and (p1_c5 <= "001100"))or ((p1_c6 >= "000000" )and (p1_c6 <= "001100"))or ((p2_c1 >= "000000" )and (p2_c1 <= "001100"))
						or ((p2_c2 >= "000000" )and (p2_c2 <= "001100"))) then
							if addrcnt(26) = x"0a" then
								addrcnt(26) <= (others => '0');
							elsif addrcnt(26) = x"15" then
								addrcnt(26) <= x"0b";
							elsif addrcnt(26) = x"20" then
								addrcnt(26) <= x"16";
							elsif addrcnt(26) = x"2b" then
								addrcnt(26) <= x"21";
							elsif addrcnt(26) = x"36" then
								addrcnt(26) <= x"2c";
							elsif addrcnt(26) = x"41" then
								addrcnt(26) <= x"37";
							elsif addrcnt(26) = x"4c" then
								addrcnt(26) <= x"42";
							elsif addrcnt(26) = x"57" then
								addrcnt(26) <= x"4d";
							elsif addrcnt(26) = x"62" then
								addrcnt(26) <= x"58";
							elsif addrcnt(26) = x"6d" then
								addrcnt(26) <= x"63";
							elsif addrcnt(26) = x"78" then
								addrcnt(26) <= x"6e";
							elsif addrcnt(26) = x"83" then
								addrcnt(26) <= x"79";
							elsif addrcnt(26) = x"8e" then
								addrcnt(26) <= x"84";
							elsif addrcnt(26) = x"99" then
								addrcnt(26) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 >= "001101" )and (p1_c4 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
						if(((p1_c5 >= "001101" )and (p1_c5 <= "011001"))or ((p1_c6 >= "001101" )and (p1_c6 <= "011001"))or ((p2_c1 >= "001101" )and (p2_c1 <= "011001"))
						or ((p2_c2 >= "001101" )and (p2_c2 <= "011001"))) then
							if addrcnt(27) = x"0a" then
								addrcnt(27) <= (others => '0');
							elsif addrcnt(27) = x"15" then
								addrcnt(27) <= x"0b";
							elsif addrcnt(27) = x"20" then
								addrcnt(27) <= x"16";
							elsif addrcnt(27) = x"2b" then
								addrcnt(27) <= x"21";
							elsif addrcnt(27) = x"36" then
								addrcnt(27) <= x"2c";
							elsif addrcnt(27) = x"41" then
								addrcnt(27) <= x"37";
							elsif addrcnt(27) = x"4c" then
								addrcnt(27) <= x"42";
							elsif addrcnt(27) = x"57" then
								addrcnt(27) <= x"4d";
							elsif addrcnt(27) = x"62" then
								addrcnt(27) <= x"58";
							elsif addrcnt(27) = x"6d" then
								addrcnt(27) <= x"63";
							elsif addrcnt(27) = x"78" then
								addrcnt(27) <= x"6e";
							elsif addrcnt(27) = x"83" then
								addrcnt(27) <= x"79";
							elsif addrcnt(27) = x"8e" then
								addrcnt(27) <= x"84";
							elsif addrcnt(27) = x"99" then
								addrcnt(27) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 >= "011010" )and (p1_c4 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
						if(((p1_c5 >= "011010" )and (p1_c5 <= "100110"))or ((p1_c6 >= "011010" )and (p1_c6 <= "100110"))or ((p2_c1 >= "011010" )and (p2_c1 <= "100110"))
						or ((p2_c2 >= "011010" )and (p2_c2 <= "100110"))) then
							if addrcnt(28) = x"0a" then
								addrcnt(28) <= (others => '0');
							elsif addrcnt(28) = x"15" then
								addrcnt(28) <= x"0b";
							elsif addrcnt(28) = x"20" then
								addrcnt(28) <= x"16";
							elsif addrcnt(28) = x"2b" then
								addrcnt(28) <= x"21";
							elsif addrcnt(28) = x"36" then
								addrcnt(28) <= x"2c";
							elsif addrcnt(28) = x"41" then
								addrcnt(28) <= x"37";
							elsif addrcnt(28) = x"4c" then
								addrcnt(28) <= x"42";
							elsif addrcnt(28) = x"57" then
								addrcnt(28) <= x"4d";
							elsif addrcnt(28) = x"62" then
								addrcnt(28) <= x"58";
							elsif addrcnt(28) = x"6d" then
								addrcnt(28) <= x"63";
							elsif addrcnt(28) = x"78" then
								addrcnt(28) <= x"6e";
							elsif addrcnt(28) = x"83" then
								addrcnt(28) <= x"79";
							elsif addrcnt(28) = x"8e" then
								addrcnt(28) <= x"84";
							elsif addrcnt(28) = x"99" then
								addrcnt(28) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 >= "100111" )and (p1_c4 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
						if(((p1_c5 >= "100111" )and (p1_c5 <= "110011"))or ((p1_c6 >= "100111" )and (p1_c6 <= "110011"))or ((p2_c1 >= "100111" )and (p2_c1 <= "110011"))
						or ((p2_c2 >= "100111" )and (p2_c2 <= "110011"))) then
							if addrcnt(29) = x"0a" then
								addrcnt(29) <= (others => '0');
							elsif addrcnt(29) = x"15" then
								addrcnt(29) <= x"0b";
							elsif addrcnt(29) = x"20" then
								addrcnt(29) <= x"16";
							elsif addrcnt(29) = x"2b" then
								addrcnt(29) <= x"21";
							elsif addrcnt(29) = x"36" then
								addrcnt(29) <= x"2c";
							elsif addrcnt(29) = x"41" then
								addrcnt(29) <= x"37";
							elsif addrcnt(29) = x"4c" then
								addrcnt(29) <= x"42";
							elsif addrcnt(29) = x"57" then
								addrcnt(29) <= x"4d";
							elsif addrcnt(29) = x"62" then
								addrcnt(29) <= x"58";
							elsif addrcnt(29) = x"6d" then
								addrcnt(29) <= x"63";
							elsif addrcnt(29) = x"78" then
								addrcnt(29) <= x"6e";
							elsif addrcnt(29) = x"83" then
								addrcnt(29) <= x"79";
							elsif addrcnt(29) = x"8e" then
								addrcnt(29) <= x"84";
							elsif addrcnt(29) = x"99" then
								addrcnt(29) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +144 ) ) and ( hsync_cnt <= (tHW + tHBP +154)) ) then
					if (p1_c5 >= "000000" )and (p1_c5 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
						if(((p1_c6 >= "000000" )and (p1_c6 <= "001100"))or ((p2_c1 >= "000000" )and (p2_c1 <= "001100"))
						or ((p2_c2 >= "000000" )and (p2_c2 <= "001100"))) then
							if addrcnt(26) = x"0a" then
								addrcnt(26) <= (others => '0');
							elsif addrcnt(26) = x"15" then
								addrcnt(26) <= x"0b";
							elsif addrcnt(26) = x"20" then
								addrcnt(26) <= x"16";
							elsif addrcnt(26) = x"2b" then
								addrcnt(26) <= x"21";
							elsif addrcnt(26) = x"36" then
								addrcnt(26) <= x"2c";
							elsif addrcnt(26) = x"41" then
								addrcnt(26) <= x"37";
							elsif addrcnt(26) = x"4c" then
								addrcnt(26) <= x"42";
							elsif addrcnt(26) = x"57" then
								addrcnt(26) <= x"4d";
							elsif addrcnt(26) = x"62" then
								addrcnt(26) <= x"58";
							elsif addrcnt(26) = x"6d" then
								addrcnt(26) <= x"63";
							elsif addrcnt(26) = x"78" then
								addrcnt(26) <= x"6e";
							elsif addrcnt(26) = x"83" then
								addrcnt(26) <= x"79";
							elsif addrcnt(26) = x"8e" then
								addrcnt(26) <= x"84";
							elsif addrcnt(26) = x"99" then
								addrcnt(26) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 >= "001101" )and (p1_c5 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
						if(((p1_c6 >= "001101" )and (p1_c6 <= "011001"))or ((p2_c1 >= "001101" )and (p2_c1 <= "011001"))
						or ((p2_c2 >= "001101" )and (p2_c2 <= "011001"))) then
							if addrcnt(27) = x"0a" then
								addrcnt(27) <= (others => '0');
							elsif addrcnt(27) = x"15" then
								addrcnt(27) <= x"0b";
							elsif addrcnt(27) = x"20" then
								addrcnt(27) <= x"16";
							elsif addrcnt(27) = x"2b" then
								addrcnt(27) <= x"21";
							elsif addrcnt(27) = x"36" then
								addrcnt(27) <= x"2c";
							elsif addrcnt(27) = x"41" then
								addrcnt(27) <= x"37";
							elsif addrcnt(27) = x"4c" then
								addrcnt(27) <= x"42";
							elsif addrcnt(27) = x"57" then
								addrcnt(27) <= x"4d";
							elsif addrcnt(27) = x"62" then
								addrcnt(27) <= x"58";
							elsif addrcnt(27) = x"6d" then
								addrcnt(27) <= x"63";
							elsif addrcnt(27) = x"78" then
								addrcnt(27) <= x"6e";
							elsif addrcnt(27) = x"83" then
								addrcnt(27) <= x"79";
							elsif addrcnt(27) = x"8e" then
								addrcnt(27) <= x"84";
							elsif addrcnt(27) = x"99" then
								addrcnt(27) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 >= "011010" )and (p1_c5 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
						if(((p1_c6 >= "011010" )and (p1_c6 <= "100110"))or ((p2_c1 >= "011010" )and (p2_c1 <= "100110"))
						or ((p2_c2 >= "011010" )and (p2_c2 <= "100110"))) then
							if addrcnt(28) = x"0a" then
								addrcnt(28) <= (others => '0');
							elsif addrcnt(28) = x"15" then
								addrcnt(28) <= x"0b";
							elsif addrcnt(28) = x"20" then
								addrcnt(28) <= x"16";
							elsif addrcnt(28) = x"2b" then
								addrcnt(28) <= x"21";
							elsif addrcnt(28) = x"36" then
								addrcnt(28) <= x"2c";
							elsif addrcnt(28) = x"41" then
								addrcnt(28) <= x"37";
							elsif addrcnt(28) = x"4c" then
								addrcnt(28) <= x"42";
							elsif addrcnt(28) = x"57" then
								addrcnt(28) <= x"4d";
							elsif addrcnt(28) = x"62" then
								addrcnt(28) <= x"58";
							elsif addrcnt(28) = x"6d" then
								addrcnt(28) <= x"63";
							elsif addrcnt(28) = x"78" then
								addrcnt(28) <= x"6e";
							elsif addrcnt(28) = x"83" then
								addrcnt(28) <= x"79";
							elsif addrcnt(28) = x"8e" then
								addrcnt(28) <= x"84";
							elsif addrcnt(28) = x"99" then
								addrcnt(28) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 >= "100111" )and (p1_c5 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
						if(((p1_c6 >= "100111" )and (p1_c6 <= "110011"))or ((p2_c1 >= "100111" )and (p2_c1 <= "110011"))
						or ((p2_c2 >= "100111" )and (p2_c2 <= "110011"))) then
							if addrcnt(29) = x"0a" then
								addrcnt(29) <= (others => '0');
							elsif addrcnt(29) = x"15" then
								addrcnt(29) <= x"0b";
							elsif addrcnt(29) = x"20" then
								addrcnt(29) <= x"16";
							elsif addrcnt(29) = x"2b" then
								addrcnt(29) <= x"21";
							elsif addrcnt(29) = x"36" then
								addrcnt(29) <= x"2c";
							elsif addrcnt(29) = x"41" then
								addrcnt(29) <= x"37";
							elsif addrcnt(29) = x"4c" then
								addrcnt(29) <= x"42";
							elsif addrcnt(29) = x"57" then
								addrcnt(29) <= x"4d";
							elsif addrcnt(29) = x"62" then
								addrcnt(29) <= x"58";
							elsif addrcnt(29) = x"6d" then
								addrcnt(29) <= x"63";
							elsif addrcnt(29) = x"78" then
								addrcnt(29) <= x"6e";
							elsif addrcnt(29) = x"83" then
								addrcnt(29) <= x"79";
							elsif addrcnt(29) = x"8e" then
								addrcnt(29) <= x"84";
							elsif addrcnt(29) = x"99" then
								addrcnt(29) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +155 ) ) and ( hsync_cnt <= (tHW + tHBP +165)) ) then
					if (p1_c6 >= "000000" )and (p1_c6 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
						if(((p2_c1 >= "000000" )and (p2_c1 <= "001100")) or ((p2_c2 >= "000000" )and (p2_c2 <= "001100"))) then
							if addrcnt(26) = x"0a" then
								addrcnt(26) <= (others => '0');
							elsif addrcnt(26) = x"15" then
								addrcnt(26) <= x"0b";
							elsif addrcnt(26) = x"20" then
								addrcnt(26) <= x"16";
							elsif addrcnt(26) = x"2b" then
								addrcnt(26) <= x"21";
							elsif addrcnt(26) = x"36" then
								addrcnt(26) <= x"2c";
							elsif addrcnt(26) = x"41" then
								addrcnt(26) <= x"37";
							elsif addrcnt(26) = x"4c" then
								addrcnt(26) <= x"42";
							elsif addrcnt(26) = x"57" then
								addrcnt(26) <= x"4d";
							elsif addrcnt(26) = x"62" then
								addrcnt(26) <= x"58";
							elsif addrcnt(26) = x"6d" then
								addrcnt(26) <= x"63";
							elsif addrcnt(26) = x"78" then
								addrcnt(26) <= x"6e";
							elsif addrcnt(26) = x"83" then
								addrcnt(26) <= x"79";
							elsif addrcnt(26) = x"8e" then
								addrcnt(26) <= x"84";
							elsif addrcnt(26) = x"99" then
								addrcnt(26) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 >= "001101" )and (p1_c6 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
						if(((p2_c1 >= "001101" )and (p2_c1 <= "011001")) or ((p2_c2 >= "001101" )and (p2_c2 <= "011001"))) then
							if addrcnt(27) = x"0a" then
								addrcnt(27) <= (others => '0');
							elsif addrcnt(27) = x"15" then
								addrcnt(27) <= x"0b";
							elsif addrcnt(27) = x"20" then
								addrcnt(27) <= x"16";
							elsif addrcnt(27) = x"2b" then
								addrcnt(27) <= x"21";
							elsif addrcnt(27) = x"36" then
								addrcnt(27) <= x"2c";
							elsif addrcnt(27) = x"41" then
								addrcnt(27) <= x"37";
							elsif addrcnt(27) = x"4c" then
								addrcnt(27) <= x"42";
							elsif addrcnt(27) = x"57" then
								addrcnt(27) <= x"4d";
							elsif addrcnt(27) = x"62" then
								addrcnt(27) <= x"58";
							elsif addrcnt(27) = x"6d" then
								addrcnt(27) <= x"63";
							elsif addrcnt(27) = x"78" then
								addrcnt(27) <= x"6e";
							elsif addrcnt(27) = x"83" then
								addrcnt(27) <= x"79";
							elsif addrcnt(27) = x"8e" then
								addrcnt(27) <= x"84";
							elsif addrcnt(27) = x"99" then
								addrcnt(27) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 >= "011010" )and (p1_c6 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
						if(((p2_c1 >= "011010" )and (p2_c1 <= "100110")) or ((p2_c2 >= "011010" )and (p2_c2 <= "100110"))) then
							if addrcnt(28) = x"0a" then
								addrcnt(28) <= (others => '0');
							elsif addrcnt(28) = x"15" then
								addrcnt(28) <= x"0b";
							elsif addrcnt(28) = x"20" then
								addrcnt(28) <= x"16";
							elsif addrcnt(28) = x"2b" then
								addrcnt(28) <= x"21";
							elsif addrcnt(28) = x"36" then
								addrcnt(28) <= x"2c";
							elsif addrcnt(28) = x"41" then
								addrcnt(28) <= x"37";
							elsif addrcnt(28) = x"4c" then
								addrcnt(28) <= x"42";
							elsif addrcnt(28) = x"57" then
								addrcnt(28) <= x"4d";
							elsif addrcnt(28) = x"62" then
								addrcnt(28) <= x"58";
							elsif addrcnt(28) = x"6d" then
								addrcnt(28) <= x"63";
							elsif addrcnt(28) = x"78" then
								addrcnt(28) <= x"6e";
							elsif addrcnt(28) = x"83" then
								addrcnt(28) <= x"79";
							elsif addrcnt(28) = x"8e" then
								addrcnt(28) <= x"84";
							elsif addrcnt(28) = x"99" then
								addrcnt(28) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 >= "100111" )and (p1_c6 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
						if(((p2_c1 >= "100111" )and (p2_c1 <= "110011")) or ((p2_c2 >= "100111" )and (p2_c2 <= "110011"))) then
							if addrcnt(29) = x"0a" then
								addrcnt(29) <= (others => '0');
							elsif addrcnt(29) = x"15" then
								addrcnt(29) <= x"0b";
							elsif addrcnt(29) = x"20" then
								addrcnt(29) <= x"16";
							elsif addrcnt(29) = x"2b" then
								addrcnt(29) <= x"21";
							elsif addrcnt(29) = x"36" then
								addrcnt(29) <= x"2c";
							elsif addrcnt(29) = x"41" then
								addrcnt(29) <= x"37";
							elsif addrcnt(29) = x"4c" then
								addrcnt(29) <= x"42";
							elsif addrcnt(29) = x"57" then
								addrcnt(29) <= x"4d";
							elsif addrcnt(29) = x"62" then
								addrcnt(29) <= x"58";
							elsif addrcnt(29) = x"6d" then
								addrcnt(29) <= x"63";
							elsif addrcnt(29) = x"78" then
								addrcnt(29) <= x"6e";
							elsif addrcnt(29) = x"83" then
								addrcnt(29) <= x"79";
							elsif addrcnt(29) = x"8e" then
								addrcnt(29) <= x"84";
							elsif addrcnt(29) = x"99" then
								addrcnt(29) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "111111") then
						if ((hsync_cnt >= (tHW + tHBP +155 ) ) and ( hsync_cnt <= (tHW + tHBP +161)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +166 ) ) and ( hsync_cnt <= (tHW + tHBP +205)) ) then
					if (p1_c3 /= "111111") then
						if ((hsync_cnt >= (tHW + tHBP +166 ) ) and ( hsync_cnt <= (tHW + tHBP +172)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
					if (p1_c4 /= "111111") then	
						if ((hsync_cnt >= (tHW + tHBP +173 ) ) and ( hsync_cnt <= (tHW + tHBP +183)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
					if (p1_c5 /= "111111") then	
						if ((hsync_cnt >= (tHW + tHBP +184 ) ) and ( hsync_cnt <= (tHW + tHBP +194)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
					if (p1_c6 /= "111111") then	
						if ((hsync_cnt >= (tHW + tHBP +195 ) ) and ( hsync_cnt <= (tHW + tHBP +205)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
				elsif( (hsync_cnt >= (tHW + tHBP +399 ) ) and ( hsync_cnt <= (tHW + tHBP +400)) ) then --가운데 세로줄
					rgb_data <= (others => '1');
				elsif ((hsync_cnt >= (tHW + tHBP +409 ) ) and ( hsync_cnt <= (tHW + tHBP +419)) ) then -- 2p 카드 모양
					if (p2_c1 >= "000000" )and (p2_c1 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
						if(((p2_c2 >= "000000" )and (p2_c2 <= "001100")) or ((p2_c3 >= "000000" )and (p2_c3 <= "001100")) or ((p2_c4 >= "000000" )and (p2_c4 <= "001100"))
						or ((p2_c5 >= "000000" )and (p2_c5 <= "001100"))or ((p2_c6 >= "000000" )and (p2_c6 <= "001100"))) then
							if addrcnt(26) = x"0a" then
								addrcnt(26) <= (others => '0');
							elsif addrcnt(26) = x"15" then
								addrcnt(26) <= x"0b";
							elsif addrcnt(26) = x"20" then
								addrcnt(26) <= x"16";
							elsif addrcnt(26) = x"2b" then
								addrcnt(26) <= x"21";
							elsif addrcnt(26) = x"36" then
								addrcnt(26) <= x"2c";
							elsif addrcnt(26) = x"41" then
								addrcnt(26) <= x"37";
							elsif addrcnt(26) = x"4c" then
								addrcnt(26) <= x"42";
							elsif addrcnt(26) = x"57" then
								addrcnt(26) <= x"4d";
							elsif addrcnt(26) = x"62" then
								addrcnt(26) <= x"58";
							elsif addrcnt(26) = x"6d" then
								addrcnt(26) <= x"63";
							elsif addrcnt(26) = x"78" then
								addrcnt(26) <= x"6e";
							elsif addrcnt(26) = x"83" then
								addrcnt(26) <= x"79";
							elsif addrcnt(26) = x"8e" then
								addrcnt(26) <= x"84";
							elsif addrcnt(26) = x"99" then
								addrcnt(26) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 >= "001101" )and (p2_c1 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
						if(((p2_c2 >= "001101" )and (p2_c2 <= "011001")) or ((p2_c3 >= "001101" )and (p2_c3 <= "011001")) or ((p2_c4 >= "001101" )and (p2_c4 <= "011001"))
						or ((p2_c5 >= "001101" )and (p2_c5 <= "011001"))or ((p2_c6 >= "001101" )and (p2_c6 <= "011001"))) then
							if addrcnt(27) = x"0a" then
								addrcnt(27) <= (others => '0');
							elsif addrcnt(27) = x"15" then
								addrcnt(27) <= x"0b";
							elsif addrcnt(27) = x"20" then
								addrcnt(27) <= x"16";
							elsif addrcnt(27) = x"2b" then
								addrcnt(27) <= x"21";
							elsif addrcnt(27) = x"36" then
								addrcnt(27) <= x"2c";
							elsif addrcnt(27) = x"41" then
								addrcnt(27) <= x"37";
							elsif addrcnt(27) = x"4c" then
								addrcnt(27) <= x"42";
							elsif addrcnt(27) = x"57" then
								addrcnt(27) <= x"4d";
							elsif addrcnt(27) = x"62" then
								addrcnt(27) <= x"58";
							elsif addrcnt(27) = x"6d" then
								addrcnt(27) <= x"63";
							elsif addrcnt(27) = x"78" then
								addrcnt(27) <= x"6e";
							elsif addrcnt(27) = x"83" then
								addrcnt(27) <= x"79";
							elsif addrcnt(27) = x"8e" then
								addrcnt(27) <= x"84";
							elsif addrcnt(27) = x"99" then
								addrcnt(27) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 >= "011010" )and (p2_c1 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
						if(((p2_c2 >= "011010" )and (p2_c2 <= "100110")) or ((p2_c3 >= "011010" )and (p2_c3 <= "100110")) or ((p2_c4 >= "011010" )and (p2_c4 <= "100110"))
						or ((p2_c5 >= "011010" )and (p2_c5 <= "100110"))or ((p2_c6 >= "011010" )and (p2_c6 <= "100110"))) then
							if addrcnt(28) = x"0a" then
								addrcnt(28) <= (others => '0');
							elsif addrcnt(28) = x"15" then
								addrcnt(28) <= x"0b";
							elsif addrcnt(28) = x"20" then
								addrcnt(28) <= x"16";
							elsif addrcnt(28) = x"2b" then
								addrcnt(28) <= x"21";
							elsif addrcnt(28) = x"36" then
								addrcnt(28) <= x"2c";
							elsif addrcnt(28) = x"41" then
								addrcnt(28) <= x"37";
							elsif addrcnt(28) = x"4c" then
								addrcnt(28) <= x"42";
							elsif addrcnt(28) = x"57" then
								addrcnt(28) <= x"4d";
							elsif addrcnt(28) = x"62" then
								addrcnt(28) <= x"58";
							elsif addrcnt(28) = x"6d" then
								addrcnt(28) <= x"63";
							elsif addrcnt(28) = x"78" then
								addrcnt(28) <= x"6e";
							elsif addrcnt(28) = x"83" then
								addrcnt(28) <= x"79";
							elsif addrcnt(28) = x"8e" then
								addrcnt(28) <= x"84";
							elsif addrcnt(28) = x"99" then
								addrcnt(28) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 >= "100111" )and (p2_c1 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
						if(((p2_c2 >= "100111" )and (p2_c2 <= "110011")) or ((p2_c3 >= "100111" )and (p2_c3 <= "110011")) or ((p2_c4 >= "100111" )and (p2_c4 <= "110011"))
						or ((p2_c5 >= "100111" )and (p2_c5 <= "110011"))or ((p2_c6 >= "100111" )and (p2_c6 <= "110011"))) then
							if addrcnt(29) = x"0a" then
								addrcnt(29) <= (others => '0');
							elsif addrcnt(29) = x"15" then
								addrcnt(29) <= x"0b";
							elsif addrcnt(29) = x"20" then
								addrcnt(29) <= x"16";
							elsif addrcnt(29) = x"2b" then
								addrcnt(29) <= x"21";
							elsif addrcnt(29) = x"36" then
								addrcnt(29) <= x"2c";
							elsif addrcnt(29) = x"41" then
								addrcnt(29) <= x"37";
							elsif addrcnt(29) = x"4c" then
								addrcnt(29) <= x"42";
							elsif addrcnt(29) = x"57" then
								addrcnt(29) <= x"4d";
							elsif addrcnt(29) = x"62" then
								addrcnt(29) <= x"58";
							elsif addrcnt(29) = x"6d" then
								addrcnt(29) <= x"63";
							elsif addrcnt(29) = x"78" then
								addrcnt(29) <= x"6e";
							elsif addrcnt(29) = x"83" then
								addrcnt(29) <= x"79";
							elsif addrcnt(29) = x"8e" then
								addrcnt(29) <= x"84";
							elsif addrcnt(29) = x"99" then
								addrcnt(29) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +420 ) ) and ( hsync_cnt <= (tHW + tHBP +430)) ) then
					if (p2_c2 >= "000000" )and (p2_c2 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
						if(((p2_c3 >= "000000" )and (p2_c3 <= "001100")) or ((p2_c4 >= "000000" )and (p2_c4 <= "001100"))
						or ((p2_c5 >= "000000" )and (p2_c5 <= "001100"))or ((p2_c6 >= "000000" )and (p2_c6 <= "001100"))) then
							if addrcnt(26) = x"0a" then
								addrcnt(26) <= (others => '0');
							elsif addrcnt(26) = x"15" then
								addrcnt(26) <= x"0b";
							elsif addrcnt(26) = x"20" then
								addrcnt(26) <= x"16";
							elsif addrcnt(26) = x"2b" then
								addrcnt(26) <= x"21";
							elsif addrcnt(26) = x"36" then
								addrcnt(26) <= x"2c";
							elsif addrcnt(26) = x"41" then
								addrcnt(26) <= x"37";
							elsif addrcnt(26) = x"4c" then
								addrcnt(26) <= x"42";
							elsif addrcnt(26) = x"57" then
								addrcnt(26) <= x"4d";
							elsif addrcnt(26) = x"62" then
								addrcnt(26) <= x"58";
							elsif addrcnt(26) = x"6d" then
								addrcnt(26) <= x"63";
							elsif addrcnt(26) = x"78" then
								addrcnt(26) <= x"6e";
							elsif addrcnt(26) = x"83" then
								addrcnt(26) <= x"79";
							elsif addrcnt(26) = x"8e" then
								addrcnt(26) <= x"84";
							elsif addrcnt(26) = x"99" then
								addrcnt(26) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 >= "001101" )and (p2_c2 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
						if(((p2_c3 >= "001101" )and (p2_c3 <= "011001")) or ((p2_c4 >= "001101" )and (p2_c4 <= "011001"))
						or ((p2_c5 >= "001101" )and (p2_c5 <= "011001"))or ((p2_c6 >= "001101" )and (p2_c6 <= "011001"))) then
							if addrcnt(27) = x"0a" then
								addrcnt(27) <= (others => '0');
							elsif addrcnt(27) = x"15" then
								addrcnt(27) <= x"0b";
							elsif addrcnt(27) = x"20" then
								addrcnt(27) <= x"16";
							elsif addrcnt(27) = x"2b" then
								addrcnt(27) <= x"21";
							elsif addrcnt(27) = x"36" then
								addrcnt(27) <= x"2c";
							elsif addrcnt(27) = x"41" then
								addrcnt(27) <= x"37";
							elsif addrcnt(27) = x"4c" then
								addrcnt(27) <= x"42";
							elsif addrcnt(27) = x"57" then
								addrcnt(27) <= x"4d";
							elsif addrcnt(27) = x"62" then
								addrcnt(27) <= x"58";
							elsif addrcnt(27) = x"6d" then
								addrcnt(27) <= x"63";
							elsif addrcnt(27) = x"78" then
								addrcnt(27) <= x"6e";
							elsif addrcnt(27) = x"83" then
								addrcnt(27) <= x"79";
							elsif addrcnt(27) = x"8e" then
								addrcnt(27) <= x"84";
							elsif addrcnt(27) = x"99" then
								addrcnt(27) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 >= "011010" )and (p2_c2 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
						if(((p2_c3 >= "011010" )and (p2_c3 <= "100110")) or ((p2_c4 >= "011010" )and (p2_c4 <= "100110"))
						or ((p2_c5 >= "011010" )and (p2_c5 <= "100110"))or ((p2_c6 >= "011010" )and (p2_c6 <= "100110"))) then
							if addrcnt(28) = x"0a" then
								addrcnt(28) <= (others => '0');
							elsif addrcnt(28) = x"15" then
								addrcnt(28) <= x"0b";
							elsif addrcnt(28) = x"20" then
								addrcnt(28) <= x"16";
							elsif addrcnt(28) = x"2b" then
								addrcnt(28) <= x"21";
							elsif addrcnt(28) = x"36" then
								addrcnt(28) <= x"2c";
							elsif addrcnt(28) = x"41" then
								addrcnt(28) <= x"37";
							elsif addrcnt(28) = x"4c" then
								addrcnt(28) <= x"42";
							elsif addrcnt(28) = x"57" then
								addrcnt(28) <= x"4d";
							elsif addrcnt(28) = x"62" then
								addrcnt(28) <= x"58";
							elsif addrcnt(28) = x"6d" then
								addrcnt(28) <= x"63";
							elsif addrcnt(28) = x"78" then
								addrcnt(28) <= x"6e";
							elsif addrcnt(28) = x"83" then
								addrcnt(28) <= x"79";
							elsif addrcnt(28) = x"8e" then
								addrcnt(28) <= x"84";
							elsif addrcnt(28) = x"99" then
								addrcnt(28) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 >= "100111" )and (p2_c2 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
						if(((p2_c3 >= "100111" )and (p2_c3 <= "110011")) or ((p2_c4 >= "100111" )and (p2_c4 <= "110011"))
						or ((p2_c5 >= "100111" )and (p2_c5 <= "110011"))or ((p2_c6 >= "100111" )and (p2_c6 <= "110011"))) then
							if addrcnt(29) = x"0a" then
								addrcnt(29) <= (others => '0');
							elsif addrcnt(29) = x"15" then
								addrcnt(29) <= x"0b";
							elsif addrcnt(29) = x"20" then
								addrcnt(29) <= x"16";
							elsif addrcnt(29) = x"2b" then
								addrcnt(29) <= x"21";
							elsif addrcnt(29) = x"36" then
								addrcnt(29) <= x"2c";
							elsif addrcnt(29) = x"41" then
								addrcnt(29) <= x"37";
							elsif addrcnt(29) = x"4c" then
								addrcnt(29) <= x"42";
							elsif addrcnt(29) = x"57" then
								addrcnt(29) <= x"4d";
							elsif addrcnt(29) = x"62" then
								addrcnt(29) <= x"58";
							elsif addrcnt(29) = x"6d" then
								addrcnt(29) <= x"63";
							elsif addrcnt(29) = x"78" then
								addrcnt(29) <= x"6e";
							elsif addrcnt(29) = x"83" then
								addrcnt(29) <= x"79";
							elsif addrcnt(29) = x"8e" then
								addrcnt(29) <= x"84";
							elsif addrcnt(29) = x"99" then
								addrcnt(29) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +431 ) ) and ( hsync_cnt <= (tHW + tHBP +441)) ) then
					if (p2_c3 >= "000000" )and (p2_c3 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
						if(((p2_c4 >= "000000" )and (p2_c4 <= "001100"))or ((p2_c5 >= "000000" )and (p2_c5 <= "001100"))or ((p2_c6 >= "000000" )and (p2_c6 <= "001100"))) then
							if addrcnt(26) = x"0a" then
								addrcnt(26) <= (others => '0');
							elsif addrcnt(26) = x"15" then
								addrcnt(26) <= x"0b";
							elsif addrcnt(26) = x"20" then
								addrcnt(26) <= x"16";
							elsif addrcnt(26) = x"2b" then
								addrcnt(26) <= x"21";
							elsif addrcnt(26) = x"36" then
								addrcnt(26) <= x"2c";
							elsif addrcnt(26) = x"41" then
								addrcnt(26) <= x"37";
							elsif addrcnt(26) = x"4c" then
								addrcnt(26) <= x"42";
							elsif addrcnt(26) = x"57" then
								addrcnt(26) <= x"4d";
							elsif addrcnt(26) = x"62" then
								addrcnt(26) <= x"58";
							elsif addrcnt(26) = x"6d" then
								addrcnt(26) <= x"63";
							elsif addrcnt(26) = x"78" then
								addrcnt(26) <= x"6e";
							elsif addrcnt(26) = x"83" then
								addrcnt(26) <= x"79";
							elsif addrcnt(26) = x"8e" then
								addrcnt(26) <= x"84";
							elsif addrcnt(26) = x"99" then
								addrcnt(26) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 >= "001101" )and (p2_c3 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
						if(((p2_c4 >= "001101" )and (p2_c4 <= "011001")) or ((p2_c5 >= "001101" )and (p2_c5 <= "011001"))or ((p2_c6 >= "001101" )and (p2_c6 <= "011001"))) then
							if addrcnt(27) = x"0a" then
								addrcnt(27) <= (others => '0');
							elsif addrcnt(27) = x"15" then
								addrcnt(27) <= x"0b";
							elsif addrcnt(27) = x"20" then
								addrcnt(27) <= x"16";
							elsif addrcnt(27) = x"2b" then
								addrcnt(27) <= x"21";
							elsif addrcnt(27) = x"36" then
								addrcnt(27) <= x"2c";
							elsif addrcnt(27) = x"41" then
								addrcnt(27) <= x"37";
							elsif addrcnt(27) = x"4c" then
								addrcnt(27) <= x"42";
							elsif addrcnt(27) = x"57" then
								addrcnt(27) <= x"4d";
							elsif addrcnt(27) = x"62" then
								addrcnt(27) <= x"58";
							elsif addrcnt(27) = x"6d" then
								addrcnt(27) <= x"63";
							elsif addrcnt(27) = x"78" then
								addrcnt(27) <= x"6e";
							elsif addrcnt(27) = x"83" then
								addrcnt(27) <= x"79";
							elsif addrcnt(27) = x"8e" then
								addrcnt(27) <= x"84";
							elsif addrcnt(27) = x"99" then
								addrcnt(27) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 >= "011010" )and (p2_c3 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
						if(((p2_c4 >= "011010" )and (p2_c4 <= "100110")) or ((p2_c5 >= "011010" )and (p2_c5 <= "100110"))or ((p2_c6 >= "011010" )and (p2_c6 <= "100110"))) then
							if addrcnt(28) = x"0a" then
								addrcnt(28) <= (others => '0');
							elsif addrcnt(28) = x"15" then
								addrcnt(28) <= x"0b";
							elsif addrcnt(28) = x"20" then
								addrcnt(28) <= x"16";
							elsif addrcnt(28) = x"2b" then
								addrcnt(28) <= x"21";
							elsif addrcnt(28) = x"36" then
								addrcnt(28) <= x"2c";
							elsif addrcnt(28) = x"41" then
								addrcnt(28) <= x"37";
							elsif addrcnt(28) = x"4c" then
								addrcnt(28) <= x"42";
							elsif addrcnt(28) = x"57" then
								addrcnt(28) <= x"4d";
							elsif addrcnt(28) = x"62" then
								addrcnt(28) <= x"58";
							elsif addrcnt(28) = x"6d" then
								addrcnt(28) <= x"63";
							elsif addrcnt(28) = x"78" then
								addrcnt(28) <= x"6e";
							elsif addrcnt(28) = x"83" then
								addrcnt(28) <= x"79";
							elsif addrcnt(28) = x"8e" then
								addrcnt(28) <= x"84";
							elsif addrcnt(28) = x"99" then
								addrcnt(28) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 >= "100111" )and (p2_c3 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
						if(((p2_c4 >= "100111" )and (p2_c4 <= "110011")) or ((p2_c5 >= "100111" )and (p2_c5 <= "110011"))or ((p2_c6 >= "100111" )and (p2_c6 <= "110011"))) then
							if addrcnt(29) = x"0a" then
								addrcnt(29) <= (others => '0');
							elsif addrcnt(29) = x"15" then
								addrcnt(29) <= x"0b";
							elsif addrcnt(29) = x"20" then
								addrcnt(29) <= x"16";
							elsif addrcnt(29) = x"2b" then
								addrcnt(29) <= x"21";
							elsif addrcnt(29) = x"36" then
								addrcnt(29) <= x"2c";
							elsif addrcnt(29) = x"41" then
								addrcnt(29) <= x"37";
							elsif addrcnt(29) = x"4c" then
								addrcnt(29) <= x"42";
							elsif addrcnt(29) = x"57" then
								addrcnt(29) <= x"4d";
							elsif addrcnt(29) = x"62" then
								addrcnt(29) <= x"58";
							elsif addrcnt(29) = x"6d" then
								addrcnt(29) <= x"63";
							elsif addrcnt(29) = x"78" then
								addrcnt(29) <= x"6e";
							elsif addrcnt(29) = x"83" then
								addrcnt(29) <= x"79";
							elsif addrcnt(29) = x"8e" then
								addrcnt(29) <= x"84";
							elsif addrcnt(29) = x"99" then
								addrcnt(29) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +442 ) ) and ( hsync_cnt <= (tHW + tHBP +452)) ) then
					if (p2_c4 >= "000000" )and (p2_c4 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
						if(((p2_c5 >= "000000" )and (p2_c5 <= "001100"))or ((p2_c6 >= "000000" )and (p2_c6 <= "001100"))) then
							if addrcnt(26) = x"0a" then
								addrcnt(26) <= (others => '0');
							elsif addrcnt(26) = x"15" then
								addrcnt(26) <= x"0b";
							elsif addrcnt(26) = x"20" then
								addrcnt(26) <= x"16";
							elsif addrcnt(26) = x"2b" then
								addrcnt(26) <= x"21";
							elsif addrcnt(26) = x"36" then
								addrcnt(26) <= x"2c";
							elsif addrcnt(26) = x"41" then
								addrcnt(26) <= x"37";
							elsif addrcnt(26) = x"4c" then
								addrcnt(26) <= x"42";
							elsif addrcnt(26) = x"57" then
								addrcnt(26) <= x"4d";
							elsif addrcnt(26) = x"62" then
								addrcnt(26) <= x"58";
							elsif addrcnt(26) = x"6d" then
								addrcnt(26) <= x"63";
							elsif addrcnt(26) = x"78" then
								addrcnt(26) <= x"6e";
							elsif addrcnt(26) = x"83" then
								addrcnt(26) <= x"79";
							elsif addrcnt(26) = x"8e" then
								addrcnt(26) <= x"84";
							elsif addrcnt(26) = x"99" then
								addrcnt(26) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 >= "001101" )and (p2_c4 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
						if(((p2_c5 >= "001101" )and (p2_c5 <= "011001"))or ((p2_c6 >= "001101" )and (p2_c6 <= "011001"))) then
							if addrcnt(27) = x"0a" then
								addrcnt(27) <= (others => '0');
							elsif addrcnt(27) = x"15" then
								addrcnt(27) <= x"0b";
							elsif addrcnt(27) = x"20" then
								addrcnt(27) <= x"16";
							elsif addrcnt(27) = x"2b" then
								addrcnt(27) <= x"21";
							elsif addrcnt(27) = x"36" then
								addrcnt(27) <= x"2c";
							elsif addrcnt(27) = x"41" then
								addrcnt(27) <= x"37";
							elsif addrcnt(27) = x"4c" then
								addrcnt(27) <= x"42";
							elsif addrcnt(27) = x"57" then
								addrcnt(27) <= x"4d";
							elsif addrcnt(27) = x"62" then
								addrcnt(27) <= x"58";
							elsif addrcnt(27) = x"6d" then
								addrcnt(27) <= x"63";
							elsif addrcnt(27) = x"78" then
								addrcnt(27) <= x"6e";
							elsif addrcnt(27) = x"83" then
								addrcnt(27) <= x"79";
							elsif addrcnt(27) = x"8e" then
								addrcnt(27) <= x"84";
							elsif addrcnt(27) = x"99" then
								addrcnt(27) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 >= "011010" )and (p2_c4 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
						if(((p2_c5 >= "011010" )and (p2_c5 <= "100110"))or ((p2_c6 >= "011010" )and (p2_c6 <= "100110"))) then
							if addrcnt(28) = x"0a" then
								addrcnt(28) <= (others => '0');
							elsif addrcnt(28) = x"15" then
								addrcnt(28) <= x"0b";
							elsif addrcnt(28) = x"20" then
								addrcnt(28) <= x"16";
							elsif addrcnt(28) = x"2b" then
								addrcnt(28) <= x"21";
							elsif addrcnt(28) = x"36" then
								addrcnt(28) <= x"2c";
							elsif addrcnt(28) = x"41" then
								addrcnt(28) <= x"37";
							elsif addrcnt(28) = x"4c" then
								addrcnt(28) <= x"42";
							elsif addrcnt(28) = x"57" then
								addrcnt(28) <= x"4d";
							elsif addrcnt(28) = x"62" then
								addrcnt(28) <= x"58";
							elsif addrcnt(28) = x"6d" then
								addrcnt(28) <= x"63";
							elsif addrcnt(28) = x"78" then
								addrcnt(28) <= x"6e";
							elsif addrcnt(28) = x"83" then
								addrcnt(28) <= x"79";
							elsif addrcnt(28) = x"8e" then
								addrcnt(28) <= x"84";
							elsif addrcnt(28) = x"99" then
								addrcnt(28) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 >= "100111" )and (p2_c4 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
						if(((p2_c5 >= "100111" )and (p2_c5 <= "110011"))or ((p2_c6 >= "100111" )and (p2_c6 <= "110011"))) then
							if addrcnt(29) = x"0a" then
								addrcnt(29) <= (others => '0');
							elsif addrcnt(29) = x"15" then
								addrcnt(29) <= x"0b";
							elsif addrcnt(29) = x"20" then
								addrcnt(29) <= x"16";
							elsif addrcnt(29) = x"2b" then
								addrcnt(29) <= x"21";
							elsif addrcnt(29) = x"36" then
								addrcnt(29) <= x"2c";
							elsif addrcnt(29) = x"41" then
								addrcnt(29) <= x"37";
							elsif addrcnt(29) = x"4c" then
								addrcnt(29) <= x"42";
							elsif addrcnt(29) = x"57" then
								addrcnt(29) <= x"4d";
							elsif addrcnt(29) = x"62" then
								addrcnt(29) <= x"58";
							elsif addrcnt(29) = x"6d" then
								addrcnt(29) <= x"63";
							elsif addrcnt(29) = x"78" then
								addrcnt(29) <= x"6e";
							elsif addrcnt(29) = x"83" then
								addrcnt(29) <= x"79";
							elsif addrcnt(29) = x"8e" then
								addrcnt(29) <= x"84";
							elsif addrcnt(29) = x"99" then
								addrcnt(29) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +453 ) ) and ( hsync_cnt <= (tHW + tHBP +463)) ) then
					if (p2_c5 >= "000000" )and (p2_c5 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
						if(((p2_c6 >= "000000" )and (p2_c6 <= "001100"))) then
							if addrcnt(26) = x"0a" then
								addrcnt(26) <= (others => '0');
							elsif addrcnt(26) = x"15" then
								addrcnt(26) <= x"0b";
							elsif addrcnt(26) = x"20" then
								addrcnt(26) <= x"16";
							elsif addrcnt(26) = x"2b" then
								addrcnt(26) <= x"21";
							elsif addrcnt(26) = x"36" then
								addrcnt(26) <= x"2c";
							elsif addrcnt(26) = x"41" then
								addrcnt(26) <= x"37";
							elsif addrcnt(26) = x"4c" then
								addrcnt(26) <= x"42";
							elsif addrcnt(26) = x"57" then
								addrcnt(26) <= x"4d";
							elsif addrcnt(26) = x"62" then
								addrcnt(26) <= x"58";
							elsif addrcnt(26) = x"6d" then
								addrcnt(26) <= x"63";
							elsif addrcnt(26) = x"78" then
								addrcnt(26) <= x"6e";
							elsif addrcnt(26) = x"83" then
								addrcnt(26) <= x"79";
							elsif addrcnt(26) = x"8e" then
								addrcnt(26) <= x"84";
							elsif addrcnt(26) = x"99" then
								addrcnt(26) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 >= "001101" )and (p2_c5 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
						if(((p2_c6 >= "001101" )and (p2_c6 <= "011001"))) then
							if addrcnt(27) = x"0a" then
								addrcnt(27) <= (others => '0');
							elsif addrcnt(27) = x"15" then
								addrcnt(27) <= x"0b";
							elsif addrcnt(27) = x"20" then
								addrcnt(27) <= x"16";
							elsif addrcnt(27) = x"2b" then
								addrcnt(27) <= x"21";
							elsif addrcnt(27) = x"36" then
								addrcnt(27) <= x"2c";
							elsif addrcnt(27) = x"41" then
								addrcnt(27) <= x"37";
							elsif addrcnt(27) = x"4c" then
								addrcnt(27) <= x"42";
							elsif addrcnt(27) = x"57" then
								addrcnt(27) <= x"4d";
							elsif addrcnt(27) = x"62" then
								addrcnt(27) <= x"58";
							elsif addrcnt(27) = x"6d" then
								addrcnt(27) <= x"63";
							elsif addrcnt(27) = x"78" then
								addrcnt(27) <= x"6e";
							elsif addrcnt(27) = x"83" then
								addrcnt(27) <= x"79";
							elsif addrcnt(27) = x"8e" then
								addrcnt(27) <= x"84";
							elsif addrcnt(27) = x"99" then
								addrcnt(27) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 >= "011010" )and (p2_c5 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
						if(((p2_c6 >= "011010" )and (p2_c6 <= "100110"))) then
							if addrcnt(28) = x"0a" then
								addrcnt(28) <= (others => '0');
							elsif addrcnt(28) = x"15" then
								addrcnt(28) <= x"0b";
							elsif addrcnt(28) = x"20" then
								addrcnt(28) <= x"16";
							elsif addrcnt(28) = x"2b" then
								addrcnt(28) <= x"21";
							elsif addrcnt(28) = x"36" then
								addrcnt(28) <= x"2c";
							elsif addrcnt(28) = x"41" then
								addrcnt(28) <= x"37";
							elsif addrcnt(28) = x"4c" then
								addrcnt(28) <= x"42";
							elsif addrcnt(28) = x"57" then
								addrcnt(28) <= x"4d";
							elsif addrcnt(28) = x"62" then
								addrcnt(28) <= x"58";
							elsif addrcnt(28) = x"6d" then
								addrcnt(28) <= x"63";
							elsif addrcnt(28) = x"78" then
								addrcnt(28) <= x"6e";
							elsif addrcnt(28) = x"83" then
								addrcnt(28) <= x"79";
							elsif addrcnt(28) = x"8e" then
								addrcnt(28) <= x"84";
							elsif addrcnt(28) = x"99" then
								addrcnt(28) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 >= "100111" )and (p2_c5 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
						if(((p2_c6 >= "100111" )and (p2_c6 <= "110011"))) then
							if addrcnt(29) = x"0a" then
								addrcnt(29) <= (others => '0');
							elsif addrcnt(29) = x"15" then
								addrcnt(29) <= x"0b";
							elsif addrcnt(29) = x"20" then
								addrcnt(29) <= x"16";
							elsif addrcnt(29) = x"2b" then
								addrcnt(29) <= x"21";
							elsif addrcnt(29) = x"36" then
								addrcnt(29) <= x"2c";
							elsif addrcnt(29) = x"41" then
								addrcnt(29) <= x"37";
							elsif addrcnt(29) = x"4c" then
								addrcnt(29) <= x"42";
							elsif addrcnt(29) = x"57" then
								addrcnt(29) <= x"4d";
							elsif addrcnt(29) = x"62" then
								addrcnt(29) <= x"58";
							elsif addrcnt(29) = x"6d" then
								addrcnt(29) <= x"63";
							elsif addrcnt(29) = x"78" then
								addrcnt(29) <= x"6e";
							elsif addrcnt(29) = x"83" then
								addrcnt(29) <= x"79";
							elsif addrcnt(29) = x"8e" then
								addrcnt(29) <= x"84";
							elsif addrcnt(29) = x"99" then
								addrcnt(29) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +464 ) ) and ( hsync_cnt <= (tHW + tHBP +474)) ) then
					if (p2_c6 >= "000000" )and (p2_c6 <= "001100") then --spade
						addrcnt(26) <= addrcnt(26) + '1';
						rgb_data <= b_data(26) & g_data(26) & r_data(26);
					elsif (p2_c6 >= "001101" )and (p2_c6 <= "011001") then --clover
						addrcnt(27) <= addrcnt(27) + '1';
						rgb_data <= b_data(27) & g_data(27) & r_data(27);
					elsif (p2_c6 >= "011010" )and (p2_c6 <= "100110") then --heart
						addrcnt(28) <= addrcnt(28) + '1';
						rgb_data <= b_data(28) & g_data(28) & r_data(28);
					elsif (p2_c6 >= "100111" )and (p2_c6 <= "110011") then --dia
						addrcnt(29) <= addrcnt(29) + '1';
						rgb_data <= b_data(29) & g_data(29) & r_data(29);
					elsif (p2_c3 = "111111") then
						if ((hsync_cnt >= (tHW + tHBP +464 ) ) and ( hsync_cnt <= (tHW + tHBP +470)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +475 ) ) and ( hsync_cnt <= (tHW + tHBP +514)) ) then
					if (p2_c3 /= "111111") then
						if ((hsync_cnt >= (tHW + tHBP +475 ) ) and ( hsync_cnt <= (tHW + tHBP +481)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
					if (p2_c4 /= "111111") then	
						if ((hsync_cnt >= (tHW + tHBP +482 ) ) and ( hsync_cnt <= (tHW + tHBP +492)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
					if (p2_c5 /= "111111") then	
						if ((hsync_cnt >= (tHW + tHBP +493 ) ) and ( hsync_cnt <= (tHW + tHBP +503)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
					if (p2_c6 /= "111111") then	
						if ((hsync_cnt >= (tHW + tHBP +504 ) ) and ( hsync_cnt <= (tHW + tHBP +514)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
				else
					rgb_data <= "00000" & "001110" & "00000";
				end if;
			elsif (( vsync_cnt >= (tVW + tVBP + 305) ) and ( vsync_cnt <= (tVW + tVBP + 306) ) ) then
				if ((hsync_cnt >= (tHW + tHBP +100 ) ) and ( hsync_cnt <= (tHW + tHBP +160)) ) then
					rgb_data <= (others => '1');
				elsif( (hsync_cnt >= (tHW + tHBP +399 ) ) and ( hsync_cnt <= (tHW + tHBP +400)) ) then --가운데 세로줄
					rgb_data <= (others => '1');
				elsif ((hsync_cnt >= (tHW + tHBP +409 ) ) and ( hsync_cnt <= (tHW + tHBP +469)) ) then
					rgb_data <= (others => '1');
				else
					rgb_data <= "00000" & "001110" & "00000";
				end if;
			elsif (( vsync_cnt >= (tVW + tVBP + 307) ) and ( vsync_cnt <= (tVW + tVBP + 321) ) ) then -- 플레이어 숫자
				if ((hsync_cnt >= (tHW + tHBP +100 ) ) and ( hsync_cnt <= (tHW + tHBP +110)) ) then
					if (p1_c1 = "000000" )or (p1_c1 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
						if(((p1_c2 = "000000" ) or (p1_c2 = "001101")) or ((p1_c3 = "000000" )or (p1_c3 = "001101")) or ((p1_c4 = "000000" )or (p1_c4 = "001101"))
						or ((p1_c5 = "000000" )or (p1_c5 = "001101"))or ((p1_c6 = "000000" )or (p1_c6 = "001101"))or ((p2_c1 = "000000" )or (p2_c1 = "001101"))
						or ((p2_c2 = "000000" )or (p2_c2 = "001101"))) then
							if addrcnt(0) = x"0a" then
								addrcnt(0) <= (others => '0');
							elsif addrcnt(0) = x"15" then
								addrcnt(0) <= x"0b";
							elsif addrcnt(0) = x"20" then
								addrcnt(0) <= x"16";
							elsif addrcnt(0) = x"2b" then
								addrcnt(0) <= x"21";
							elsif addrcnt(0) = x"36" then
								addrcnt(0) <= x"2c";
							elsif addrcnt(0) = x"41" then
								addrcnt(0) <= x"37";
							elsif addrcnt(0) = x"4c" then
								addrcnt(0) <= x"42";
							elsif addrcnt(0) = x"57" then
								addrcnt(0) <= x"4d";
							elsif addrcnt(0) = x"62" then
								addrcnt(0) <= x"58";
							elsif addrcnt(0) = x"6d" then
								addrcnt(0) <= x"63";
							elsif addrcnt(0) = x"78" then
								addrcnt(0) <= x"6e";
							elsif addrcnt(0) = x"83" then
								addrcnt(0) <= x"79";
							elsif addrcnt(0) = x"8e" then
								addrcnt(0) <= x"84";
							elsif addrcnt(0) = x"99" then
								addrcnt(0) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "000001" )or (p1_c1 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
						if(((p1_c2 = "000001" ) or (p1_c2 = "001110")) or ((p1_c3 = "000001" )or (p1_c3 = "001110")) or ((p1_c4 = "000001" )or (p1_c4 = "001110"))
						or ((p1_c5 = "000001" )or (p1_c5 = "001110"))or ((p1_c6 = "000001" )or (p1_c6 = "001110"))or ((p2_c1 = "000001" )or (p2_c1 = "001110"))
						or ((p2_c2 = "000001" )or (p2_c2 = "001110"))) then
							if addrcnt(1) = x"0a" then
								addrcnt(1) <= (others => '0');
							elsif addrcnt(1) = x"15" then
								addrcnt(1) <= x"0b";
							elsif addrcnt(1) = x"20" then
								addrcnt(1) <= x"16";
							elsif addrcnt(1) = x"2b" then
								addrcnt(1) <= x"21";
							elsif addrcnt(1) = x"36" then
								addrcnt(1) <= x"2c";
							elsif addrcnt(1) = x"41" then
								addrcnt(1) <= x"37";
							elsif addrcnt(1) = x"4c" then
								addrcnt(1) <= x"42";
							elsif addrcnt(1) = x"57" then
								addrcnt(1) <= x"4d";
							elsif addrcnt(1) = x"62" then
								addrcnt(1) <= x"58";
							elsif addrcnt(1) = x"6d" then
								addrcnt(1) <= x"63";
							elsif addrcnt(1) = x"78" then
								addrcnt(1) <= x"6e";
							elsif addrcnt(1) = x"83" then
								addrcnt(1) <= x"79";
							elsif addrcnt(1) = x"8e" then
								addrcnt(1) <= x"84";
							elsif addrcnt(1) = x"99" then
								addrcnt(1) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "000010" )or (p1_c1 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
						if(((p1_c2 = "000010" ) or (p1_c2 = "001111")) or ((p1_c3 = "000010" )or (p1_c3 = "001111")) or ((p1_c4 = "000010" )or (p1_c4 = "001111"))
						or ((p1_c5 = "000010" )or (p1_c5 = "001111"))or ((p1_c6 = "000010" )or (p1_c6 = "001111"))or ((p2_c1 = "000010" )or (p2_c1 = "001111"))
						or ((p2_c2 = "000010" )or (p2_c2 = "001111"))) then
							if addrcnt(2) = x"0a" then
								addrcnt(2) <= (others => '0');
							elsif addrcnt(2) = x"15" then
								addrcnt(2) <= x"0b";
							elsif addrcnt(2) = x"20" then
								addrcnt(2) <= x"16";
							elsif addrcnt(2) = x"2b" then
								addrcnt(2) <= x"21";
							elsif addrcnt(2) = x"36" then
								addrcnt(2) <= x"2c";
							elsif addrcnt(2) = x"41" then
								addrcnt(2) <= x"37";
							elsif addrcnt(2) = x"4c" then
								addrcnt(2) <= x"42";
							elsif addrcnt(2) = x"57" then
								addrcnt(2) <= x"4d";
							elsif addrcnt(2) = x"62" then
								addrcnt(2) <= x"58";
							elsif addrcnt(2) = x"6d" then
								addrcnt(2) <= x"63";
							elsif addrcnt(2) = x"78" then
								addrcnt(2) <= x"6e";
							elsif addrcnt(2) = x"83" then
								addrcnt(2) <= x"79";
							elsif addrcnt(2) = x"8e" then
								addrcnt(2) <= x"84";
							elsif addrcnt(2) = x"99" then
								addrcnt(2) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "000011" )or (p1_c1 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
						if(((p1_c2 = "000011" ) or (p1_c2 = "010000")) or ((p1_c3 = "000011" )or (p1_c3 = "010000")) or ((p1_c4 = "000011" )or (p1_c4 = "010000"))
						or ((p1_c5 = "000011" )or (p1_c5 = "010000"))or ((p1_c6 = "000011" )or (p1_c6 = "010000"))or ((p2_c1 = "000011" )or (p2_c1 = "010000"))
						or ((p2_c2 = "000011" )or (p2_c2 = "010000"))) then
							if addrcnt(3) = x"0a" then
								addrcnt(3) <= (others => '0');
							elsif addrcnt(3) = x"15" then
								addrcnt(3) <= x"0b";
							elsif addrcnt(3) = x"20" then
								addrcnt(3) <= x"16";
							elsif addrcnt(3) = x"2b" then
								addrcnt(3) <= x"21";
							elsif addrcnt(3) = x"36" then
								addrcnt(3) <= x"2c";
							elsif addrcnt(3) = x"41" then
								addrcnt(3) <= x"37";
							elsif addrcnt(3) = x"4c" then
								addrcnt(3) <= x"42";
							elsif addrcnt(3) = x"57" then
								addrcnt(3) <= x"4d";
							elsif addrcnt(3) = x"62" then
								addrcnt(3) <= x"58";
							elsif addrcnt(3) = x"6d" then
								addrcnt(3) <= x"63";
							elsif addrcnt(3) = x"78" then
								addrcnt(3) <= x"6e";
							elsif addrcnt(3) = x"83" then
								addrcnt(3) <= x"79";
							elsif addrcnt(3) = x"8e" then
								addrcnt(3) <= x"84";
							elsif addrcnt(3) = x"99" then
								addrcnt(3) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "000100" )or (p1_c1 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);
						if(((p1_c2 = "000100" ) or (p1_c2 = "010001")) or ((p1_c3 = "000100" )or (p1_c3 = "010001")) or ((p1_c4 = "000100" )or (p1_c4 = "010001"))
						or ((p1_c5 = "000100" )or (p1_c5 = "010001"))or ((p1_c6 = "000100" )or (p1_c6 = "010001"))or ((p2_c1 = "000100" )or (p2_c1 = "010001"))
						or ((p2_c2 = "000100" )or (p2_c2 = "010001"))) then
							if addrcnt(4) = x"0a" then
								addrcnt(4) <= (others => '0');
							elsif addrcnt(4) = x"15" then
								addrcnt(4) <= x"0b";
							elsif addrcnt(4) = x"20" then
								addrcnt(4) <= x"16";
							elsif addrcnt(4) = x"2b" then
								addrcnt(4) <= x"21";
							elsif addrcnt(4) = x"36" then
								addrcnt(4) <= x"2c";
							elsif addrcnt(4) = x"41" then
								addrcnt(4) <= x"37";
							elsif addrcnt(4) = x"4c" then
								addrcnt(4) <= x"42";
							elsif addrcnt(4) = x"57" then
								addrcnt(4) <= x"4d";
							elsif addrcnt(4) = x"62" then
								addrcnt(4) <= x"58";
							elsif addrcnt(4) = x"6d" then
								addrcnt(4) <= x"63";
							elsif addrcnt(4) = x"78" then
								addrcnt(4) <= x"6e";
							elsif addrcnt(4) = x"83" then
								addrcnt(4) <= x"79";
							elsif addrcnt(4) = x"8e" then
								addrcnt(4) <= x"84";
							elsif addrcnt(4) = x"99" then
								addrcnt(4) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "000101" )or (p1_c1 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);
						if(((p1_c2 = "000101" ) or (p1_c2 = "010010")) or ((p1_c3 = "000101" )or (p1_c3 = "010010")) or ((p1_c4 = "000101" )or (p1_c4 = "010010"))
						or ((p1_c5 = "000101" )or (p1_c5 = "010010"))or ((p1_c6 = "000101" )or (p1_c6 = "010010"))or ((p2_c1 = "000101" )or (p2_c1 = "010010"))
						or ((p2_c2 = "000101" )or (p2_c2 = "010010"))) then
							if addrcnt(5) = x"0a" then
								addrcnt(5) <= (others => '0');
							elsif addrcnt(5) = x"15" then
								addrcnt(5) <= x"0b";
							elsif addrcnt(5) = x"20" then
								addrcnt(5) <= x"16";
							elsif addrcnt(5) = x"2b" then
								addrcnt(5) <= x"21";
							elsif addrcnt(5) = x"36" then
								addrcnt(5) <= x"2c";
							elsif addrcnt(5) = x"41" then
								addrcnt(5) <= x"37";
							elsif addrcnt(5) = x"4c" then
								addrcnt(5) <= x"42";
							elsif addrcnt(5) = x"57" then
								addrcnt(5) <= x"4d";
							elsif addrcnt(5) = x"62" then
								addrcnt(5) <= x"58";
							elsif addrcnt(5) = x"6d" then
								addrcnt(5) <= x"63";
							elsif addrcnt(5) = x"78" then
								addrcnt(5) <= x"6e";
							elsif addrcnt(5) = x"83" then
								addrcnt(5) <= x"79";
							elsif addrcnt(5) = x"8e" then
								addrcnt(5) <= x"84";
							elsif addrcnt(5) = x"99" then
								addrcnt(5) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "000110" )or (p1_c1 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);
						if(((p1_c2 = "0000110" ) or (p1_c2 = "010011")) or ((p1_c3 = "0000110" )or (p1_c3 = "010011")) or ((p1_c4 = "0000110" )or (p1_c4 = "010011"))
						or ((p1_c5 = "0000110" )or (p1_c5 = "010011"))or ((p1_c6 = "0000110" )or (p1_c6 = "010011"))or ((p2_c1 = "0000110" )or (p2_c1 = "010011"))
						or ((p2_c2 = "0000110" )or (p2_c2 = "010011"))) then
							if addrcnt(6) = x"0a" then
								addrcnt(6) <= (others => '0');
							elsif addrcnt(6) = x"15" then
								addrcnt(6) <= x"0b";
							elsif addrcnt(6) = x"20" then
								addrcnt(6) <= x"16";
							elsif addrcnt(6) = x"2b" then
								addrcnt(6) <= x"21";
							elsif addrcnt(6) = x"36" then
								addrcnt(6) <= x"2c";
							elsif addrcnt(6) = x"41" then
								addrcnt(6) <= x"37";
							elsif addrcnt(6) = x"4c" then
								addrcnt(6) <= x"42";
							elsif addrcnt(6) = x"57" then
								addrcnt(6) <= x"4d";
							elsif addrcnt(6) = x"62" then
								addrcnt(6) <= x"58";
							elsif addrcnt(6) = x"6d" then
								addrcnt(6) <= x"63";
							elsif addrcnt(6) = x"78" then
								addrcnt(6) <= x"6e";
							elsif addrcnt(6) = x"83" then
								addrcnt(6) <= x"79";
							elsif addrcnt(6) = x"8e" then
								addrcnt(6) <= x"84";
							elsif addrcnt(6) = x"99" then
								addrcnt(6) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "000111" )or (p1_c1 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);
						if(((p1_c2 = "0000111" ) or (p1_c2 = "010100")) or ((p1_c3 = "0000111" )or (p1_c3 = "010100")) or ((p1_c4 = "0000111" )or (p1_c4 = "010100"))
						or ((p1_c5 = "0000111" )or (p1_c5 = "010100"))or ((p1_c6 = "0000111" )or (p1_c6 = "010100"))or ((p2_c1 = "0000111" )or (p2_c1 = "010100"))
						or ((p2_c2 = "0000111" )or (p2_c2 = "010100"))) then
							if addrcnt(7) = x"0a" then
								addrcnt(7) <= (others => '0');
							elsif addrcnt(7) = x"15" then
								addrcnt(7) <= x"0b";
							elsif addrcnt(7) = x"20" then
								addrcnt(7) <= x"16";
							elsif addrcnt(7) = x"2b" then
								addrcnt(7) <= x"21";
							elsif addrcnt(7) = x"36" then
								addrcnt(7) <= x"2c";
							elsif addrcnt(7) = x"41" then
								addrcnt(7) <= x"37";
							elsif addrcnt(7) = x"4c" then
								addrcnt(7) <= x"42";
							elsif addrcnt(7) = x"57" then
								addrcnt(7) <= x"4d";
							elsif addrcnt(7) = x"62" then
								addrcnt(7) <= x"58";
							elsif addrcnt(7) = x"6d" then
								addrcnt(7) <= x"63";
							elsif addrcnt(7) = x"78" then
								addrcnt(7) <= x"6e";
							elsif addrcnt(7) = x"83" then
								addrcnt(7) <= x"79";
							elsif addrcnt(7) = x"8e" then
								addrcnt(7) <= x"84";
							elsif addrcnt(7) = x"99" then
								addrcnt(7) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "001000" )or (p1_c1 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
						if(((p1_c2 = "001000" ) or (p1_c2 = "010101")) or ((p1_c3 = "001000" )or (p1_c3 = "010101")) or ((p1_c4 = "001000" )or (p1_c4 = "010101"))
						or ((p1_c5 = "001000" )or (p1_c5 = "010101"))or ((p1_c6 = "001000" )or (p1_c6 = "010101"))or ((p2_c1 = "001000" )or (p2_c1 = "010101"))
						or ((p2_c2 = "001000" )or (p2_c2 = "010101"))) then
							if addrcnt(8) = x"0a" then
								addrcnt(8) <= (others => '0');
							elsif addrcnt(8) = x"15" then
								addrcnt(8) <= x"0b";
							elsif addrcnt(8) = x"20" then
								addrcnt(8) <= x"16";
							elsif addrcnt(8) = x"2b" then
								addrcnt(8) <= x"21";
							elsif addrcnt(8) = x"36" then
								addrcnt(8) <= x"2c";
							elsif addrcnt(8) = x"41" then
								addrcnt(8) <= x"37";
							elsif addrcnt(8) = x"4c" then
								addrcnt(8) <= x"42";
							elsif addrcnt(8) = x"57" then
								addrcnt(8) <= x"4d";
							elsif addrcnt(8) = x"62" then
								addrcnt(8) <= x"58";
							elsif addrcnt(8) = x"6d" then
								addrcnt(8) <= x"63";
							elsif addrcnt(8) = x"78" then
								addrcnt(8) <= x"6e";
							elsif addrcnt(8) = x"83" then
								addrcnt(8) <= x"79";
							elsif addrcnt(8) = x"8e" then
								addrcnt(8) <= x"84";
							elsif addrcnt(8) = x"99" then
								addrcnt(8) <= x"8f";
							end if;
						end if;
					elsif (p1_c1= "001001" )or (p1_c1 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);
						if(((p1_c2 = "001001" ) or (p1_c2 = "010110")) or ((p1_c3 = "001001" )or (p1_c3 = "010110")) or ((p1_c4 = "001001" )or (p1_c4 = "010110"))
						or ((p1_c5 = "001001" )or (p1_c5 = "010110"))or ((p1_c6 = "001001" )or (p1_c6 = "010110"))or ((p2_c1 = "001001" )or (p2_c1 = "010110"))
						or ((p2_c2 = "001001" )or (p2_c2 = "010110"))) then
							if addrcnt(9) = x"0a" then
								addrcnt(9) <= (others => '0');
							elsif addrcnt(9) = x"15" then
								addrcnt(9) <= x"0b";
							elsif addrcnt(9) = x"20" then
								addrcnt(9) <= x"16";
							elsif addrcnt(9) = x"2b" then
								addrcnt(9) <= x"21";
							elsif addrcnt(9) = x"36" then
								addrcnt(9) <= x"2c";
							elsif addrcnt(9) = x"41" then
								addrcnt(9) <= x"37";
							elsif addrcnt(9) = x"4c" then
								addrcnt(9) <= x"42";
							elsif addrcnt(9) = x"57" then
								addrcnt(9) <= x"4d";
							elsif addrcnt(9) = x"62" then
								addrcnt(9) <= x"58";
							elsif addrcnt(9) = x"6d" then
								addrcnt(9) <= x"63";
							elsif addrcnt(9) = x"78" then
								addrcnt(9) <= x"6e";
							elsif addrcnt(9) = x"83" then
								addrcnt(9) <= x"79";
							elsif addrcnt(9) = x"8e" then
								addrcnt(9) <= x"84";
							elsif addrcnt(9) = x"99" then
								addrcnt(9) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "001010" )or (p1_c1 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);
						if(((p1_c2 = "001010" ) or (p1_c2 = "010111")) or ((p1_c3 = "001010" )or (p1_c3 = "010111")) or ((p1_c4 = "001010" )or (p1_c4 = "010111"))
						or ((p1_c5 = "001010" )or (p1_c5 = "010111"))or ((p1_c6 = "001010" )or (p1_c6 = "010111"))or ((p2_c1 = "001010" )or (p2_c1 = "010111"))
						or ((p2_c2 = "001010" )or (p2_c2 = "010111"))) then
							if addrcnt(10) = x"0a" then
								addrcnt(10) <= (others => '0');
							elsif addrcnt(10) = x"15" then
								addrcnt(10) <= x"0b";
							elsif addrcnt(10) = x"20" then
								addrcnt(10) <= x"16";
							elsif addrcnt(10) = x"2b" then
								addrcnt(10) <= x"21";
							elsif addrcnt(10) = x"36" then
								addrcnt(10) <= x"2c";
							elsif addrcnt(10) = x"41" then
								addrcnt(10) <= x"37";
							elsif addrcnt(10) = x"4c" then
								addrcnt(10) <= x"42";
							elsif addrcnt(10) = x"57" then
								addrcnt(10) <= x"4d";
							elsif addrcnt(10) = x"62" then
								addrcnt(10) <= x"58";
							elsif addrcnt(10) = x"6d" then
								addrcnt(10) <= x"63";
							elsif addrcnt(10) = x"78" then
								addrcnt(10) <= x"6e";
							elsif addrcnt(10) = x"83" then
								addrcnt(10) <= x"79";
							elsif addrcnt(10) = x"8e" then
								addrcnt(10) <= x"84";
							elsif addrcnt(10) = x"99" then
								addrcnt(10) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "001011" )or (p1_c1 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);
						if(((p1_c2 = "001011" ) or (p1_c2 = "011000")) or ((p1_c3 = "001011" )or (p1_c3 = "011000")) or ((p1_c4 = "001011" )or (p1_c4 = "011000"))
						or ((p1_c5 = "001011" )or (p1_c5 = "011000"))or ((p1_c6 = "001011" )or (p1_c6 = "011000"))or ((p2_c1 = "001011" )or (p2_c1 = "011000"))
						or ((p2_c2 = "001011" )or (p2_c2 = "011000"))) then
							if addrcnt(11) = x"0a" then
								addrcnt(11) <= (others => '0');
							elsif addrcnt(11) = x"15" then
								addrcnt(11) <= x"0b";
							elsif addrcnt(11) = x"20" then
								addrcnt(11) <= x"16";
							elsif addrcnt(11) = x"2b" then
								addrcnt(11) <= x"21";
							elsif addrcnt(11) = x"36" then
								addrcnt(11) <= x"2c";
							elsif addrcnt(11) = x"41" then
								addrcnt(11) <= x"37";
							elsif addrcnt(11) = x"4c" then
								addrcnt(11) <= x"42";
							elsif addrcnt(11) = x"57" then
								addrcnt(11) <= x"4d";
							elsif addrcnt(11) = x"62" then
								addrcnt(11) <= x"58";
							elsif addrcnt(11) = x"6d" then
								addrcnt(11) <= x"63";
							elsif addrcnt(11) = x"78" then
								addrcnt(11) <= x"6e";
							elsif addrcnt(11) = x"83" then
								addrcnt(11) <= x"79";
							elsif addrcnt(11) = x"8e" then
								addrcnt(11) <= x"84";
							elsif addrcnt(11) = x"99" then
								addrcnt(11) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "001100" )or (p1_c1 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
						if(((p1_c2 = "001100" ) or (p1_c2 = "011001")) or ((p1_c3 = "001100" )or (p1_c3 = "011001")) or ((p1_c4 = "001100" )or (p1_c4 = "011001"))
						or ((p1_c5 = "001100" )or (p1_c5 = "011001"))or ((p1_c6 = "001100" )or (p1_c6 = "011001"))or ((p2_c1 = "001100" )or (p2_c1 = "011001"))
						or ((p2_c2 = "001100" )or (p2_c2 = "011001"))) then
							if addrcnt(12) = x"0a" then
								addrcnt(12) <= (others => '0');
							elsif addrcnt(12) = x"15" then
								addrcnt(12) <= x"0b";
							elsif addrcnt(12) = x"20" then
								addrcnt(12) <= x"16";
							elsif addrcnt(12) = x"2b" then
								addrcnt(12) <= x"21";
							elsif addrcnt(12) = x"36" then
								addrcnt(12) <= x"2c";
							elsif addrcnt(12) = x"41" then
								addrcnt(12) <= x"37";
							elsif addrcnt(12) = x"4c" then
								addrcnt(12) <= x"42";
							elsif addrcnt(12) = x"57" then
								addrcnt(12) <= x"4d";
							elsif addrcnt(12) = x"62" then
								addrcnt(12) <= x"58";
							elsif addrcnt(12) = x"6d" then
								addrcnt(12) <= x"63";
							elsif addrcnt(12) = x"78" then
								addrcnt(12) <= x"6e";
							elsif addrcnt(12) = x"83" then
								addrcnt(12) <= x"79";
							elsif addrcnt(12) = x"8e" then
								addrcnt(12) <= x"84";
							elsif addrcnt(12) = x"99" then
								addrcnt(12) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "011010" )or (p1_c1 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
						if(((p1_c2 = "011010" ) or (p1_c2 = "100111")) or ((p1_c3 = "011010" )or (p1_c3 = "100111")) or ((p1_c4 = "011010" )or (p1_c4 = "100111"))
						or ((p1_c5 = "011010" )or (p1_c5 = "100111"))or ((p1_c6 = "011010" )or (p1_c6 = "100111"))or ((p2_c1 = "011010" )or (p2_c1 = "100111"))
						or ((p2_c2 = "011010" )or (p2_c2 = "100111"))) then
							if addrcnt(13) = x"0a" then
								addrcnt(13) <= (others => '0');
							elsif addrcnt(13) = x"15" then
								addrcnt(13) <= x"0b";
							elsif addrcnt(13) = x"20" then
								addrcnt(13) <= x"16";
							elsif addrcnt(13) = x"2b" then
								addrcnt(13) <= x"21";
							elsif addrcnt(13) = x"36" then
								addrcnt(13) <= x"2c";
							elsif addrcnt(13) = x"41" then
								addrcnt(13) <= x"37";
							elsif addrcnt(13) = x"4c" then
								addrcnt(13) <= x"42";
							elsif addrcnt(13) = x"57" then
								addrcnt(13) <= x"4d";
							elsif addrcnt(13) = x"62" then
								addrcnt(13) <= x"58";
							elsif addrcnt(13) = x"6d" then
								addrcnt(13) <= x"63";
							elsif addrcnt(13) = x"78" then
								addrcnt(13) <= x"6e";
							elsif addrcnt(13) = x"83" then
								addrcnt(13) <= x"79";
							elsif addrcnt(13) = x"8e" then
								addrcnt(13) <= x"84";
							elsif addrcnt(13) = x"99" then
								addrcnt(13) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "011011" )or (p1_c1 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
						if(((p1_c2 = "011011" ) or (p1_c2 = "101000")) or ((p1_c3 = "011011" )or (p1_c3 = "101000")) or ((p1_c4 = "011011" )or (p1_c4 = "101000"))
						or ((p1_c5 = "011011" )or (p1_c5 = "101000"))or ((p1_c6 = "011011" )or (p1_c6 = "101000"))or ((p2_c1 = "011011" )or (p2_c1 = "101000"))
						or ((p2_c2 = "011011" )or (p2_c2 = "101000"))) then
							if addrcnt(14) = x"0a" then
								addrcnt(14) <= (others => '0');
							elsif addrcnt(14) = x"15" then
								addrcnt(14) <= x"0b";
							elsif addrcnt(14) = x"20" then
								addrcnt(14) <= x"16";
							elsif addrcnt(14) = x"2b" then
								addrcnt(14) <= x"21";
							elsif addrcnt(14) = x"36" then
								addrcnt(14) <= x"2c";
							elsif addrcnt(14) = x"41" then
								addrcnt(14) <= x"37";
							elsif addrcnt(14) = x"4c" then
								addrcnt(14) <= x"42";
							elsif addrcnt(14) = x"57" then
								addrcnt(14) <= x"4d";
							elsif addrcnt(14) = x"62" then
								addrcnt(14) <= x"58";
							elsif addrcnt(14) = x"6d" then
								addrcnt(14) <= x"63";
							elsif addrcnt(14) = x"78" then
								addrcnt(14) <= x"6e";
							elsif addrcnt(14) = x"83" then
								addrcnt(14) <= x"79";
							elsif addrcnt(14) = x"8e" then
								addrcnt(14) <= x"84";
							elsif addrcnt(14) = x"99" then
								addrcnt(14) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "011100" )or (p1_c1 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
						if(((p1_c2 = "011100" ) or (p1_c2 = "101001")) or ((p1_c3 = "011100" )or (p1_c3 = "101001")) or ((p1_c4 = "011100" )or (p1_c4 = "101001"))
						or ((p1_c5 = "011100" )or (p1_c5 = "101001"))or ((p1_c6 = "011100" )or (p1_c6 = "101001"))or ((p2_c1 = "011100" )or (p2_c1 = "101001"))
						or ((p2_c2 = "011100" )or (p2_c2 = "101001"))) then
							if addrcnt(15) = x"0a" then
								addrcnt(15) <= (others => '0');
							elsif addrcnt(15) = x"15" then
								addrcnt(15) <= x"0b";
							elsif addrcnt(15) = x"20" then
								addrcnt(15) <= x"16";
							elsif addrcnt(15) = x"2b" then
								addrcnt(15) <= x"21";
							elsif addrcnt(15) = x"36" then
								addrcnt(15) <= x"2c";
							elsif addrcnt(15) = x"41" then
								addrcnt(15) <= x"37";
							elsif addrcnt(15) = x"4c" then
								addrcnt(15) <= x"42";
							elsif addrcnt(15) = x"57" then
								addrcnt(15) <= x"4d";
							elsif addrcnt(15) = x"62" then
								addrcnt(15) <= x"58";
							elsif addrcnt(15) = x"6d" then
								addrcnt(15) <= x"63";
							elsif addrcnt(15) = x"78" then
								addrcnt(15) <= x"6e";
							elsif addrcnt(15) = x"83" then
								addrcnt(15) <= x"79";
							elsif addrcnt(15) = x"8e" then
								addrcnt(15) <= x"84";
							elsif addrcnt(15) = x"99" then
								addrcnt(15) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "011101" )or (p1_c1 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
						if(((p1_c2 = "011101" ) or (p1_c2 = "101010")) or ((p1_c3 = "011101" )or (p1_c3 = "101010")) or ((p1_c4 = "011101" )or (p1_c4 = "101010"))
						or ((p1_c5 = "011101" )or (p1_c5 = "101010"))or ((p1_c6 = "011101" )or (p1_c6 = "101010"))or ((p2_c1 = "011101" )or (p2_c1 = "101010"))
						or ((p2_c2 = "011101" )or (p2_c2 = "101010"))) then
							if addrcnt(16) = x"0a" then
								addrcnt(16) <= (others => '0');
							elsif addrcnt(16) = x"15" then
								addrcnt(16) <= x"0b";
							elsif addrcnt(16) = x"20" then
								addrcnt(16) <= x"16";
							elsif addrcnt(16) = x"2b" then
								addrcnt(16) <= x"21";
							elsif addrcnt(16) = x"36" then
								addrcnt(16) <= x"2c";
							elsif addrcnt(16) = x"41" then
								addrcnt(16) <= x"37";
							elsif addrcnt(16) = x"4c" then
								addrcnt(16) <= x"42";
							elsif addrcnt(16) = x"57" then
								addrcnt(16) <= x"4d";
							elsif addrcnt(16) = x"62" then
								addrcnt(16) <= x"58";
							elsif addrcnt(16) = x"6d" then
								addrcnt(16) <= x"63";
							elsif addrcnt(16) = x"78" then
								addrcnt(16) <= x"6e";
							elsif addrcnt(16) = x"83" then
								addrcnt(16) <= x"79";
							elsif addrcnt(16) = x"8e" then
								addrcnt(16) <= x"84";
							elsif addrcnt(16) = x"99" then
								addrcnt(16) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "011110" )or (p1_c1 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);
						if(((p1_c2 = "011110" ) or (p1_c2 = "101011")) or ((p1_c3 = "011110" )or (p1_c3 = "101011")) or ((p1_c4 = "011110" )or (p1_c4 = "101011"))
						or ((p1_c5 = "011110" )or (p1_c5 = "101011"))or ((p1_c6 = "011110" )or (p1_c6 = "101011"))or ((p2_c1 = "011110" )or (p2_c1 = "101011"))
						or ((p2_c2 = "011110" )or (p2_c2 = "101011"))) then
							if addrcnt(17) = x"0a" then
								addrcnt(17) <= (others => '0');
							elsif addrcnt(17) = x"15" then
								addrcnt(17) <= x"0b";
							elsif addrcnt(17) = x"20" then
								addrcnt(17) <= x"16";
							elsif addrcnt(17) = x"2b" then
								addrcnt(17) <= x"21";
							elsif addrcnt(17) = x"36" then
								addrcnt(17) <= x"2c";
							elsif addrcnt(17) = x"41" then
								addrcnt(17) <= x"37";
							elsif addrcnt(17) = x"4c" then
								addrcnt(17) <= x"42";
							elsif addrcnt(17) = x"57" then
								addrcnt(17) <= x"4d";
							elsif addrcnt(17) = x"62" then
								addrcnt(17) <= x"58";
							elsif addrcnt(17) = x"6d" then
								addrcnt(17) <= x"63";
							elsif addrcnt(17) = x"78" then
								addrcnt(17) <= x"6e";
							elsif addrcnt(17) = x"83" then
								addrcnt(17) <= x"79";
							elsif addrcnt(17) = x"8e" then
								addrcnt(17) <= x"84";
							elsif addrcnt(17) = x"99" then
								addrcnt(17) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "011111" )or (p1_c1 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);
						if(((p1_c2 = "011111" ) or (p1_c2 = "101100")) or ((p1_c3 = "011111" )or (p1_c3 = "101100")) or ((p1_c4 = "011111" )or (p1_c4 = "101100"))
						or ((p1_c5 = "011111" )or (p1_c5 = "101100"))or ((p1_c6 = "011111" )or (p1_c6 = "101100"))or ((p2_c1 = "011111" )or (p2_c1 = "101100"))
						or ((p2_c2 = "011111" )or (p2_c2 = "101100"))) then
							if addrcnt(18) = x"0a" then
								addrcnt(18) <= (others => '0');
							elsif addrcnt(18) = x"15" then
								addrcnt(18) <= x"0b";
							elsif addrcnt(18) = x"20" then
								addrcnt(18) <= x"16";
							elsif addrcnt(18) = x"2b" then
								addrcnt(18) <= x"21";
							elsif addrcnt(18) = x"36" then
								addrcnt(18) <= x"2c";
							elsif addrcnt(18) = x"41" then
								addrcnt(18) <= x"37";
							elsif addrcnt(18) = x"4c" then
								addrcnt(18) <= x"42";
							elsif addrcnt(18) = x"57" then
								addrcnt(18) <= x"4d";
							elsif addrcnt(18) = x"62" then
								addrcnt(18) <= x"58";
							elsif addrcnt(18) = x"6d" then
								addrcnt(18) <= x"63";
							elsif addrcnt(18) = x"78" then
								addrcnt(18) <= x"6e";
							elsif addrcnt(18) = x"83" then
								addrcnt(18) <= x"79";
							elsif addrcnt(18) = x"8e" then
								addrcnt(18) <= x"84";
							elsif addrcnt(18) = x"99" then
								addrcnt(18) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "100000" )or (p1_c1 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
						if(((p1_c2 = "100000" ) or (p1_c2 = "101101")) or ((p1_c3 = "100000" )or (p1_c3 = "101101")) or ((p1_c4 = "100000" )or (p1_c4 = "101101"))
						or ((p1_c5 = "100000" )or (p1_c5 = "101101"))or ((p1_c6 = "100000" )or (p1_c6 = "101101"))or ((p2_c1 = "100000" )or (p2_c1 = "101101"))
						or ((p2_c2 = "100000" )or (p2_c2 = "101101"))) then
							if addrcnt(19) = x"0a" then
								addrcnt(19) <= (others => '0');
							elsif addrcnt(19) = x"15" then
								addrcnt(19) <= x"0b";
							elsif addrcnt(19) = x"20" then
								addrcnt(19) <= x"16";
							elsif addrcnt(19) = x"2b" then
								addrcnt(19) <= x"21";
							elsif addrcnt(19) = x"36" then
								addrcnt(19) <= x"2c";
							elsif addrcnt(19) = x"41" then
								addrcnt(19) <= x"37";
							elsif addrcnt(19) = x"4c" then
								addrcnt(19) <= x"42";
							elsif addrcnt(19) = x"57" then
								addrcnt(19) <= x"4d";
							elsif addrcnt(19) = x"62" then
								addrcnt(19) <= x"58";
							elsif addrcnt(19) = x"6d" then
								addrcnt(19) <= x"63";
							elsif addrcnt(19) = x"78" then
								addrcnt(19) <= x"6e";
							elsif addrcnt(19) = x"83" then
								addrcnt(19) <= x"79";
							elsif addrcnt(19) = x"8e" then
								addrcnt(19) <= x"84";
							elsif addrcnt(19) = x"99" then
								addrcnt(19) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "100001" )or (p1_c1 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
						if(((p1_c2 = "100001" ) or (p1_c2 = "101110")) or ((p1_c3 = "100001" )or (p1_c3 = "101110")) or ((p1_c4 = "100001" )or (p1_c4 = "101110"))
						or ((p1_c5 = "100001" )or (p1_c5 = "101110"))or ((p1_c6 = "100001" )or (p1_c6 = "101110"))or ((p2_c1 = "100001" )or (p2_c1 = "101110"))
						or ((p2_c2 = "100001" )or (p2_c2 = "101110"))) then
							if addrcnt(20) = x"0a" then
								addrcnt(20) <= (others => '0');
							elsif addrcnt(20) = x"15" then
								addrcnt(20) <= x"0b";
							elsif addrcnt(20) = x"20" then
								addrcnt(20) <= x"16";
							elsif addrcnt(20) = x"2b" then
								addrcnt(20) <= x"21";
							elsif addrcnt(20) = x"36" then
								addrcnt(20) <= x"2c";
							elsif addrcnt(20) = x"41" then
								addrcnt(20) <= x"37";
							elsif addrcnt(20) = x"4c" then
								addrcnt(20) <= x"42";
							elsif addrcnt(20) = x"57" then
								addrcnt(20) <= x"4d";
							elsif addrcnt(20) = x"62" then
								addrcnt(20) <= x"58";
							elsif addrcnt(20) = x"6d" then
								addrcnt(20) <= x"63";
							elsif addrcnt(20) = x"78" then
								addrcnt(20) <= x"6e";
							elsif addrcnt(20) = x"83" then
								addrcnt(20) <= x"79";
							elsif addrcnt(20) = x"8e" then
								addrcnt(20) <= x"84";
							elsif addrcnt(20) = x"99" then
								addrcnt(20) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "100010" )or (p1_c1 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
						if(((p1_c2 = "100010" ) or (p1_c2 = "101111")) or ((p1_c3 = "100010" )or (p1_c3 = "101111")) or ((p1_c4 = "100010" )or (p1_c4 = "101111"))
						or ((p1_c5 = "100010" )or (p1_c5 = "101111"))or ((p1_c6 = "100010" )or (p1_c6 = "101111"))or ((p2_c1 = "100010" )or (p2_c1 = "101111"))
						or ((p2_c2 = "100010" )or (p2_c2 = "101111"))) then
							if addrcnt(21) = x"0a" then
								addrcnt(21) <= (others => '0');
							elsif addrcnt(21) = x"15" then
								addrcnt(21) <= x"0b";
							elsif addrcnt(21) = x"20" then
								addrcnt(21) <= x"16";
							elsif addrcnt(21) = x"2b" then
								addrcnt(21) <= x"21";
							elsif addrcnt(21) = x"36" then
								addrcnt(21) <= x"2c";
							elsif addrcnt(21) = x"41" then
								addrcnt(21) <= x"37";
							elsif addrcnt(21) = x"4c" then
								addrcnt(21) <= x"42";
							elsif addrcnt(21) = x"57" then
								addrcnt(21) <= x"4d";
							elsif addrcnt(21) = x"62" then
								addrcnt(21) <= x"58";
							elsif addrcnt(21) = x"6d" then
								addrcnt(21) <= x"63";
							elsif addrcnt(21) = x"78" then
								addrcnt(21) <= x"6e";
							elsif addrcnt(21) = x"83" then
								addrcnt(21) <= x"79";
							elsif addrcnt(21) = x"8e" then
								addrcnt(21) <= x"84";
							elsif addrcnt(21) = x"99" then
								addrcnt(21) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "100011" )or (p1_c1 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);
						if(((p1_c2 = "100011" ) or (p1_c2 = "110000")) or ((p1_c3 = "100011" )or (p1_c3 = "110000")) or ((p1_c4 = "100011" )or (p1_c4 = "110000"))
						or ((p1_c5 = "100011" )or (p1_c5 = "110000"))or ((p1_c6 = "100011" )or (p1_c6 = "110000"))or ((p2_c1 = "100011" )or (p2_c1 = "110000"))
						or ((p2_c2 = "100011" )or (p2_c2 = "110000"))) then
							if addrcnt(22) = x"0a" then
								addrcnt(22) <= (others => '0');
							elsif addrcnt(22) = x"15" then
								addrcnt(22) <= x"0b";
							elsif addrcnt(22) = x"20" then
								addrcnt(22) <= x"16";
							elsif addrcnt(22) = x"2b" then
								addrcnt(22) <= x"21";
							elsif addrcnt(22) = x"36" then
								addrcnt(22) <= x"2c";
							elsif addrcnt(22) = x"41" then
								addrcnt(22) <= x"37";
							elsif addrcnt(22) = x"4c" then
								addrcnt(22) <= x"42";
							elsif addrcnt(22) = x"57" then
								addrcnt(22) <= x"4d";
							elsif addrcnt(22) = x"62" then
								addrcnt(22) <= x"58";
							elsif addrcnt(22) = x"6d" then
								addrcnt(22) <= x"63";
							elsif addrcnt(22) = x"78" then
								addrcnt(22) <= x"6e";
							elsif addrcnt(22) = x"83" then
								addrcnt(22) <= x"79";
							elsif addrcnt(22) = x"8e" then
								addrcnt(22) <= x"84";
							elsif addrcnt(22) = x"99" then
								addrcnt(22) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "100100" )or (p1_c1 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
						if(((p1_c2 = "100100" ) or (p1_c2 = "110001")) or ((p1_c3 = "100100" )or (p1_c3 = "110001")) or ((p1_c4 = "100100" )or (p1_c4 = "110001"))
						or ((p1_c5 = "100100" )or (p1_c5 = "110001"))or ((p1_c6 = "100100" )or (p1_c6 = "110001"))or ((p2_c1 = "100100" )or (p2_c1 = "110001"))
						or ((p2_c2 = "100100" )or (p2_c2 = "110001"))) then
							if addrcnt(23) = x"0a" then
								addrcnt(23) <= (others => '0');
							elsif addrcnt(23) = x"15" then
								addrcnt(23) <= x"0b";
							elsif addrcnt(23) = x"20" then
								addrcnt(23) <= x"16";
							elsif addrcnt(23) = x"2b" then
								addrcnt(23) <= x"21";
							elsif addrcnt(23) = x"36" then
								addrcnt(23) <= x"2c";
							elsif addrcnt(23) = x"41" then
								addrcnt(23) <= x"37";
							elsif addrcnt(23) = x"4c" then
								addrcnt(23) <= x"42";
							elsif addrcnt(23) = x"57" then
								addrcnt(23) <= x"4d";
							elsif addrcnt(23) = x"62" then
								addrcnt(23) <= x"58";
							elsif addrcnt(23) = x"6d" then
								addrcnt(23) <= x"63";
							elsif addrcnt(23) = x"78" then
								addrcnt(23) <= x"6e";
							elsif addrcnt(23) = x"83" then
								addrcnt(23) <= x"79";
							elsif addrcnt(23) = x"8e" then
								addrcnt(23) <= x"84";
							elsif addrcnt(23) = x"99" then
								addrcnt(23) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "100101" )or (p1_c1 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
						if(((p1_c2 = "100101" ) or (p1_c2 = "110010")) or ((p1_c3 = "100101" )or (p1_c3 = "110010")) or ((p1_c4 = "100101" )or (p1_c4 = "110010"))
						or ((p1_c5 = "100101" )or (p1_c5 = "110010"))or ((p1_c6 = "100101" )or (p1_c6 = "110010"))or ((p2_c1 = "100101" )or (p2_c1 = "110010"))
						or ((p2_c2 = "100101" )or (p2_c2 = "110010"))) then
							if addrcnt(24) = x"0a" then
								addrcnt(24) <= (others => '0');
							elsif addrcnt(24) = x"15" then
								addrcnt(24) <= x"0b";
							elsif addrcnt(24) = x"20" then
								addrcnt(24) <= x"16";
							elsif addrcnt(24) = x"2b" then
								addrcnt(24) <= x"21";
							elsif addrcnt(24) = x"36" then
								addrcnt(24) <= x"2c";
							elsif addrcnt(24) = x"41" then
								addrcnt(24) <= x"37";
							elsif addrcnt(24) = x"4c" then
								addrcnt(24) <= x"42";
							elsif addrcnt(24) = x"57" then
								addrcnt(24) <= x"4d";
							elsif addrcnt(24) = x"62" then
								addrcnt(24) <= x"58";
							elsif addrcnt(24) = x"6d" then
								addrcnt(24) <= x"63";
							elsif addrcnt(24) = x"78" then
								addrcnt(24) <= x"6e";
							elsif addrcnt(24) = x"83" then
								addrcnt(24) <= x"79";
							elsif addrcnt(24) = x"8e" then
								addrcnt(24) <= x"84";
							elsif addrcnt(24) = x"99" then
								addrcnt(24) <= x"8f";
							end if;
						end if;
					elsif (p1_c1 = "100110" )or (p1_c1 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
						if(((p1_c2 = "100110" ) or (p1_c2 = "110011")) or ((p1_c3 = "100110" )or (p1_c3 = "110011")) or ((p1_c4 = "100110" )or (p1_c4 = "110011"))
						or ((p1_c5 = "100110" )or (p1_c5 = "110011"))or ((p1_c6 = "100110" )or (p1_c6 = "110011"))or ((p2_c1 = "100110" )or (p2_c1 = "110011"))
						or ((p2_c2 = "100110" )or (p2_c2 = "110011"))) then
							if addrcnt(25) = x"0a" then
								addrcnt(25) <= (others => '0');
							elsif addrcnt(25) = x"15" then
								addrcnt(25) <= x"0b";
							elsif addrcnt(25) = x"20" then
								addrcnt(25) <= x"16";
							elsif addrcnt(25) = x"2b" then
								addrcnt(25) <= x"21";
							elsif addrcnt(25) = x"36" then
								addrcnt(25) <= x"2c";
							elsif addrcnt(25) = x"41" then
								addrcnt(25) <= x"37";
							elsif addrcnt(25) = x"4c" then
								addrcnt(25) <= x"42";
							elsif addrcnt(25) = x"57" then
								addrcnt(25) <= x"4d";
							elsif addrcnt(25) = x"62" then
								addrcnt(25) <= x"58";
							elsif addrcnt(25) = x"6d" then
								addrcnt(25) <= x"63";
							elsif addrcnt(25) = x"78" then
								addrcnt(25) <= x"6e";
							elsif addrcnt(25) = x"83" then
								addrcnt(25) <= x"79";
							elsif addrcnt(25) = x"8e" then
								addrcnt(25) <= x"84";
							elsif addrcnt(25) = x"99" then
								addrcnt(25) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +111 ) ) and ( hsync_cnt <= (tHW + tHBP +121)) ) then
					if (p1_c2 = "000000" )or (p1_c2 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
						if(((p1_c3 = "000000" )or (p1_c3 = "001101")) or ((p1_c4 = "000000" )or (p1_c4 = "001101"))
						or ((p1_c5 = "000000" )or (p1_c5 = "001101"))or ((p1_c6 = "000000" )or (p1_c6 = "001101"))or ((p2_c1 = "000000" )or (p2_c1 = "001101"))
						or ((p2_c2 = "000000" )or (p2_c2 = "001101"))) then
							if addrcnt(0) = x"0a" then
								addrcnt(0) <= (others => '0');
							elsif addrcnt(0) = x"15" then
								addrcnt(0) <= x"0b";
							elsif addrcnt(0) = x"20" then
								addrcnt(0) <= x"16";
							elsif addrcnt(0) = x"2b" then
								addrcnt(0) <= x"21";
							elsif addrcnt(0) = x"36" then
								addrcnt(0) <= x"2c";
							elsif addrcnt(0) = x"41" then
								addrcnt(0) <= x"37";
							elsif addrcnt(0) = x"4c" then
								addrcnt(0) <= x"42";
							elsif addrcnt(0) = x"57" then
								addrcnt(0) <= x"4d";
							elsif addrcnt(0) = x"62" then
								addrcnt(0) <= x"58";
							elsif addrcnt(0) = x"6d" then
								addrcnt(0) <= x"63";
							elsif addrcnt(0) = x"78" then
								addrcnt(0) <= x"6e";
							elsif addrcnt(0) = x"83" then
								addrcnt(0) <= x"79";
							elsif addrcnt(0) = x"8e" then
								addrcnt(0) <= x"84";
							elsif addrcnt(0) = x"99" then
								addrcnt(0) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "000001" )or (p1_c2 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
						if(((p1_c3 = "000001" )or (p1_c3 = "001110")) or ((p1_c4 = "000001" )or (p1_c4 = "001110"))
						or ((p1_c5 = "000001" )or (p1_c5 = "001110"))or ((p1_c6 = "000001" )or (p1_c6 = "001110"))or ((p2_c1 = "000001" )or (p2_c1 = "001110"))
						or ((p2_c2 = "000001" )or (p2_c2 = "001110"))) then
							if addrcnt(1) = x"0a" then
								addrcnt(1) <= (others => '0');
							elsif addrcnt(1) = x"15" then
								addrcnt(1) <= x"0b";
							elsif addrcnt(1) = x"20" then
								addrcnt(1) <= x"16";
							elsif addrcnt(1) = x"2b" then
								addrcnt(1) <= x"21";
							elsif addrcnt(1) = x"36" then
								addrcnt(1) <= x"2c";
							elsif addrcnt(1) = x"41" then
								addrcnt(1) <= x"37";
							elsif addrcnt(1) = x"4c" then
								addrcnt(1) <= x"42";
							elsif addrcnt(1) = x"57" then
								addrcnt(1) <= x"4d";
							elsif addrcnt(1) = x"62" then
								addrcnt(1) <= x"58";
							elsif addrcnt(1) = x"6d" then
								addrcnt(1) <= x"63";
							elsif addrcnt(1) = x"78" then
								addrcnt(1) <= x"6e";
							elsif addrcnt(1) = x"83" then
								addrcnt(1) <= x"79";
							elsif addrcnt(1) = x"8e" then
								addrcnt(1) <= x"84";
							elsif addrcnt(1) = x"99" then
								addrcnt(1) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "000010" )or (p1_c2 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
						if(((p1_c3 = "000010" )or (p1_c3 = "001111")) or ((p1_c4 = "000010" )or (p1_c4 = "001111"))
						or ((p1_c5 = "000010" )or (p1_c5 = "001111"))or ((p1_c6 = "000010" )or (p1_c6 = "001111"))or ((p2_c1 = "000010" )or (p2_c1 = "001111"))
						or ((p2_c2 = "000010" )or (p2_c2 = "001111"))) then
							if addrcnt(2) = x"0a" then
								addrcnt(2) <= (others => '0');
							elsif addrcnt(2) = x"15" then
								addrcnt(2) <= x"0b";
							elsif addrcnt(2) = x"20" then
								addrcnt(2) <= x"16";
							elsif addrcnt(2) = x"2b" then
								addrcnt(2) <= x"21";
							elsif addrcnt(2) = x"36" then
								addrcnt(2) <= x"2c";
							elsif addrcnt(2) = x"41" then
								addrcnt(2) <= x"37";
							elsif addrcnt(2) = x"4c" then
								addrcnt(2) <= x"42";
							elsif addrcnt(2) = x"57" then
								addrcnt(2) <= x"4d";
							elsif addrcnt(2) = x"62" then
								addrcnt(2) <= x"58";
							elsif addrcnt(2) = x"6d" then
								addrcnt(2) <= x"63";
							elsif addrcnt(2) = x"78" then
								addrcnt(2) <= x"6e";
							elsif addrcnt(2) = x"83" then
								addrcnt(2) <= x"79";
							elsif addrcnt(2) = x"8e" then
								addrcnt(2) <= x"84";
							elsif addrcnt(2) = x"99" then
								addrcnt(2) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "000011" )or (p1_c2 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
						if(((p1_c3 = "000011" )or (p1_c3 = "010000")) or ((p1_c4 = "000011" )or (p1_c4 = "010000"))
						or ((p1_c5 = "000011" )or (p1_c5 = "010000"))or ((p1_c6 = "000011" )or (p1_c6 = "010000"))or ((p2_c1 = "000011" )or (p2_c1 = "010000"))
						or ((p2_c2 = "000011" )or (p2_c2 = "010000"))) then
							if addrcnt(3) = x"0a" then
								addrcnt(3) <= (others => '0');
							elsif addrcnt(3) = x"15" then
								addrcnt(3) <= x"0b";
							elsif addrcnt(3) = x"20" then
								addrcnt(3) <= x"16";
							elsif addrcnt(3) = x"2b" then
								addrcnt(3) <= x"21";
							elsif addrcnt(3) = x"36" then
								addrcnt(3) <= x"2c";
							elsif addrcnt(3) = x"41" then
								addrcnt(3) <= x"37";
							elsif addrcnt(3) = x"4c" then
								addrcnt(3) <= x"42";
							elsif addrcnt(3) = x"57" then
								addrcnt(3) <= x"4d";
							elsif addrcnt(3) = x"62" then
								addrcnt(3) <= x"58";
							elsif addrcnt(3) = x"6d" then
								addrcnt(3) <= x"63";
							elsif addrcnt(3) = x"78" then
								addrcnt(3) <= x"6e";
							elsif addrcnt(3) = x"83" then
								addrcnt(3) <= x"79";
							elsif addrcnt(3) = x"8e" then
								addrcnt(3) <= x"84";
							elsif addrcnt(3) = x"99" then
								addrcnt(3) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "000100" )or (p1_c2 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);
						if(((p1_c3 = "000100" )or (p1_c3 = "010001")) or ((p1_c4 = "000100" )or (p1_c4 = "010001"))
						or ((p1_c5 = "000100" )or (p1_c5 = "010001"))or ((p1_c6 = "000100" )or (p1_c6 = "010001"))or ((p2_c1 = "000100" )or (p2_c1 = "010001"))
						or ((p2_c2 = "000100" )or (p2_c2 = "010001"))) then
							if addrcnt(4) = x"0a" then
								addrcnt(4) <= (others => '0');
							elsif addrcnt(4) = x"15" then
								addrcnt(4) <= x"0b";
							elsif addrcnt(4) = x"20" then
								addrcnt(4) <= x"16";
							elsif addrcnt(4) = x"2b" then
								addrcnt(4) <= x"21";
							elsif addrcnt(4) = x"36" then
								addrcnt(4) <= x"2c";
							elsif addrcnt(4) = x"41" then
								addrcnt(4) <= x"37";
							elsif addrcnt(4) = x"4c" then
								addrcnt(4) <= x"42";
							elsif addrcnt(4) = x"57" then
								addrcnt(4) <= x"4d";
							elsif addrcnt(4) = x"62" then
								addrcnt(4) <= x"58";
							elsif addrcnt(4) = x"6d" then
								addrcnt(4) <= x"63";
							elsif addrcnt(4) = x"78" then
								addrcnt(4) <= x"6e";
							elsif addrcnt(4) = x"83" then
								addrcnt(4) <= x"79";
							elsif addrcnt(4) = x"8e" then
								addrcnt(4) <= x"84";
							elsif addrcnt(4) = x"99" then
								addrcnt(4) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "000101" )or (p1_c2 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);
						if(((p1_c3 = "000101" )or (p1_c3 = "010010")) or ((p1_c4 = "000101" )or (p1_c4 = "010010"))
						or ((p1_c5 = "000101" )or (p1_c5 = "010010"))or ((p1_c6 = "000101" )or (p1_c6 = "010010"))or ((p2_c1 = "000101" )or (p2_c1 = "010010"))
						or ((p2_c2 = "000101" )or (p2_c2 = "010010"))) then
							if addrcnt(5) = x"0a" then
								addrcnt(5) <= (others => '0');
							elsif addrcnt(5) = x"15" then
								addrcnt(5) <= x"0b";
							elsif addrcnt(5) = x"20" then
								addrcnt(5) <= x"16";
							elsif addrcnt(5) = x"2b" then
								addrcnt(5) <= x"21";
							elsif addrcnt(5) = x"36" then
								addrcnt(5) <= x"2c";
							elsif addrcnt(5) = x"41" then
								addrcnt(5) <= x"37";
							elsif addrcnt(5) = x"4c" then
								addrcnt(5) <= x"42";
							elsif addrcnt(5) = x"57" then
								addrcnt(5) <= x"4d";
							elsif addrcnt(5) = x"62" then
								addrcnt(5) <= x"58";
							elsif addrcnt(5) = x"6d" then
								addrcnt(5) <= x"63";
							elsif addrcnt(5) = x"78" then
								addrcnt(5) <= x"6e";
							elsif addrcnt(5) = x"83" then
								addrcnt(5) <= x"79";
							elsif addrcnt(5) = x"8e" then
								addrcnt(5) <= x"84";
							elsif addrcnt(5) = x"99" then
								addrcnt(5) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "000110" )or (p1_c2 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);
						if( ((p1_c3 = "0000110" )or (p1_c3 = "010011")) or ((p1_c4 = "0000110" )or (p1_c4 = "010011"))
						or ((p1_c5 = "0000110" )or (p1_c5 = "010011"))or ((p1_c6 = "0000110" )or (p1_c6 = "010011"))or ((p2_c1 = "0000110" )or (p2_c1 = "010011"))
						or ((p2_c2 = "0000110" )or (p2_c2 = "010011"))) then
							if addrcnt(6) = x"0a" then
								addrcnt(6) <= (others => '0');
							elsif addrcnt(6) = x"15" then
								addrcnt(6) <= x"0b";
							elsif addrcnt(6) = x"20" then
								addrcnt(6) <= x"16";
							elsif addrcnt(6) = x"2b" then
								addrcnt(6) <= x"21";
							elsif addrcnt(6) = x"36" then
								addrcnt(6) <= x"2c";
							elsif addrcnt(6) = x"41" then
								addrcnt(6) <= x"37";
							elsif addrcnt(6) = x"4c" then
								addrcnt(6) <= x"42";
							elsif addrcnt(6) = x"57" then
								addrcnt(6) <= x"4d";
							elsif addrcnt(6) = x"62" then
								addrcnt(6) <= x"58";
							elsif addrcnt(6) = x"6d" then
								addrcnt(6) <= x"63";
							elsif addrcnt(6) = x"78" then
								addrcnt(6) <= x"6e";
							elsif addrcnt(6) = x"83" then
								addrcnt(6) <= x"79";
							elsif addrcnt(6) = x"8e" then
								addrcnt(6) <= x"84";
							elsif addrcnt(6) = x"99" then
								addrcnt(6) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "000111" )or (p1_c2 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);
						if(((p1_c3 = "0000111" )or (p1_c3 = "010100")) or ((p1_c4 = "0000111" )or (p1_c4 = "010100"))
						or ((p1_c5 = "0000111" )or (p1_c5 = "010100"))or ((p1_c6 = "0000111" )or (p1_c6 = "010100"))or ((p2_c1 = "0000111" )or (p2_c1 = "010100"))
						or ((p2_c2 = "0000111" )or (p2_c2 = "010100"))) then
							if addrcnt(7) = x"0a" then
								addrcnt(7) <= (others => '0');
							elsif addrcnt(7) = x"15" then
								addrcnt(7) <= x"0b";
							elsif addrcnt(7) = x"20" then
								addrcnt(7) <= x"16";
							elsif addrcnt(7) = x"2b" then
								addrcnt(7) <= x"21";
							elsif addrcnt(7) = x"36" then
								addrcnt(7) <= x"2c";
							elsif addrcnt(7) = x"41" then
								addrcnt(7) <= x"37";
							elsif addrcnt(7) = x"4c" then
								addrcnt(7) <= x"42";
							elsif addrcnt(7) = x"57" then
								addrcnt(7) <= x"4d";
							elsif addrcnt(7) = x"62" then
								addrcnt(7) <= x"58";
							elsif addrcnt(7) = x"6d" then
								addrcnt(7) <= x"63";
							elsif addrcnt(7) = x"78" then
								addrcnt(7) <= x"6e";
							elsif addrcnt(7) = x"83" then
								addrcnt(7) <= x"79";
							elsif addrcnt(7) = x"8e" then
								addrcnt(7) <= x"84";
							elsif addrcnt(7) = x"99" then
								addrcnt(7) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "001000" )or (p1_c2 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
						if(((p1_c3 = "001000" )or (p1_c3 = "010101")) or ((p1_c4 = "001000" )or (p1_c4 = "010101"))
						or ((p1_c5 = "001000" )or (p1_c5 = "010101"))or ((p1_c6 = "001000" )or (p1_c6 = "010101"))or ((p2_c1 = "001000" )or (p2_c1 = "010101"))
						or ((p2_c2 = "001000" )or (p2_c2 = "010101"))) then
							if addrcnt(8) = x"0a" then
								addrcnt(8) <= (others => '0');
							elsif addrcnt(8) = x"15" then
								addrcnt(8) <= x"0b";
							elsif addrcnt(8) = x"20" then
								addrcnt(8) <= x"16";
							elsif addrcnt(8) = x"2b" then
								addrcnt(8) <= x"21";
							elsif addrcnt(8) = x"36" then
								addrcnt(8) <= x"2c";
							elsif addrcnt(8) = x"41" then
								addrcnt(8) <= x"37";
							elsif addrcnt(8) = x"4c" then
								addrcnt(8) <= x"42";
							elsif addrcnt(8) = x"57" then
								addrcnt(8) <= x"4d";
							elsif addrcnt(8) = x"62" then
								addrcnt(8) <= x"58";
							elsif addrcnt(8) = x"6d" then
								addrcnt(8) <= x"63";
							elsif addrcnt(8) = x"78" then
								addrcnt(8) <= x"6e";
							elsif addrcnt(8) = x"83" then
								addrcnt(8) <= x"79";
							elsif addrcnt(8) = x"8e" then
								addrcnt(8) <= x"84";
							elsif addrcnt(8) = x"99" then
								addrcnt(8) <= x"8f";
							end if;
						end if;
					elsif (p1_c2= "001001" )or (p1_c2 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);
						if(((p1_c3 = "001001" )or (p1_c3 = "010110")) or ((p1_c4 = "001001" )or (p1_c4 = "010110"))
						or ((p1_c5 = "001001" )or (p1_c5 = "010110"))or ((p1_c6 = "001001" )or (p1_c6 = "010110"))or ((p2_c1 = "001001" )or (p2_c1 = "010110"))
						or ((p2_c2 = "001001" )or (p2_c2 = "010110"))) then
							if addrcnt(9) = x"0a" then
								addrcnt(9) <= (others => '0');
							elsif addrcnt(9) = x"15" then
								addrcnt(9) <= x"0b";
							elsif addrcnt(9) = x"20" then
								addrcnt(9) <= x"16";
							elsif addrcnt(9) = x"2b" then
								addrcnt(9) <= x"21";
							elsif addrcnt(9) = x"36" then
								addrcnt(9) <= x"2c";
							elsif addrcnt(9) = x"41" then
								addrcnt(9) <= x"37";
							elsif addrcnt(9) = x"4c" then
								addrcnt(9) <= x"42";
							elsif addrcnt(9) = x"57" then
								addrcnt(9) <= x"4d";
							elsif addrcnt(9) = x"62" then
								addrcnt(9) <= x"58";
							elsif addrcnt(9) = x"6d" then
								addrcnt(9) <= x"63";
							elsif addrcnt(9) = x"78" then
								addrcnt(9) <= x"6e";
							elsif addrcnt(9) = x"83" then
								addrcnt(9) <= x"79";
							elsif addrcnt(9) = x"8e" then
								addrcnt(9) <= x"84";
							elsif addrcnt(9) = x"99" then
								addrcnt(9) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "001010" )or (p1_c2 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);
						if(((p1_c3 = "001010" )or (p1_c3 = "010111")) or ((p1_c4 = "001010" )or (p1_c4 = "010111"))
						or ((p1_c5 = "001010" )or (p1_c5 = "010111"))or ((p1_c6 = "001010" )or (p1_c6 = "010111"))or ((p2_c1 = "001010" )or (p2_c1 = "010111"))
						or ((p2_c2 = "001010" )or (p2_c2 = "010111"))) then
							if addrcnt(10) = x"0a" then
								addrcnt(10) <= (others => '0');
							elsif addrcnt(10) = x"15" then
								addrcnt(10) <= x"0b";
							elsif addrcnt(10) = x"20" then
								addrcnt(10) <= x"16";
							elsif addrcnt(10) = x"2b" then
								addrcnt(10) <= x"21";
							elsif addrcnt(10) = x"36" then
								addrcnt(10) <= x"2c";
							elsif addrcnt(10) = x"41" then
								addrcnt(10) <= x"37";
							elsif addrcnt(10) = x"4c" then
								addrcnt(10) <= x"42";
							elsif addrcnt(10) = x"57" then
								addrcnt(10) <= x"4d";
							elsif addrcnt(10) = x"62" then
								addrcnt(10) <= x"58";
							elsif addrcnt(10) = x"6d" then
								addrcnt(10) <= x"63";
							elsif addrcnt(10) = x"78" then
								addrcnt(10) <= x"6e";
							elsif addrcnt(10) = x"83" then
								addrcnt(10) <= x"79";
							elsif addrcnt(10) = x"8e" then
								addrcnt(10) <= x"84";
							elsif addrcnt(10) = x"99" then
								addrcnt(10) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "001011" )or (p1_c2 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);
						if(((p1_c3 = "001011" )or (p1_c3 = "011000")) or ((p1_c4 = "001011" )or (p1_c4 = "011000"))
						or ((p1_c5 = "001011" )or (p1_c5 = "011000"))or ((p1_c6 = "001011" )or (p1_c6 = "011000"))or ((p2_c1 = "001011" )or (p2_c1 = "011000"))
						or ((p2_c2 = "001011" )or (p2_c2 = "011000"))) then
							if addrcnt(11) = x"0a" then
								addrcnt(11) <= (others => '0');
							elsif addrcnt(11) = x"15" then
								addrcnt(11) <= x"0b";
							elsif addrcnt(11) = x"20" then
								addrcnt(11) <= x"16";
							elsif addrcnt(11) = x"2b" then
								addrcnt(11) <= x"21";
							elsif addrcnt(11) = x"36" then
								addrcnt(11) <= x"2c";
							elsif addrcnt(11) = x"41" then
								addrcnt(11) <= x"37";
							elsif addrcnt(11) = x"4c" then
								addrcnt(11) <= x"42";
							elsif addrcnt(11) = x"57" then
								addrcnt(11) <= x"4d";
							elsif addrcnt(11) = x"62" then
								addrcnt(11) <= x"58";
							elsif addrcnt(11) = x"6d" then
								addrcnt(11) <= x"63";
							elsif addrcnt(11) = x"78" then
								addrcnt(11) <= x"6e";
							elsif addrcnt(11) = x"83" then
								addrcnt(11) <= x"79";
							elsif addrcnt(11) = x"8e" then
								addrcnt(11) <= x"84";
							elsif addrcnt(11) = x"99" then
								addrcnt(11) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "001100" )or (p1_c2 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
						if(((p1_c3 = "001100" )or (p1_c3 = "011001")) or ((p1_c4 = "001100" )or (p1_c4 = "011001"))
						or ((p1_c5 = "001100" )or (p1_c5 = "011001"))or ((p1_c6 = "001100" )or (p1_c6 = "011001"))or ((p2_c1 = "001100" )or (p2_c1 = "011001"))
						or ((p2_c2 = "001100" )or (p2_c2 = "011001"))) then
							if addrcnt(12) = x"0a" then
								addrcnt(12) <= (others => '0');
							elsif addrcnt(12) = x"15" then
								addrcnt(12) <= x"0b";
							elsif addrcnt(12) = x"20" then
								addrcnt(12) <= x"16";
							elsif addrcnt(12) = x"2b" then
								addrcnt(12) <= x"21";
							elsif addrcnt(12) = x"36" then
								addrcnt(12) <= x"2c";
							elsif addrcnt(12) = x"41" then
								addrcnt(12) <= x"37";
							elsif addrcnt(12) = x"4c" then
								addrcnt(12) <= x"42";
							elsif addrcnt(12) = x"57" then
								addrcnt(12) <= x"4d";
							elsif addrcnt(12) = x"62" then
								addrcnt(12) <= x"58";
							elsif addrcnt(12) = x"6d" then
								addrcnt(12) <= x"63";
							elsif addrcnt(12) = x"78" then
								addrcnt(12) <= x"6e";
							elsif addrcnt(12) = x"83" then
								addrcnt(12) <= x"79";
							elsif addrcnt(12) = x"8e" then
								addrcnt(12) <= x"84";
							elsif addrcnt(12) = x"99" then
								addrcnt(12) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "011010" )or (p1_c2 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
						if(((p1_c3 = "011010" )or (p1_c3 = "100111")) or ((p1_c4 = "011010" )or (p1_c4 = "100111"))
						or ((p1_c5 = "011010" )or (p1_c5 = "100111"))or ((p1_c6 = "011010" )or (p1_c6 = "100111"))or ((p2_c1 = "011010" )or (p2_c1 = "100111"))
						or ((p2_c2 = "011010" )or (p2_c2 = "100111"))) then
							if addrcnt(13) = x"0a" then
								addrcnt(13) <= (others => '0');
							elsif addrcnt(13) = x"15" then
								addrcnt(13) <= x"0b";
							elsif addrcnt(13) = x"20" then
								addrcnt(13) <= x"16";
							elsif addrcnt(13) = x"2b" then
								addrcnt(13) <= x"21";
							elsif addrcnt(13) = x"36" then
								addrcnt(13) <= x"2c";
							elsif addrcnt(13) = x"41" then
								addrcnt(13) <= x"37";
							elsif addrcnt(13) = x"4c" then
								addrcnt(13) <= x"42";
							elsif addrcnt(13) = x"57" then
								addrcnt(13) <= x"4d";
							elsif addrcnt(13) = x"62" then
								addrcnt(13) <= x"58";
							elsif addrcnt(13) = x"6d" then
								addrcnt(13) <= x"63";
							elsif addrcnt(13) = x"78" then
								addrcnt(13) <= x"6e";
							elsif addrcnt(13) = x"83" then
								addrcnt(13) <= x"79";
							elsif addrcnt(13) = x"8e" then
								addrcnt(13) <= x"84";
							elsif addrcnt(13) = x"99" then
								addrcnt(13) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "011011" )or (p1_c2 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
						if(((p1_c3 = "011011" )or (p1_c3 = "101000")) or ((p1_c4 = "011011" )or (p1_c4 = "101000"))
						or ((p1_c5 = "011011" )or (p1_c5 = "101000"))or ((p1_c6 = "011011" )or (p1_c6 = "101000"))or ((p2_c1 = "011011" )or (p2_c1 = "101000"))
						or ((p2_c2 = "011011" )or (p2_c2 = "101000"))) then
							if addrcnt(14) = x"0a" then
								addrcnt(14) <= (others => '0');
							elsif addrcnt(14) = x"15" then
								addrcnt(14) <= x"0b";
							elsif addrcnt(14) = x"20" then
								addrcnt(14) <= x"16";
							elsif addrcnt(14) = x"2b" then
								addrcnt(14) <= x"21";
							elsif addrcnt(14) = x"36" then
								addrcnt(14) <= x"2c";
							elsif addrcnt(14) = x"41" then
								addrcnt(14) <= x"37";
							elsif addrcnt(14) = x"4c" then
								addrcnt(14) <= x"42";
							elsif addrcnt(14) = x"57" then
								addrcnt(14) <= x"4d";
							elsif addrcnt(14) = x"62" then
								addrcnt(14) <= x"58";
							elsif addrcnt(14) = x"6d" then
								addrcnt(14) <= x"63";
							elsif addrcnt(14) = x"78" then
								addrcnt(14) <= x"6e";
							elsif addrcnt(14) = x"83" then
								addrcnt(14) <= x"79";
							elsif addrcnt(14) = x"8e" then
								addrcnt(14) <= x"84";
							elsif addrcnt(14) = x"99" then
								addrcnt(14) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "011100" )or (p1_c2 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
						if( ((p1_c3 = "011100" )or (p1_c3 = "101001")) or ((p1_c4 = "011100" )or (p1_c4 = "101001"))
						or ((p1_c5 = "011100" )or (p1_c5 = "101001"))or ((p1_c6 = "011100" )or (p1_c6 = "101001"))or ((p2_c1 = "011100" )or (p2_c1 = "101001"))
						or ((p2_c2 = "011100" )or (p2_c2 = "101001"))) then
							if addrcnt(15) = x"0a" then
								addrcnt(15) <= (others => '0');
							elsif addrcnt(15) = x"15" then
								addrcnt(15) <= x"0b";
							elsif addrcnt(15) = x"20" then
								addrcnt(15) <= x"16";
							elsif addrcnt(15) = x"2b" then
								addrcnt(15) <= x"21";
							elsif addrcnt(15) = x"36" then
								addrcnt(15) <= x"2c";
							elsif addrcnt(15) = x"41" then
								addrcnt(15) <= x"37";
							elsif addrcnt(15) = x"4c" then
								addrcnt(15) <= x"42";
							elsif addrcnt(15) = x"57" then
								addrcnt(15) <= x"4d";
							elsif addrcnt(15) = x"62" then
								addrcnt(15) <= x"58";
							elsif addrcnt(15) = x"6d" then
								addrcnt(15) <= x"63";
							elsif addrcnt(15) = x"78" then
								addrcnt(15) <= x"6e";
							elsif addrcnt(15) = x"83" then
								addrcnt(15) <= x"79";
							elsif addrcnt(15) = x"8e" then
								addrcnt(15) <= x"84";
							elsif addrcnt(15) = x"99" then
								addrcnt(15) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "011101" )or (p1_c2 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
						if( ((p1_c3 = "011101" )or (p1_c3 = "101010")) or ((p1_c4 = "011101" )or (p1_c4 = "101010"))
						or ((p1_c5 = "011101" )or (p1_c5 = "101010"))or ((p1_c6 = "011101" )or (p1_c6 = "101010"))or ((p2_c1 = "011101" )or (p2_c1 = "101010"))
						or ((p2_c2 = "011101" )or (p2_c2 = "101010"))) then
							if addrcnt(16) = x"0a" then
								addrcnt(16) <= (others => '0');
							elsif addrcnt(16) = x"15" then
								addrcnt(16) <= x"0b";
							elsif addrcnt(16) = x"20" then
								addrcnt(16) <= x"16";
							elsif addrcnt(16) = x"2b" then
								addrcnt(16) <= x"21";
							elsif addrcnt(16) = x"36" then
								addrcnt(16) <= x"2c";
							elsif addrcnt(16) = x"41" then
								addrcnt(16) <= x"37";
							elsif addrcnt(16) = x"4c" then
								addrcnt(16) <= x"42";
							elsif addrcnt(16) = x"57" then
								addrcnt(16) <= x"4d";
							elsif addrcnt(16) = x"62" then
								addrcnt(16) <= x"58";
							elsif addrcnt(16) = x"6d" then
								addrcnt(16) <= x"63";
							elsif addrcnt(16) = x"78" then
								addrcnt(16) <= x"6e";
							elsif addrcnt(16) = x"83" then
								addrcnt(16) <= x"79";
							elsif addrcnt(16) = x"8e" then
								addrcnt(16) <= x"84";
							elsif addrcnt(16) = x"99" then
								addrcnt(16) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "011110" )or (p1_c2 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);
						if(((p1_c3 = "011110" )or (p1_c3 = "101011")) or ((p1_c4 = "011110" )or (p1_c4 = "101011"))
						or ((p1_c5 = "011110" )or (p1_c5 = "101011"))or ((p1_c6 = "011110" )or (p1_c6 = "101011"))or ((p2_c1 = "011110" )or (p2_c1 = "101011"))
						or ((p2_c2 = "011110" )or (p2_c2 = "101011"))) then
							if addrcnt(17) = x"0a" then
								addrcnt(17) <= (others => '0');
							elsif addrcnt(17) = x"15" then
								addrcnt(17) <= x"0b";
							elsif addrcnt(17) = x"20" then
								addrcnt(17) <= x"16";
							elsif addrcnt(17) = x"2b" then
								addrcnt(17) <= x"21";
							elsif addrcnt(17) = x"36" then
								addrcnt(17) <= x"2c";
							elsif addrcnt(17) = x"41" then
								addrcnt(17) <= x"37";
							elsif addrcnt(17) = x"4c" then
								addrcnt(17) <= x"42";
							elsif addrcnt(17) = x"57" then
								addrcnt(17) <= x"4d";
							elsif addrcnt(17) = x"62" then
								addrcnt(17) <= x"58";
							elsif addrcnt(17) = x"6d" then
								addrcnt(17) <= x"63";
							elsif addrcnt(17) = x"78" then
								addrcnt(17) <= x"6e";
							elsif addrcnt(17) = x"83" then
								addrcnt(17) <= x"79";
							elsif addrcnt(17) = x"8e" then
								addrcnt(17) <= x"84";
							elsif addrcnt(17) = x"99" then
								addrcnt(17) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "011111" )or (p1_c2 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);
						if(((p1_c3 = "011111" )or (p1_c3 = "101100")) or ((p1_c4 = "011111" )or (p1_c4 = "101100"))
						or ((p1_c5 = "011111" )or (p1_c5 = "101100"))or ((p1_c6 = "011111" )or (p1_c6 = "101100"))or ((p2_c1 = "011111" )or (p2_c1 = "101100"))
						or ((p2_c2 = "011111" )or (p2_c2 = "101100"))) then
							if addrcnt(18) = x"0a" then
								addrcnt(18) <= (others => '0');
							elsif addrcnt(18) = x"15" then
								addrcnt(18) <= x"0b";
							elsif addrcnt(18) = x"20" then
								addrcnt(18) <= x"16";
							elsif addrcnt(18) = x"2b" then
								addrcnt(18) <= x"21";
							elsif addrcnt(18) = x"36" then
								addrcnt(18) <= x"2c";
							elsif addrcnt(18) = x"41" then
								addrcnt(18) <= x"37";
							elsif addrcnt(18) = x"4c" then
								addrcnt(18) <= x"42";
							elsif addrcnt(18) = x"57" then
								addrcnt(18) <= x"4d";
							elsif addrcnt(18) = x"62" then
								addrcnt(18) <= x"58";
							elsif addrcnt(18) = x"6d" then
								addrcnt(18) <= x"63";
							elsif addrcnt(18) = x"78" then
								addrcnt(18) <= x"6e";
							elsif addrcnt(18) = x"83" then
								addrcnt(18) <= x"79";
							elsif addrcnt(18) = x"8e" then
								addrcnt(18) <= x"84";
							elsif addrcnt(18) = x"99" then
								addrcnt(18) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "100000" )or (p1_c2 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
						if( ((p1_c3 = "100000" )or (p1_c3 = "101101")) or ((p1_c4 = "100000" )or (p1_c4 = "101101"))
						or ((p1_c5 = "100000" )or (p1_c5 = "101101"))or ((p1_c6 = "100000" )or (p1_c6 = "101101"))or ((p2_c1 = "100000" )or (p2_c1 = "101101"))
						or ((p2_c2 = "100000" )or (p2_c2 = "101101"))) then
							if addrcnt(19) = x"0a" then
								addrcnt(19) <= (others => '0');
							elsif addrcnt(19) = x"15" then
								addrcnt(19) <= x"0b";
							elsif addrcnt(19) = x"20" then
								addrcnt(19) <= x"16";
							elsif addrcnt(19) = x"2b" then
								addrcnt(19) <= x"21";
							elsif addrcnt(19) = x"36" then
								addrcnt(19) <= x"2c";
							elsif addrcnt(19) = x"41" then
								addrcnt(19) <= x"37";
							elsif addrcnt(19) = x"4c" then
								addrcnt(19) <= x"42";
							elsif addrcnt(19) = x"57" then
								addrcnt(19) <= x"4d";
							elsif addrcnt(19) = x"62" then
								addrcnt(19) <= x"58";
							elsif addrcnt(19) = x"6d" then
								addrcnt(19) <= x"63";
							elsif addrcnt(19) = x"78" then
								addrcnt(19) <= x"6e";
							elsif addrcnt(19) = x"83" then
								addrcnt(19) <= x"79";
							elsif addrcnt(19) = x"8e" then
								addrcnt(19) <= x"84";
							elsif addrcnt(19) = x"99" then
								addrcnt(19) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "100001" )or (p1_c2 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
						if(((p1_c3 = "100001" )or (p1_c3 = "101110")) or ((p1_c4 = "100001" )or (p1_c4 = "101110"))
						or ((p1_c5 = "100001" )or (p1_c5 = "101110"))or ((p1_c6 = "100001" )or (p1_c6 = "101110"))or ((p2_c1 = "100001" )or (p2_c1 = "101110"))
						or ((p2_c2 = "100001" )or (p2_c2 = "101110"))) then
							if addrcnt(20) = x"0a" then
								addrcnt(20) <= (others => '0');
							elsif addrcnt(20) = x"15" then
								addrcnt(20) <= x"0b";
							elsif addrcnt(20) = x"20" then
								addrcnt(20) <= x"16";
							elsif addrcnt(20) = x"2b" then
								addrcnt(20) <= x"21";
							elsif addrcnt(20) = x"36" then
								addrcnt(20) <= x"2c";
							elsif addrcnt(20) = x"41" then
								addrcnt(20) <= x"37";
							elsif addrcnt(20) = x"4c" then
								addrcnt(20) <= x"42";
							elsif addrcnt(20) = x"57" then
								addrcnt(20) <= x"4d";
							elsif addrcnt(20) = x"62" then
								addrcnt(20) <= x"58";
							elsif addrcnt(20) = x"6d" then
								addrcnt(20) <= x"63";
							elsif addrcnt(20) = x"78" then
								addrcnt(20) <= x"6e";
							elsif addrcnt(20) = x"83" then
								addrcnt(20) <= x"79";
							elsif addrcnt(20) = x"8e" then
								addrcnt(20) <= x"84";
							elsif addrcnt(20) = x"99" then
								addrcnt(20) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "100010" )or (p1_c2 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
						if( ((p1_c3 = "100010" )or (p1_c3 = "101111")) or ((p1_c4 = "100010" )or (p1_c4 = "101111"))
						or ((p1_c5 = "100010" )or (p1_c5 = "101111"))or ((p1_c6 = "100010" )or (p1_c6 = "101111"))or ((p2_c1 = "100010" )or (p2_c1 = "101111"))
						or ((p2_c2 = "100010" )or (p2_c2 = "101111"))) then
							if addrcnt(21) = x"0a" then
								addrcnt(21) <= (others => '0');
							elsif addrcnt(21) = x"15" then
								addrcnt(21) <= x"0b";
							elsif addrcnt(21) = x"20" then
								addrcnt(21) <= x"16";
							elsif addrcnt(21) = x"2b" then
								addrcnt(21) <= x"21";
							elsif addrcnt(21) = x"36" then
								addrcnt(21) <= x"2c";
							elsif addrcnt(21) = x"41" then
								addrcnt(21) <= x"37";
							elsif addrcnt(21) = x"4c" then
								addrcnt(21) <= x"42";
							elsif addrcnt(21) = x"57" then
								addrcnt(21) <= x"4d";
							elsif addrcnt(21) = x"62" then
								addrcnt(21) <= x"58";
							elsif addrcnt(21) = x"6d" then
								addrcnt(21) <= x"63";
							elsif addrcnt(21) = x"78" then
								addrcnt(21) <= x"6e";
							elsif addrcnt(21) = x"83" then
								addrcnt(21) <= x"79";
							elsif addrcnt(21) = x"8e" then
								addrcnt(21) <= x"84";
							elsif addrcnt(21) = x"99" then
								addrcnt(21) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "100011" )or (p1_c2 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);
						if( ((p1_c3 = "100011" )or (p1_c3 = "110000")) or ((p1_c4 = "100011" )or (p1_c4 = "110000"))
						or ((p1_c5 = "100011" )or (p1_c5 = "110000"))or ((p1_c6 = "100011" )or (p1_c6 = "110000"))or ((p2_c1 = "100011" )or (p2_c1 = "110000"))
						or ((p2_c2 = "100011" )or (p2_c2 = "110000"))) then
							if addrcnt(22) = x"0a" then
								addrcnt(22) <= (others => '0');
							elsif addrcnt(22) = x"15" then
								addrcnt(22) <= x"0b";
							elsif addrcnt(22) = x"20" then
								addrcnt(22) <= x"16";
							elsif addrcnt(22) = x"2b" then
								addrcnt(22) <= x"21";
							elsif addrcnt(22) = x"36" then
								addrcnt(22) <= x"2c";
							elsif addrcnt(22) = x"41" then
								addrcnt(22) <= x"37";
							elsif addrcnt(22) = x"4c" then
								addrcnt(22) <= x"42";
							elsif addrcnt(22) = x"57" then
								addrcnt(22) <= x"4d";
							elsif addrcnt(22) = x"62" then
								addrcnt(22) <= x"58";
							elsif addrcnt(22) = x"6d" then
								addrcnt(22) <= x"63";
							elsif addrcnt(22) = x"78" then
								addrcnt(22) <= x"6e";
							elsif addrcnt(22) = x"83" then
								addrcnt(22) <= x"79";
							elsif addrcnt(22) = x"8e" then
								addrcnt(22) <= x"84";
							elsif addrcnt(22) = x"99" then
								addrcnt(22) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "100100" )or (p1_c2 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
						if( ((p1_c3 = "100100" )or (p1_c3 = "110001")) or ((p1_c4 = "100100" )or (p1_c4 = "110001"))
						or ((p1_c5 = "100100" )or (p1_c5 = "110001"))or ((p1_c6 = "100100" )or (p1_c6 = "110001"))or ((p2_c1 = "100100" )or (p2_c1 = "110001"))
						or ((p2_c2 = "100100" )or (p2_c2 = "110001"))) then
							if addrcnt(23) = x"0a" then
								addrcnt(23) <= (others => '0');
							elsif addrcnt(23) = x"15" then
								addrcnt(23) <= x"0b";
							elsif addrcnt(23) = x"20" then
								addrcnt(23) <= x"16";
							elsif addrcnt(23) = x"2b" then
								addrcnt(23) <= x"21";
							elsif addrcnt(23) = x"36" then
								addrcnt(23) <= x"2c";
							elsif addrcnt(23) = x"41" then
								addrcnt(23) <= x"37";
							elsif addrcnt(23) = x"4c" then
								addrcnt(23) <= x"42";
							elsif addrcnt(23) = x"57" then
								addrcnt(23) <= x"4d";
							elsif addrcnt(23) = x"62" then
								addrcnt(23) <= x"58";
							elsif addrcnt(23) = x"6d" then
								addrcnt(23) <= x"63";
							elsif addrcnt(23) = x"78" then
								addrcnt(23) <= x"6e";
							elsif addrcnt(23) = x"83" then
								addrcnt(23) <= x"79";
							elsif addrcnt(23) = x"8e" then
								addrcnt(23) <= x"84";
							elsif addrcnt(23) = x"99" then
								addrcnt(23) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "100101" )or (p1_c2 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
						if( ((p1_c3 = "100101" )or (p1_c3 = "110010")) or ((p1_c4 = "100101" )or (p1_c4 = "110010"))
						or ((p1_c5 = "100101" )or (p1_c5 = "110010"))or ((p1_c6 = "100101" )or (p1_c6 = "110010"))or ((p2_c1 = "100101" )or (p2_c1 = "110010"))
						or ((p2_c2 = "100101" )or (p2_c2 = "110010"))) then
							if addrcnt(24) = x"0a" then
								addrcnt(24) <= (others => '0');
							elsif addrcnt(24) = x"15" then
								addrcnt(24) <= x"0b";
							elsif addrcnt(24) = x"20" then
								addrcnt(24) <= x"16";
							elsif addrcnt(24) = x"2b" then
								addrcnt(24) <= x"21";
							elsif addrcnt(24) = x"36" then
								addrcnt(24) <= x"2c";
							elsif addrcnt(24) = x"41" then
								addrcnt(24) <= x"37";
							elsif addrcnt(24) = x"4c" then
								addrcnt(24) <= x"42";
							elsif addrcnt(24) = x"57" then
								addrcnt(24) <= x"4d";
							elsif addrcnt(24) = x"62" then
								addrcnt(24) <= x"58";
							elsif addrcnt(24) = x"6d" then
								addrcnt(24) <= x"63";
							elsif addrcnt(24) = x"78" then
								addrcnt(24) <= x"6e";
							elsif addrcnt(24) = x"83" then
								addrcnt(24) <= x"79";
							elsif addrcnt(24) = x"8e" then
								addrcnt(24) <= x"84";
							elsif addrcnt(24) = x"99" then
								addrcnt(24) <= x"8f";
							end if;
						end if;
					elsif (p1_c2 = "100110" )or (p1_c2 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
						if( ((p1_c3 = "100110" )or (p1_c3 = "110011")) or ((p1_c4 = "100110" )or (p1_c4 = "110011"))
						or ((p1_c5 = "100110" )or (p1_c5 = "110011"))or ((p1_c6 = "100110" )or (p1_c6 = "110011"))or ((p2_c1 = "100110" )or (p2_c1 = "110011"))
						or ((p2_c2 = "100110" )or (p2_c2 = "110011"))) then
							if addrcnt(25) = x"0a" then
								addrcnt(25) <= (others => '0');
							elsif addrcnt(25) = x"15" then
								addrcnt(25) <= x"0b";
							elsif addrcnt(25) = x"20" then
								addrcnt(25) <= x"16";
							elsif addrcnt(25) = x"2b" then
								addrcnt(25) <= x"21";
							elsif addrcnt(25) = x"36" then
								addrcnt(25) <= x"2c";
							elsif addrcnt(25) = x"41" then
								addrcnt(25) <= x"37";
							elsif addrcnt(25) = x"4c" then
								addrcnt(25) <= x"42";
							elsif addrcnt(25) = x"57" then
								addrcnt(25) <= x"4d";
							elsif addrcnt(25) = x"62" then
								addrcnt(25) <= x"58";
							elsif addrcnt(25) = x"6d" then
								addrcnt(25) <= x"63";
							elsif addrcnt(25) = x"78" then
								addrcnt(25) <= x"6e";
							elsif addrcnt(25) = x"83" then
								addrcnt(25) <= x"79";
							elsif addrcnt(25) = x"8e" then
								addrcnt(25) <= x"84";
							elsif addrcnt(25) = x"99" then
								addrcnt(25) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +122 ) ) and ( hsync_cnt <= (tHW + tHBP +132)) ) then
					if (p1_c3 = "000000" )or (p1_c3 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
						if(((p1_c4 = "000000" )or (p1_c4 = "001101"))or ((p1_c5 = "000000" )or (p1_c5 = "001101"))or ((p1_c6 = "000000" )or 
						(p1_c6 = "001101"))or ((p2_c1 = "000000" )or (p2_c1 = "001101")) or ((p2_c2 = "000000" )or (p2_c2 = "001101"))) then
							if addrcnt(0) = x"0a" then
								addrcnt(0) <= (others => '0');
							elsif addrcnt(0) = x"15" then
								addrcnt(0) <= x"0b";
							elsif addrcnt(0) = x"20" then
								addrcnt(0) <= x"16";
							elsif addrcnt(0) = x"2b" then
								addrcnt(0) <= x"21";
							elsif addrcnt(0) = x"36" then
								addrcnt(0) <= x"2c";
							elsif addrcnt(0) = x"41" then
								addrcnt(0) <= x"37";
							elsif addrcnt(0) = x"4c" then
								addrcnt(0) <= x"42";
							elsif addrcnt(0) = x"57" then
								addrcnt(0) <= x"4d";
							elsif addrcnt(0) = x"62" then
								addrcnt(0) <= x"58";
							elsif addrcnt(0) = x"6d" then
								addrcnt(0) <= x"63";
							elsif addrcnt(0) = x"78" then
								addrcnt(0) <= x"6e";
							elsif addrcnt(0) = x"83" then
								addrcnt(0) <= x"79";
							elsif addrcnt(0) = x"8e" then
								addrcnt(0) <= x"84";
							elsif addrcnt(0) = x"99" then
								addrcnt(0) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "000001" )or (p1_c3 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
						if(((p1_c4 = "000001" )or (p1_c4 = "001110")) or ((p1_c5 = "000001" )or (p1_c5 = "001110"))or ((p1_c6 = "000001" )or 
						(p1_c6 = "001110"))or ((p2_c1 = "000001" )or (p2_c1 = "001110")) or ((p2_c2 = "000001" )or (p2_c2 = "001110"))) then
							if addrcnt(1) = x"0a" then
								addrcnt(1) <= (others => '0');
							elsif addrcnt(1) = x"15" then
								addrcnt(1) <= x"0b";
							elsif addrcnt(1) = x"20" then
								addrcnt(1) <= x"16";
							elsif addrcnt(1) = x"2b" then
								addrcnt(1) <= x"21";
							elsif addrcnt(1) = x"36" then
								addrcnt(1) <= x"2c";
							elsif addrcnt(1) = x"41" then
								addrcnt(1) <= x"37";
							elsif addrcnt(1) = x"4c" then
								addrcnt(1) <= x"42";
							elsif addrcnt(1) = x"57" then
								addrcnt(1) <= x"4d";
							elsif addrcnt(1) = x"62" then
								addrcnt(1) <= x"58";
							elsif addrcnt(1) = x"6d" then
								addrcnt(1) <= x"63";
							elsif addrcnt(1) = x"78" then
								addrcnt(1) <= x"6e";
							elsif addrcnt(1) = x"83" then
								addrcnt(1) <= x"79";
							elsif addrcnt(1) = x"8e" then
								addrcnt(1) <= x"84";
							elsif addrcnt(1) = x"99" then
								addrcnt(1) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "000010" )or (p1_c3 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
						if( ((p1_c4 = "000010" )or (p1_c4 = "001111"))
						or ((p1_c5 = "000010" )or (p1_c5 = "001111"))or ((p1_c6 = "000010" )or (p1_c6 = "001111"))or ((p2_c1 = "000010" )or (p2_c1 = "001111"))
						or ((p2_c2 = "000010" )or (p2_c2 = "001111"))) then
							if addrcnt(2) = x"0a" then
								addrcnt(2) <= (others => '0');
							elsif addrcnt(2) = x"15" then
								addrcnt(2) <= x"0b";
							elsif addrcnt(2) = x"20" then
								addrcnt(2) <= x"16";
							elsif addrcnt(2) = x"2b" then
								addrcnt(2) <= x"21";
							elsif addrcnt(2) = x"36" then
								addrcnt(2) <= x"2c";
							elsif addrcnt(2) = x"41" then
								addrcnt(2) <= x"37";
							elsif addrcnt(2) = x"4c" then
								addrcnt(2) <= x"42";
							elsif addrcnt(2) = x"57" then
								addrcnt(2) <= x"4d";
							elsif addrcnt(2) = x"62" then
								addrcnt(2) <= x"58";
							elsif addrcnt(2) = x"6d" then
								addrcnt(2) <= x"63";
							elsif addrcnt(2) = x"78" then
								addrcnt(2) <= x"6e";
							elsif addrcnt(2) = x"83" then
								addrcnt(2) <= x"79";
							elsif addrcnt(2) = x"8e" then
								addrcnt(2) <= x"84";
							elsif addrcnt(2) = x"99" then
								addrcnt(2) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "000011" )or (p1_c3 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
						if(((p1_c4 = "000011" )or (p1_c4 = "010000"))
						or ((p1_c5 = "000011" )or (p1_c5 = "010000"))or ((p1_c6 = "000011" )or (p1_c6 = "010000"))or ((p2_c1 = "000011" )or (p2_c1 = "010000"))
						or ((p2_c2 = "000011" )or (p2_c2 = "010000"))) then
							if addrcnt(3) = x"0a" then
								addrcnt(3) <= (others => '0');
							elsif addrcnt(3) = x"15" then
								addrcnt(3) <= x"0b";
							elsif addrcnt(3) = x"20" then
								addrcnt(3) <= x"16";
							elsif addrcnt(3) = x"2b" then
								addrcnt(3) <= x"21";
							elsif addrcnt(3) = x"36" then
								addrcnt(3) <= x"2c";
							elsif addrcnt(3) = x"41" then
								addrcnt(3) <= x"37";
							elsif addrcnt(3) = x"4c" then
								addrcnt(3) <= x"42";
							elsif addrcnt(3) = x"57" then
								addrcnt(3) <= x"4d";
							elsif addrcnt(3) = x"62" then
								addrcnt(3) <= x"58";
							elsif addrcnt(3) = x"6d" then
								addrcnt(3) <= x"63";
							elsif addrcnt(3) = x"78" then
								addrcnt(3) <= x"6e";
							elsif addrcnt(3) = x"83" then
								addrcnt(3) <= x"79";
							elsif addrcnt(3) = x"8e" then
								addrcnt(3) <= x"84";
							elsif addrcnt(3) = x"99" then
								addrcnt(3) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "000100" )or (p1_c3 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);
						if(((p1_c4 = "000100" )or (p1_c4 = "010001"))
						or ((p1_c5 = "000100" )or (p1_c5 = "010001"))or ((p1_c6 = "000100" )or (p1_c6 = "010001"))or ((p2_c1 = "000100" )or (p2_c1 = "010001"))
						or ((p2_c2 = "000100" )or (p2_c2 = "010001"))) then
							if addrcnt(4) = x"0a" then
								addrcnt(4) <= (others => '0');
							elsif addrcnt(4) = x"15" then
								addrcnt(4) <= x"0b";
							elsif addrcnt(4) = x"20" then
								addrcnt(4) <= x"16";
							elsif addrcnt(4) = x"2b" then
								addrcnt(4) <= x"21";
							elsif addrcnt(4) = x"36" then
								addrcnt(4) <= x"2c";
							elsif addrcnt(4) = x"41" then
								addrcnt(4) <= x"37";
							elsif addrcnt(4) = x"4c" then
								addrcnt(4) <= x"42";
							elsif addrcnt(4) = x"57" then
								addrcnt(4) <= x"4d";
							elsif addrcnt(4) = x"62" then
								addrcnt(4) <= x"58";
							elsif addrcnt(4) = x"6d" then
								addrcnt(4) <= x"63";
							elsif addrcnt(4) = x"78" then
								addrcnt(4) <= x"6e";
							elsif addrcnt(4) = x"83" then
								addrcnt(4) <= x"79";
							elsif addrcnt(4) = x"8e" then
								addrcnt(4) <= x"84";
							elsif addrcnt(4) = x"99" then
								addrcnt(4) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "000101" )or (p1_c3 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);
						if( ((p1_c4 = "000101" )or (p1_c4 = "010010"))
						or ((p1_c5 = "000101" )or (p1_c5 = "010010"))or ((p1_c6 = "000101" )or (p1_c6 = "010010"))or ((p2_c1 = "000101" )or (p2_c1 = "010010"))
						or ((p2_c2 = "000101" )or (p2_c2 = "010010"))) then
							if addrcnt(5) = x"0a" then
								addrcnt(5) <= (others => '0');
							elsif addrcnt(5) = x"15" then
								addrcnt(5) <= x"0b";
							elsif addrcnt(5) = x"20" then
								addrcnt(5) <= x"16";
							elsif addrcnt(5) = x"2b" then
								addrcnt(5) <= x"21";
							elsif addrcnt(5) = x"36" then
								addrcnt(5) <= x"2c";
							elsif addrcnt(5) = x"41" then
								addrcnt(5) <= x"37";
							elsif addrcnt(5) = x"4c" then
								addrcnt(5) <= x"42";
							elsif addrcnt(5) = x"57" then
								addrcnt(5) <= x"4d";
							elsif addrcnt(5) = x"62" then
								addrcnt(5) <= x"58";
							elsif addrcnt(5) = x"6d" then
								addrcnt(5) <= x"63";
							elsif addrcnt(5) = x"78" then
								addrcnt(5) <= x"6e";
							elsif addrcnt(5) = x"83" then
								addrcnt(5) <= x"79";
							elsif addrcnt(5) = x"8e" then
								addrcnt(5) <= x"84";
							elsif addrcnt(5) = x"99" then
								addrcnt(5) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "000110" )or (p1_c3 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);
						if(((p1_c4 = "0000110" )or (p1_c4 = "010011"))
						or ((p1_c5 = "0000110" )or (p1_c5 = "010011"))or ((p1_c6 = "0000110" )or (p1_c6 = "010011"))or ((p2_c1 = "0000110" )or (p2_c1 = "010011"))
						or ((p2_c2 = "0000110" )or (p2_c2 = "010011"))) then
							if addrcnt(6) = x"0a" then
								addrcnt(6) <= (others => '0');
							elsif addrcnt(6) = x"15" then
								addrcnt(6) <= x"0b";
							elsif addrcnt(6) = x"20" then
								addrcnt(6) <= x"16";
							elsif addrcnt(6) = x"2b" then
								addrcnt(6) <= x"21";
							elsif addrcnt(6) = x"36" then
								addrcnt(6) <= x"2c";
							elsif addrcnt(6) = x"41" then
								addrcnt(6) <= x"37";
							elsif addrcnt(6) = x"4c" then
								addrcnt(6) <= x"42";
							elsif addrcnt(6) = x"57" then
								addrcnt(6) <= x"4d";
							elsif addrcnt(6) = x"62" then
								addrcnt(6) <= x"58";
							elsif addrcnt(6) = x"6d" then
								addrcnt(6) <= x"63";
							elsif addrcnt(6) = x"78" then
								addrcnt(6) <= x"6e";
							elsif addrcnt(6) = x"83" then
								addrcnt(6) <= x"79";
							elsif addrcnt(6) = x"8e" then
								addrcnt(6) <= x"84";
							elsif addrcnt(6) = x"99" then
								addrcnt(6) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "000111" )or (p1_c3 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);
						if( ((p1_c4 = "0000111" )or (p1_c4 = "010100"))
						or ((p1_c5 = "0000111" )or (p1_c5 = "010100"))or ((p1_c6 = "0000111" )or (p1_c6 = "010100"))or ((p2_c1 = "0000111" )or (p2_c1 = "010100"))
						or ((p2_c2 = "0000111" )or (p2_c2 = "010100"))) then
							if addrcnt(7) = x"0a" then
								addrcnt(7) <= (others => '0');
							elsif addrcnt(7) = x"15" then
								addrcnt(7) <= x"0b";
							elsif addrcnt(7) = x"20" then
								addrcnt(7) <= x"16";
							elsif addrcnt(7) = x"2b" then
								addrcnt(7) <= x"21";
							elsif addrcnt(7) = x"36" then
								addrcnt(7) <= x"2c";
							elsif addrcnt(7) = x"41" then
								addrcnt(7) <= x"37";
							elsif addrcnt(7) = x"4c" then
								addrcnt(7) <= x"42";
							elsif addrcnt(7) = x"57" then
								addrcnt(7) <= x"4d";
							elsif addrcnt(7) = x"62" then
								addrcnt(7) <= x"58";
							elsif addrcnt(7) = x"6d" then
								addrcnt(7) <= x"63";
							elsif addrcnt(7) = x"78" then
								addrcnt(7) <= x"6e";
							elsif addrcnt(7) = x"83" then
								addrcnt(7) <= x"79";
							elsif addrcnt(7) = x"8e" then
								addrcnt(7) <= x"84";
							elsif addrcnt(7) = x"99" then
								addrcnt(7) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "001000" )or (p1_c3 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
						if( ((p1_c4 = "001000" )or (p1_c4 = "010101"))
						or ((p1_c5 = "001000" )or (p1_c5 = "010101"))or ((p1_c6 = "001000" )or (p1_c6 = "010101"))or ((p2_c1 = "001000" )or (p2_c1 = "010101"))
						or ((p2_c2 = "001000" )or (p2_c2 = "010101"))) then
							if addrcnt(8) = x"0a" then
								addrcnt(8) <= (others => '0');
							elsif addrcnt(8) = x"15" then
								addrcnt(8) <= x"0b";
							elsif addrcnt(8) = x"20" then
								addrcnt(8) <= x"16";
							elsif addrcnt(8) = x"2b" then
								addrcnt(8) <= x"21";
							elsif addrcnt(8) = x"36" then
								addrcnt(8) <= x"2c";
							elsif addrcnt(8) = x"41" then
								addrcnt(8) <= x"37";
							elsif addrcnt(8) = x"4c" then
								addrcnt(8) <= x"42";
							elsif addrcnt(8) = x"57" then
								addrcnt(8) <= x"4d";
							elsif addrcnt(8) = x"62" then
								addrcnt(8) <= x"58";
							elsif addrcnt(8) = x"6d" then
								addrcnt(8) <= x"63";
							elsif addrcnt(8) = x"78" then
								addrcnt(8) <= x"6e";
							elsif addrcnt(8) = x"83" then
								addrcnt(8) <= x"79";
							elsif addrcnt(8) = x"8e" then
								addrcnt(8) <= x"84";
							elsif addrcnt(8) = x"99" then
								addrcnt(8) <= x"8f";
							end if;
						end if;
					elsif (p1_c3= "001001" )or (p1_c3 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);
						if(((p1_c4 = "001001" )or (p1_c4 = "010110"))
						or ((p1_c5 = "001001" )or (p1_c5 = "010110"))or ((p1_c6 = "001001" )or (p1_c6 = "010110"))or ((p2_c1 = "001001" )or (p2_c1 = "010110"))
						or ((p2_c2 = "001001" )or (p2_c2 = "010110"))) then
							if addrcnt(9) = x"0a" then
								addrcnt(9) <= (others => '0');
							elsif addrcnt(9) = x"15" then
								addrcnt(9) <= x"0b";
							elsif addrcnt(9) = x"20" then
								addrcnt(9) <= x"16";
							elsif addrcnt(9) = x"2b" then
								addrcnt(9) <= x"21";
							elsif addrcnt(9) = x"36" then
								addrcnt(9) <= x"2c";
							elsif addrcnt(9) = x"41" then
								addrcnt(9) <= x"37";
							elsif addrcnt(9) = x"4c" then
								addrcnt(9) <= x"42";
							elsif addrcnt(9) = x"57" then
								addrcnt(9) <= x"4d";
							elsif addrcnt(9) = x"62" then
								addrcnt(9) <= x"58";
							elsif addrcnt(9) = x"6d" then
								addrcnt(9) <= x"63";
							elsif addrcnt(9) = x"78" then
								addrcnt(9) <= x"6e";
							elsif addrcnt(9) = x"83" then
								addrcnt(9) <= x"79";
							elsif addrcnt(9) = x"8e" then
								addrcnt(9) <= x"84";
							elsif addrcnt(9) = x"99" then
								addrcnt(9) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "001010" )or (p1_c3 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);
						if( ((p1_c4 = "001010" )or (p1_c4 = "010111"))
						or ((p1_c5 = "001010" )or (p1_c5 = "010111"))or ((p1_c6 = "001010" )or (p1_c6 = "010111"))or ((p2_c1 = "001010" )or (p2_c1 = "010111"))
						or ((p2_c2 = "001010" )or (p2_c2 = "010111"))) then
							if addrcnt(10) = x"0a" then
								addrcnt(10) <= (others => '0');
							elsif addrcnt(10) = x"15" then
								addrcnt(10) <= x"0b";
							elsif addrcnt(10) = x"20" then
								addrcnt(10) <= x"16";
							elsif addrcnt(10) = x"2b" then
								addrcnt(10) <= x"21";
							elsif addrcnt(10) = x"36" then
								addrcnt(10) <= x"2c";
							elsif addrcnt(10) = x"41" then
								addrcnt(10) <= x"37";
							elsif addrcnt(10) = x"4c" then
								addrcnt(10) <= x"42";
							elsif addrcnt(10) = x"57" then
								addrcnt(10) <= x"4d";
							elsif addrcnt(10) = x"62" then
								addrcnt(10) <= x"58";
							elsif addrcnt(10) = x"6d" then
								addrcnt(10) <= x"63";
							elsif addrcnt(10) = x"78" then
								addrcnt(10) <= x"6e";
							elsif addrcnt(10) = x"83" then
								addrcnt(10) <= x"79";
							elsif addrcnt(10) = x"8e" then
								addrcnt(10) <= x"84";
							elsif addrcnt(10) = x"99" then
								addrcnt(10) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "001011" )or (p1_c3 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);
						if( ((p1_c4 = "001011" )or (p1_c4 = "011000"))
						or ((p1_c5 = "001011" )or (p1_c5 = "011000"))or ((p1_c6 = "001011" )or (p1_c6 = "011000"))or ((p2_c1 = "001011" )or (p2_c1 = "011000"))
						or ((p2_c2 = "001011" )or (p2_c2 = "011000"))) then
							if addrcnt(11) = x"0a" then
								addrcnt(11) <= (others => '0');
							elsif addrcnt(11) = x"15" then
								addrcnt(11) <= x"0b";
							elsif addrcnt(11) = x"20" then
								addrcnt(11) <= x"16";
							elsif addrcnt(11) = x"2b" then
								addrcnt(11) <= x"21";
							elsif addrcnt(11) = x"36" then
								addrcnt(11) <= x"2c";
							elsif addrcnt(11) = x"41" then
								addrcnt(11) <= x"37";
							elsif addrcnt(11) = x"4c" then
								addrcnt(11) <= x"42";
							elsif addrcnt(11) = x"57" then
								addrcnt(11) <= x"4d";
							elsif addrcnt(11) = x"62" then
								addrcnt(11) <= x"58";
							elsif addrcnt(11) = x"6d" then
								addrcnt(11) <= x"63";
							elsif addrcnt(11) = x"78" then
								addrcnt(11) <= x"6e";
							elsif addrcnt(11) = x"83" then
								addrcnt(11) <= x"79";
							elsif addrcnt(11) = x"8e" then
								addrcnt(11) <= x"84";
							elsif addrcnt(11) = x"99" then
								addrcnt(11) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "001100" )or (p1_c3 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
						if(((p1_c4 = "001100" )or (p1_c4 = "011001"))
						or ((p1_c5 = "001100" )or (p1_c5 = "011001"))or ((p1_c6 = "001100" )or (p1_c6 = "011001"))or ((p2_c1 = "001100" )or (p2_c1 = "011001"))
						or ((p2_c2 = "001100" )or (p2_c2 = "011001"))) then
							if addrcnt(12) = x"0a" then
								addrcnt(12) <= (others => '0');
							elsif addrcnt(12) = x"15" then
								addrcnt(12) <= x"0b";
							elsif addrcnt(12) = x"20" then
								addrcnt(12) <= x"16";
							elsif addrcnt(12) = x"2b" then
								addrcnt(12) <= x"21";
							elsif addrcnt(12) = x"36" then
								addrcnt(12) <= x"2c";
							elsif addrcnt(12) = x"41" then
								addrcnt(12) <= x"37";
							elsif addrcnt(12) = x"4c" then
								addrcnt(12) <= x"42";
							elsif addrcnt(12) = x"57" then
								addrcnt(12) <= x"4d";
							elsif addrcnt(12) = x"62" then
								addrcnt(12) <= x"58";
							elsif addrcnt(12) = x"6d" then
								addrcnt(12) <= x"63";
							elsif addrcnt(12) = x"78" then
								addrcnt(12) <= x"6e";
							elsif addrcnt(12) = x"83" then
								addrcnt(12) <= x"79";
							elsif addrcnt(12) = x"8e" then
								addrcnt(12) <= x"84";
							elsif addrcnt(12) = x"99" then
								addrcnt(12) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "011010" )or (p1_c3 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
						if(((p1_c4 = "011010" )or (p1_c4 = "100111"))
						or ((p1_c5 = "011010" )or (p1_c5 = "100111"))or ((p1_c6 = "011010" )or (p1_c6 = "100111"))or ((p2_c1 = "011010" )or (p2_c1 = "100111"))
						or ((p2_c2 = "011010" )or (p2_c2 = "100111"))) then
							if addrcnt(13) = x"0a" then
								addrcnt(13) <= (others => '0');
							elsif addrcnt(13) = x"15" then
								addrcnt(13) <= x"0b";
							elsif addrcnt(13) = x"20" then
								addrcnt(13) <= x"16";
							elsif addrcnt(13) = x"2b" then
								addrcnt(13) <= x"21";
							elsif addrcnt(13) = x"36" then
								addrcnt(13) <= x"2c";
							elsif addrcnt(13) = x"41" then
								addrcnt(13) <= x"37";
							elsif addrcnt(13) = x"4c" then
								addrcnt(13) <= x"42";
							elsif addrcnt(13) = x"57" then
								addrcnt(13) <= x"4d";
							elsif addrcnt(13) = x"62" then
								addrcnt(13) <= x"58";
							elsif addrcnt(13) = x"6d" then
								addrcnt(13) <= x"63";
							elsif addrcnt(13) = x"78" then
								addrcnt(13) <= x"6e";
							elsif addrcnt(13) = x"83" then
								addrcnt(13) <= x"79";
							elsif addrcnt(13) = x"8e" then
								addrcnt(13) <= x"84";
							elsif addrcnt(13) = x"99" then
								addrcnt(13) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "011011" )or (p1_c3 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
						if(((p1_c4 = "011011" )or (p1_c4 = "101000"))
						or ((p1_c5 = "011011" )or (p1_c5 = "101000"))or ((p1_c6 = "011011" )or (p1_c6 = "101000"))or ((p2_c1 = "011011" )or (p2_c1 = "101000"))
						or ((p2_c2 = "011011" )or (p2_c2 = "101000"))) then
							if addrcnt(14) = x"0a" then
								addrcnt(14) <= (others => '0');
							elsif addrcnt(14) = x"15" then
								addrcnt(14) <= x"0b";
							elsif addrcnt(14) = x"20" then
								addrcnt(14) <= x"16";
							elsif addrcnt(14) = x"2b" then
								addrcnt(14) <= x"21";
							elsif addrcnt(14) = x"36" then
								addrcnt(14) <= x"2c";
							elsif addrcnt(14) = x"41" then
								addrcnt(14) <= x"37";
							elsif addrcnt(14) = x"4c" then
								addrcnt(14) <= x"42";
							elsif addrcnt(14) = x"57" then
								addrcnt(14) <= x"4d";
							elsif addrcnt(14) = x"62" then
								addrcnt(14) <= x"58";
							elsif addrcnt(14) = x"6d" then
								addrcnt(14) <= x"63";
							elsif addrcnt(14) = x"78" then
								addrcnt(14) <= x"6e";
							elsif addrcnt(14) = x"83" then
								addrcnt(14) <= x"79";
							elsif addrcnt(14) = x"8e" then
								addrcnt(14) <= x"84";
							elsif addrcnt(14) = x"99" then
								addrcnt(14) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "011100" )or (p1_c3 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
						if( ((p1_c4 = "011100" )or (p1_c4 = "101001"))
						or ((p1_c5 = "011100" )or (p1_c5 = "101001"))or ((p1_c6 = "011100" )or (p1_c6 = "101001"))or ((p2_c1 = "011100" )or (p2_c1 = "101001"))
						or ((p2_c2 = "011100" )or (p2_c2 = "101001"))) then
							if addrcnt(15) = x"0a" then
								addrcnt(15) <= (others => '0');
							elsif addrcnt(15) = x"15" then
								addrcnt(15) <= x"0b";
							elsif addrcnt(15) = x"20" then
								addrcnt(15) <= x"16";
							elsif addrcnt(15) = x"2b" then
								addrcnt(15) <= x"21";
							elsif addrcnt(15) = x"36" then
								addrcnt(15) <= x"2c";
							elsif addrcnt(15) = x"41" then
								addrcnt(15) <= x"37";
							elsif addrcnt(15) = x"4c" then
								addrcnt(15) <= x"42";
							elsif addrcnt(15) = x"57" then
								addrcnt(15) <= x"4d";
							elsif addrcnt(15) = x"62" then
								addrcnt(15) <= x"58";
							elsif addrcnt(15) = x"6d" then
								addrcnt(15) <= x"63";
							elsif addrcnt(15) = x"78" then
								addrcnt(15) <= x"6e";
							elsif addrcnt(15) = x"83" then
								addrcnt(15) <= x"79";
							elsif addrcnt(15) = x"8e" then
								addrcnt(15) <= x"84";
							elsif addrcnt(15) = x"99" then
								addrcnt(15) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "011101" )or (p1_c3 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
						if(((p1_c4 = "011101" )or (p1_c4 = "101010"))
						or ((p1_c5 = "011101" )or (p1_c5 = "101010"))or ((p1_c6 = "011101" )or (p1_c6 = "101010"))or ((p2_c1 = "011101" )or (p2_c1 = "101010"))
						or ((p2_c2 = "011101" )or (p2_c2 = "101010"))) then
							if addrcnt(16) = x"0a" then
								addrcnt(16) <= (others => '0');
							elsif addrcnt(16) = x"15" then
								addrcnt(16) <= x"0b";
							elsif addrcnt(16) = x"20" then
								addrcnt(16) <= x"16";
							elsif addrcnt(16) = x"2b" then
								addrcnt(16) <= x"21";
							elsif addrcnt(16) = x"36" then
								addrcnt(16) <= x"2c";
							elsif addrcnt(16) = x"41" then
								addrcnt(16) <= x"37";
							elsif addrcnt(16) = x"4c" then
								addrcnt(16) <= x"42";
							elsif addrcnt(16) = x"57" then
								addrcnt(16) <= x"4d";
							elsif addrcnt(16) = x"62" then
								addrcnt(16) <= x"58";
							elsif addrcnt(16) = x"6d" then
								addrcnt(16) <= x"63";
							elsif addrcnt(16) = x"78" then
								addrcnt(16) <= x"6e";
							elsif addrcnt(16) = x"83" then
								addrcnt(16) <= x"79";
							elsif addrcnt(16) = x"8e" then
								addrcnt(16) <= x"84";
							elsif addrcnt(16) = x"99" then
								addrcnt(16) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "011110" )or (p1_c3 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);
						if(((p1_c4 = "011110" )or (p1_c4 = "101011"))
						or ((p1_c5 = "011110" )or (p1_c5 = "101011"))or ((p1_c6 = "011110" )or (p1_c6 = "101011"))or ((p2_c1 = "011110" )or (p2_c1 = "101011"))
						or ((p2_c2 = "011110" )or (p2_c2 = "101011"))) then
							if addrcnt(17) = x"0a" then
								addrcnt(17) <= (others => '0');
							elsif addrcnt(17) = x"15" then
								addrcnt(17) <= x"0b";
							elsif addrcnt(17) = x"20" then
								addrcnt(17) <= x"16";
							elsif addrcnt(17) = x"2b" then
								addrcnt(17) <= x"21";
							elsif addrcnt(17) = x"36" then
								addrcnt(17) <= x"2c";
							elsif addrcnt(17) = x"41" then
								addrcnt(17) <= x"37";
							elsif addrcnt(17) = x"4c" then
								addrcnt(17) <= x"42";
							elsif addrcnt(17) = x"57" then
								addrcnt(17) <= x"4d";
							elsif addrcnt(17) = x"62" then
								addrcnt(17) <= x"58";
							elsif addrcnt(17) = x"6d" then
								addrcnt(17) <= x"63";
							elsif addrcnt(17) = x"78" then
								addrcnt(17) <= x"6e";
							elsif addrcnt(17) = x"83" then
								addrcnt(17) <= x"79";
							elsif addrcnt(17) = x"8e" then
								addrcnt(17) <= x"84";
							elsif addrcnt(17) = x"99" then
								addrcnt(17) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "011111" )or (p1_c3 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);
						if( ((p1_c4 = "011111" )or (p1_c4 = "101100"))
						or ((p1_c5 = "011111" )or (p1_c5 = "101100"))or ((p1_c6 = "011111" )or (p1_c6 = "101100"))or ((p2_c1 = "011111" )or (p2_c1 = "101100"))
						or ((p2_c2 = "011111" )or (p2_c2 = "101100"))) then
							if addrcnt(18) = x"0a" then
								addrcnt(18) <= (others => '0');
							elsif addrcnt(18) = x"15" then
								addrcnt(18) <= x"0b";
							elsif addrcnt(18) = x"20" then
								addrcnt(18) <= x"16";
							elsif addrcnt(18) = x"2b" then
								addrcnt(18) <= x"21";
							elsif addrcnt(18) = x"36" then
								addrcnt(18) <= x"2c";
							elsif addrcnt(18) = x"41" then
								addrcnt(18) <= x"37";
							elsif addrcnt(18) = x"4c" then
								addrcnt(18) <= x"42";
							elsif addrcnt(18) = x"57" then
								addrcnt(18) <= x"4d";
							elsif addrcnt(18) = x"62" then
								addrcnt(18) <= x"58";
							elsif addrcnt(18) = x"6d" then
								addrcnt(18) <= x"63";
							elsif addrcnt(18) = x"78" then
								addrcnt(18) <= x"6e";
							elsif addrcnt(18) = x"83" then
								addrcnt(18) <= x"79";
							elsif addrcnt(18) = x"8e" then
								addrcnt(18) <= x"84";
							elsif addrcnt(18) = x"99" then
								addrcnt(18) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "100000" )or (p1_c3 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
						if(((p1_c4 = "100000" )or (p1_c4 = "101101"))
						or ((p1_c5 = "100000" )or (p1_c5 = "101101"))or ((p1_c6 = "100000" )or (p1_c6 = "101101"))or ((p2_c1 = "100000" )or (p2_c1 = "101101"))
						or ((p2_c2 = "100000" )or (p2_c2 = "101101"))) then
							if addrcnt(19) = x"0a" then
								addrcnt(19) <= (others => '0');
							elsif addrcnt(19) = x"15" then
								addrcnt(19) <= x"0b";
							elsif addrcnt(19) = x"20" then
								addrcnt(19) <= x"16";
							elsif addrcnt(19) = x"2b" then
								addrcnt(19) <= x"21";
							elsif addrcnt(19) = x"36" then
								addrcnt(19) <= x"2c";
							elsif addrcnt(19) = x"41" then
								addrcnt(19) <= x"37";
							elsif addrcnt(19) = x"4c" then
								addrcnt(19) <= x"42";
							elsif addrcnt(19) = x"57" then
								addrcnt(19) <= x"4d";
							elsif addrcnt(19) = x"62" then
								addrcnt(19) <= x"58";
							elsif addrcnt(19) = x"6d" then
								addrcnt(19) <= x"63";
							elsif addrcnt(19) = x"78" then
								addrcnt(19) <= x"6e";
							elsif addrcnt(19) = x"83" then
								addrcnt(19) <= x"79";
							elsif addrcnt(19) = x"8e" then
								addrcnt(19) <= x"84";
							elsif addrcnt(19) = x"99" then
								addrcnt(19) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "100001" )or (p1_c3 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
						if( ((p1_c4 = "100001" )or (p1_c4 = "101110"))
						or ((p1_c5 = "100001" )or (p1_c5 = "101110"))or ((p1_c6 = "100001" )or (p1_c6 = "101110"))or ((p2_c1 = "100001" )or (p2_c1 = "101110"))
						or ((p2_c2 = "100001" )or (p2_c2 = "101110"))) then
							if addrcnt(20) = x"0a" then
								addrcnt(20) <= (others => '0');
							elsif addrcnt(20) = x"15" then
								addrcnt(20) <= x"0b";
							elsif addrcnt(20) = x"20" then
								addrcnt(20) <= x"16";
							elsif addrcnt(20) = x"2b" then
								addrcnt(20) <= x"21";
							elsif addrcnt(20) = x"36" then
								addrcnt(20) <= x"2c";
							elsif addrcnt(20) = x"41" then
								addrcnt(20) <= x"37";
							elsif addrcnt(20) = x"4c" then
								addrcnt(20) <= x"42";
							elsif addrcnt(20) = x"57" then
								addrcnt(20) <= x"4d";
							elsif addrcnt(20) = x"62" then
								addrcnt(20) <= x"58";
							elsif addrcnt(20) = x"6d" then
								addrcnt(20) <= x"63";
							elsif addrcnt(20) = x"78" then
								addrcnt(20) <= x"6e";
							elsif addrcnt(20) = x"83" then
								addrcnt(20) <= x"79";
							elsif addrcnt(20) = x"8e" then
								addrcnt(20) <= x"84";
							elsif addrcnt(20) = x"99" then
								addrcnt(20) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "100010" )or (p1_c3 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
						if( ((p1_c4 = "100010" )or (p1_c4 = "101111"))
						or ((p1_c5 = "100010" )or (p1_c5 = "101111"))or ((p1_c6 = "100010" )or (p1_c6 = "101111"))or ((p2_c1 = "100010" )or (p2_c1 = "101111"))
						or ((p2_c2 = "100010" )or (p2_c2 = "101111"))) then
							if addrcnt(21) = x"0a" then
								addrcnt(21) <= (others => '0');
							elsif addrcnt(21) = x"15" then
								addrcnt(21) <= x"0b";
							elsif addrcnt(21) = x"20" then
								addrcnt(21) <= x"16";
							elsif addrcnt(21) = x"2b" then
								addrcnt(21) <= x"21";
							elsif addrcnt(21) = x"36" then
								addrcnt(21) <= x"2c";
							elsif addrcnt(21) = x"41" then
								addrcnt(21) <= x"37";
							elsif addrcnt(21) = x"4c" then
								addrcnt(21) <= x"42";
							elsif addrcnt(21) = x"57" then
								addrcnt(21) <= x"4d";
							elsif addrcnt(21) = x"62" then
								addrcnt(21) <= x"58";
							elsif addrcnt(21) = x"6d" then
								addrcnt(21) <= x"63";
							elsif addrcnt(21) = x"78" then
								addrcnt(21) <= x"6e";
							elsif addrcnt(21) = x"83" then
								addrcnt(21) <= x"79";
							elsif addrcnt(21) = x"8e" then
								addrcnt(21) <= x"84";
							elsif addrcnt(21) = x"99" then
								addrcnt(21) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "100011" )or (p1_c3 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);
						if( ((p1_c4 = "100011" )or (p1_c4 = "110000"))
						or ((p1_c5 = "100011" )or (p1_c5 = "110000"))or ((p1_c6 = "100011" )or (p1_c6 = "110000"))or ((p2_c1 = "100011" )or (p2_c1 = "110000"))
						or ((p2_c2 = "100011" )or (p2_c2 = "110000"))) then
							if addrcnt(22) = x"0a" then
								addrcnt(22) <= (others => '0');
							elsif addrcnt(22) = x"15" then
								addrcnt(22) <= x"0b";
							elsif addrcnt(22) = x"20" then
								addrcnt(22) <= x"16";
							elsif addrcnt(22) = x"2b" then
								addrcnt(22) <= x"21";
							elsif addrcnt(22) = x"36" then
								addrcnt(22) <= x"2c";
							elsif addrcnt(22) = x"41" then
								addrcnt(22) <= x"37";
							elsif addrcnt(22) = x"4c" then
								addrcnt(22) <= x"42";
							elsif addrcnt(22) = x"57" then
								addrcnt(22) <= x"4d";
							elsif addrcnt(22) = x"62" then
								addrcnt(22) <= x"58";
							elsif addrcnt(22) = x"6d" then
								addrcnt(22) <= x"63";
							elsif addrcnt(22) = x"78" then
								addrcnt(22) <= x"6e";
							elsif addrcnt(22) = x"83" then
								addrcnt(22) <= x"79";
							elsif addrcnt(22) = x"8e" then
								addrcnt(22) <= x"84";
							elsif addrcnt(22) = x"99" then
								addrcnt(22) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "100100" )or (p1_c3 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
						if(((p1_c4 = "100100" )or (p1_c4 = "110001"))
						or ((p1_c5 = "100100" )or (p1_c5 = "110001"))or ((p1_c6 = "100100" )or (p1_c6 = "110001"))or ((p2_c1 = "100100" )or (p2_c1 = "110001"))
						or ((p2_c2 = "100100" )or (p2_c2 = "110001"))) then
							if addrcnt(23) = x"0a" then
								addrcnt(23) <= (others => '0');
							elsif addrcnt(23) = x"15" then
								addrcnt(23) <= x"0b";
							elsif addrcnt(23) = x"20" then
								addrcnt(23) <= x"16";
							elsif addrcnt(23) = x"2b" then
								addrcnt(23) <= x"21";
							elsif addrcnt(23) = x"36" then
								addrcnt(23) <= x"2c";
							elsif addrcnt(23) = x"41" then
								addrcnt(23) <= x"37";
							elsif addrcnt(23) = x"4c" then
								addrcnt(23) <= x"42";
							elsif addrcnt(23) = x"57" then
								addrcnt(23) <= x"4d";
							elsif addrcnt(23) = x"62" then
								addrcnt(23) <= x"58";
							elsif addrcnt(23) = x"6d" then
								addrcnt(23) <= x"63";
							elsif addrcnt(23) = x"78" then
								addrcnt(23) <= x"6e";
							elsif addrcnt(23) = x"83" then
								addrcnt(23) <= x"79";
							elsif addrcnt(23) = x"8e" then
								addrcnt(23) <= x"84";
							elsif addrcnt(23) = x"99" then
								addrcnt(23) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "100101" )or (p1_c3 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
						if(((p1_c4 = "100101" )or (p1_c4 = "110010"))
						or ((p1_c5 = "100101" )or (p1_c5 = "110010"))or ((p1_c6 = "100101" )or (p1_c6 = "110010"))or ((p2_c1 = "100101" )or (p2_c1 = "110010"))
						or ((p2_c2 = "100101" )or (p2_c2 = "110010"))) then
							if addrcnt(24) = x"0a" then
								addrcnt(24) <= (others => '0');
							elsif addrcnt(24) = x"15" then
								addrcnt(24) <= x"0b";
							elsif addrcnt(24) = x"20" then
								addrcnt(24) <= x"16";
							elsif addrcnt(24) = x"2b" then
								addrcnt(24) <= x"21";
							elsif addrcnt(24) = x"36" then
								addrcnt(24) <= x"2c";
							elsif addrcnt(24) = x"41" then
								addrcnt(24) <= x"37";
							elsif addrcnt(24) = x"4c" then
								addrcnt(24) <= x"42";
							elsif addrcnt(24) = x"57" then
								addrcnt(24) <= x"4d";
							elsif addrcnt(24) = x"62" then
								addrcnt(24) <= x"58";
							elsif addrcnt(24) = x"6d" then
								addrcnt(24) <= x"63";
							elsif addrcnt(24) = x"78" then
								addrcnt(24) <= x"6e";
							elsif addrcnt(24) = x"83" then
								addrcnt(24) <= x"79";
							elsif addrcnt(24) = x"8e" then
								addrcnt(24) <= x"84";
							elsif addrcnt(24) = x"99" then
								addrcnt(24) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "100110" )or (p1_c3 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
						if(((p1_c4 = "100110" )or (p1_c4 = "110011"))
						or ((p1_c5 = "100110" )or (p1_c5 = "110011"))or ((p1_c6 = "100110" )or (p1_c6 = "110011"))or ((p2_c1 = "100110" )or (p2_c1 = "110011"))
						or ((p2_c2 = "100110" )or (p2_c2 = "110011"))) then
							if addrcnt(25) = x"0a" then
								addrcnt(25) <= (others => '0');
							elsif addrcnt(25) = x"15" then
								addrcnt(25) <= x"0b";
							elsif addrcnt(25) = x"20" then
								addrcnt(25) <= x"16";
							elsif addrcnt(25) = x"2b" then
								addrcnt(25) <= x"21";
							elsif addrcnt(25) = x"36" then
								addrcnt(25) <= x"2c";
							elsif addrcnt(25) = x"41" then
								addrcnt(25) <= x"37";
							elsif addrcnt(25) = x"4c" then
								addrcnt(25) <= x"42";
							elsif addrcnt(25) = x"57" then
								addrcnt(25) <= x"4d";
							elsif addrcnt(25) = x"62" then
								addrcnt(25) <= x"58";
							elsif addrcnt(25) = x"6d" then
								addrcnt(25) <= x"63";
							elsif addrcnt(25) = x"78" then
								addrcnt(25) <= x"6e";
							elsif addrcnt(25) = x"83" then
								addrcnt(25) <= x"79";
							elsif addrcnt(25) = x"8e" then
								addrcnt(25) <= x"84";
							elsif addrcnt(25) = x"99" then
								addrcnt(25) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +133) ) and ( hsync_cnt <= (tHW + tHBP +143)) ) then
					if (p1_c4 = "000000" )or (p1_c4 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
						if(((p1_c5 = "000000" )or (p1_c5 = "001101"))or ((p1_c6 = "000000" )or 
						(p1_c6 = "001101"))or ((p2_c1 = "000000" )or (p2_c1 = "001101")) or ((p2_c2 = "000000" )or (p2_c2 = "001101"))) then
							if addrcnt(0) = x"0a" then
								addrcnt(0) <= (others => '0');
							elsif addrcnt(0) = x"15" then
								addrcnt(0) <= x"0b";
							elsif addrcnt(0) = x"20" then
								addrcnt(0) <= x"16";
							elsif addrcnt(0) = x"2b" then
								addrcnt(0) <= x"21";
							elsif addrcnt(0) = x"36" then
								addrcnt(0) <= x"2c";
							elsif addrcnt(0) = x"41" then
								addrcnt(0) <= x"37";
							elsif addrcnt(0) = x"4c" then
								addrcnt(0) <= x"42";
							elsif addrcnt(0) = x"57" then
								addrcnt(0) <= x"4d";
							elsif addrcnt(0) = x"62" then
								addrcnt(0) <= x"58";
							elsif addrcnt(0) = x"6d" then
								addrcnt(0) <= x"63";
							elsif addrcnt(0) = x"78" then
								addrcnt(0) <= x"6e";
							elsif addrcnt(0) = x"83" then
								addrcnt(0) <= x"79";
							elsif addrcnt(0) = x"8e" then
								addrcnt(0) <= x"84";
							elsif addrcnt(0) = x"99" then
								addrcnt(0) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "000001" )or (p1_c4 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
						if(((p1_c5 = "000001" )or (p1_c5 = "001110"))or ((p1_c6 = "000001" )or 
						(p1_c6 = "001110"))or ((p2_c1 = "000001" )or (p2_c1 = "001110")) or ((p2_c2 = "000001" )or (p2_c2 = "001110"))) then
							if addrcnt(1) = x"0a" then
								addrcnt(1) <= (others => '0');
							elsif addrcnt(1) = x"15" then
								addrcnt(1) <= x"0b";
							elsif addrcnt(1) = x"20" then
								addrcnt(1) <= x"16";
							elsif addrcnt(1) = x"2b" then
								addrcnt(1) <= x"21";
							elsif addrcnt(1) = x"36" then
								addrcnt(1) <= x"2c";
							elsif addrcnt(1) = x"41" then
								addrcnt(1) <= x"37";
							elsif addrcnt(1) = x"4c" then
								addrcnt(1) <= x"42";
							elsif addrcnt(1) = x"57" then
								addrcnt(1) <= x"4d";
							elsif addrcnt(1) = x"62" then
								addrcnt(1) <= x"58";
							elsif addrcnt(1) = x"6d" then
								addrcnt(1) <= x"63";
							elsif addrcnt(1) = x"78" then
								addrcnt(1) <= x"6e";
							elsif addrcnt(1) = x"83" then
								addrcnt(1) <= x"79";
							elsif addrcnt(1) = x"8e" then
								addrcnt(1) <= x"84";
							elsif addrcnt(1) = x"99" then
								addrcnt(1) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "000010" )or (p1_c4 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
						if( ((p1_c5 = "000010" )or (p1_c5 = "001111"))or ((p1_c6 = "000010" )or (p1_c6 = "001111"))or ((p2_c1 = "000010" )or (p2_c1 = "001111"))
						or ((p2_c2 = "000010" )or (p2_c2 = "001111"))) then
							if addrcnt(2) = x"0a" then
								addrcnt(2) <= (others => '0');
							elsif addrcnt(2) = x"15" then
								addrcnt(2) <= x"0b";
							elsif addrcnt(2) = x"20" then
								addrcnt(2) <= x"16";
							elsif addrcnt(2) = x"2b" then
								addrcnt(2) <= x"21";
							elsif addrcnt(2) = x"36" then
								addrcnt(2) <= x"2c";
							elsif addrcnt(2) = x"41" then
								addrcnt(2) <= x"37";
							elsif addrcnt(2) = x"4c" then
								addrcnt(2) <= x"42";
							elsif addrcnt(2) = x"57" then
								addrcnt(2) <= x"4d";
							elsif addrcnt(2) = x"62" then
								addrcnt(2) <= x"58";
							elsif addrcnt(2) = x"6d" then
								addrcnt(2) <= x"63";
							elsif addrcnt(2) = x"78" then
								addrcnt(2) <= x"6e";
							elsif addrcnt(2) = x"83" then
								addrcnt(2) <= x"79";
							elsif addrcnt(2) = x"8e" then
								addrcnt(2) <= x"84";
							elsif addrcnt(2) = x"99" then
								addrcnt(2) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "000011" )or (p1_c4 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
						if(((p1_c5 = "000011" )or (p1_c5 = "010000"))or ((p1_c6 = "000011" )or (p1_c6 = "010000"))or ((p2_c1 = "000011" )or (p2_c1 = "010000"))
						or ((p2_c2 = "000011" )or (p2_c2 = "010000"))) then
							if addrcnt(3) = x"0a" then
								addrcnt(3) <= (others => '0');
							elsif addrcnt(3) = x"15" then
								addrcnt(3) <= x"0b";
							elsif addrcnt(3) = x"20" then
								addrcnt(3) <= x"16";
							elsif addrcnt(3) = x"2b" then
								addrcnt(3) <= x"21";
							elsif addrcnt(3) = x"36" then
								addrcnt(3) <= x"2c";
							elsif addrcnt(3) = x"41" then
								addrcnt(3) <= x"37";
							elsif addrcnt(3) = x"4c" then
								addrcnt(3) <= x"42";
							elsif addrcnt(3) = x"57" then
								addrcnt(3) <= x"4d";
							elsif addrcnt(3) = x"62" then
								addrcnt(3) <= x"58";
							elsif addrcnt(3) = x"6d" then
								addrcnt(3) <= x"63";
							elsif addrcnt(3) = x"78" then
								addrcnt(3) <= x"6e";
							elsif addrcnt(3) = x"83" then
								addrcnt(3) <= x"79";
							elsif addrcnt(3) = x"8e" then
								addrcnt(3) <= x"84";
							elsif addrcnt(3) = x"99" then
								addrcnt(3) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "000100" )or (p1_c4 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);
						if( ((p1_c5 = "000100" )or (p1_c5 = "010001"))or ((p1_c6 = "000100" )or (p1_c6 = "010001"))or ((p2_c1 = "000100" )or (p2_c1 = "010001"))
						or ((p2_c2 = "000100" )or (p2_c2 = "010001"))) then
							if addrcnt(4) = x"0a" then
								addrcnt(4) <= (others => '0');
							elsif addrcnt(4) = x"15" then
								addrcnt(4) <= x"0b";
							elsif addrcnt(4) = x"20" then
								addrcnt(4) <= x"16";
							elsif addrcnt(4) = x"2b" then
								addrcnt(4) <= x"21";
							elsif addrcnt(4) = x"36" then
								addrcnt(4) <= x"2c";
							elsif addrcnt(4) = x"41" then
								addrcnt(4) <= x"37";
							elsif addrcnt(4) = x"4c" then
								addrcnt(4) <= x"42";
							elsif addrcnt(4) = x"57" then
								addrcnt(4) <= x"4d";
							elsif addrcnt(4) = x"62" then
								addrcnt(4) <= x"58";
							elsif addrcnt(4) = x"6d" then
								addrcnt(4) <= x"63";
							elsif addrcnt(4) = x"78" then
								addrcnt(4) <= x"6e";
							elsif addrcnt(4) = x"83" then
								addrcnt(4) <= x"79";
							elsif addrcnt(4) = x"8e" then
								addrcnt(4) <= x"84";
							elsif addrcnt(4) = x"99" then
								addrcnt(4) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "000101" )or (p1_c4 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);
						if(((p1_c5 = "000101" )or (p1_c5 = "010010"))or ((p1_c6 = "000101" )or (p1_c6 = "010010"))or ((p2_c1 = "000101" )or (p2_c1 = "010010"))
						or ((p2_c2 = "000101" )or (p2_c2 = "010010"))) then
							if addrcnt(5) = x"0a" then
								addrcnt(5) <= (others => '0');
							elsif addrcnt(5) = x"15" then
								addrcnt(5) <= x"0b";
							elsif addrcnt(5) = x"20" then
								addrcnt(5) <= x"16";
							elsif addrcnt(5) = x"2b" then
								addrcnt(5) <= x"21";
							elsif addrcnt(5) = x"36" then
								addrcnt(5) <= x"2c";
							elsif addrcnt(5) = x"41" then
								addrcnt(5) <= x"37";
							elsif addrcnt(5) = x"4c" then
								addrcnt(5) <= x"42";
							elsif addrcnt(5) = x"57" then
								addrcnt(5) <= x"4d";
							elsif addrcnt(5) = x"62" then
								addrcnt(5) <= x"58";
							elsif addrcnt(5) = x"6d" then
								addrcnt(5) <= x"63";
							elsif addrcnt(5) = x"78" then
								addrcnt(5) <= x"6e";
							elsif addrcnt(5) = x"83" then
								addrcnt(5) <= x"79";
							elsif addrcnt(5) = x"8e" then
								addrcnt(5) <= x"84";
							elsif addrcnt(5) = x"99" then
								addrcnt(5) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "000110" )or (p1_c4 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);
						if(((p1_c5 = "0000110" )or (p1_c5 = "010011"))or ((p1_c6 = "0000110" )or (p1_c6 = "010011"))or ((p2_c1 = "0000110" )or (p2_c1 = "010011"))
						or ((p2_c2 = "0000110" )or (p2_c2 = "010011"))) then
							if addrcnt(6) = x"0a" then
								addrcnt(6) <= (others => '0');
							elsif addrcnt(6) = x"15" then
								addrcnt(6) <= x"0b";
							elsif addrcnt(6) = x"20" then
								addrcnt(6) <= x"16";
							elsif addrcnt(6) = x"2b" then
								addrcnt(6) <= x"21";
							elsif addrcnt(6) = x"36" then
								addrcnt(6) <= x"2c";
							elsif addrcnt(6) = x"41" then
								addrcnt(6) <= x"37";
							elsif addrcnt(6) = x"4c" then
								addrcnt(6) <= x"42";
							elsif addrcnt(6) = x"57" then
								addrcnt(6) <= x"4d";
							elsif addrcnt(6) = x"62" then
								addrcnt(6) <= x"58";
							elsif addrcnt(6) = x"6d" then
								addrcnt(6) <= x"63";
							elsif addrcnt(6) = x"78" then
								addrcnt(6) <= x"6e";
							elsif addrcnt(6) = x"83" then
								addrcnt(6) <= x"79";
							elsif addrcnt(6) = x"8e" then
								addrcnt(6) <= x"84";
							elsif addrcnt(6) = x"99" then
								addrcnt(6) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "000111" )or (p1_c4 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);
						if( ((p1_c5 = "0000111" )or (p1_c5 = "010100"))or ((p1_c6 = "0000111" )or (p1_c6 = "010100"))or ((p2_c1 = "0000111" )or (p2_c1 = "010100"))
						or ((p2_c2 = "0000111" )or (p2_c2 = "010100"))) then
							if addrcnt(7) = x"0a" then
								addrcnt(7) <= (others => '0');
							elsif addrcnt(7) = x"15" then
								addrcnt(7) <= x"0b";
							elsif addrcnt(7) = x"20" then
								addrcnt(7) <= x"16";
							elsif addrcnt(7) = x"2b" then
								addrcnt(7) <= x"21";
							elsif addrcnt(7) = x"36" then
								addrcnt(7) <= x"2c";
							elsif addrcnt(7) = x"41" then
								addrcnt(7) <= x"37";
							elsif addrcnt(7) = x"4c" then
								addrcnt(7) <= x"42";
							elsif addrcnt(7) = x"57" then
								addrcnt(7) <= x"4d";
							elsif addrcnt(7) = x"62" then
								addrcnt(7) <= x"58";
							elsif addrcnt(7) = x"6d" then
								addrcnt(7) <= x"63";
							elsif addrcnt(7) = x"78" then
								addrcnt(7) <= x"6e";
							elsif addrcnt(7) = x"83" then
								addrcnt(7) <= x"79";
							elsif addrcnt(7) = x"8e" then
								addrcnt(7) <= x"84";
							elsif addrcnt(7) = x"99" then
								addrcnt(7) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "001000" )or (p1_c4 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
						if( ((p1_c5 = "001000" )or (p1_c5 = "010101"))or ((p1_c6 = "001000" )or (p1_c6 = "010101"))or ((p2_c1 = "001000" )or (p2_c1 = "010101"))
						or ((p2_c2 = "001000" )or (p2_c2 = "010101"))) then
							if addrcnt(8) = x"0a" then
								addrcnt(8) <= (others => '0');
							elsif addrcnt(8) = x"15" then
								addrcnt(8) <= x"0b";
							elsif addrcnt(8) = x"20" then
								addrcnt(8) <= x"16";
							elsif addrcnt(8) = x"2b" then
								addrcnt(8) <= x"21";
							elsif addrcnt(8) = x"36" then
								addrcnt(8) <= x"2c";
							elsif addrcnt(8) = x"41" then
								addrcnt(8) <= x"37";
							elsif addrcnt(8) = x"4c" then
								addrcnt(8) <= x"42";
							elsif addrcnt(8) = x"57" then
								addrcnt(8) <= x"4d";
							elsif addrcnt(8) = x"62" then
								addrcnt(8) <= x"58";
							elsif addrcnt(8) = x"6d" then
								addrcnt(8) <= x"63";
							elsif addrcnt(8) = x"78" then
								addrcnt(8) <= x"6e";
							elsif addrcnt(8) = x"83" then
								addrcnt(8) <= x"79";
							elsif addrcnt(8) = x"8e" then
								addrcnt(8) <= x"84";
							elsif addrcnt(8) = x"99" then
								addrcnt(8) <= x"8f";
							end if;
						end if;
					elsif (p1_c4= "001001" )or (p1_c4 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);
						if(((p1_c5 = "001001" )or (p1_c5 = "010110"))or ((p1_c6 = "001001" )or (p1_c6 = "010110"))or ((p2_c1 = "001001" )or (p2_c1 = "010110"))
						or ((p2_c2 = "001001" )or (p2_c2 = "010110"))) then
							if addrcnt(9) = x"0a" then
								addrcnt(9) <= (others => '0');
							elsif addrcnt(9) = x"15" then
								addrcnt(9) <= x"0b";
							elsif addrcnt(9) = x"20" then
								addrcnt(9) <= x"16";
							elsif addrcnt(9) = x"2b" then
								addrcnt(9) <= x"21";
							elsif addrcnt(9) = x"36" then
								addrcnt(9) <= x"2c";
							elsif addrcnt(9) = x"41" then
								addrcnt(9) <= x"37";
							elsif addrcnt(9) = x"4c" then
								addrcnt(9) <= x"42";
							elsif addrcnt(9) = x"57" then
								addrcnt(9) <= x"4d";
							elsif addrcnt(9) = x"62" then
								addrcnt(9) <= x"58";
							elsif addrcnt(9) = x"6d" then
								addrcnt(9) <= x"63";
							elsif addrcnt(9) = x"78" then
								addrcnt(9) <= x"6e";
							elsif addrcnt(9) = x"83" then
								addrcnt(9) <= x"79";
							elsif addrcnt(9) = x"8e" then
								addrcnt(9) <= x"84";
							elsif addrcnt(9) = x"99" then
								addrcnt(9) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "001010" )or (p1_c4 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);
						if( ((p1_c5 = "001010" )or (p1_c5 = "010111"))or ((p1_c6 = "001010" )or (p1_c6 = "010111"))or ((p2_c1 = "001010" )or (p2_c1 = "010111"))
						or ((p2_c2 = "001010" )or (p2_c2 = "010111"))) then
							if addrcnt(10) = x"0a" then
								addrcnt(10) <= (others => '0');
							elsif addrcnt(10) = x"15" then
								addrcnt(10) <= x"0b";
							elsif addrcnt(10) = x"20" then
								addrcnt(10) <= x"16";
							elsif addrcnt(10) = x"2b" then
								addrcnt(10) <= x"21";
							elsif addrcnt(10) = x"36" then
								addrcnt(10) <= x"2c";
							elsif addrcnt(10) = x"41" then
								addrcnt(10) <= x"37";
							elsif addrcnt(10) = x"4c" then
								addrcnt(10) <= x"42";
							elsif addrcnt(10) = x"57" then
								addrcnt(10) <= x"4d";
							elsif addrcnt(10) = x"62" then
								addrcnt(10) <= x"58";
							elsif addrcnt(10) = x"6d" then
								addrcnt(10) <= x"63";
							elsif addrcnt(10) = x"78" then
								addrcnt(10) <= x"6e";
							elsif addrcnt(10) = x"83" then
								addrcnt(10) <= x"79";
							elsif addrcnt(10) = x"8e" then
								addrcnt(10) <= x"84";
							elsif addrcnt(10) = x"99" then
								addrcnt(10) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "001011" )or (p1_c4 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);
						if( ((p1_c5 = "001011" )or (p1_c5 = "011000"))or ((p1_c6 = "001011" )or (p1_c6 = "011000"))or ((p2_c1 = "001011" )or (p2_c1 = "011000"))
						or ((p2_c2 = "001011" )or (p2_c2 = "011000"))) then
							if addrcnt(11) = x"0a" then
								addrcnt(11) <= (others => '0');
							elsif addrcnt(11) = x"15" then
								addrcnt(11) <= x"0b";
							elsif addrcnt(11) = x"20" then
								addrcnt(11) <= x"16";
							elsif addrcnt(11) = x"2b" then
								addrcnt(11) <= x"21";
							elsif addrcnt(11) = x"36" then
								addrcnt(11) <= x"2c";
							elsif addrcnt(11) = x"41" then
								addrcnt(11) <= x"37";
							elsif addrcnt(11) = x"4c" then
								addrcnt(11) <= x"42";
							elsif addrcnt(11) = x"57" then
								addrcnt(11) <= x"4d";
							elsif addrcnt(11) = x"62" then
								addrcnt(11) <= x"58";
							elsif addrcnt(11) = x"6d" then
								addrcnt(11) <= x"63";
							elsif addrcnt(11) = x"78" then
								addrcnt(11) <= x"6e";
							elsif addrcnt(11) = x"83" then
								addrcnt(11) <= x"79";
							elsif addrcnt(11) = x"8e" then
								addrcnt(11) <= x"84";
							elsif addrcnt(11) = x"99" then
								addrcnt(11) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "001100" )or (p1_c4 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
						if(((p1_c5 = "001100" )or (p1_c5 = "011001"))or ((p1_c6 = "001100" )or (p1_c6 = "011001"))or ((p2_c1 = "001100" )or (p2_c1 = "011001"))
						or ((p2_c2 = "001100" )or (p2_c2 = "011001"))) then
							if addrcnt(12) = x"0a" then
								addrcnt(12) <= (others => '0');
							elsif addrcnt(12) = x"15" then
								addrcnt(12) <= x"0b";
							elsif addrcnt(12) = x"20" then
								addrcnt(12) <= x"16";
							elsif addrcnt(12) = x"2b" then
								addrcnt(12) <= x"21";
							elsif addrcnt(12) = x"36" then
								addrcnt(12) <= x"2c";
							elsif addrcnt(12) = x"41" then
								addrcnt(12) <= x"37";
							elsif addrcnt(12) = x"4c" then
								addrcnt(12) <= x"42";
							elsif addrcnt(12) = x"57" then
								addrcnt(12) <= x"4d";
							elsif addrcnt(12) = x"62" then
								addrcnt(12) <= x"58";
							elsif addrcnt(12) = x"6d" then
								addrcnt(12) <= x"63";
							elsif addrcnt(12) = x"78" then
								addrcnt(12) <= x"6e";
							elsif addrcnt(12) = x"83" then
								addrcnt(12) <= x"79";
							elsif addrcnt(12) = x"8e" then
								addrcnt(12) <= x"84";
							elsif addrcnt(12) = x"99" then
								addrcnt(12) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "011010" )or (p1_c4 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
						if(((p1_c5 = "011010" )or (p1_c5 = "100111"))or ((p1_c6 = "011010" )or (p1_c6 = "100111"))or ((p2_c1 = "011010" )or (p2_c1 = "100111"))
						or ((p2_c2 = "011010" )or (p2_c2 = "100111"))) then
							if addrcnt(13) = x"0a" then
								addrcnt(13) <= (others => '0');
							elsif addrcnt(13) = x"15" then
								addrcnt(13) <= x"0b";
							elsif addrcnt(13) = x"20" then
								addrcnt(13) <= x"16";
							elsif addrcnt(13) = x"2b" then
								addrcnt(13) <= x"21";
							elsif addrcnt(13) = x"36" then
								addrcnt(13) <= x"2c";
							elsif addrcnt(13) = x"41" then
								addrcnt(13) <= x"37";
							elsif addrcnt(13) = x"4c" then
								addrcnt(13) <= x"42";
							elsif addrcnt(13) = x"57" then
								addrcnt(13) <= x"4d";
							elsif addrcnt(13) = x"62" then
								addrcnt(13) <= x"58";
							elsif addrcnt(13) = x"6d" then
								addrcnt(13) <= x"63";
							elsif addrcnt(13) = x"78" then
								addrcnt(13) <= x"6e";
							elsif addrcnt(13) = x"83" then
								addrcnt(13) <= x"79";
							elsif addrcnt(13) = x"8e" then
								addrcnt(13) <= x"84";
							elsif addrcnt(13) = x"99" then
								addrcnt(13) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "011011" )or (p1_c4 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
						if(((p1_c5 = "011011" )or (p1_c5 = "101000"))or ((p1_c6 = "011011" )or (p1_c6 = "101000"))or ((p2_c1 = "011011" )or (p2_c1 = "101000"))
						or ((p2_c2 = "011011" )or (p2_c2 = "101000"))) then
							if addrcnt(14) = x"0a" then
								addrcnt(14) <= (others => '0');
							elsif addrcnt(14) = x"15" then
								addrcnt(14) <= x"0b";
							elsif addrcnt(14) = x"20" then
								addrcnt(14) <= x"16";
							elsif addrcnt(14) = x"2b" then
								addrcnt(14) <= x"21";
							elsif addrcnt(14) = x"36" then
								addrcnt(14) <= x"2c";
							elsif addrcnt(14) = x"41" then
								addrcnt(14) <= x"37";
							elsif addrcnt(14) = x"4c" then
								addrcnt(14) <= x"42";
							elsif addrcnt(14) = x"57" then
								addrcnt(14) <= x"4d";
							elsif addrcnt(14) = x"62" then
								addrcnt(14) <= x"58";
							elsif addrcnt(14) = x"6d" then
								addrcnt(14) <= x"63";
							elsif addrcnt(14) = x"78" then
								addrcnt(14) <= x"6e";
							elsif addrcnt(14) = x"83" then
								addrcnt(14) <= x"79";
							elsif addrcnt(14) = x"8e" then
								addrcnt(14) <= x"84";
							elsif addrcnt(14) = x"99" then
								addrcnt(14) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "011100" )or (p1_c4 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
						if( ((p1_c5 = "011100" )or (p1_c5 = "101001"))or ((p1_c6 = "011100" )or (p1_c6 = "101001"))or ((p2_c1 = "011100" )or (p2_c1 = "101001"))
						or ((p2_c2 = "011100" )or (p2_c2 = "101001"))) then
							if addrcnt(15) = x"0a" then
								addrcnt(15) <= (others => '0');
							elsif addrcnt(15) = x"15" then
								addrcnt(15) <= x"0b";
							elsif addrcnt(15) = x"20" then
								addrcnt(15) <= x"16";
							elsif addrcnt(15) = x"2b" then
								addrcnt(15) <= x"21";
							elsif addrcnt(15) = x"36" then
								addrcnt(15) <= x"2c";
							elsif addrcnt(15) = x"41" then
								addrcnt(15) <= x"37";
							elsif addrcnt(15) = x"4c" then
								addrcnt(15) <= x"42";
							elsif addrcnt(15) = x"57" then
								addrcnt(15) <= x"4d";
							elsif addrcnt(15) = x"62" then
								addrcnt(15) <= x"58";
							elsif addrcnt(15) = x"6d" then
								addrcnt(15) <= x"63";
							elsif addrcnt(15) = x"78" then
								addrcnt(15) <= x"6e";
							elsif addrcnt(15) = x"83" then
								addrcnt(15) <= x"79";
							elsif addrcnt(15) = x"8e" then
								addrcnt(15) <= x"84";
							elsif addrcnt(15) = x"99" then
								addrcnt(15) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "011101" )or (p1_c4 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
						if(((p1_c5 = "011101" )or (p1_c5 = "101010"))or ((p1_c6 = "011101" )or (p1_c6 = "101010"))or ((p2_c1 = "011101" )or (p2_c1 = "101010"))
						or ((p2_c2 = "011101" )or (p2_c2 = "101010"))) then
							if addrcnt(16) = x"0a" then
								addrcnt(16) <= (others => '0');
							elsif addrcnt(16) = x"15" then
								addrcnt(16) <= x"0b";
							elsif addrcnt(16) = x"20" then
								addrcnt(16) <= x"16";
							elsif addrcnt(16) = x"2b" then
								addrcnt(16) <= x"21";
							elsif addrcnt(16) = x"36" then
								addrcnt(16) <= x"2c";
							elsif addrcnt(16) = x"41" then
								addrcnt(16) <= x"37";
							elsif addrcnt(16) = x"4c" then
								addrcnt(16) <= x"42";
							elsif addrcnt(16) = x"57" then
								addrcnt(16) <= x"4d";
							elsif addrcnt(16) = x"62" then
								addrcnt(16) <= x"58";
							elsif addrcnt(16) = x"6d" then
								addrcnt(16) <= x"63";
							elsif addrcnt(16) = x"78" then
								addrcnt(16) <= x"6e";
							elsif addrcnt(16) = x"83" then
								addrcnt(16) <= x"79";
							elsif addrcnt(16) = x"8e" then
								addrcnt(16) <= x"84";
							elsif addrcnt(16) = x"99" then
								addrcnt(16) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "011110" )or (p1_c4 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);
						if(((p1_c5 = "011110" )or (p1_c5 = "101011"))or ((p1_c6 = "011110" )or (p1_c6 = "101011"))or ((p2_c1 = "011110" )or (p2_c1 = "101011"))
						or ((p2_c2 = "011110" )or (p2_c2 = "101011"))) then
							if addrcnt(17) = x"0a" then
								addrcnt(17) <= (others => '0');
							elsif addrcnt(17) = x"15" then
								addrcnt(17) <= x"0b";
							elsif addrcnt(17) = x"20" then
								addrcnt(17) <= x"16";
							elsif addrcnt(17) = x"2b" then
								addrcnt(17) <= x"21";
							elsif addrcnt(17) = x"36" then
								addrcnt(17) <= x"2c";
							elsif addrcnt(17) = x"41" then
								addrcnt(17) <= x"37";
							elsif addrcnt(17) = x"4c" then
								addrcnt(17) <= x"42";
							elsif addrcnt(17) = x"57" then
								addrcnt(17) <= x"4d";
							elsif addrcnt(17) = x"62" then
								addrcnt(17) <= x"58";
							elsif addrcnt(17) = x"6d" then
								addrcnt(17) <= x"63";
							elsif addrcnt(17) = x"78" then
								addrcnt(17) <= x"6e";
							elsif addrcnt(17) = x"83" then
								addrcnt(17) <= x"79";
							elsif addrcnt(17) = x"8e" then
								addrcnt(17) <= x"84";
							elsif addrcnt(17) = x"99" then
								addrcnt(17) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "011111" )or (p1_c4 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);
						if( ((p1_c5 = "011111" )or (p1_c5 = "101100"))or ((p1_c6 = "011111" )or (p1_c6 = "101100"))or ((p2_c1 = "011111" )or (p2_c1 = "101100"))
						or ((p2_c2 = "011111" )or (p2_c2 = "101100"))) then
							if addrcnt(18) = x"0a" then
								addrcnt(18) <= (others => '0');
							elsif addrcnt(18) = x"15" then
								addrcnt(18) <= x"0b";
							elsif addrcnt(18) = x"20" then
								addrcnt(18) <= x"16";
							elsif addrcnt(18) = x"2b" then
								addrcnt(18) <= x"21";
							elsif addrcnt(18) = x"36" then
								addrcnt(18) <= x"2c";
							elsif addrcnt(18) = x"41" then
								addrcnt(18) <= x"37";
							elsif addrcnt(18) = x"4c" then
								addrcnt(18) <= x"42";
							elsif addrcnt(18) = x"57" then
								addrcnt(18) <= x"4d";
							elsif addrcnt(18) = x"62" then
								addrcnt(18) <= x"58";
							elsif addrcnt(18) = x"6d" then
								addrcnt(18) <= x"63";
							elsif addrcnt(18) = x"78" then
								addrcnt(18) <= x"6e";
							elsif addrcnt(18) = x"83" then
								addrcnt(18) <= x"79";
							elsif addrcnt(18) = x"8e" then
								addrcnt(18) <= x"84";
							elsif addrcnt(18) = x"99" then
								addrcnt(18) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "100000" )or (p1_c4 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
						if( ((p1_c5 = "100000" )or (p1_c5 = "101101"))or ((p1_c6 = "100000" )or (p1_c6 = "101101"))or ((p2_c1 = "100000" )or (p2_c1 = "101101"))
						or ((p2_c2 = "100000" )or (p2_c2 = "101101"))) then
							if addrcnt(19) = x"0a" then
								addrcnt(19) <= (others => '0');
							elsif addrcnt(19) = x"15" then
								addrcnt(19) <= x"0b";
							elsif addrcnt(19) = x"20" then
								addrcnt(19) <= x"16";
							elsif addrcnt(19) = x"2b" then
								addrcnt(19) <= x"21";
							elsif addrcnt(19) = x"36" then
								addrcnt(19) <= x"2c";
							elsif addrcnt(19) = x"41" then
								addrcnt(19) <= x"37";
							elsif addrcnt(19) = x"4c" then
								addrcnt(19) <= x"42";
							elsif addrcnt(19) = x"57" then
								addrcnt(19) <= x"4d";
							elsif addrcnt(19) = x"62" then
								addrcnt(19) <= x"58";
							elsif addrcnt(19) = x"6d" then
								addrcnt(19) <= x"63";
							elsif addrcnt(19) = x"78" then
								addrcnt(19) <= x"6e";
							elsif addrcnt(19) = x"83" then
								addrcnt(19) <= x"79";
							elsif addrcnt(19) = x"8e" then
								addrcnt(19) <= x"84";
							elsif addrcnt(19) = x"99" then
								addrcnt(19) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "100001" )or (p1_c4 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
						if( ((p1_c5 = "100001" )or (p1_c5 = "101110"))or ((p1_c6 = "100001" )or (p1_c6 = "101110"))or ((p2_c1 = "100001" )or (p2_c1 = "101110"))
						or ((p2_c2 = "100001" )or (p2_c2 = "101110"))) then
							if addrcnt(20) = x"0a" then
								addrcnt(20) <= (others => '0');
							elsif addrcnt(20) = x"15" then
								addrcnt(20) <= x"0b";
							elsif addrcnt(20) = x"20" then
								addrcnt(20) <= x"16";
							elsif addrcnt(20) = x"2b" then
								addrcnt(20) <= x"21";
							elsif addrcnt(20) = x"36" then
								addrcnt(20) <= x"2c";
							elsif addrcnt(20) = x"41" then
								addrcnt(20) <= x"37";
							elsif addrcnt(20) = x"4c" then
								addrcnt(20) <= x"42";
							elsif addrcnt(20) = x"57" then
								addrcnt(20) <= x"4d";
							elsif addrcnt(20) = x"62" then
								addrcnt(20) <= x"58";
							elsif addrcnt(20) = x"6d" then
								addrcnt(20) <= x"63";
							elsif addrcnt(20) = x"78" then
								addrcnt(20) <= x"6e";
							elsif addrcnt(20) = x"83" then
								addrcnt(20) <= x"79";
							elsif addrcnt(20) = x"8e" then
								addrcnt(20) <= x"84";
							elsif addrcnt(20) = x"99" then
								addrcnt(20) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "100010" )or (p1_c4 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
						if( ((p1_c5 = "100010" )or (p1_c5 = "101111"))or ((p1_c6 = "100010" )or (p1_c6 = "101111"))or ((p2_c1 = "100010" )or (p2_c1 = "101111"))
						or ((p2_c2 = "100010" )or (p2_c2 = "101111"))) then
							if addrcnt(21) = x"0a" then
								addrcnt(21) <= (others => '0');
							elsif addrcnt(21) = x"15" then
								addrcnt(21) <= x"0b";
							elsif addrcnt(21) = x"20" then
								addrcnt(21) <= x"16";
							elsif addrcnt(21) = x"2b" then
								addrcnt(21) <= x"21";
							elsif addrcnt(21) = x"36" then
								addrcnt(21) <= x"2c";
							elsif addrcnt(21) = x"41" then
								addrcnt(21) <= x"37";
							elsif addrcnt(21) = x"4c" then
								addrcnt(21) <= x"42";
							elsif addrcnt(21) = x"57" then
								addrcnt(21) <= x"4d";
							elsif addrcnt(21) = x"62" then
								addrcnt(21) <= x"58";
							elsif addrcnt(21) = x"6d" then
								addrcnt(21) <= x"63";
							elsif addrcnt(21) = x"78" then
								addrcnt(21) <= x"6e";
							elsif addrcnt(21) = x"83" then
								addrcnt(21) <= x"79";
							elsif addrcnt(21) = x"8e" then
								addrcnt(21) <= x"84";
							elsif addrcnt(21) = x"99" then
								addrcnt(21) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "100011" )or (p1_c4 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);
						if(((p1_c5 = "100011" )or (p1_c5 = "110000"))or ((p1_c6 = "100011" )or (p1_c6 = "110000"))or ((p2_c1 = "100011" )or (p2_c1 = "110000"))
						or ((p2_c2 = "100011" )or (p2_c2 = "110000"))) then
							if addrcnt(22) = x"0a" then
								addrcnt(22) <= (others => '0');
							elsif addrcnt(22) = x"15" then
								addrcnt(22) <= x"0b";
							elsif addrcnt(22) = x"20" then
								addrcnt(22) <= x"16";
							elsif addrcnt(22) = x"2b" then
								addrcnt(22) <= x"21";
							elsif addrcnt(22) = x"36" then
								addrcnt(22) <= x"2c";
							elsif addrcnt(22) = x"41" then
								addrcnt(22) <= x"37";
							elsif addrcnt(22) = x"4c" then
								addrcnt(22) <= x"42";
							elsif addrcnt(22) = x"57" then
								addrcnt(22) <= x"4d";
							elsif addrcnt(22) = x"62" then
								addrcnt(22) <= x"58";
							elsif addrcnt(22) = x"6d" then
								addrcnt(22) <= x"63";
							elsif addrcnt(22) = x"78" then
								addrcnt(22) <= x"6e";
							elsif addrcnt(22) = x"83" then
								addrcnt(22) <= x"79";
							elsif addrcnt(22) = x"8e" then
								addrcnt(22) <= x"84";
							elsif addrcnt(22) = x"99" then
								addrcnt(22) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "100100" )or (p1_c4 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
						if( ((p1_c5 = "100100" )or (p1_c5 = "110001"))or ((p1_c6 = "100100" )or (p1_c6 = "110001"))or ((p2_c1 = "100100" )or (p2_c1 = "110001"))
						or ((p2_c2 = "100100" )or (p2_c2 = "110001"))) then
							if addrcnt(23) = x"0a" then
								addrcnt(23) <= (others => '0');
							elsif addrcnt(23) = x"15" then
								addrcnt(23) <= x"0b";
							elsif addrcnt(23) = x"20" then
								addrcnt(23) <= x"16";
							elsif addrcnt(23) = x"2b" then
								addrcnt(23) <= x"21";
							elsif addrcnt(23) = x"36" then
								addrcnt(23) <= x"2c";
							elsif addrcnt(23) = x"41" then
								addrcnt(23) <= x"37";
							elsif addrcnt(23) = x"4c" then
								addrcnt(23) <= x"42";
							elsif addrcnt(23) = x"57" then
								addrcnt(23) <= x"4d";
							elsif addrcnt(23) = x"62" then
								addrcnt(23) <= x"58";
							elsif addrcnt(23) = x"6d" then
								addrcnt(23) <= x"63";
							elsif addrcnt(23) = x"78" then
								addrcnt(23) <= x"6e";
							elsif addrcnt(23) = x"83" then
								addrcnt(23) <= x"79";
							elsif addrcnt(23) = x"8e" then
								addrcnt(23) <= x"84";
							elsif addrcnt(23) = x"99" then
								addrcnt(23) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "100101" )or (p1_c4 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
						if(((p1_c5 = "100101" )or (p1_c5 = "110010"))or ((p1_c6 = "100101" )or (p1_c6 = "110010"))or ((p2_c1 = "100101" )or (p2_c1 = "110010"))
						or ((p2_c2 = "100101" )or (p2_c2 = "110010"))) then
							if addrcnt(24) = x"0a" then
								addrcnt(24) <= (others => '0');
							elsif addrcnt(24) = x"15" then
								addrcnt(24) <= x"0b";
							elsif addrcnt(24) = x"20" then
								addrcnt(24) <= x"16";
							elsif addrcnt(24) = x"2b" then
								addrcnt(24) <= x"21";
							elsif addrcnt(24) = x"36" then
								addrcnt(24) <= x"2c";
							elsif addrcnt(24) = x"41" then
								addrcnt(24) <= x"37";
							elsif addrcnt(24) = x"4c" then
								addrcnt(24) <= x"42";
							elsif addrcnt(24) = x"57" then
								addrcnt(24) <= x"4d";
							elsif addrcnt(24) = x"62" then
								addrcnt(24) <= x"58";
							elsif addrcnt(24) = x"6d" then
								addrcnt(24) <= x"63";
							elsif addrcnt(24) = x"78" then
								addrcnt(24) <= x"6e";
							elsif addrcnt(24) = x"83" then
								addrcnt(24) <= x"79";
							elsif addrcnt(24) = x"8e" then
								addrcnt(24) <= x"84";
							elsif addrcnt(24) = x"99" then
								addrcnt(24) <= x"8f";
							end if;
						end if;
					elsif (p1_c4 = "100110" )or (p1_c4 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
						if(((p1_c5 = "100110" )or (p1_c5 = "110011"))or ((p1_c6 = "100110" )or (p1_c6 = "110011"))or ((p2_c1 = "100110" )or (p2_c1 = "110011"))
						or ((p2_c2 = "100110" )or (p2_c2 = "110011"))) then
							if addrcnt(25) = x"0a" then
								addrcnt(25) <= (others => '0');
							elsif addrcnt(25) = x"15" then
								addrcnt(25) <= x"0b";
							elsif addrcnt(25) = x"20" then
								addrcnt(25) <= x"16";
							elsif addrcnt(25) = x"2b" then
								addrcnt(25) <= x"21";
							elsif addrcnt(25) = x"36" then
								addrcnt(25) <= x"2c";
							elsif addrcnt(25) = x"41" then
								addrcnt(25) <= x"37";
							elsif addrcnt(25) = x"4c" then
								addrcnt(25) <= x"42";
							elsif addrcnt(25) = x"57" then
								addrcnt(25) <= x"4d";
							elsif addrcnt(25) = x"62" then
								addrcnt(25) <= x"58";
							elsif addrcnt(25) = x"6d" then
								addrcnt(25) <= x"63";
							elsif addrcnt(25) = x"78" then
								addrcnt(25) <= x"6e";
							elsif addrcnt(25) = x"83" then
								addrcnt(25) <= x"79";
							elsif addrcnt(25) = x"8e" then
								addrcnt(25) <= x"84";
							elsif addrcnt(25) = x"99" then
								addrcnt(25) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +144 ) ) and ( hsync_cnt <= (tHW + tHBP +154)) ) then
					if (p1_c5 = "000000" )or (p1_c5 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
						if(((p1_c6 = "000000" )or 	(p1_c6 = "001101"))or ((p2_c1 = "000000" )or (p2_c1 = "001101")) or ((p2_c2 = "000000" )or (p2_c2 = "001101"))) then
							if addrcnt(0) = x"0a" then
								addrcnt(0) <= (others => '0');
							elsif addrcnt(0) = x"15" then
								addrcnt(0) <= x"0b";
							elsif addrcnt(0) = x"20" then
								addrcnt(0) <= x"16";
							elsif addrcnt(0) = x"2b" then
								addrcnt(0) <= x"21";
							elsif addrcnt(0) = x"36" then
								addrcnt(0) <= x"2c";
							elsif addrcnt(0) = x"41" then
								addrcnt(0) <= x"37";
							elsif addrcnt(0) = x"4c" then
								addrcnt(0) <= x"42";
							elsif addrcnt(0) = x"57" then
								addrcnt(0) <= x"4d";
							elsif addrcnt(0) = x"62" then
								addrcnt(0) <= x"58";
							elsif addrcnt(0) = x"6d" then
								addrcnt(0) <= x"63";
							elsif addrcnt(0) = x"78" then
								addrcnt(0) <= x"6e";
							elsif addrcnt(0) = x"83" then
								addrcnt(0) <= x"79";
							elsif addrcnt(0) = x"8e" then
								addrcnt(0) <= x"84";
							elsif addrcnt(0) = x"99" then
								addrcnt(0) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "000001" )or (p1_c5 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
						if(((p1_c6 = "000001" )or 
						(p1_c6 = "001110"))or ((p2_c1 = "000001" )or (p2_c1 = "001110")) or ((p2_c2 = "000001" )or (p2_c2 = "001110"))) then
							if addrcnt(1) = x"0a" then
								addrcnt(1) <= (others => '0');
							elsif addrcnt(1) = x"15" then
								addrcnt(1) <= x"0b";
							elsif addrcnt(1) = x"20" then
								addrcnt(1) <= x"16";
							elsif addrcnt(1) = x"2b" then
								addrcnt(1) <= x"21";
							elsif addrcnt(1) = x"36" then
								addrcnt(1) <= x"2c";
							elsif addrcnt(1) = x"41" then
								addrcnt(1) <= x"37";
							elsif addrcnt(1) = x"4c" then
								addrcnt(1) <= x"42";
							elsif addrcnt(1) = x"57" then
								addrcnt(1) <= x"4d";
							elsif addrcnt(1) = x"62" then
								addrcnt(1) <= x"58";
							elsif addrcnt(1) = x"6d" then
								addrcnt(1) <= x"63";
							elsif addrcnt(1) = x"78" then
								addrcnt(1) <= x"6e";
							elsif addrcnt(1) = x"83" then
								addrcnt(1) <= x"79";
							elsif addrcnt(1) = x"8e" then
								addrcnt(1) <= x"84";
							elsif addrcnt(1) = x"99" then
								addrcnt(1) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "000010" )or (p1_c5 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
						if( ((p1_c6 = "000010" )or (p1_c6 = "001111"))or ((p2_c1 = "000010" )or (p2_c1 = "001111"))
						or ((p2_c2 = "000010" )or (p2_c2 = "001111"))) then
							if addrcnt(2) = x"0a" then
								addrcnt(2) <= (others => '0');
							elsif addrcnt(2) = x"15" then
								addrcnt(2) <= x"0b";
							elsif addrcnt(2) = x"20" then
								addrcnt(2) <= x"16";
							elsif addrcnt(2) = x"2b" then
								addrcnt(2) <= x"21";
							elsif addrcnt(2) = x"36" then
								addrcnt(2) <= x"2c";
							elsif addrcnt(2) = x"41" then
								addrcnt(2) <= x"37";
							elsif addrcnt(2) = x"4c" then
								addrcnt(2) <= x"42";
							elsif addrcnt(2) = x"57" then
								addrcnt(2) <= x"4d";
							elsif addrcnt(2) = x"62" then
								addrcnt(2) <= x"58";
							elsif addrcnt(2) = x"6d" then
								addrcnt(2) <= x"63";
							elsif addrcnt(2) = x"78" then
								addrcnt(2) <= x"6e";
							elsif addrcnt(2) = x"83" then
								addrcnt(2) <= x"79";
							elsif addrcnt(2) = x"8e" then
								addrcnt(2) <= x"84";
							elsif addrcnt(2) = x"99" then
								addrcnt(2) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "000011" )or (p1_c5 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
						if( ((p1_c6 = "000011" )or (p1_c6 = "010000"))or ((p2_c1 = "000011" )or (p2_c1 = "010000"))
						or ((p2_c2 = "000011" )or (p2_c2 = "010000"))) then
							if addrcnt(3) = x"0a" then
								addrcnt(3) <= (others => '0');
							elsif addrcnt(3) = x"15" then
								addrcnt(3) <= x"0b";
							elsif addrcnt(3) = x"20" then
								addrcnt(3) <= x"16";
							elsif addrcnt(3) = x"2b" then
								addrcnt(3) <= x"21";
							elsif addrcnt(3) = x"36" then
								addrcnt(3) <= x"2c";
							elsif addrcnt(3) = x"41" then
								addrcnt(3) <= x"37";
							elsif addrcnt(3) = x"4c" then
								addrcnt(3) <= x"42";
							elsif addrcnt(3) = x"57" then
								addrcnt(3) <= x"4d";
							elsif addrcnt(3) = x"62" then
								addrcnt(3) <= x"58";
							elsif addrcnt(3) = x"6d" then
								addrcnt(3) <= x"63";
							elsif addrcnt(3) = x"78" then
								addrcnt(3) <= x"6e";
							elsif addrcnt(3) = x"83" then
								addrcnt(3) <= x"79";
							elsif addrcnt(3) = x"8e" then
								addrcnt(3) <= x"84";
							elsif addrcnt(3) = x"99" then
								addrcnt(3) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "000100" )or (p1_c5 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);
						if( ((p1_c6 = "000100" )or (p1_c6 = "010001"))or ((p2_c1 = "000100" )or (p2_c1 = "010001"))
						or ((p2_c2 = "000100" )or (p2_c2 = "010001"))) then
							if addrcnt(4) = x"0a" then
								addrcnt(4) <= (others => '0');
							elsif addrcnt(4) = x"15" then
								addrcnt(4) <= x"0b";
							elsif addrcnt(4) = x"20" then
								addrcnt(4) <= x"16";
							elsif addrcnt(4) = x"2b" then
								addrcnt(4) <= x"21";
							elsif addrcnt(4) = x"36" then
								addrcnt(4) <= x"2c";
							elsif addrcnt(4) = x"41" then
								addrcnt(4) <= x"37";
							elsif addrcnt(4) = x"4c" then
								addrcnt(4) <= x"42";
							elsif addrcnt(4) = x"57" then
								addrcnt(4) <= x"4d";
							elsif addrcnt(4) = x"62" then
								addrcnt(4) <= x"58";
							elsif addrcnt(4) = x"6d" then
								addrcnt(4) <= x"63";
							elsif addrcnt(4) = x"78" then
								addrcnt(4) <= x"6e";
							elsif addrcnt(4) = x"83" then
								addrcnt(4) <= x"79";
							elsif addrcnt(4) = x"8e" then
								addrcnt(4) <= x"84";
							elsif addrcnt(4) = x"99" then
								addrcnt(4) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "000101" )or (p1_c5 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);
						if( ((p1_c6 = "000101" )or (p1_c6 = "010010"))or ((p2_c1 = "000101" )or (p2_c1 = "010010"))
						or ((p2_c2 = "000101" )or (p2_c2 = "010010"))) then
							if addrcnt(5) = x"0a" then
								addrcnt(5) <= (others => '0');
							elsif addrcnt(5) = x"15" then
								addrcnt(5) <= x"0b";
							elsif addrcnt(5) = x"20" then
								addrcnt(5) <= x"16";
							elsif addrcnt(5) = x"2b" then
								addrcnt(5) <= x"21";
							elsif addrcnt(5) = x"36" then
								addrcnt(5) <= x"2c";
							elsif addrcnt(5) = x"41" then
								addrcnt(5) <= x"37";
							elsif addrcnt(5) = x"4c" then
								addrcnt(5) <= x"42";
							elsif addrcnt(5) = x"57" then
								addrcnt(5) <= x"4d";
							elsif addrcnt(5) = x"62" then
								addrcnt(5) <= x"58";
							elsif addrcnt(5) = x"6d" then
								addrcnt(5) <= x"63";
							elsif addrcnt(5) = x"78" then
								addrcnt(5) <= x"6e";
							elsif addrcnt(5) = x"83" then
								addrcnt(5) <= x"79";
							elsif addrcnt(5) = x"8e" then
								addrcnt(5) <= x"84";
							elsif addrcnt(5) = x"99" then
								addrcnt(5) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "000110" )or (p1_c5 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);
						if( ((p1_c6 = "0000110" )or (p1_c6 = "010011"))or ((p2_c1 = "0000110" )or (p2_c1 = "010011"))
						or ((p2_c2 = "0000110" )or (p2_c2 = "010011"))) then
							if addrcnt(6) = x"0a" then
								addrcnt(6) <= (others => '0');
							elsif addrcnt(6) = x"15" then
								addrcnt(6) <= x"0b";
							elsif addrcnt(6) = x"20" then
								addrcnt(6) <= x"16";
							elsif addrcnt(6) = x"2b" then
								addrcnt(6) <= x"21";
							elsif addrcnt(6) = x"36" then
								addrcnt(6) <= x"2c";
							elsif addrcnt(6) = x"41" then
								addrcnt(6) <= x"37";
							elsif addrcnt(6) = x"4c" then
								addrcnt(6) <= x"42";
							elsif addrcnt(6) = x"57" then
								addrcnt(6) <= x"4d";
							elsif addrcnt(6) = x"62" then
								addrcnt(6) <= x"58";
							elsif addrcnt(6) = x"6d" then
								addrcnt(6) <= x"63";
							elsif addrcnt(6) = x"78" then
								addrcnt(6) <= x"6e";
							elsif addrcnt(6) = x"83" then
								addrcnt(6) <= x"79";
							elsif addrcnt(6) = x"8e" then
								addrcnt(6) <= x"84";
							elsif addrcnt(6) = x"99" then
								addrcnt(6) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "000111" )or (p1_c5 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);
						if(  ((p1_c6 = "0000111" )or (p1_c6 = "010100"))or ((p2_c1 = "0000111" )or (p2_c1 = "010100"))
						or ((p2_c2 = "0000111" )or (p2_c2 = "010100"))) then
							if addrcnt(7) = x"0a" then
								addrcnt(7) <= (others => '0');
							elsif addrcnt(7) = x"15" then
								addrcnt(7) <= x"0b";
							elsif addrcnt(7) = x"20" then
								addrcnt(7) <= x"16";
							elsif addrcnt(7) = x"2b" then
								addrcnt(7) <= x"21";
							elsif addrcnt(7) = x"36" then
								addrcnt(7) <= x"2c";
							elsif addrcnt(7) = x"41" then
								addrcnt(7) <= x"37";
							elsif addrcnt(7) = x"4c" then
								addrcnt(7) <= x"42";
							elsif addrcnt(7) = x"57" then
								addrcnt(7) <= x"4d";
							elsif addrcnt(7) = x"62" then
								addrcnt(7) <= x"58";
							elsif addrcnt(7) = x"6d" then
								addrcnt(7) <= x"63";
							elsif addrcnt(7) = x"78" then
								addrcnt(7) <= x"6e";
							elsif addrcnt(7) = x"83" then
								addrcnt(7) <= x"79";
							elsif addrcnt(7) = x"8e" then
								addrcnt(7) <= x"84";
							elsif addrcnt(7) = x"99" then
								addrcnt(7) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "001000" )or (p1_c5 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
						if(  ((p1_c6 = "001000" )or (p1_c6 = "010101"))or ((p2_c1 = "001000" )or (p2_c1 = "010101"))
						or ((p2_c2 = "001000" )or (p2_c2 = "010101"))) then
							if addrcnt(8) = x"0a" then
								addrcnt(8) <= (others => '0');
							elsif addrcnt(8) = x"15" then
								addrcnt(8) <= x"0b";
							elsif addrcnt(8) = x"20" then
								addrcnt(8) <= x"16";
							elsif addrcnt(8) = x"2b" then
								addrcnt(8) <= x"21";
							elsif addrcnt(8) = x"36" then
								addrcnt(8) <= x"2c";
							elsif addrcnt(8) = x"41" then
								addrcnt(8) <= x"37";
							elsif addrcnt(8) = x"4c" then
								addrcnt(8) <= x"42";
							elsif addrcnt(8) = x"57" then
								addrcnt(8) <= x"4d";
							elsif addrcnt(8) = x"62" then
								addrcnt(8) <= x"58";
							elsif addrcnt(8) = x"6d" then
								addrcnt(8) <= x"63";
							elsif addrcnt(8) = x"78" then
								addrcnt(8) <= x"6e";
							elsif addrcnt(8) = x"83" then
								addrcnt(8) <= x"79";
							elsif addrcnt(8) = x"8e" then
								addrcnt(8) <= x"84";
							elsif addrcnt(8) = x"99" then
								addrcnt(8) <= x"8f";
							end if;
						end if;
					elsif (p1_c5= "001001" )or (p1_c5 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);
						if(((p1_c6 = "001001" )or (p1_c6 = "010110"))or ((p2_c1 = "001001" )or (p2_c1 = "010110"))
						or ((p2_c2 = "001001" )or (p2_c2 = "010110"))) then
							if addrcnt(9) = x"0a" then
								addrcnt(9) <= (others => '0');
							elsif addrcnt(9) = x"15" then
								addrcnt(9) <= x"0b";
							elsif addrcnt(9) = x"20" then
								addrcnt(9) <= x"16";
							elsif addrcnt(9) = x"2b" then
								addrcnt(9) <= x"21";
							elsif addrcnt(9) = x"36" then
								addrcnt(9) <= x"2c";
							elsif addrcnt(9) = x"41" then
								addrcnt(9) <= x"37";
							elsif addrcnt(9) = x"4c" then
								addrcnt(9) <= x"42";
							elsif addrcnt(9) = x"57" then
								addrcnt(9) <= x"4d";
							elsif addrcnt(9) = x"62" then
								addrcnt(9) <= x"58";
							elsif addrcnt(9) = x"6d" then
								addrcnt(9) <= x"63";
							elsif addrcnt(9) = x"78" then
								addrcnt(9) <= x"6e";
							elsif addrcnt(9) = x"83" then
								addrcnt(9) <= x"79";
							elsif addrcnt(9) = x"8e" then
								addrcnt(9) <= x"84";
							elsif addrcnt(9) = x"99" then
								addrcnt(9) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "001010" )or (p1_c5 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);
						if(  ((p1_c6 = "001010" )or (p1_c6 = "010111"))or ((p2_c1 = "001010" )or (p2_c1 = "010111"))
						or ((p2_c2 = "001010" )or (p2_c2 = "010111"))) then
							if addrcnt(10) = x"0a" then
								addrcnt(10) <= (others => '0');
							elsif addrcnt(10) = x"15" then
								addrcnt(10) <= x"0b";
							elsif addrcnt(10) = x"20" then
								addrcnt(10) <= x"16";
							elsif addrcnt(10) = x"2b" then
								addrcnt(10) <= x"21";
							elsif addrcnt(10) = x"36" then
								addrcnt(10) <= x"2c";
							elsif addrcnt(10) = x"41" then
								addrcnt(10) <= x"37";
							elsif addrcnt(10) = x"4c" then
								addrcnt(10) <= x"42";
							elsif addrcnt(10) = x"57" then
								addrcnt(10) <= x"4d";
							elsif addrcnt(10) = x"62" then
								addrcnt(10) <= x"58";
							elsif addrcnt(10) = x"6d" then
								addrcnt(10) <= x"63";
							elsif addrcnt(10) = x"78" then
								addrcnt(10) <= x"6e";
							elsif addrcnt(10) = x"83" then
								addrcnt(10) <= x"79";
							elsif addrcnt(10) = x"8e" then
								addrcnt(10) <= x"84";
							elsif addrcnt(10) = x"99" then
								addrcnt(10) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "001011" )or (p1_c5 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);
						if(((p1_c6 = "001011" )or (p1_c6 = "011000"))or ((p2_c1 = "001011" )or (p2_c1 = "011000"))
						or ((p2_c2 = "001011" )or (p2_c2 = "011000"))) then
							if addrcnt(11) = x"0a" then
								addrcnt(11) <= (others => '0');
							elsif addrcnt(11) = x"15" then
								addrcnt(11) <= x"0b";
							elsif addrcnt(11) = x"20" then
								addrcnt(11) <= x"16";
							elsif addrcnt(11) = x"2b" then
								addrcnt(11) <= x"21";
							elsif addrcnt(11) = x"36" then
								addrcnt(11) <= x"2c";
							elsif addrcnt(11) = x"41" then
								addrcnt(11) <= x"37";
							elsif addrcnt(11) = x"4c" then
								addrcnt(11) <= x"42";
							elsif addrcnt(11) = x"57" then
								addrcnt(11) <= x"4d";
							elsif addrcnt(11) = x"62" then
								addrcnt(11) <= x"58";
							elsif addrcnt(11) = x"6d" then
								addrcnt(11) <= x"63";
							elsif addrcnt(11) = x"78" then
								addrcnt(11) <= x"6e";
							elsif addrcnt(11) = x"83" then
								addrcnt(11) <= x"79";
							elsif addrcnt(11) = x"8e" then
								addrcnt(11) <= x"84";
							elsif addrcnt(11) = x"99" then
								addrcnt(11) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "001100" )or (p1_c5 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
						if(((p1_c6 = "001100" )or (p1_c6 = "011001"))or ((p2_c1 = "001100" )or (p2_c1 = "011001"))
						or ((p2_c2 = "001100" )or (p2_c2 = "011001"))) then
							if addrcnt(12) = x"0a" then
								addrcnt(12) <= (others => '0');
							elsif addrcnt(12) = x"15" then
								addrcnt(12) <= x"0b";
							elsif addrcnt(12) = x"20" then
								addrcnt(12) <= x"16";
							elsif addrcnt(12) = x"2b" then
								addrcnt(12) <= x"21";
							elsif addrcnt(12) = x"36" then
								addrcnt(12) <= x"2c";
							elsif addrcnt(12) = x"41" then
								addrcnt(12) <= x"37";
							elsif addrcnt(12) = x"4c" then
								addrcnt(12) <= x"42";
							elsif addrcnt(12) = x"57" then
								addrcnt(12) <= x"4d";
							elsif addrcnt(12) = x"62" then
								addrcnt(12) <= x"58";
							elsif addrcnt(12) = x"6d" then
								addrcnt(12) <= x"63";
							elsif addrcnt(12) = x"78" then
								addrcnt(12) <= x"6e";
							elsif addrcnt(12) = x"83" then
								addrcnt(12) <= x"79";
							elsif addrcnt(12) = x"8e" then
								addrcnt(12) <= x"84";
							elsif addrcnt(12) = x"99" then
								addrcnt(12) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "011010" )or (p1_c5 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
						if(((p1_c6 = "011010" )or (p1_c6 = "100111"))or ((p2_c1 = "011010" )or (p2_c1 = "100111"))
						or ((p2_c2 = "011010" )or (p2_c2 = "100111"))) then
							if addrcnt(13) = x"0a" then
								addrcnt(13) <= (others => '0');
							elsif addrcnt(13) = x"15" then
								addrcnt(13) <= x"0b";
							elsif addrcnt(13) = x"20" then
								addrcnt(13) <= x"16";
							elsif addrcnt(13) = x"2b" then
								addrcnt(13) <= x"21";
							elsif addrcnt(13) = x"36" then
								addrcnt(13) <= x"2c";
							elsif addrcnt(13) = x"41" then
								addrcnt(13) <= x"37";
							elsif addrcnt(13) = x"4c" then
								addrcnt(13) <= x"42";
							elsif addrcnt(13) = x"57" then
								addrcnt(13) <= x"4d";
							elsif addrcnt(13) = x"62" then
								addrcnt(13) <= x"58";
							elsif addrcnt(13) = x"6d" then
								addrcnt(13) <= x"63";
							elsif addrcnt(13) = x"78" then
								addrcnt(13) <= x"6e";
							elsif addrcnt(13) = x"83" then
								addrcnt(13) <= x"79";
							elsif addrcnt(13) = x"8e" then
								addrcnt(13) <= x"84";
							elsif addrcnt(13) = x"99" then
								addrcnt(13) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "011011" )or (p1_c5 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
						if(((p1_c6 = "011011" )or (p1_c6 = "101000"))or ((p2_c1 = "011011" )or (p2_c1 = "101000"))
						or ((p2_c2 = "011011" )or (p2_c2 = "101000"))) then
							if addrcnt(14) = x"0a" then
								addrcnt(14) <= (others => '0');
							elsif addrcnt(14) = x"15" then
								addrcnt(14) <= x"0b";
							elsif addrcnt(14) = x"20" then
								addrcnt(14) <= x"16";
							elsif addrcnt(14) = x"2b" then
								addrcnt(14) <= x"21";
							elsif addrcnt(14) = x"36" then
								addrcnt(14) <= x"2c";
							elsif addrcnt(14) = x"41" then
								addrcnt(14) <= x"37";
							elsif addrcnt(14) = x"4c" then
								addrcnt(14) <= x"42";
							elsif addrcnt(14) = x"57" then
								addrcnt(14) <= x"4d";
							elsif addrcnt(14) = x"62" then
								addrcnt(14) <= x"58";
							elsif addrcnt(14) = x"6d" then
								addrcnt(14) <= x"63";
							elsif addrcnt(14) = x"78" then
								addrcnt(14) <= x"6e";
							elsif addrcnt(14) = x"83" then
								addrcnt(14) <= x"79";
							elsif addrcnt(14) = x"8e" then
								addrcnt(14) <= x"84";
							elsif addrcnt(14) = x"99" then
								addrcnt(14) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "011100" )or (p1_c5 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
						if(  ((p1_c6 = "011100" )or (p1_c6 = "101001"))or ((p2_c1 = "011100" )or (p2_c1 = "101001"))
						or ((p2_c2 = "011100" )or (p2_c2 = "101001"))) then
							if addrcnt(15) = x"0a" then
								addrcnt(15) <= (others => '0');
							elsif addrcnt(15) = x"15" then
								addrcnt(15) <= x"0b";
							elsif addrcnt(15) = x"20" then
								addrcnt(15) <= x"16";
							elsif addrcnt(15) = x"2b" then
								addrcnt(15) <= x"21";
							elsif addrcnt(15) = x"36" then
								addrcnt(15) <= x"2c";
							elsif addrcnt(15) = x"41" then
								addrcnt(15) <= x"37";
							elsif addrcnt(15) = x"4c" then
								addrcnt(15) <= x"42";
							elsif addrcnt(15) = x"57" then
								addrcnt(15) <= x"4d";
							elsif addrcnt(15) = x"62" then
								addrcnt(15) <= x"58";
							elsif addrcnt(15) = x"6d" then
								addrcnt(15) <= x"63";
							elsif addrcnt(15) = x"78" then
								addrcnt(15) <= x"6e";
							elsif addrcnt(15) = x"83" then
								addrcnt(15) <= x"79";
							elsif addrcnt(15) = x"8e" then
								addrcnt(15) <= x"84";
							elsif addrcnt(15) = x"99" then
								addrcnt(15) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "011101" )or (p1_c5 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
						if( ((p1_c6 = "011101" )or (p1_c6 = "101010"))or ((p2_c1 = "011101" )or (p2_c1 = "101010"))
						or ((p2_c2 = "011101" )or (p2_c2 = "101010"))) then
							if addrcnt(16) = x"0a" then
								addrcnt(16) <= (others => '0');
							elsif addrcnt(16) = x"15" then
								addrcnt(16) <= x"0b";
							elsif addrcnt(16) = x"20" then
								addrcnt(16) <= x"16";
							elsif addrcnt(16) = x"2b" then
								addrcnt(16) <= x"21";
							elsif addrcnt(16) = x"36" then
								addrcnt(16) <= x"2c";
							elsif addrcnt(16) = x"41" then
								addrcnt(16) <= x"37";
							elsif addrcnt(16) = x"4c" then
								addrcnt(16) <= x"42";
							elsif addrcnt(16) = x"57" then
								addrcnt(16) <= x"4d";
							elsif addrcnt(16) = x"62" then
								addrcnt(16) <= x"58";
							elsif addrcnt(16) = x"6d" then
								addrcnt(16) <= x"63";
							elsif addrcnt(16) = x"78" then
								addrcnt(16) <= x"6e";
							elsif addrcnt(16) = x"83" then
								addrcnt(16) <= x"79";
							elsif addrcnt(16) = x"8e" then
								addrcnt(16) <= x"84";
							elsif addrcnt(16) = x"99" then
								addrcnt(16) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "011110" )or (p1_c5 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);
						if( ((p1_c6 = "011110" )or (p1_c6 = "101011"))or ((p2_c1 = "011110" )or (p2_c1 = "101011"))
						or ((p2_c2 = "011110" )or (p2_c2 = "101011"))) then
							if addrcnt(17) = x"0a" then
								addrcnt(17) <= (others => '0');
							elsif addrcnt(17) = x"15" then
								addrcnt(17) <= x"0b";
							elsif addrcnt(17) = x"20" then
								addrcnt(17) <= x"16";
							elsif addrcnt(17) = x"2b" then
								addrcnt(17) <= x"21";
							elsif addrcnt(17) = x"36" then
								addrcnt(17) <= x"2c";
							elsif addrcnt(17) = x"41" then
								addrcnt(17) <= x"37";
							elsif addrcnt(17) = x"4c" then
								addrcnt(17) <= x"42";
							elsif addrcnt(17) = x"57" then
								addrcnt(17) <= x"4d";
							elsif addrcnt(17) = x"62" then
								addrcnt(17) <= x"58";
							elsif addrcnt(17) = x"6d" then
								addrcnt(17) <= x"63";
							elsif addrcnt(17) = x"78" then
								addrcnt(17) <= x"6e";
							elsif addrcnt(17) = x"83" then
								addrcnt(17) <= x"79";
							elsif addrcnt(17) = x"8e" then
								addrcnt(17) <= x"84";
							elsif addrcnt(17) = x"99" then
								addrcnt(17) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "011111" )or (p1_c5 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);
						if( ((p1_c6 = "011111" )or (p1_c6 = "101100"))or ((p2_c1 = "011111" )or (p2_c1 = "101100"))
						or ((p2_c2 = "011111" )or (p2_c2 = "101100"))) then
							if addrcnt(18) = x"0a" then
								addrcnt(18) <= (others => '0');
							elsif addrcnt(18) = x"15" then
								addrcnt(18) <= x"0b";
							elsif addrcnt(18) = x"20" then
								addrcnt(18) <= x"16";
							elsif addrcnt(18) = x"2b" then
								addrcnt(18) <= x"21";
							elsif addrcnt(18) = x"36" then
								addrcnt(18) <= x"2c";
							elsif addrcnt(18) = x"41" then
								addrcnt(18) <= x"37";
							elsif addrcnt(18) = x"4c" then
								addrcnt(18) <= x"42";
							elsif addrcnt(18) = x"57" then
								addrcnt(18) <= x"4d";
							elsif addrcnt(18) = x"62" then
								addrcnt(18) <= x"58";
							elsif addrcnt(18) = x"6d" then
								addrcnt(18) <= x"63";
							elsif addrcnt(18) = x"78" then
								addrcnt(18) <= x"6e";
							elsif addrcnt(18) = x"83" then
								addrcnt(18) <= x"79";
							elsif addrcnt(18) = x"8e" then
								addrcnt(18) <= x"84";
							elsif addrcnt(18) = x"99" then
								addrcnt(18) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "100000" )or (p1_c5 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
						if(((p1_c6 = "100000" )or (p1_c6 = "101101"))or ((p2_c1 = "100000" )or (p2_c1 = "101101"))
						or ((p2_c2 = "100000" )or (p2_c2 = "101101"))) then
							if addrcnt(19) = x"0a" then
								addrcnt(19) <= (others => '0');
							elsif addrcnt(19) = x"15" then
								addrcnt(19) <= x"0b";
							elsif addrcnt(19) = x"20" then
								addrcnt(19) <= x"16";
							elsif addrcnt(19) = x"2b" then
								addrcnt(19) <= x"21";
							elsif addrcnt(19) = x"36" then
								addrcnt(19) <= x"2c";
							elsif addrcnt(19) = x"41" then
								addrcnt(19) <= x"37";
							elsif addrcnt(19) = x"4c" then
								addrcnt(19) <= x"42";
							elsif addrcnt(19) = x"57" then
								addrcnt(19) <= x"4d";
							elsif addrcnt(19) = x"62" then
								addrcnt(19) <= x"58";
							elsif addrcnt(19) = x"6d" then
								addrcnt(19) <= x"63";
							elsif addrcnt(19) = x"78" then
								addrcnt(19) <= x"6e";
							elsif addrcnt(19) = x"83" then
								addrcnt(19) <= x"79";
							elsif addrcnt(19) = x"8e" then
								addrcnt(19) <= x"84";
							elsif addrcnt(19) = x"99" then
								addrcnt(19) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "100001" )or (p1_c5 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
						if( ((p1_c6 = "100001" )or (p1_c6 = "101110"))or ((p2_c1 = "100001" )or (p2_c1 = "101110"))
						or ((p2_c2 = "100001" )or (p2_c2 = "101110"))) then
							if addrcnt(20) = x"0a" then
								addrcnt(20) <= (others => '0');
							elsif addrcnt(20) = x"15" then
								addrcnt(20) <= x"0b";
							elsif addrcnt(20) = x"20" then
								addrcnt(20) <= x"16";
							elsif addrcnt(20) = x"2b" then
								addrcnt(20) <= x"21";
							elsif addrcnt(20) = x"36" then
								addrcnt(20) <= x"2c";
							elsif addrcnt(20) = x"41" then
								addrcnt(20) <= x"37";
							elsif addrcnt(20) = x"4c" then
								addrcnt(20) <= x"42";
							elsif addrcnt(20) = x"57" then
								addrcnt(20) <= x"4d";
							elsif addrcnt(20) = x"62" then
								addrcnt(20) <= x"58";
							elsif addrcnt(20) = x"6d" then
								addrcnt(20) <= x"63";
							elsif addrcnt(20) = x"78" then
								addrcnt(20) <= x"6e";
							elsif addrcnt(20) = x"83" then
								addrcnt(20) <= x"79";
							elsif addrcnt(20) = x"8e" then
								addrcnt(20) <= x"84";
							elsif addrcnt(20) = x"99" then
								addrcnt(20) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "100010" )or (p1_c5 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
						if(((p1_c6 = "100010" )or (p1_c6 = "101111"))or ((p2_c1 = "100010" )or (p2_c1 = "101111"))
						or ((p2_c2 = "100010" )or (p2_c2 = "101111"))) then
							if addrcnt(21) = x"0a" then
								addrcnt(21) <= (others => '0');
							elsif addrcnt(21) = x"15" then
								addrcnt(21) <= x"0b";
							elsif addrcnt(21) = x"20" then
								addrcnt(21) <= x"16";
							elsif addrcnt(21) = x"2b" then
								addrcnt(21) <= x"21";
							elsif addrcnt(21) = x"36" then
								addrcnt(21) <= x"2c";
							elsif addrcnt(21) = x"41" then
								addrcnt(21) <= x"37";
							elsif addrcnt(21) = x"4c" then
								addrcnt(21) <= x"42";
							elsif addrcnt(21) = x"57" then
								addrcnt(21) <= x"4d";
							elsif addrcnt(21) = x"62" then
								addrcnt(21) <= x"58";
							elsif addrcnt(21) = x"6d" then
								addrcnt(21) <= x"63";
							elsif addrcnt(21) = x"78" then
								addrcnt(21) <= x"6e";
							elsif addrcnt(21) = x"83" then
								addrcnt(21) <= x"79";
							elsif addrcnt(21) = x"8e" then
								addrcnt(21) <= x"84";
							elsif addrcnt(21) = x"99" then
								addrcnt(21) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "100011" )or (p1_c5 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);
						if(((p1_c6 = "100011" )or (p1_c6 = "110000"))or ((p2_c1 = "100011" )or (p2_c1 = "110000"))
						or ((p2_c2 = "100011" )or (p2_c2 = "110000"))) then
							if addrcnt(22) = x"0a" then
								addrcnt(22) <= (others => '0');
							elsif addrcnt(22) = x"15" then
								addrcnt(22) <= x"0b";
							elsif addrcnt(22) = x"20" then
								addrcnt(22) <= x"16";
							elsif addrcnt(22) = x"2b" then
								addrcnt(22) <= x"21";
							elsif addrcnt(22) = x"36" then
								addrcnt(22) <= x"2c";
							elsif addrcnt(22) = x"41" then
								addrcnt(22) <= x"37";
							elsif addrcnt(22) = x"4c" then
								addrcnt(22) <= x"42";
							elsif addrcnt(22) = x"57" then
								addrcnt(22) <= x"4d";
							elsif addrcnt(22) = x"62" then
								addrcnt(22) <= x"58";
							elsif addrcnt(22) = x"6d" then
								addrcnt(22) <= x"63";
							elsif addrcnt(22) = x"78" then
								addrcnt(22) <= x"6e";
							elsif addrcnt(22) = x"83" then
								addrcnt(22) <= x"79";
							elsif addrcnt(22) = x"8e" then
								addrcnt(22) <= x"84";
							elsif addrcnt(22) = x"99" then
								addrcnt(22) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "100100" )or (p1_c5 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
						if( ((p1_c6 = "100100" )or (p1_c6 = "110001"))or ((p2_c1 = "100100" )or (p2_c1 = "110001"))
						or ((p2_c2 = "100100" )or (p2_c2 = "110001"))) then
							if addrcnt(23) = x"0a" then
								addrcnt(23) <= (others => '0');
							elsif addrcnt(23) = x"15" then
								addrcnt(23) <= x"0b";
							elsif addrcnt(23) = x"20" then
								addrcnt(23) <= x"16";
							elsif addrcnt(23) = x"2b" then
								addrcnt(23) <= x"21";
							elsif addrcnt(23) = x"36" then
								addrcnt(23) <= x"2c";
							elsif addrcnt(23) = x"41" then
								addrcnt(23) <= x"37";
							elsif addrcnt(23) = x"4c" then
								addrcnt(23) <= x"42";
							elsif addrcnt(23) = x"57" then
								addrcnt(23) <= x"4d";
							elsif addrcnt(23) = x"62" then
								addrcnt(23) <= x"58";
							elsif addrcnt(23) = x"6d" then
								addrcnt(23) <= x"63";
							elsif addrcnt(23) = x"78" then
								addrcnt(23) <= x"6e";
							elsif addrcnt(23) = x"83" then
								addrcnt(23) <= x"79";
							elsif addrcnt(23) = x"8e" then
								addrcnt(23) <= x"84";
							elsif addrcnt(23) = x"99" then
								addrcnt(23) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "100101" )or (p1_c5 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
						if(((p1_c6 = "100101" )or (p1_c6 = "110010"))or ((p2_c1 = "100101" )or (p2_c1 = "110010"))
						or ((p2_c2 = "100101" )or (p2_c2 = "110010"))) then
							if addrcnt(24) = x"0a" then
								addrcnt(24) <= (others => '0');
							elsif addrcnt(24) = x"15" then
								addrcnt(24) <= x"0b";
							elsif addrcnt(24) = x"20" then
								addrcnt(24) <= x"16";
							elsif addrcnt(24) = x"2b" then
								addrcnt(24) <= x"21";
							elsif addrcnt(24) = x"36" then
								addrcnt(24) <= x"2c";
							elsif addrcnt(24) = x"41" then
								addrcnt(24) <= x"37";
							elsif addrcnt(24) = x"4c" then
								addrcnt(24) <= x"42";
							elsif addrcnt(24) = x"57" then
								addrcnt(24) <= x"4d";
							elsif addrcnt(24) = x"62" then
								addrcnt(24) <= x"58";
							elsif addrcnt(24) = x"6d" then
								addrcnt(24) <= x"63";
							elsif addrcnt(24) = x"78" then
								addrcnt(24) <= x"6e";
							elsif addrcnt(24) = x"83" then
								addrcnt(24) <= x"79";
							elsif addrcnt(24) = x"8e" then
								addrcnt(24) <= x"84";
							elsif addrcnt(24) = x"99" then
								addrcnt(24) <= x"8f";
							end if;
						end if;
					elsif (p1_c5 = "100110" )or (p1_c5 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
						if(((p1_c6 = "100110" )or (p1_c6 = "110011"))or ((p2_c1 = "100110" )or (p2_c1 = "110011"))
						or ((p2_c2 = "100110" )or (p2_c2 = "110011"))) then
							if addrcnt(25) = x"0a" then
								addrcnt(25) <= (others => '0');
							elsif addrcnt(25) = x"15" then
								addrcnt(25) <= x"0b";
							elsif addrcnt(25) = x"20" then
								addrcnt(25) <= x"16";
							elsif addrcnt(25) = x"2b" then
								addrcnt(25) <= x"21";
							elsif addrcnt(25) = x"36" then
								addrcnt(25) <= x"2c";
							elsif addrcnt(25) = x"41" then
								addrcnt(25) <= x"37";
							elsif addrcnt(25) = x"4c" then
								addrcnt(25) <= x"42";
							elsif addrcnt(25) = x"57" then
								addrcnt(25) <= x"4d";
							elsif addrcnt(25) = x"62" then
								addrcnt(25) <= x"58";
							elsif addrcnt(25) = x"6d" then
								addrcnt(25) <= x"63";
							elsif addrcnt(25) = x"78" then
								addrcnt(25) <= x"6e";
							elsif addrcnt(25) = x"83" then
								addrcnt(25) <= x"79";
							elsif addrcnt(25) = x"8e" then
								addrcnt(25) <= x"84";
							elsif addrcnt(25) = x"99" then
								addrcnt(25) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +155 ) ) and ( hsync_cnt <= (tHW + tHBP +165)) ) then
					if (p1_c6 = "000000" )or (p1_c6 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
						if(((p2_c1 = "000000" )or (p2_c1 = "001101")) or ((p2_c2 = "000000" )or (p2_c2 = "001101"))) then
							if addrcnt(0) = x"0a" then
								addrcnt(0) <= (others => '0');
							elsif addrcnt(0) = x"15" then
								addrcnt(0) <= x"0b";
							elsif addrcnt(0) = x"20" then
								addrcnt(0) <= x"16";
							elsif addrcnt(0) = x"2b" then
								addrcnt(0) <= x"21";
							elsif addrcnt(0) = x"36" then
								addrcnt(0) <= x"2c";
							elsif addrcnt(0) = x"41" then
								addrcnt(0) <= x"37";
							elsif addrcnt(0) = x"4c" then
								addrcnt(0) <= x"42";
							elsif addrcnt(0) = x"57" then
								addrcnt(0) <= x"4d";
							elsif addrcnt(0) = x"62" then
								addrcnt(0) <= x"58";
							elsif addrcnt(0) = x"6d" then
								addrcnt(0) <= x"63";
							elsif addrcnt(0) = x"78" then
								addrcnt(0) <= x"6e";
							elsif addrcnt(0) = x"83" then
								addrcnt(0) <= x"79";
							elsif addrcnt(0) = x"8e" then
								addrcnt(0) <= x"84";
							elsif addrcnt(0) = x"99" then
								addrcnt(0) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "000001" )or (p1_c6 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
						if(((p2_c1 = "000001" )or (p2_c1 = "001110")) or ((p2_c2 = "000001" )or (p2_c2 = "001110"))) then
							if addrcnt(1) = x"0a" then
								addrcnt(1) <= (others => '0');
							elsif addrcnt(1) = x"15" then
								addrcnt(1) <= x"0b";
							elsif addrcnt(1) = x"20" then
								addrcnt(1) <= x"16";
							elsif addrcnt(1) = x"2b" then
								addrcnt(1) <= x"21";
							elsif addrcnt(1) = x"36" then
								addrcnt(1) <= x"2c";
							elsif addrcnt(1) = x"41" then
								addrcnt(1) <= x"37";
							elsif addrcnt(1) = x"4c" then
								addrcnt(1) <= x"42";
							elsif addrcnt(1) = x"57" then
								addrcnt(1) <= x"4d";
							elsif addrcnt(1) = x"62" then
								addrcnt(1) <= x"58";
							elsif addrcnt(1) = x"6d" then
								addrcnt(1) <= x"63";
							elsif addrcnt(1) = x"78" then
								addrcnt(1) <= x"6e";
							elsif addrcnt(1) = x"83" then
								addrcnt(1) <= x"79";
							elsif addrcnt(1) = x"8e" then
								addrcnt(1) <= x"84";
							elsif addrcnt(1) = x"99" then
								addrcnt(1) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "000010" )or (p1_c6 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
						if(((p2_c1 = "000010" )or (p2_c1 = "001111"))
						or ((p2_c2 = "000010" )or (p2_c2 = "001111"))) then
							if addrcnt(2) = x"0a" then
								addrcnt(2) <= (others => '0');
							elsif addrcnt(2) = x"15" then
								addrcnt(2) <= x"0b";
							elsif addrcnt(2) = x"20" then
								addrcnt(2) <= x"16";
							elsif addrcnt(2) = x"2b" then
								addrcnt(2) <= x"21";
							elsif addrcnt(2) = x"36" then
								addrcnt(2) <= x"2c";
							elsif addrcnt(2) = x"41" then
								addrcnt(2) <= x"37";
							elsif addrcnt(2) = x"4c" then
								addrcnt(2) <= x"42";
							elsif addrcnt(2) = x"57" then
								addrcnt(2) <= x"4d";
							elsif addrcnt(2) = x"62" then
								addrcnt(2) <= x"58";
							elsif addrcnt(2) = x"6d" then
								addrcnt(2) <= x"63";
							elsif addrcnt(2) = x"78" then
								addrcnt(2) <= x"6e";
							elsif addrcnt(2) = x"83" then
								addrcnt(2) <= x"79";
							elsif addrcnt(2) = x"8e" then
								addrcnt(2) <= x"84";
							elsif addrcnt(2) = x"99" then
								addrcnt(2) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "000011" )or (p1_c6 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
						if( ((p2_c1 = "000011" )or (p2_c1 = "010000"))	or ((p2_c2 = "000011" )or (p2_c2 = "010000"))) then
							if addrcnt(3) = x"0a" then
								addrcnt(3) <= (others => '0');
							elsif addrcnt(3) = x"15" then
								addrcnt(3) <= x"0b";
							elsif addrcnt(3) = x"20" then
								addrcnt(3) <= x"16";
							elsif addrcnt(3) = x"2b" then
								addrcnt(3) <= x"21";
							elsif addrcnt(3) = x"36" then
								addrcnt(3) <= x"2c";
							elsif addrcnt(3) = x"41" then
								addrcnt(3) <= x"37";
							elsif addrcnt(3) = x"4c" then
								addrcnt(3) <= x"42";
							elsif addrcnt(3) = x"57" then
								addrcnt(3) <= x"4d";
							elsif addrcnt(3) = x"62" then
								addrcnt(3) <= x"58";
							elsif addrcnt(3) = x"6d" then
								addrcnt(3) <= x"63";
							elsif addrcnt(3) = x"78" then
								addrcnt(3) <= x"6e";
							elsif addrcnt(3) = x"83" then
								addrcnt(3) <= x"79";
							elsif addrcnt(3) = x"8e" then
								addrcnt(3) <= x"84";
							elsif addrcnt(3) = x"99" then
								addrcnt(3) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "000100" )or (p1_c6 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);
						if(((p2_c1 = "000100" )or (p2_c1 = "010001"))	or ((p2_c2 = "000100" )or (p2_c2 = "010001"))) then
							if addrcnt(4) = x"0a" then
								addrcnt(4) <= (others => '0');
							elsif addrcnt(4) = x"15" then
								addrcnt(4) <= x"0b";
							elsif addrcnt(4) = x"20" then
								addrcnt(4) <= x"16";
							elsif addrcnt(4) = x"2b" then
								addrcnt(4) <= x"21";
							elsif addrcnt(4) = x"36" then
								addrcnt(4) <= x"2c";
							elsif addrcnt(4) = x"41" then
								addrcnt(4) <= x"37";
							elsif addrcnt(4) = x"4c" then
								addrcnt(4) <= x"42";
							elsif addrcnt(4) = x"57" then
								addrcnt(4) <= x"4d";
							elsif addrcnt(4) = x"62" then
								addrcnt(4) <= x"58";
							elsif addrcnt(4) = x"6d" then
								addrcnt(4) <= x"63";
							elsif addrcnt(4) = x"78" then
								addrcnt(4) <= x"6e";
							elsif addrcnt(4) = x"83" then
								addrcnt(4) <= x"79";
							elsif addrcnt(4) = x"8e" then
								addrcnt(4) <= x"84";
							elsif addrcnt(4) = x"99" then
								addrcnt(4) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "000101" )or (p1_c6 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);
						if( ((p2_c1 = "000101" )or (p2_c1 = "010010"))	or ((p2_c2 = "000101" )or (p2_c2 = "010010"))) then
							if addrcnt(5) = x"0a" then
								addrcnt(5) <= (others => '0');
							elsif addrcnt(5) = x"15" then
								addrcnt(5) <= x"0b";
							elsif addrcnt(5) = x"20" then
								addrcnt(5) <= x"16";
							elsif addrcnt(5) = x"2b" then
								addrcnt(5) <= x"21";
							elsif addrcnt(5) = x"36" then
								addrcnt(5) <= x"2c";
							elsif addrcnt(5) = x"41" then
								addrcnt(5) <= x"37";
							elsif addrcnt(5) = x"4c" then
								addrcnt(5) <= x"42";
							elsif addrcnt(5) = x"57" then
								addrcnt(5) <= x"4d";
							elsif addrcnt(5) = x"62" then
								addrcnt(5) <= x"58";
							elsif addrcnt(5) = x"6d" then
								addrcnt(5) <= x"63";
							elsif addrcnt(5) = x"78" then
								addrcnt(5) <= x"6e";
							elsif addrcnt(5) = x"83" then
								addrcnt(5) <= x"79";
							elsif addrcnt(5) = x"8e" then
								addrcnt(5) <= x"84";
							elsif addrcnt(5) = x"99" then
								addrcnt(5) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "000110" )or (p1_c6 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);
						if( ((p2_c1 = "0000110" )or (p2_c1 = "010011"))	or ((p2_c2 = "0000110" )or (p2_c2 = "010011"))) then
							if addrcnt(6) = x"0a" then
								addrcnt(6) <= (others => '0');
							elsif addrcnt(6) = x"15" then
								addrcnt(6) <= x"0b";
							elsif addrcnt(6) = x"20" then
								addrcnt(6) <= x"16";
							elsif addrcnt(6) = x"2b" then
								addrcnt(6) <= x"21";
							elsif addrcnt(6) = x"36" then
								addrcnt(6) <= x"2c";
							elsif addrcnt(6) = x"41" then
								addrcnt(6) <= x"37";
							elsif addrcnt(6) = x"4c" then
								addrcnt(6) <= x"42";
							elsif addrcnt(6) = x"57" then
								addrcnt(6) <= x"4d";
							elsif addrcnt(6) = x"62" then
								addrcnt(6) <= x"58";
							elsif addrcnt(6) = x"6d" then
								addrcnt(6) <= x"63";
							elsif addrcnt(6) = x"78" then
								addrcnt(6) <= x"6e";
							elsif addrcnt(6) = x"83" then
								addrcnt(6) <= x"79";
							elsif addrcnt(6) = x"8e" then
								addrcnt(6) <= x"84";
							elsif addrcnt(6) = x"99" then
								addrcnt(6) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "000111" )or (p1_c6 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);
						if( ((p2_c1 = "0000111" )or (p2_c1 = "010100"))		or ((p2_c2 = "0000111" )or (p2_c2 = "010100"))) then
							if addrcnt(7) = x"0a" then
								addrcnt(7) <= (others => '0');
							elsif addrcnt(7) = x"15" then
								addrcnt(7) <= x"0b";
							elsif addrcnt(7) = x"20" then
								addrcnt(7) <= x"16";
							elsif addrcnt(7) = x"2b" then
								addrcnt(7) <= x"21";
							elsif addrcnt(7) = x"36" then
								addrcnt(7) <= x"2c";
							elsif addrcnt(7) = x"41" then
								addrcnt(7) <= x"37";
							elsif addrcnt(7) = x"4c" then
								addrcnt(7) <= x"42";
							elsif addrcnt(7) = x"57" then
								addrcnt(7) <= x"4d";
							elsif addrcnt(7) = x"62" then
								addrcnt(7) <= x"58";
							elsif addrcnt(7) = x"6d" then
								addrcnt(7) <= x"63";
							elsif addrcnt(7) = x"78" then
								addrcnt(7) <= x"6e";
							elsif addrcnt(7) = x"83" then
								addrcnt(7) <= x"79";
							elsif addrcnt(7) = x"8e" then
								addrcnt(7) <= x"84";
							elsif addrcnt(7) = x"99" then
								addrcnt(7) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "001000" )or (p1_c6 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
						if( ((p2_c1 = "001000" )or (p2_c1 = "010101"))	or ((p2_c2 = "001000" )or (p2_c2 = "010101"))) then
							if addrcnt(8) = x"0a" then
								addrcnt(8) <= (others => '0');
							elsif addrcnt(8) = x"15" then
								addrcnt(8) <= x"0b";
							elsif addrcnt(8) = x"20" then
								addrcnt(8) <= x"16";
							elsif addrcnt(8) = x"2b" then
								addrcnt(8) <= x"21";
							elsif addrcnt(8) = x"36" then
								addrcnt(8) <= x"2c";
							elsif addrcnt(8) = x"41" then
								addrcnt(8) <= x"37";
							elsif addrcnt(8) = x"4c" then
								addrcnt(8) <= x"42";
							elsif addrcnt(8) = x"57" then
								addrcnt(8) <= x"4d";
							elsif addrcnt(8) = x"62" then
								addrcnt(8) <= x"58";
							elsif addrcnt(8) = x"6d" then
								addrcnt(8) <= x"63";
							elsif addrcnt(8) = x"78" then
								addrcnt(8) <= x"6e";
							elsif addrcnt(8) = x"83" then
								addrcnt(8) <= x"79";
							elsif addrcnt(8) = x"8e" then
								addrcnt(8) <= x"84";
							elsif addrcnt(8) = x"99" then
								addrcnt(8) <= x"8f";
							end if;
						end if;
					elsif (p1_c6= "001001" )or (p1_c6 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);
						if( ((p2_c1 = "001001" )or (p2_c1 = "010110"))	or ((p2_c2 = "001001" )or (p2_c2 = "010110"))) then
							if addrcnt(9) = x"0a" then
								addrcnt(9) <= (others => '0');
							elsif addrcnt(9) = x"15" then
								addrcnt(9) <= x"0b";
							elsif addrcnt(9) = x"20" then
								addrcnt(9) <= x"16";
							elsif addrcnt(9) = x"2b" then
								addrcnt(9) <= x"21";
							elsif addrcnt(9) = x"36" then
								addrcnt(9) <= x"2c";
							elsif addrcnt(9) = x"41" then
								addrcnt(9) <= x"37";
							elsif addrcnt(9) = x"4c" then
								addrcnt(9) <= x"42";
							elsif addrcnt(9) = x"57" then
								addrcnt(9) <= x"4d";
							elsif addrcnt(9) = x"62" then
								addrcnt(9) <= x"58";
							elsif addrcnt(9) = x"6d" then
								addrcnt(9) <= x"63";
							elsif addrcnt(9) = x"78" then
								addrcnt(9) <= x"6e";
							elsif addrcnt(9) = x"83" then
								addrcnt(9) <= x"79";
							elsif addrcnt(9) = x"8e" then
								addrcnt(9) <= x"84";
							elsif addrcnt(9) = x"99" then
								addrcnt(9) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "001010" )or (p1_c6 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);
						if(  ((p2_c1 = "001010" )or (p2_c1 = "010111"))	or ((p2_c2 = "001010" )or (p2_c2 = "010111"))) then
							if addrcnt(10) = x"0a" then
								addrcnt(10) <= (others => '0');
							elsif addrcnt(10) = x"15" then
								addrcnt(10) <= x"0b";
							elsif addrcnt(10) = x"20" then
								addrcnt(10) <= x"16";
							elsif addrcnt(10) = x"2b" then
								addrcnt(10) <= x"21";
							elsif addrcnt(10) = x"36" then
								addrcnt(10) <= x"2c";
							elsif addrcnt(10) = x"41" then
								addrcnt(10) <= x"37";
							elsif addrcnt(10) = x"4c" then
								addrcnt(10) <= x"42";
							elsif addrcnt(10) = x"57" then
								addrcnt(10) <= x"4d";
							elsif addrcnt(10) = x"62" then
								addrcnt(10) <= x"58";
							elsif addrcnt(10) = x"6d" then
								addrcnt(10) <= x"63";
							elsif addrcnt(10) = x"78" then
								addrcnt(10) <= x"6e";
							elsif addrcnt(10) = x"83" then
								addrcnt(10) <= x"79";
							elsif addrcnt(10) = x"8e" then
								addrcnt(10) <= x"84";
							elsif addrcnt(10) = x"99" then
								addrcnt(10) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "001011" )or (p1_c6 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);
						if(((p2_c1 = "001011" )or (p2_c1 = "011000"))	or ((p2_c2 = "001011" )or (p2_c2 = "011000"))) then
							if addrcnt(11) = x"0a" then
								addrcnt(11) <= (others => '0');
							elsif addrcnt(11) = x"15" then
								addrcnt(11) <= x"0b";
							elsif addrcnt(11) = x"20" then
								addrcnt(11) <= x"16";
							elsif addrcnt(11) = x"2b" then
								addrcnt(11) <= x"21";
							elsif addrcnt(11) = x"36" then
								addrcnt(11) <= x"2c";
							elsif addrcnt(11) = x"41" then
								addrcnt(11) <= x"37";
							elsif addrcnt(11) = x"4c" then
								addrcnt(11) <= x"42";
							elsif addrcnt(11) = x"57" then
								addrcnt(11) <= x"4d";
							elsif addrcnt(11) = x"62" then
								addrcnt(11) <= x"58";
							elsif addrcnt(11) = x"6d" then
								addrcnt(11) <= x"63";
							elsif addrcnt(11) = x"78" then
								addrcnt(11) <= x"6e";
							elsif addrcnt(11) = x"83" then
								addrcnt(11) <= x"79";
							elsif addrcnt(11) = x"8e" then
								addrcnt(11) <= x"84";
							elsif addrcnt(11) = x"99" then
								addrcnt(11) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "001100" )or (p1_c6 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
						if(((p2_c1 = "001100" )or (p2_c1 = "011001"))	or ((p2_c2 = "001100" )or (p2_c2 = "011001"))) then
							if addrcnt(12) = x"0a" then
								addrcnt(12) <= (others => '0');
							elsif addrcnt(12) = x"15" then
								addrcnt(12) <= x"0b";
							elsif addrcnt(12) = x"20" then
								addrcnt(12) <= x"16";
							elsif addrcnt(12) = x"2b" then
								addrcnt(12) <= x"21";
							elsif addrcnt(12) = x"36" then
								addrcnt(12) <= x"2c";
							elsif addrcnt(12) = x"41" then
								addrcnt(12) <= x"37";
							elsif addrcnt(12) = x"4c" then
								addrcnt(12) <= x"42";
							elsif addrcnt(12) = x"57" then
								addrcnt(12) <= x"4d";
							elsif addrcnt(12) = x"62" then
								addrcnt(12) <= x"58";
							elsif addrcnt(12) = x"6d" then
								addrcnt(12) <= x"63";
							elsif addrcnt(12) = x"78" then
								addrcnt(12) <= x"6e";
							elsif addrcnt(12) = x"83" then
								addrcnt(12) <= x"79";
							elsif addrcnt(12) = x"8e" then
								addrcnt(12) <= x"84";
							elsif addrcnt(12) = x"99" then
								addrcnt(12) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "011010" )or (p1_c6 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
						if(((p2_c1 = "011010" )or (p2_c1 = "100111"))	or ((p2_c2 = "011010" )or (p2_c2 = "100111"))) then
							if addrcnt(13) = x"0a" then
								addrcnt(13) <= (others => '0');
							elsif addrcnt(13) = x"15" then
								addrcnt(13) <= x"0b";
							elsif addrcnt(13) = x"20" then
								addrcnt(13) <= x"16";
							elsif addrcnt(13) = x"2b" then
								addrcnt(13) <= x"21";
							elsif addrcnt(13) = x"36" then
								addrcnt(13) <= x"2c";
							elsif addrcnt(13) = x"41" then
								addrcnt(13) <= x"37";
							elsif addrcnt(13) = x"4c" then
								addrcnt(13) <= x"42";
							elsif addrcnt(13) = x"57" then
								addrcnt(13) <= x"4d";
							elsif addrcnt(13) = x"62" then
								addrcnt(13) <= x"58";
							elsif addrcnt(13) = x"6d" then
								addrcnt(13) <= x"63";
							elsif addrcnt(13) = x"78" then
								addrcnt(13) <= x"6e";
							elsif addrcnt(13) = x"83" then
								addrcnt(13) <= x"79";
							elsif addrcnt(13) = x"8e" then
								addrcnt(13) <= x"84";
							elsif addrcnt(13) = x"99" then
								addrcnt(13) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "011011" )or (p1_c6 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
						if(((p2_c1 = "011011" )or (p2_c1 = "101000"))	or ((p2_c2 = "011011" )or (p2_c2 = "101000"))) then
							if addrcnt(14) = x"0a" then
								addrcnt(14) <= (others => '0');
							elsif addrcnt(14) = x"15" then
								addrcnt(14) <= x"0b";
							elsif addrcnt(14) = x"20" then
								addrcnt(14) <= x"16";
							elsif addrcnt(14) = x"2b" then
								addrcnt(14) <= x"21";
							elsif addrcnt(14) = x"36" then
								addrcnt(14) <= x"2c";
							elsif addrcnt(14) = x"41" then
								addrcnt(14) <= x"37";
							elsif addrcnt(14) = x"4c" then
								addrcnt(14) <= x"42";
							elsif addrcnt(14) = x"57" then
								addrcnt(14) <= x"4d";
							elsif addrcnt(14) = x"62" then
								addrcnt(14) <= x"58";
							elsif addrcnt(14) = x"6d" then
								addrcnt(14) <= x"63";
							elsif addrcnt(14) = x"78" then
								addrcnt(14) <= x"6e";
							elsif addrcnt(14) = x"83" then
								addrcnt(14) <= x"79";
							elsif addrcnt(14) = x"8e" then
								addrcnt(14) <= x"84";
							elsif addrcnt(14) = x"99" then
								addrcnt(14) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "011100" )or (p1_c6 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
						if(  ((p2_c1 = "011100" )or (p2_c1 = "101001"))	or ((p2_c2 = "011100" )or (p2_c2 = "101001"))) then
							if addrcnt(15) = x"0a" then
								addrcnt(15) <= (others => '0');
							elsif addrcnt(15) = x"15" then
								addrcnt(15) <= x"0b";
							elsif addrcnt(15) = x"20" then
								addrcnt(15) <= x"16";
							elsif addrcnt(15) = x"2b" then
								addrcnt(15) <= x"21";
							elsif addrcnt(15) = x"36" then
								addrcnt(15) <= x"2c";
							elsif addrcnt(15) = x"41" then
								addrcnt(15) <= x"37";
							elsif addrcnt(15) = x"4c" then
								addrcnt(15) <= x"42";
							elsif addrcnt(15) = x"57" then
								addrcnt(15) <= x"4d";
							elsif addrcnt(15) = x"62" then
								addrcnt(15) <= x"58";
							elsif addrcnt(15) = x"6d" then
								addrcnt(15) <= x"63";
							elsif addrcnt(15) = x"78" then
								addrcnt(15) <= x"6e";
							elsif addrcnt(15) = x"83" then
								addrcnt(15) <= x"79";
							elsif addrcnt(15) = x"8e" then
								addrcnt(15) <= x"84";
							elsif addrcnt(15) = x"99" then
								addrcnt(15) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "011101" )or (p1_c6 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
						if(((p2_c1 = "011101" )or (p2_c1 = "101010"))	or ((p2_c2 = "011101" )or (p2_c2 = "101010"))) then
							if addrcnt(16) = x"0a" then
								addrcnt(16) <= (others => '0');
							elsif addrcnt(16) = x"15" then
								addrcnt(16) <= x"0b";
							elsif addrcnt(16) = x"20" then
								addrcnt(16) <= x"16";
							elsif addrcnt(16) = x"2b" then
								addrcnt(16) <= x"21";
							elsif addrcnt(16) = x"36" then
								addrcnt(16) <= x"2c";
							elsif addrcnt(16) = x"41" then
								addrcnt(16) <= x"37";
							elsif addrcnt(16) = x"4c" then
								addrcnt(16) <= x"42";
							elsif addrcnt(16) = x"57" then
								addrcnt(16) <= x"4d";
							elsif addrcnt(16) = x"62" then
								addrcnt(16) <= x"58";
							elsif addrcnt(16) = x"6d" then
								addrcnt(16) <= x"63";
							elsif addrcnt(16) = x"78" then
								addrcnt(16) <= x"6e";
							elsif addrcnt(16) = x"83" then
								addrcnt(16) <= x"79";
							elsif addrcnt(16) = x"8e" then
								addrcnt(16) <= x"84";
							elsif addrcnt(16) = x"99" then
								addrcnt(16) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "011110" )or (p1_c6 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);
						if(((p2_c1 = "011110" )or (p2_c1 = "101011"))	or ((p2_c2 = "011110" )or (p2_c2 = "101011"))) then
							if addrcnt(17) = x"0a" then
								addrcnt(17) <= (others => '0');
							elsif addrcnt(17) = x"15" then
								addrcnt(17) <= x"0b";
							elsif addrcnt(17) = x"20" then
								addrcnt(17) <= x"16";
							elsif addrcnt(17) = x"2b" then
								addrcnt(17) <= x"21";
							elsif addrcnt(17) = x"36" then
								addrcnt(17) <= x"2c";
							elsif addrcnt(17) = x"41" then
								addrcnt(17) <= x"37";
							elsif addrcnt(17) = x"4c" then
								addrcnt(17) <= x"42";
							elsif addrcnt(17) = x"57" then
								addrcnt(17) <= x"4d";
							elsif addrcnt(17) = x"62" then
								addrcnt(17) <= x"58";
							elsif addrcnt(17) = x"6d" then
								addrcnt(17) <= x"63";
							elsif addrcnt(17) = x"78" then
								addrcnt(17) <= x"6e";
							elsif addrcnt(17) = x"83" then
								addrcnt(17) <= x"79";
							elsif addrcnt(17) = x"8e" then
								addrcnt(17) <= x"84";
							elsif addrcnt(17) = x"99" then
								addrcnt(17) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "011111" )or (p1_c6 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);
						if( ((p2_c1 = "011111" )or (p2_c1 = "101100"))	or ((p2_c2 = "011111" )or (p2_c2 = "101100"))) then
							if addrcnt(18) = x"0a" then
								addrcnt(18) <= (others => '0');
							elsif addrcnt(18) = x"15" then
								addrcnt(18) <= x"0b";
							elsif addrcnt(18) = x"20" then
								addrcnt(18) <= x"16";
							elsif addrcnt(18) = x"2b" then
								addrcnt(18) <= x"21";
							elsif addrcnt(18) = x"36" then
								addrcnt(18) <= x"2c";
							elsif addrcnt(18) = x"41" then
								addrcnt(18) <= x"37";
							elsif addrcnt(18) = x"4c" then
								addrcnt(18) <= x"42";
							elsif addrcnt(18) = x"57" then
								addrcnt(18) <= x"4d";
							elsif addrcnt(18) = x"62" then
								addrcnt(18) <= x"58";
							elsif addrcnt(18) = x"6d" then
								addrcnt(18) <= x"63";
							elsif addrcnt(18) = x"78" then
								addrcnt(18) <= x"6e";
							elsif addrcnt(18) = x"83" then
								addrcnt(18) <= x"79";
							elsif addrcnt(18) = x"8e" then
								addrcnt(18) <= x"84";
							elsif addrcnt(18) = x"99" then
								addrcnt(18) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "100000" )or (p1_c6 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
						if( ((p2_c1 = "100000" )or (p2_c1 = "101101"))	or ((p2_c2 = "100000" )or (p2_c2 = "101101"))) then
							if addrcnt(19) = x"0a" then
								addrcnt(19) <= (others => '0');
							elsif addrcnt(19) = x"15" then
								addrcnt(19) <= x"0b";
							elsif addrcnt(19) = x"20" then
								addrcnt(19) <= x"16";
							elsif addrcnt(19) = x"2b" then
								addrcnt(19) <= x"21";
							elsif addrcnt(19) = x"36" then
								addrcnt(19) <= x"2c";
							elsif addrcnt(19) = x"41" then
								addrcnt(19) <= x"37";
							elsif addrcnt(19) = x"4c" then
								addrcnt(19) <= x"42";
							elsif addrcnt(19) = x"57" then
								addrcnt(19) <= x"4d";
							elsif addrcnt(19) = x"62" then
								addrcnt(19) <= x"58";
							elsif addrcnt(19) = x"6d" then
								addrcnt(19) <= x"63";
							elsif addrcnt(19) = x"78" then
								addrcnt(19) <= x"6e";
							elsif addrcnt(19) = x"83" then
								addrcnt(19) <= x"79";
							elsif addrcnt(19) = x"8e" then
								addrcnt(19) <= x"84";
							elsif addrcnt(19) = x"99" then
								addrcnt(19) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "100001" )or (p1_c6 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
						if(((p2_c1 = "100001" )or (p2_c1 = "101110"))	or ((p2_c2 = "100001" )or (p2_c2 = "101110"))) then
							if addrcnt(20) = x"0a" then
								addrcnt(20) <= (others => '0');
							elsif addrcnt(20) = x"15" then
								addrcnt(20) <= x"0b";
							elsif addrcnt(20) = x"20" then
								addrcnt(20) <= x"16";
							elsif addrcnt(20) = x"2b" then
								addrcnt(20) <= x"21";
							elsif addrcnt(20) = x"36" then
								addrcnt(20) <= x"2c";
							elsif addrcnt(20) = x"41" then
								addrcnt(20) <= x"37";
							elsif addrcnt(20) = x"4c" then
								addrcnt(20) <= x"42";
							elsif addrcnt(20) = x"57" then
								addrcnt(20) <= x"4d";
							elsif addrcnt(20) = x"62" then
								addrcnt(20) <= x"58";
							elsif addrcnt(20) = x"6d" then
								addrcnt(20) <= x"63";
							elsif addrcnt(20) = x"78" then
								addrcnt(20) <= x"6e";
							elsif addrcnt(20) = x"83" then
								addrcnt(20) <= x"79";
							elsif addrcnt(20) = x"8e" then
								addrcnt(20) <= x"84";
							elsif addrcnt(20) = x"99" then
								addrcnt(20) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "100010" )or (p1_c6 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
						if(((p2_c1 = "100010" )or (p2_c1 = "101111"))	or ((p2_c2 = "100010" )or (p2_c2 = "101111"))) then
							if addrcnt(21) = x"0a" then
								addrcnt(21) <= (others => '0');
							elsif addrcnt(21) = x"15" then
								addrcnt(21) <= x"0b";
							elsif addrcnt(21) = x"20" then
								addrcnt(21) <= x"16";
							elsif addrcnt(21) = x"2b" then
								addrcnt(21) <= x"21";
							elsif addrcnt(21) = x"36" then
								addrcnt(21) <= x"2c";
							elsif addrcnt(21) = x"41" then
								addrcnt(21) <= x"37";
							elsif addrcnt(21) = x"4c" then
								addrcnt(21) <= x"42";
							elsif addrcnt(21) = x"57" then
								addrcnt(21) <= x"4d";
							elsif addrcnt(21) = x"62" then
								addrcnt(21) <= x"58";
							elsif addrcnt(21) = x"6d" then
								addrcnt(21) <= x"63";
							elsif addrcnt(21) = x"78" then
								addrcnt(21) <= x"6e";
							elsif addrcnt(21) = x"83" then
								addrcnt(21) <= x"79";
							elsif addrcnt(21) = x"8e" then
								addrcnt(21) <= x"84";
							elsif addrcnt(21) = x"99" then
								addrcnt(21) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "100011" )or (p1_c6 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);
						if(((p2_c1 = "100011" )or (p2_c1 = "110000"))	or ((p2_c2 = "100011" )or (p2_c2 = "110000"))) then
							if addrcnt(22) = x"0a" then
								addrcnt(22) <= (others => '0');
							elsif addrcnt(22) = x"15" then
								addrcnt(22) <= x"0b";
							elsif addrcnt(22) = x"20" then
								addrcnt(22) <= x"16";
							elsif addrcnt(22) = x"2b" then
								addrcnt(22) <= x"21";
							elsif addrcnt(22) = x"36" then
								addrcnt(22) <= x"2c";
							elsif addrcnt(22) = x"41" then
								addrcnt(22) <= x"37";
							elsif addrcnt(22) = x"4c" then
								addrcnt(22) <= x"42";
							elsif addrcnt(22) = x"57" then
								addrcnt(22) <= x"4d";
							elsif addrcnt(22) = x"62" then
								addrcnt(22) <= x"58";
							elsif addrcnt(22) = x"6d" then
								addrcnt(22) <= x"63";
							elsif addrcnt(22) = x"78" then
								addrcnt(22) <= x"6e";
							elsif addrcnt(22) = x"83" then
								addrcnt(22) <= x"79";
							elsif addrcnt(22) = x"8e" then
								addrcnt(22) <= x"84";
							elsif addrcnt(22) = x"99" then
								addrcnt(22) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "100100" )or (p1_c6 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
						if(  ((p2_c1 = "100100" )or (p2_c1 = "110001"))	or ((p2_c2 = "100100" )or (p2_c2 = "110001"))) then
							if addrcnt(23) = x"0a" then
								addrcnt(23) <= (others => '0');
							elsif addrcnt(23) = x"15" then
								addrcnt(23) <= x"0b";
							elsif addrcnt(23) = x"20" then
								addrcnt(23) <= x"16";
							elsif addrcnt(23) = x"2b" then
								addrcnt(23) <= x"21";
							elsif addrcnt(23) = x"36" then
								addrcnt(23) <= x"2c";
							elsif addrcnt(23) = x"41" then
								addrcnt(23) <= x"37";
							elsif addrcnt(23) = x"4c" then
								addrcnt(23) <= x"42";
							elsif addrcnt(23) = x"57" then
								addrcnt(23) <= x"4d";
							elsif addrcnt(23) = x"62" then
								addrcnt(23) <= x"58";
							elsif addrcnt(23) = x"6d" then
								addrcnt(23) <= x"63";
							elsif addrcnt(23) = x"78" then
								addrcnt(23) <= x"6e";
							elsif addrcnt(23) = x"83" then
								addrcnt(23) <= x"79";
							elsif addrcnt(23) = x"8e" then
								addrcnt(23) <= x"84";
							elsif addrcnt(23) = x"99" then
								addrcnt(23) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "100101" )or (p1_c6 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
						if(((p2_c1 = "100101" )or (p2_c1 = "110010"))	or ((p2_c2 = "100101" )or (p2_c2 = "110010"))) then
							if addrcnt(24) = x"0a" then
								addrcnt(24) <= (others => '0');
							elsif addrcnt(24) = x"15" then
								addrcnt(24) <= x"0b";
							elsif addrcnt(24) = x"20" then
								addrcnt(24) <= x"16";
							elsif addrcnt(24) = x"2b" then
								addrcnt(24) <= x"21";
							elsif addrcnt(24) = x"36" then
								addrcnt(24) <= x"2c";
							elsif addrcnt(24) = x"41" then
								addrcnt(24) <= x"37";
							elsif addrcnt(24) = x"4c" then
								addrcnt(24) <= x"42";
							elsif addrcnt(24) = x"57" then
								addrcnt(24) <= x"4d";
							elsif addrcnt(24) = x"62" then
								addrcnt(24) <= x"58";
							elsif addrcnt(24) = x"6d" then
								addrcnt(24) <= x"63";
							elsif addrcnt(24) = x"78" then
								addrcnt(24) <= x"6e";
							elsif addrcnt(24) = x"83" then
								addrcnt(24) <= x"79";
							elsif addrcnt(24) = x"8e" then
								addrcnt(24) <= x"84";
							elsif addrcnt(24) = x"99" then
								addrcnt(24) <= x"8f";
							end if;
						end if;
					elsif (p1_c6 = "100110" )or (p1_c6 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
						if(((p2_c1 = "100110" )or (p2_c1 = "110011"))	or ((p2_c2 = "100110" )or (p2_c2 = "110011"))) then
							if addrcnt(25) = x"0a" then
								addrcnt(25) <= (others => '0');
							elsif addrcnt(25) = x"15" then
								addrcnt(25) <= x"0b";
							elsif addrcnt(25) = x"20" then
								addrcnt(25) <= x"16";
							elsif addrcnt(25) = x"2b" then
								addrcnt(25) <= x"21";
							elsif addrcnt(25) = x"36" then
								addrcnt(25) <= x"2c";
							elsif addrcnt(25) = x"41" then
								addrcnt(25) <= x"37";
							elsif addrcnt(25) = x"4c" then
								addrcnt(25) <= x"42";
							elsif addrcnt(25) = x"57" then
								addrcnt(25) <= x"4d";
							elsif addrcnt(25) = x"62" then
								addrcnt(25) <= x"58";
							elsif addrcnt(25) = x"6d" then
								addrcnt(25) <= x"63";
							elsif addrcnt(25) = x"78" then
								addrcnt(25) <= x"6e";
							elsif addrcnt(25) = x"83" then
								addrcnt(25) <= x"79";
							elsif addrcnt(25) = x"8e" then
								addrcnt(25) <= x"84";
							elsif addrcnt(25) = x"99" then
								addrcnt(25) <= x"8f";
							end if;
						end if;
					elsif (p1_c3 = "111111") then
						if ((hsync_cnt >= (tHW + tHBP +155 ) ) and ( hsync_cnt <= (tHW + tHBP +161)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +166 ) ) and ( hsync_cnt <= (tHW + tHBP +205)) ) then
					if (p1_c3 /= "111111") then
						if ((hsync_cnt >= (tHW + tHBP +166 ) ) and ( hsync_cnt <= (tHW + tHBP +172)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
					if (p1_c4 /= "111111") then	
						if ((hsync_cnt >= (tHW + tHBP +173 ) ) and ( hsync_cnt <= (tHW + tHBP +183)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
					if (p1_c5 /= "111111") then	
						if ((hsync_cnt >= (tHW + tHBP +184 ) ) and ( hsync_cnt <= (tHW + tHBP +194)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
					if (p1_c6 /= "111111") then	
						if ((hsync_cnt >= (tHW + tHBP +195 ) ) and ( hsync_cnt <= (tHW + tHBP +205)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
				elsif( (hsync_cnt >= (tHW + tHBP +399 ) ) and ( hsync_cnt <= (tHW + tHBP +400)) ) then --가운데 세로줄
					rgb_data <= (others => '1');
				elsif ((hsync_cnt >= (tHW + tHBP +409 ) ) and ( hsync_cnt <= (tHW + tHBP +419)) ) then -- 2p 카드 숫자
					if (p2_c1 = "000000" )or (p2_c1 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
						if(((p2_c2 = "000000" )or (p2_c2 = "001101"))or ((p2_c3 = "000000" )or (p2_c3 = "001101"))
						or ((p2_c4 = "000000" )or (p2_c4 = "001101"))or ((p2_c5 = "000000" )or (p2_c5 = "001101"))or ((p2_c6 = "000000" )or (p2_c6 = "001101"))) then
							if addrcnt(0) = x"0a" then
								addrcnt(0) <= (others => '0');
							elsif addrcnt(0) = x"15" then
								addrcnt(0) <= x"0b";
							elsif addrcnt(0) = x"20" then
								addrcnt(0) <= x"16";
							elsif addrcnt(0) = x"2b" then
								addrcnt(0) <= x"21";
							elsif addrcnt(0) = x"36" then
								addrcnt(0) <= x"2c";
							elsif addrcnt(0) = x"41" then
								addrcnt(0) <= x"37";
							elsif addrcnt(0) = x"4c" then
								addrcnt(0) <= x"42";
							elsif addrcnt(0) = x"57" then
								addrcnt(0) <= x"4d";
							elsif addrcnt(0) = x"62" then
								addrcnt(0) <= x"58";
							elsif addrcnt(0) = x"6d" then
								addrcnt(0) <= x"63";
							elsif addrcnt(0) = x"78" then
								addrcnt(0) <= x"6e";
							elsif addrcnt(0) = x"83" then
								addrcnt(0) <= x"79";
							elsif addrcnt(0) = x"8e" then
								addrcnt(0) <= x"84";
							elsif addrcnt(0) = x"99" then
								addrcnt(0) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "000001" )or (p2_c1 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
						if(((p2_c2 = "000001" )or (p2_c2 = "001110"))or ((p2_c3 = "000001" )or (p2_c3 = "001110"))
						or ((p2_c4 = "000001" )or (p2_c4 = "001110"))or ((p2_c5 = "000001" )or (p2_c5 = "001110"))or ((p2_c6 = "000001" )or (p2_c6 = "001110"))) then
							if addrcnt(1) = x"0a" then
								addrcnt(1) <= (others => '0');
							elsif addrcnt(1) = x"15" then
								addrcnt(1) <= x"0b";
							elsif addrcnt(1) = x"20" then
								addrcnt(1) <= x"16";
							elsif addrcnt(1) = x"2b" then
								addrcnt(1) <= x"21";
							elsif addrcnt(1) = x"36" then
								addrcnt(1) <= x"2c";
							elsif addrcnt(1) = x"41" then
								addrcnt(1) <= x"37";
							elsif addrcnt(1) = x"4c" then
								addrcnt(1) <= x"42";
							elsif addrcnt(1) = x"57" then
								addrcnt(1) <= x"4d";
							elsif addrcnt(1) = x"62" then
								addrcnt(1) <= x"58";
							elsif addrcnt(1) = x"6d" then
								addrcnt(1) <= x"63";
							elsif addrcnt(1) = x"78" then
								addrcnt(1) <= x"6e";
							elsif addrcnt(1) = x"83" then
								addrcnt(1) <= x"79";
							elsif addrcnt(1) = x"8e" then
								addrcnt(1) <= x"84";
							elsif addrcnt(1) = x"99" then
								addrcnt(1) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "000010" )or (p2_c1 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
						if( ((p2_c2 = "000010" )or (p2_c2 = "001111"))or ((p2_c3 = "000010" )or (p2_c3 = "001111"))
						or ((p2_c4 = "000010" )or (p2_c4 = "001111"))or ((p2_c5 = "000010" )or (p2_c5 = "001111"))or ((p2_c6 = "000010" )or (p2_c6 = "001111"))) then
							if addrcnt(2) = x"0a" then
								addrcnt(2) <= (others => '0');
							elsif addrcnt(2) = x"15" then
								addrcnt(2) <= x"0b";
							elsif addrcnt(2) = x"20" then
								addrcnt(2) <= x"16";
							elsif addrcnt(2) = x"2b" then
								addrcnt(2) <= x"21";
							elsif addrcnt(2) = x"36" then
								addrcnt(2) <= x"2c";
							elsif addrcnt(2) = x"41" then
								addrcnt(2) <= x"37";
							elsif addrcnt(2) = x"4c" then
								addrcnt(2) <= x"42";
							elsif addrcnt(2) = x"57" then
								addrcnt(2) <= x"4d";
							elsif addrcnt(2) = x"62" then
								addrcnt(2) <= x"58";
							elsif addrcnt(2) = x"6d" then
								addrcnt(2) <= x"63";
							elsif addrcnt(2) = x"78" then
								addrcnt(2) <= x"6e";
							elsif addrcnt(2) = x"83" then
								addrcnt(2) <= x"79";
							elsif addrcnt(2) = x"8e" then
								addrcnt(2) <= x"84";
							elsif addrcnt(2) = x"99" then
								addrcnt(2) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "000011" )or (p2_c1 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
						if(((p2_c2 = "000011" )or (p2_c2 = "010000"))or ((p2_c3 = "000011" )or (p2_c3 = "010000"))
						or ((p2_c4 = "000011" )or (p2_c4 = "010000"))or ((p2_c5 = "000011" )or (p2_c5 = "010000"))or ((p2_c6 = "000011" )or (p2_c6 = "010000"))) then
							if addrcnt(3) = x"0a" then
								addrcnt(3) <= (others => '0');
							elsif addrcnt(3) = x"15" then
								addrcnt(3) <= x"0b";
							elsif addrcnt(3) = x"20" then
								addrcnt(3) <= x"16";
							elsif addrcnt(3) = x"2b" then
								addrcnt(3) <= x"21";
							elsif addrcnt(3) = x"36" then
								addrcnt(3) <= x"2c";
							elsif addrcnt(3) = x"41" then
								addrcnt(3) <= x"37";
							elsif addrcnt(3) = x"4c" then
								addrcnt(3) <= x"42";
							elsif addrcnt(3) = x"57" then
								addrcnt(3) <= x"4d";
							elsif addrcnt(3) = x"62" then
								addrcnt(3) <= x"58";
							elsif addrcnt(3) = x"6d" then
								addrcnt(3) <= x"63";
							elsif addrcnt(3) = x"78" then
								addrcnt(3) <= x"6e";
							elsif addrcnt(3) = x"83" then
								addrcnt(3) <= x"79";
							elsif addrcnt(3) = x"8e" then
								addrcnt(3) <= x"84";
							elsif addrcnt(3) = x"99" then
								addrcnt(3) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "000100" )or (p2_c1 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);
						if(((p2_c2 = "000100" )or (p2_c2 = "010001"))or ((p2_c3 = "000100" )or (p2_c3 = "010001"))
						or ((p2_c4 = "000100" )or (p2_c4 = "010001"))or ((p2_c5 = "000100" )or (p2_c5 = "010001"))or ((p2_c6 = "000100" )or (p2_c6 = "010001"))) then
							if addrcnt(4) = x"0a" then
								addrcnt(4) <= (others => '0');
							elsif addrcnt(4) = x"15" then
								addrcnt(4) <= x"0b";
							elsif addrcnt(4) = x"20" then
								addrcnt(4) <= x"16";
							elsif addrcnt(4) = x"2b" then
								addrcnt(4) <= x"21";
							elsif addrcnt(4) = x"36" then
								addrcnt(4) <= x"2c";
							elsif addrcnt(4) = x"41" then
								addrcnt(4) <= x"37";
							elsif addrcnt(4) = x"4c" then
								addrcnt(4) <= x"42";
							elsif addrcnt(4) = x"57" then
								addrcnt(4) <= x"4d";
							elsif addrcnt(4) = x"62" then
								addrcnt(4) <= x"58";
							elsif addrcnt(4) = x"6d" then
								addrcnt(4) <= x"63";
							elsif addrcnt(4) = x"78" then
								addrcnt(4) <= x"6e";
							elsif addrcnt(4) = x"83" then
								addrcnt(4) <= x"79";
							elsif addrcnt(4) = x"8e" then
								addrcnt(4) <= x"84";
							elsif addrcnt(4) = x"99" then
								addrcnt(4) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "000101" )or (p2_c1 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);
						if( ((p2_c2 = "000101" )or (p2_c2 = "010010"))or ((p2_c3 = "000101" )or (p2_c3 = "010010"))
						or ((p2_c4 = "000101" )or (p2_c4 = "010010"))or ((p2_c5 = "000101" )or (p2_c5 = "010010"))or ((p2_c6 = "000101" )or (p2_c6 = "010010"))) then
							if addrcnt(5) = x"0a" then
								addrcnt(5) <= (others => '0');
							elsif addrcnt(5) = x"15" then
								addrcnt(5) <= x"0b";
							elsif addrcnt(5) = x"20" then
								addrcnt(5) <= x"16";
							elsif addrcnt(5) = x"2b" then
								addrcnt(5) <= x"21";
							elsif addrcnt(5) = x"36" then
								addrcnt(5) <= x"2c";
							elsif addrcnt(5) = x"41" then
								addrcnt(5) <= x"37";
							elsif addrcnt(5) = x"4c" then
								addrcnt(5) <= x"42";
							elsif addrcnt(5) = x"57" then
								addrcnt(5) <= x"4d";
							elsif addrcnt(5) = x"62" then
								addrcnt(5) <= x"58";
							elsif addrcnt(5) = x"6d" then
								addrcnt(5) <= x"63";
							elsif addrcnt(5) = x"78" then
								addrcnt(5) <= x"6e";
							elsif addrcnt(5) = x"83" then
								addrcnt(5) <= x"79";
							elsif addrcnt(5) = x"8e" then
								addrcnt(5) <= x"84";
							elsif addrcnt(5) = x"99" then
								addrcnt(5) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "000110" )or (p2_c1 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);
						if( ((p2_c2 = "000110" )or (p2_c2 = "010011"))or ((p2_c3 = "000110" )or (p2_c3 = "010011"))
						or ((p2_c4 = "000110" )or (p2_c4 = "010011"))or ((p2_c5 = "000110" )or (p2_c5 = "010011"))or ((p2_c6 = "000110" )or (p2_c6 = "010011"))) then
							if addrcnt(6) = x"0a" then
								addrcnt(6) <= (others => '0');
							elsif addrcnt(6) = x"15" then
								addrcnt(6) <= x"0b";
							elsif addrcnt(6) = x"20" then
								addrcnt(6) <= x"16";
							elsif addrcnt(6) = x"2b" then
								addrcnt(6) <= x"21";
							elsif addrcnt(6) = x"36" then
								addrcnt(6) <= x"2c";
							elsif addrcnt(6) = x"41" then
								addrcnt(6) <= x"37";
							elsif addrcnt(6) = x"4c" then
								addrcnt(6) <= x"42";
							elsif addrcnt(6) = x"57" then
								addrcnt(6) <= x"4d";
							elsif addrcnt(6) = x"62" then
								addrcnt(6) <= x"58";
							elsif addrcnt(6) = x"6d" then
								addrcnt(6) <= x"63";
							elsif addrcnt(6) = x"78" then
								addrcnt(6) <= x"6e";
							elsif addrcnt(6) = x"83" then
								addrcnt(6) <= x"79";
							elsif addrcnt(6) = x"8e" then
								addrcnt(6) <= x"84";
							elsif addrcnt(6) = x"99" then
								addrcnt(6) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "000111" )or (p2_c1 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);
						if( ((p2_c2 = "000111" )or (p2_c2 = "010100"))or ((p2_c3 = "000111" )or (p2_c3 = "010100"))
						or ((p2_c4 = "000111" )or (p2_c4 = "010100"))or ((p2_c5 = "000111" )or (p2_c5 = "010100"))or ((p2_c6 = "000111" )or (p2_c6 = "010100"))) then
							if addrcnt(7) = x"0a" then
								addrcnt(7) <= (others => '0');
							elsif addrcnt(7) = x"15" then
								addrcnt(7) <= x"0b";
							elsif addrcnt(7) = x"20" then
								addrcnt(7) <= x"16";
							elsif addrcnt(7) = x"2b" then
								addrcnt(7) <= x"21";
							elsif addrcnt(7) = x"36" then
								addrcnt(7) <= x"2c";
							elsif addrcnt(7) = x"41" then
								addrcnt(7) <= x"37";
							elsif addrcnt(7) = x"4c" then
								addrcnt(7) <= x"42";
							elsif addrcnt(7) = x"57" then
								addrcnt(7) <= x"4d";
							elsif addrcnt(7) = x"62" then
								addrcnt(7) <= x"58";
							elsif addrcnt(7) = x"6d" then
								addrcnt(7) <= x"63";
							elsif addrcnt(7) = x"78" then
								addrcnt(7) <= x"6e";
							elsif addrcnt(7) = x"83" then
								addrcnt(7) <= x"79";
							elsif addrcnt(7) = x"8e" then
								addrcnt(7) <= x"84";
							elsif addrcnt(7) = x"99" then
								addrcnt(7) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "001000" )or (p2_c1 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
						if( ((p2_c2 = "001000" )or (p2_c2 = "010101"))or ((p2_c3 = "001000" )or (p2_c3 = "010101"))
						or ((p2_c4 = "001000" )or (p2_c4 = "010101"))or ((p2_c5 = "001000" )or (p2_c5 = "010101"))or ((p2_c6 = "001000" )or (p2_c6 = "010101"))) then
							if addrcnt(8) = x"0a" then
								addrcnt(8) <= (others => '0');
							elsif addrcnt(8) = x"15" then
								addrcnt(8) <= x"0b";
							elsif addrcnt(8) = x"20" then
								addrcnt(8) <= x"16";
							elsif addrcnt(8) = x"2b" then
								addrcnt(8) <= x"21";
							elsif addrcnt(8) = x"36" then
								addrcnt(8) <= x"2c";
							elsif addrcnt(8) = x"41" then
								addrcnt(8) <= x"37";
							elsif addrcnt(8) = x"4c" then
								addrcnt(8) <= x"42";
							elsif addrcnt(8) = x"57" then
								addrcnt(8) <= x"4d";
							elsif addrcnt(8) = x"62" then
								addrcnt(8) <= x"58";
							elsif addrcnt(8) = x"6d" then
								addrcnt(8) <= x"63";
							elsif addrcnt(8) = x"78" then
								addrcnt(8) <= x"6e";
							elsif addrcnt(8) = x"83" then
								addrcnt(8) <= x"79";
							elsif addrcnt(8) = x"8e" then
								addrcnt(8) <= x"84";
							elsif addrcnt(8) = x"99" then
								addrcnt(8) <= x"8f";
							end if;
						end if;
					elsif (p2_c1= "001001" )or (p2_c1 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);
						if(((p2_c2 = "001001" )or (p2_c2 = "010110"))or ((p2_c3 = "001001" )or (p2_c3 = "010110"))
						or ((p2_c4 = "001001" )or (p2_c4 = "010110"))or ((p2_c5 = "001001" )or (p2_c5 = "010110"))or ((p2_c6 = "001001" )or (p2_c6 = "010110"))) then
							if addrcnt(9) = x"0a" then
								addrcnt(9) <= (others => '0');
							elsif addrcnt(9) = x"15" then
								addrcnt(9) <= x"0b";
							elsif addrcnt(9) = x"20" then
								addrcnt(9) <= x"16";
							elsif addrcnt(9) = x"2b" then
								addrcnt(9) <= x"21";
							elsif addrcnt(9) = x"36" then
								addrcnt(9) <= x"2c";
							elsif addrcnt(9) = x"41" then
								addrcnt(9) <= x"37";
							elsif addrcnt(9) = x"4c" then
								addrcnt(9) <= x"42";
							elsif addrcnt(9) = x"57" then
								addrcnt(9) <= x"4d";
							elsif addrcnt(9) = x"62" then
								addrcnt(9) <= x"58";
							elsif addrcnt(9) = x"6d" then
								addrcnt(9) <= x"63";
							elsif addrcnt(9) = x"78" then
								addrcnt(9) <= x"6e";
							elsif addrcnt(9) = x"83" then
								addrcnt(9) <= x"79";
							elsif addrcnt(9) = x"8e" then
								addrcnt(9) <= x"84";
							elsif addrcnt(9) = x"99" then
								addrcnt(9) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "001010" )or (p2_c1 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);
						if(((p2_c2 = "001010" )or (p2_c2 = "010111"))or ((p2_c3 = "001010" )or (p2_c3 = "010111"))
						or ((p2_c4 = "001010" )or (p2_c4 = "010111"))or ((p2_c5 = "001010" )or (p2_c5 = "010111"))or ((p2_c6 = "001010" )or (p2_c6 = "010111"))) then
							if addrcnt(10) = x"0a" then
								addrcnt(10) <= (others => '0');
							elsif addrcnt(10) = x"15" then
								addrcnt(10) <= x"0b";
							elsif addrcnt(10) = x"20" then
								addrcnt(10) <= x"16";
							elsif addrcnt(10) = x"2b" then
								addrcnt(10) <= x"21";
							elsif addrcnt(10) = x"36" then
								addrcnt(10) <= x"2c";
							elsif addrcnt(10) = x"41" then
								addrcnt(10) <= x"37";
							elsif addrcnt(10) = x"4c" then
								addrcnt(10) <= x"42";
							elsif addrcnt(10) = x"57" then
								addrcnt(10) <= x"4d";
							elsif addrcnt(10) = x"62" then
								addrcnt(10) <= x"58";
							elsif addrcnt(10) = x"6d" then
								addrcnt(10) <= x"63";
							elsif addrcnt(10) = x"78" then
								addrcnt(10) <= x"6e";
							elsif addrcnt(10) = x"83" then
								addrcnt(10) <= x"79";
							elsif addrcnt(10) = x"8e" then
								addrcnt(10) <= x"84";
							elsif addrcnt(10) = x"99" then
								addrcnt(10) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "001011" )or (p2_c1 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);
						if(((p2_c2 = "001011" )or (p2_c2 = "011000"))or ((p2_c3 = "001011" )or (p2_c3 = "011000"))
						or ((p2_c4 = "001011" )or (p2_c4 = "011000"))or ((p2_c5 = "001011" )or (p2_c5 = "011000"))or ((p2_c6 = "001011" )or (p2_c6 = "011000"))) then
							if addrcnt(11) = x"0a" then
								addrcnt(11) <= (others => '0');
							elsif addrcnt(11) = x"15" then
								addrcnt(11) <= x"0b";
							elsif addrcnt(11) = x"20" then
								addrcnt(11) <= x"16";
							elsif addrcnt(11) = x"2b" then
								addrcnt(11) <= x"21";
							elsif addrcnt(11) = x"36" then
								addrcnt(11) <= x"2c";
							elsif addrcnt(11) = x"41" then
								addrcnt(11) <= x"37";
							elsif addrcnt(11) = x"4c" then
								addrcnt(11) <= x"42";
							elsif addrcnt(11) = x"57" then
								addrcnt(11) <= x"4d";
							elsif addrcnt(11) = x"62" then
								addrcnt(11) <= x"58";
							elsif addrcnt(11) = x"6d" then
								addrcnt(11) <= x"63";
							elsif addrcnt(11) = x"78" then
								addrcnt(11) <= x"6e";
							elsif addrcnt(11) = x"83" then
								addrcnt(11) <= x"79";
							elsif addrcnt(11) = x"8e" then
								addrcnt(11) <= x"84";
							elsif addrcnt(11) = x"99" then
								addrcnt(11) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "001100" )or (p2_c1 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
						if(((p2_c2 = "001100" )or (p2_c2 = "011001"))or ((p2_c3 = "001100" )or (p2_c3 = "011001"))
						or ((p2_c4 = "001100" )or (p2_c4 = "011001"))or ((p2_c5 = "001100" )or (p2_c5 = "011001"))or ((p2_c6 = "001100" )or (p2_c6 = "011001"))) then
							if addrcnt(12) = x"0a" then
								addrcnt(12) <= (others => '0');
							elsif addrcnt(12) = x"15" then
								addrcnt(12) <= x"0b";
							elsif addrcnt(12) = x"20" then
								addrcnt(12) <= x"16";
							elsif addrcnt(12) = x"2b" then
								addrcnt(12) <= x"21";
							elsif addrcnt(12) = x"36" then
								addrcnt(12) <= x"2c";
							elsif addrcnt(12) = x"41" then
								addrcnt(12) <= x"37";
							elsif addrcnt(12) = x"4c" then
								addrcnt(12) <= x"42";
							elsif addrcnt(12) = x"57" then
								addrcnt(12) <= x"4d";
							elsif addrcnt(12) = x"62" then
								addrcnt(12) <= x"58";
							elsif addrcnt(12) = x"6d" then
								addrcnt(12) <= x"63";
							elsif addrcnt(12) = x"78" then
								addrcnt(12) <= x"6e";
							elsif addrcnt(12) = x"83" then
								addrcnt(12) <= x"79";
							elsif addrcnt(12) = x"8e" then
								addrcnt(12) <= x"84";
							elsif addrcnt(12) = x"99" then
								addrcnt(12) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "011010" )or (p2_c1 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
						if( ((p2_c2 = "011010" )or (p2_c2 = "100111"))or ((p2_c3 = "011010" )or (p2_c3 = "100111"))
						or ((p2_c4 = "011010" )or (p2_c4 = "100111"))or ((p2_c5 = "011010" )or (p2_c5 = "100111"))or ((p2_c6 = "011010" )or (p2_c6 = "100111"))) then
							if addrcnt(13) = x"0a" then
								addrcnt(13) <= (others => '0');
							elsif addrcnt(13) = x"15" then
								addrcnt(13) <= x"0b";
							elsif addrcnt(13) = x"20" then
								addrcnt(13) <= x"16";
							elsif addrcnt(13) = x"2b" then
								addrcnt(13) <= x"21";
							elsif addrcnt(13) = x"36" then
								addrcnt(13) <= x"2c";
							elsif addrcnt(13) = x"41" then
								addrcnt(13) <= x"37";
							elsif addrcnt(13) = x"4c" then
								addrcnt(13) <= x"42";
							elsif addrcnt(13) = x"57" then
								addrcnt(13) <= x"4d";
							elsif addrcnt(13) = x"62" then
								addrcnt(13) <= x"58";
							elsif addrcnt(13) = x"6d" then
								addrcnt(13) <= x"63";
							elsif addrcnt(13) = x"78" then
								addrcnt(13) <= x"6e";
							elsif addrcnt(13) = x"83" then
								addrcnt(13) <= x"79";
							elsif addrcnt(13) = x"8e" then
								addrcnt(13) <= x"84";
							elsif addrcnt(13) = x"99" then
								addrcnt(13) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "011011" )or (p2_c1 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
						if( ((p2_c2 = "011011" )or (p2_c2 = "101000"))or ((p2_c3 = "011011" )or (p2_c3 = "101000"))
						or ((p2_c4 = "011011" )or (p2_c4 = "101000"))or ((p2_c5 = "011011" )or (p2_c5 = "101000"))or ((p2_c6 = "011011" )or (p2_c6 = "101000"))) then
							if addrcnt(14) = x"0a" then
								addrcnt(14) <= (others => '0');
							elsif addrcnt(14) = x"15" then
								addrcnt(14) <= x"0b";
							elsif addrcnt(14) = x"20" then
								addrcnt(14) <= x"16";
							elsif addrcnt(14) = x"2b" then
								addrcnt(14) <= x"21";
							elsif addrcnt(14) = x"36" then
								addrcnt(14) <= x"2c";
							elsif addrcnt(14) = x"41" then
								addrcnt(14) <= x"37";
							elsif addrcnt(14) = x"4c" then
								addrcnt(14) <= x"42";
							elsif addrcnt(14) = x"57" then
								addrcnt(14) <= x"4d";
							elsif addrcnt(14) = x"62" then
								addrcnt(14) <= x"58";
							elsif addrcnt(14) = x"6d" then
								addrcnt(14) <= x"63";
							elsif addrcnt(14) = x"78" then
								addrcnt(14) <= x"6e";
							elsif addrcnt(14) = x"83" then
								addrcnt(14) <= x"79";
							elsif addrcnt(14) = x"8e" then
								addrcnt(14) <= x"84";
							elsif addrcnt(14) = x"99" then
								addrcnt(14) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "011100" )or (p2_c1 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
						if( ((p2_c2 = "011100" )or (p2_c2 = "101001"))or ((p2_c3 = "011100" )or (p2_c3 = "101001"))
						or ((p2_c4 = "011100" )or (p2_c4 = "101001"))or ((p2_c5 = "011100" )or (p2_c5 = "101001"))or ((p2_c6 = "011100" )or (p2_c6 = "101001"))) then
							if addrcnt(15) = x"0a" then
								addrcnt(15) <= (others => '0');
							elsif addrcnt(15) = x"15" then
								addrcnt(15) <= x"0b";
							elsif addrcnt(15) = x"20" then
								addrcnt(15) <= x"16";
							elsif addrcnt(15) = x"2b" then
								addrcnt(15) <= x"21";
							elsif addrcnt(15) = x"36" then
								addrcnt(15) <= x"2c";
							elsif addrcnt(15) = x"41" then
								addrcnt(15) <= x"37";
							elsif addrcnt(15) = x"4c" then
								addrcnt(15) <= x"42";
							elsif addrcnt(15) = x"57" then
								addrcnt(15) <= x"4d";
							elsif addrcnt(15) = x"62" then
								addrcnt(15) <= x"58";
							elsif addrcnt(15) = x"6d" then
								addrcnt(15) <= x"63";
							elsif addrcnt(15) = x"78" then
								addrcnt(15) <= x"6e";
							elsif addrcnt(15) = x"83" then
								addrcnt(15) <= x"79";
							elsif addrcnt(15) = x"8e" then
								addrcnt(15) <= x"84";
							elsif addrcnt(15) = x"99" then
								addrcnt(15) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "011101" )or (p2_c1 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
						if( ((p2_c2 = "011101" )or (p2_c2 = "101010"))or ((p2_c3 = "011101" )or (p2_c3 = "101010"))
						or ((p2_c4 = "011101" )or (p2_c4 = "101010"))or ((p2_c5 = "011101" )or (p2_c5 = "101010"))or ((p2_c6 = "011101" )or (p2_c6 = "101010"))) then
							if addrcnt(16) = x"0a" then
								addrcnt(16) <= (others => '0');
							elsif addrcnt(16) = x"15" then
								addrcnt(16) <= x"0b";
							elsif addrcnt(16) = x"20" then
								addrcnt(16) <= x"16";
							elsif addrcnt(16) = x"2b" then
								addrcnt(16) <= x"21";
							elsif addrcnt(16) = x"36" then
								addrcnt(16) <= x"2c";
							elsif addrcnt(16) = x"41" then
								addrcnt(16) <= x"37";
							elsif addrcnt(16) = x"4c" then
								addrcnt(16) <= x"42";
							elsif addrcnt(16) = x"57" then
								addrcnt(16) <= x"4d";
							elsif addrcnt(16) = x"62" then
								addrcnt(16) <= x"58";
							elsif addrcnt(16) = x"6d" then
								addrcnt(16) <= x"63";
							elsif addrcnt(16) = x"78" then
								addrcnt(16) <= x"6e";
							elsif addrcnt(16) = x"83" then
								addrcnt(16) <= x"79";
							elsif addrcnt(16) = x"8e" then
								addrcnt(16) <= x"84";
							elsif addrcnt(16) = x"99" then
								addrcnt(16) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "011110" )or (p2_c1 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);
						if(((p2_c2 = "011110" )or (p2_c2 = "101011"))or ((p2_c3 = "011110" )or (p2_c3 = "101011"))
						or ((p2_c4 = "011110" )or (p2_c4 = "101011"))or ((p2_c5 = "011110" )or (p2_c5 = "101011"))or ((p2_c6 = "011110" )or (p2_c6 = "101011"))) then
							if addrcnt(17) = x"0a" then
								addrcnt(17) <= (others => '0');
							elsif addrcnt(17) = x"15" then
								addrcnt(17) <= x"0b";
							elsif addrcnt(17) = x"20" then
								addrcnt(17) <= x"16";
							elsif addrcnt(17) = x"2b" then
								addrcnt(17) <= x"21";
							elsif addrcnt(17) = x"36" then
								addrcnt(17) <= x"2c";
							elsif addrcnt(17) = x"41" then
								addrcnt(17) <= x"37";
							elsif addrcnt(17) = x"4c" then
								addrcnt(17) <= x"42";
							elsif addrcnt(17) = x"57" then
								addrcnt(17) <= x"4d";
							elsif addrcnt(17) = x"62" then
								addrcnt(17) <= x"58";
							elsif addrcnt(17) = x"6d" then
								addrcnt(17) <= x"63";
							elsif addrcnt(17) = x"78" then
								addrcnt(17) <= x"6e";
							elsif addrcnt(17) = x"83" then
								addrcnt(17) <= x"79";
							elsif addrcnt(17) = x"8e" then
								addrcnt(17) <= x"84";
							elsif addrcnt(17) = x"99" then
								addrcnt(17) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "011111" )or (p2_c1 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);
						if( ((p2_c2 = "011111" )or (p2_c2 = "101100"))or ((p2_c3 = "011111" )or (p2_c3 = "101100"))
						or ((p2_c4 = "011111" )or (p2_c4 = "101100"))or ((p2_c5 = "011111" )or (p2_c5 = "101100"))or ((p2_c6 = "011111" )or (p2_c6 = "101100"))) then
							if addrcnt(18) = x"0a" then
								addrcnt(18) <= (others => '0');
							elsif addrcnt(18) = x"15" then
								addrcnt(18) <= x"0b";
							elsif addrcnt(18) = x"20" then
								addrcnt(18) <= x"16";
							elsif addrcnt(18) = x"2b" then
								addrcnt(18) <= x"21";
							elsif addrcnt(18) = x"36" then
								addrcnt(18) <= x"2c";
							elsif addrcnt(18) = x"41" then
								addrcnt(18) <= x"37";
							elsif addrcnt(18) = x"4c" then
								addrcnt(18) <= x"42";
							elsif addrcnt(18) = x"57" then
								addrcnt(18) <= x"4d";
							elsif addrcnt(18) = x"62" then
								addrcnt(18) <= x"58";
							elsif addrcnt(18) = x"6d" then
								addrcnt(18) <= x"63";
							elsif addrcnt(18) = x"78" then
								addrcnt(18) <= x"6e";
							elsif addrcnt(18) = x"83" then
								addrcnt(18) <= x"79";
							elsif addrcnt(18) = x"8e" then
								addrcnt(18) <= x"84";
							elsif addrcnt(18) = x"99" then
								addrcnt(18) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "100000" )or (p2_c1 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
						if( ((p2_c2 = "100000" )or (p2_c2 = "101101"))or ((p2_c3 = "100000" )or (p2_c3 = "101101"))
						or ((p2_c4 = "100000" )or (p2_c4 = "101101"))or ((p2_c5 = "100000" )or (p2_c5 = "101101"))or ((p2_c6 = "100000" )or (p2_c6 = "101101"))) then
							if addrcnt(19) = x"0a" then
								addrcnt(19) <= (others => '0');
							elsif addrcnt(19) = x"15" then
								addrcnt(19) <= x"0b";
							elsif addrcnt(19) = x"20" then
								addrcnt(19) <= x"16";
							elsif addrcnt(19) = x"2b" then
								addrcnt(19) <= x"21";
							elsif addrcnt(19) = x"36" then
								addrcnt(19) <= x"2c";
							elsif addrcnt(19) = x"41" then
								addrcnt(19) <= x"37";
							elsif addrcnt(19) = x"4c" then
								addrcnt(19) <= x"42";
							elsif addrcnt(19) = x"57" then
								addrcnt(19) <= x"4d";
							elsif addrcnt(19) = x"62" then
								addrcnt(19) <= x"58";
							elsif addrcnt(19) = x"6d" then
								addrcnt(19) <= x"63";
							elsif addrcnt(19) = x"78" then
								addrcnt(19) <= x"6e";
							elsif addrcnt(19) = x"83" then
								addrcnt(19) <= x"79";
							elsif addrcnt(19) = x"8e" then
								addrcnt(19) <= x"84";
							elsif addrcnt(19) = x"99" then
								addrcnt(19) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "100001" )or (p2_c1 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
						if( ((p2_c2 = "100001" )or (p2_c2 = "101110"))or ((p2_c3 = "100001" )or (p2_c3 = "101110"))
						or ((p2_c4 = "100001" )or (p2_c4 = "101110"))or ((p2_c5 = "100001" )or (p2_c5 = "101110"))or ((p2_c6 = "100001" )or (p2_c6 = "101110"))) then
							if addrcnt(20) = x"0a" then
								addrcnt(20) <= (others => '0');
							elsif addrcnt(20) = x"15" then
								addrcnt(20) <= x"0b";
							elsif addrcnt(20) = x"20" then
								addrcnt(20) <= x"16";
							elsif addrcnt(20) = x"2b" then
								addrcnt(20) <= x"21";
							elsif addrcnt(20) = x"36" then
								addrcnt(20) <= x"2c";
							elsif addrcnt(20) = x"41" then
								addrcnt(20) <= x"37";
							elsif addrcnt(20) = x"4c" then
								addrcnt(20) <= x"42";
							elsif addrcnt(20) = x"57" then
								addrcnt(20) <= x"4d";
							elsif addrcnt(20) = x"62" then
								addrcnt(20) <= x"58";
							elsif addrcnt(20) = x"6d" then
								addrcnt(20) <= x"63";
							elsif addrcnt(20) = x"78" then
								addrcnt(20) <= x"6e";
							elsif addrcnt(20) = x"83" then
								addrcnt(20) <= x"79";
							elsif addrcnt(20) = x"8e" then
								addrcnt(20) <= x"84";
							elsif addrcnt(20) = x"99" then
								addrcnt(20) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "100010" )or (p2_c1 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
						if( ((p2_c2 = "100010" )or (p2_c2 = "101111"))or ((p2_c3 = "100010" )or (p2_c3 = "101111"))
						or ((p2_c4 = "100010" )or (p2_c4 = "101111"))or ((p2_c5 = "100010" )or (p2_c5 = "101111"))or ((p2_c6 = "100010" )or (p2_c6 = "101111"))) then
							if addrcnt(21) = x"0a" then
								addrcnt(21) <= (others => '0');
							elsif addrcnt(21) = x"15" then
								addrcnt(21) <= x"0b";
							elsif addrcnt(21) = x"20" then
								addrcnt(21) <= x"16";
							elsif addrcnt(21) = x"2b" then
								addrcnt(21) <= x"21";
							elsif addrcnt(21) = x"36" then
								addrcnt(21) <= x"2c";
							elsif addrcnt(21) = x"41" then
								addrcnt(21) <= x"37";
							elsif addrcnt(21) = x"4c" then
								addrcnt(21) <= x"42";
							elsif addrcnt(21) = x"57" then
								addrcnt(21) <= x"4d";
							elsif addrcnt(21) = x"62" then
								addrcnt(21) <= x"58";
							elsif addrcnt(21) = x"6d" then
								addrcnt(21) <= x"63";
							elsif addrcnt(21) = x"78" then
								addrcnt(21) <= x"6e";
							elsif addrcnt(21) = x"83" then
								addrcnt(21) <= x"79";
							elsif addrcnt(21) = x"8e" then
								addrcnt(21) <= x"84";
							elsif addrcnt(21) = x"99" then
								addrcnt(21) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "100011" )or (p2_c1 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);
						if(((p2_c2 = "100011" )or (p2_c2 = "110000"))or ((p2_c3 = "100011" )or (p2_c3 = "110000"))
						or ((p2_c4 = "100011" )or (p2_c4 = "110000"))or ((p2_c5 = "100011" )or (p2_c5 = "110000"))or ((p2_c6 = "100011" )or (p2_c6 = "110000"))) then
							if addrcnt(22) = x"0a" then
								addrcnt(22) <= (others => '0');
							elsif addrcnt(22) = x"15" then
								addrcnt(22) <= x"0b";
							elsif addrcnt(22) = x"20" then
								addrcnt(22) <= x"16";
							elsif addrcnt(22) = x"2b" then
								addrcnt(22) <= x"21";
							elsif addrcnt(22) = x"36" then
								addrcnt(22) <= x"2c";
							elsif addrcnt(22) = x"41" then
								addrcnt(22) <= x"37";
							elsif addrcnt(22) = x"4c" then
								addrcnt(22) <= x"42";
							elsif addrcnt(22) = x"57" then
								addrcnt(22) <= x"4d";
							elsif addrcnt(22) = x"62" then
								addrcnt(22) <= x"58";
							elsif addrcnt(22) = x"6d" then
								addrcnt(22) <= x"63";
							elsif addrcnt(22) = x"78" then
								addrcnt(22) <= x"6e";
							elsif addrcnt(22) = x"83" then
								addrcnt(22) <= x"79";
							elsif addrcnt(22) = x"8e" then
								addrcnt(22) <= x"84";
							elsif addrcnt(22) = x"99" then
								addrcnt(22) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "100100" )or (p2_c1 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
						if(((p2_c2 = "100100" )or (p2_c2 = "110001"))or ((p2_c3 = "100100" )or (p2_c3 = "110001"))
						or ((p2_c4 = "100100" )or (p2_c4 = "110001"))or ((p2_c5 = "100100" )or (p2_c5 = "110001"))or ((p2_c6 = "100100" )or (p2_c6 = "110001"))) then
							if addrcnt(23) = x"0a" then
								addrcnt(23) <= (others => '0');
							elsif addrcnt(23) = x"15" then
								addrcnt(23) <= x"0b";
							elsif addrcnt(23) = x"20" then
								addrcnt(23) <= x"16";
							elsif addrcnt(23) = x"2b" then
								addrcnt(23) <= x"21";
							elsif addrcnt(23) = x"36" then
								addrcnt(23) <= x"2c";
							elsif addrcnt(23) = x"41" then
								addrcnt(23) <= x"37";
							elsif addrcnt(23) = x"4c" then
								addrcnt(23) <= x"42";
							elsif addrcnt(23) = x"57" then
								addrcnt(23) <= x"4d";
							elsif addrcnt(23) = x"62" then
								addrcnt(23) <= x"58";
							elsif addrcnt(23) = x"6d" then
								addrcnt(23) <= x"63";
							elsif addrcnt(23) = x"78" then
								addrcnt(23) <= x"6e";
							elsif addrcnt(23) = x"83" then
								addrcnt(23) <= x"79";
							elsif addrcnt(23) = x"8e" then
								addrcnt(23) <= x"84";
							elsif addrcnt(23) = x"99" then
								addrcnt(23) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "100101" )or (p2_c1 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
						if( ((p2_c2 = "100101" )or (p2_c2 = "110010"))or ((p2_c3 = "100101" )or (p2_c3 = "110010"))
						or ((p2_c4 = "100101" )or (p2_c4 = "110010"))or ((p2_c5 = "100101" )or (p2_c5 = "110010"))or ((p2_c6 = "100101" )or (p2_c6 = "110010"))) then
							if addrcnt(24) = x"0a" then
								addrcnt(24) <= (others => '0');
							elsif addrcnt(24) = x"15" then
								addrcnt(24) <= x"0b";
							elsif addrcnt(24) = x"20" then
								addrcnt(24) <= x"16";
							elsif addrcnt(24) = x"2b" then
								addrcnt(24) <= x"21";
							elsif addrcnt(24) = x"36" then
								addrcnt(24) <= x"2c";
							elsif addrcnt(24) = x"41" then
								addrcnt(24) <= x"37";
							elsif addrcnt(24) = x"4c" then
								addrcnt(24) <= x"42";
							elsif addrcnt(24) = x"57" then
								addrcnt(24) <= x"4d";
							elsif addrcnt(24) = x"62" then
								addrcnt(24) <= x"58";
							elsif addrcnt(24) = x"6d" then
								addrcnt(24) <= x"63";
							elsif addrcnt(24) = x"78" then
								addrcnt(24) <= x"6e";
							elsif addrcnt(24) = x"83" then
								addrcnt(24) <= x"79";
							elsif addrcnt(24) = x"8e" then
								addrcnt(24) <= x"84";
							elsif addrcnt(24) = x"99" then
								addrcnt(24) <= x"8f";
							end if;
						end if;
					elsif (p2_c1 = "100110" )or (p2_c1 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
						if( ((p2_c2 = "100110" )or (p2_c2 = "110011"))or ((p2_c3 = "100110" )or (p2_c3 = "110011"))
						or ((p2_c4 = "100110" )or (p2_c4 = "110011"))or ((p2_c5 = "100110" )or (p2_c5 = "110011"))or ((p2_c6 = "100110" )or (p2_c6 = "110011"))) then
							if addrcnt(25) = x"0a" then
								addrcnt(25) <= (others => '0');
							elsif addrcnt(25) = x"15" then
								addrcnt(25) <= x"0b";
							elsif addrcnt(25) = x"20" then
								addrcnt(25) <= x"16";
							elsif addrcnt(25) = x"2b" then
								addrcnt(25) <= x"21";
							elsif addrcnt(25) = x"36" then
								addrcnt(25) <= x"2c";
							elsif addrcnt(25) = x"41" then
								addrcnt(25) <= x"37";
							elsif addrcnt(25) = x"4c" then
								addrcnt(25) <= x"42";
							elsif addrcnt(25) = x"57" then
								addrcnt(25) <= x"4d";
							elsif addrcnt(25) = x"62" then
								addrcnt(25) <= x"58";
							elsif addrcnt(25) = x"6d" then
								addrcnt(25) <= x"63";
							elsif addrcnt(25) = x"78" then
								addrcnt(25) <= x"6e";
							elsif addrcnt(25) = x"83" then
								addrcnt(25) <= x"79";
							elsif addrcnt(25) = x"8e" then
								addrcnt(25) <= x"84";
							elsif addrcnt(25) = x"99" then
								addrcnt(25) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +420 ) ) and ( hsync_cnt <= (tHW + tHBP +430)) ) then
					if (p2_c2 = "000000" )or (p2_c2 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
						if(((p2_c3 = "000000" )or (p2_c3 = "001101"))
						or ((p2_c4 = "000000" )or (p2_c4 = "001101"))or ((p2_c5 = "000000" )or (p2_c5 = "001101"))or ((p2_c6 = "000000" )or (p2_c6 = "001101"))) then
							if addrcnt(0) = x"0a" then
								addrcnt(0) <= (others => '0');
							elsif addrcnt(0) = x"15" then
								addrcnt(0) <= x"0b";
							elsif addrcnt(0) = x"20" then
								addrcnt(0) <= x"16";
							elsif addrcnt(0) = x"2b" then
								addrcnt(0) <= x"21";
							elsif addrcnt(0) = x"36" then
								addrcnt(0) <= x"2c";
							elsif addrcnt(0) = x"41" then
								addrcnt(0) <= x"37";
							elsif addrcnt(0) = x"4c" then
								addrcnt(0) <= x"42";
							elsif addrcnt(0) = x"57" then
								addrcnt(0) <= x"4d";
							elsif addrcnt(0) = x"62" then
								addrcnt(0) <= x"58";
							elsif addrcnt(0) = x"6d" then
								addrcnt(0) <= x"63";
							elsif addrcnt(0) = x"78" then
								addrcnt(0) <= x"6e";
							elsif addrcnt(0) = x"83" then
								addrcnt(0) <= x"79";
							elsif addrcnt(0) = x"8e" then
								addrcnt(0) <= x"84";
							elsif addrcnt(0) = x"99" then
								addrcnt(0) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "000001" )or (p2_c2 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
						if(((p2_c3 = "000001" )or (p2_c3 = "001110"))
						or ((p2_c4 = "000001" )or (p2_c4 = "001110"))or ((p2_c5 = "000001" )or (p2_c5 = "001110"))or ((p2_c6 = "000001" )or (p2_c6 = "001110"))) then
							if addrcnt(1) = x"0a" then
								addrcnt(1) <= (others => '0');
							elsif addrcnt(1) = x"15" then
								addrcnt(1) <= x"0b";
							elsif addrcnt(1) = x"20" then
								addrcnt(1) <= x"16";
							elsif addrcnt(1) = x"2b" then
								addrcnt(1) <= x"21";
							elsif addrcnt(1) = x"36" then
								addrcnt(1) <= x"2c";
							elsif addrcnt(1) = x"41" then
								addrcnt(1) <= x"37";
							elsif addrcnt(1) = x"4c" then
								addrcnt(1) <= x"42";
							elsif addrcnt(1) = x"57" then
								addrcnt(1) <= x"4d";
							elsif addrcnt(1) = x"62" then
								addrcnt(1) <= x"58";
							elsif addrcnt(1) = x"6d" then
								addrcnt(1) <= x"63";
							elsif addrcnt(1) = x"78" then
								addrcnt(1) <= x"6e";
							elsif addrcnt(1) = x"83" then
								addrcnt(1) <= x"79";
							elsif addrcnt(1) = x"8e" then
								addrcnt(1) <= x"84";
							elsif addrcnt(1) = x"99" then
								addrcnt(1) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "000010" )or (p2_c2 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
						if( ((p2_c3 = "000010" )or (p2_c3 = "001111"))
						or ((p2_c4 = "000010" )or (p2_c4 = "001111"))or ((p2_c5 = "000010" )or (p2_c5 = "001111"))or ((p2_c6 = "000010" )or (p2_c6 = "001111"))) then
							if addrcnt(2) = x"0a" then
								addrcnt(2) <= (others => '0');
							elsif addrcnt(2) = x"15" then
								addrcnt(2) <= x"0b";
							elsif addrcnt(2) = x"20" then
								addrcnt(2) <= x"16";
							elsif addrcnt(2) = x"2b" then
								addrcnt(2) <= x"21";
							elsif addrcnt(2) = x"36" then
								addrcnt(2) <= x"2c";
							elsif addrcnt(2) = x"41" then
								addrcnt(2) <= x"37";
							elsif addrcnt(2) = x"4c" then
								addrcnt(2) <= x"42";
							elsif addrcnt(2) = x"57" then
								addrcnt(2) <= x"4d";
							elsif addrcnt(2) = x"62" then
								addrcnt(2) <= x"58";
							elsif addrcnt(2) = x"6d" then
								addrcnt(2) <= x"63";
							elsif addrcnt(2) = x"78" then
								addrcnt(2) <= x"6e";
							elsif addrcnt(2) = x"83" then
								addrcnt(2) <= x"79";
							elsif addrcnt(2) = x"8e" then
								addrcnt(2) <= x"84";
							elsif addrcnt(2) = x"99" then
								addrcnt(2) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "000011" )or (p2_c2 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
						if( ((p2_c3 = "000011" )or (p2_c3 = "010000"))
						or ((p2_c4 = "000011" )or (p2_c4 = "010000"))or ((p2_c5 = "000011" )or (p2_c5 = "010000"))or ((p2_c6 = "000011" )or (p2_c6 = "010000"))) then
							if addrcnt(3) = x"0a" then
								addrcnt(3) <= (others => '0');
							elsif addrcnt(3) = x"15" then
								addrcnt(3) <= x"0b";
							elsif addrcnt(3) = x"20" then
								addrcnt(3) <= x"16";
							elsif addrcnt(3) = x"2b" then
								addrcnt(3) <= x"21";
							elsif addrcnt(3) = x"36" then
								addrcnt(3) <= x"2c";
							elsif addrcnt(3) = x"41" then
								addrcnt(3) <= x"37";
							elsif addrcnt(3) = x"4c" then
								addrcnt(3) <= x"42";
							elsif addrcnt(3) = x"57" then
								addrcnt(3) <= x"4d";
							elsif addrcnt(3) = x"62" then
								addrcnt(3) <= x"58";
							elsif addrcnt(3) = x"6d" then
								addrcnt(3) <= x"63";
							elsif addrcnt(3) = x"78" then
								addrcnt(3) <= x"6e";
							elsif addrcnt(3) = x"83" then
								addrcnt(3) <= x"79";
							elsif addrcnt(3) = x"8e" then
								addrcnt(3) <= x"84";
							elsif addrcnt(3) = x"99" then
								addrcnt(3) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "000100" )or (p2_c2 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);
						if(((p2_c3 = "000100" )or (p2_c3 = "010001"))
						or ((p2_c4 = "000100" )or (p2_c4 = "010001"))or ((p2_c5 = "000100" )or (p2_c5 = "010001"))or ((p2_c6 = "000100" )or (p2_c6 = "010001"))) then
							if addrcnt(4) = x"0a" then
								addrcnt(4) <= (others => '0');
							elsif addrcnt(4) = x"15" then
								addrcnt(4) <= x"0b";
							elsif addrcnt(4) = x"20" then
								addrcnt(4) <= x"16";
							elsif addrcnt(4) = x"2b" then
								addrcnt(4) <= x"21";
							elsif addrcnt(4) = x"36" then
								addrcnt(4) <= x"2c";
							elsif addrcnt(4) = x"41" then
								addrcnt(4) <= x"37";
							elsif addrcnt(4) = x"4c" then
								addrcnt(4) <= x"42";
							elsif addrcnt(4) = x"57" then
								addrcnt(4) <= x"4d";
							elsif addrcnt(4) = x"62" then
								addrcnt(4) <= x"58";
							elsif addrcnt(4) = x"6d" then
								addrcnt(4) <= x"63";
							elsif addrcnt(4) = x"78" then
								addrcnt(4) <= x"6e";
							elsif addrcnt(4) = x"83" then
								addrcnt(4) <= x"79";
							elsif addrcnt(4) = x"8e" then
								addrcnt(4) <= x"84";
							elsif addrcnt(4) = x"99" then
								addrcnt(4) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "000101" )or (p2_c2 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);
						if( ((p2_c3 = "000101" )or (p2_c3 = "010010"))
						or ((p2_c4 = "000101" )or (p2_c4 = "010010"))or ((p2_c5 = "000101" )or (p2_c5 = "010010"))or ((p2_c6 = "000101" )or (p2_c6 = "010010"))) then
							if addrcnt(5) = x"0a" then
								addrcnt(5) <= (others => '0');
							elsif addrcnt(5) = x"15" then
								addrcnt(5) <= x"0b";
							elsif addrcnt(5) = x"20" then
								addrcnt(5) <= x"16";
							elsif addrcnt(5) = x"2b" then
								addrcnt(5) <= x"21";
							elsif addrcnt(5) = x"36" then
								addrcnt(5) <= x"2c";
							elsif addrcnt(5) = x"41" then
								addrcnt(5) <= x"37";
							elsif addrcnt(5) = x"4c" then
								addrcnt(5) <= x"42";
							elsif addrcnt(5) = x"57" then
								addrcnt(5) <= x"4d";
							elsif addrcnt(5) = x"62" then
								addrcnt(5) <= x"58";
							elsif addrcnt(5) = x"6d" then
								addrcnt(5) <= x"63";
							elsif addrcnt(5) = x"78" then
								addrcnt(5) <= x"6e";
							elsif addrcnt(5) = x"83" then
								addrcnt(5) <= x"79";
							elsif addrcnt(5) = x"8e" then
								addrcnt(5) <= x"84";
							elsif addrcnt(5) = x"99" then
								addrcnt(5) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "000110" )or (p2_c2 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);
						if( ((p2_c3 = "000110" )or (p2_c3 = "010011"))
						or ((p2_c4 = "000110" )or (p2_c4 = "010011"))or ((p2_c5 = "000110" )or (p2_c5 = "010011"))or ((p2_c6 = "000110" )or (p2_c6 = "010011"))) then
							if addrcnt(6) = x"0a" then
								addrcnt(6) <= (others => '0');
							elsif addrcnt(6) = x"15" then
								addrcnt(6) <= x"0b";
							elsif addrcnt(6) = x"20" then
								addrcnt(6) <= x"16";
							elsif addrcnt(6) = x"2b" then
								addrcnt(6) <= x"21";
							elsif addrcnt(6) = x"36" then
								addrcnt(6) <= x"2c";
							elsif addrcnt(6) = x"41" then
								addrcnt(6) <= x"37";
							elsif addrcnt(6) = x"4c" then
								addrcnt(6) <= x"42";
							elsif addrcnt(6) = x"57" then
								addrcnt(6) <= x"4d";
							elsif addrcnt(6) = x"62" then
								addrcnt(6) <= x"58";
							elsif addrcnt(6) = x"6d" then
								addrcnt(6) <= x"63";
							elsif addrcnt(6) = x"78" then
								addrcnt(6) <= x"6e";
							elsif addrcnt(6) = x"83" then
								addrcnt(6) <= x"79";
							elsif addrcnt(6) = x"8e" then
								addrcnt(6) <= x"84";
							elsif addrcnt(6) = x"99" then
								addrcnt(6) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "000111" )or (p2_c2 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);
						if( ((p2_c3 = "000111" )or (p2_c3 = "010100"))
						or ((p2_c4 = "000111" )or (p2_c4 = "010100"))or ((p2_c5 = "000111" )or (p2_c5 = "010100"))or ((p2_c6 = "000111" )or (p2_c6 = "010100"))) then
							if addrcnt(7) = x"0a" then
								addrcnt(7) <= (others => '0');
							elsif addrcnt(7) = x"15" then
								addrcnt(7) <= x"0b";
							elsif addrcnt(7) = x"20" then
								addrcnt(7) <= x"16";
							elsif addrcnt(7) = x"2b" then
								addrcnt(7) <= x"21";
							elsif addrcnt(7) = x"36" then
								addrcnt(7) <= x"2c";
							elsif addrcnt(7) = x"41" then
								addrcnt(7) <= x"37";
							elsif addrcnt(7) = x"4c" then
								addrcnt(7) <= x"42";
							elsif addrcnt(7) = x"57" then
								addrcnt(7) <= x"4d";
							elsif addrcnt(7) = x"62" then
								addrcnt(7) <= x"58";
							elsif addrcnt(7) = x"6d" then
								addrcnt(7) <= x"63";
							elsif addrcnt(7) = x"78" then
								addrcnt(7) <= x"6e";
							elsif addrcnt(7) = x"83" then
								addrcnt(7) <= x"79";
							elsif addrcnt(7) = x"8e" then
								addrcnt(7) <= x"84";
							elsif addrcnt(7) = x"99" then
								addrcnt(7) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "001000" )or (p2_c2 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
						if(  ((p2_c3 = "001000" )or (p2_c3 = "010101"))
						or ((p2_c4 = "001000" )or (p2_c4 = "010101"))or ((p2_c5 = "001000" )or (p2_c5 = "010101"))or ((p2_c6 = "001000" )or (p2_c6 = "010101"))) then
							if addrcnt(8) = x"0a" then
								addrcnt(8) <= (others => '0');
							elsif addrcnt(8) = x"15" then
								addrcnt(8) <= x"0b";
							elsif addrcnt(8) = x"20" then
								addrcnt(8) <= x"16";
							elsif addrcnt(8) = x"2b" then
								addrcnt(8) <= x"21";
							elsif addrcnt(8) = x"36" then
								addrcnt(8) <= x"2c";
							elsif addrcnt(8) = x"41" then
								addrcnt(8) <= x"37";
							elsif addrcnt(8) = x"4c" then
								addrcnt(8) <= x"42";
							elsif addrcnt(8) = x"57" then
								addrcnt(8) <= x"4d";
							elsif addrcnt(8) = x"62" then
								addrcnt(8) <= x"58";
							elsif addrcnt(8) = x"6d" then
								addrcnt(8) <= x"63";
							elsif addrcnt(8) = x"78" then
								addrcnt(8) <= x"6e";
							elsif addrcnt(8) = x"83" then
								addrcnt(8) <= x"79";
							elsif addrcnt(8) = x"8e" then
								addrcnt(8) <= x"84";
							elsif addrcnt(8) = x"99" then
								addrcnt(8) <= x"8f";
							end if;
						end if;
					elsif (p2_c2= "001001" )or (p2_c2 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);
						if(((p2_c3 = "001001" )or (p2_c3 = "010110"))
						or ((p2_c4 = "001001" )or (p2_c4 = "010110"))or ((p2_c5 = "001001" )or (p2_c5 = "010110"))or ((p2_c6 = "001001" )or (p2_c6 = "010110"))) then
							if addrcnt(9) = x"0a" then
								addrcnt(9) <= (others => '0');
							elsif addrcnt(9) = x"15" then
								addrcnt(9) <= x"0b";
							elsif addrcnt(9) = x"20" then
								addrcnt(9) <= x"16";
							elsif addrcnt(9) = x"2b" then
								addrcnt(9) <= x"21";
							elsif addrcnt(9) = x"36" then
								addrcnt(9) <= x"2c";
							elsif addrcnt(9) = x"41" then
								addrcnt(9) <= x"37";
							elsif addrcnt(9) = x"4c" then
								addrcnt(9) <= x"42";
							elsif addrcnt(9) = x"57" then
								addrcnt(9) <= x"4d";
							elsif addrcnt(9) = x"62" then
								addrcnt(9) <= x"58";
							elsif addrcnt(9) = x"6d" then
								addrcnt(9) <= x"63";
							elsif addrcnt(9) = x"78" then
								addrcnt(9) <= x"6e";
							elsif addrcnt(9) = x"83" then
								addrcnt(9) <= x"79";
							elsif addrcnt(9) = x"8e" then
								addrcnt(9) <= x"84";
							elsif addrcnt(9) = x"99" then
								addrcnt(9) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "001010" )or (p2_c2 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);
						if( ((p2_c3 = "001010" )or (p2_c3 = "010111"))
						or ((p2_c4 = "001010" )or (p2_c4 = "010111"))or ((p2_c5 = "001010" )or (p2_c5 = "010111"))or ((p2_c6 = "001010" )or (p2_c6 = "010111"))) then
							if addrcnt(10) = x"0a" then
								addrcnt(10) <= (others => '0');
							elsif addrcnt(10) = x"15" then
								addrcnt(10) <= x"0b";
							elsif addrcnt(10) = x"20" then
								addrcnt(10) <= x"16";
							elsif addrcnt(10) = x"2b" then
								addrcnt(10) <= x"21";
							elsif addrcnt(10) = x"36" then
								addrcnt(10) <= x"2c";
							elsif addrcnt(10) = x"41" then
								addrcnt(10) <= x"37";
							elsif addrcnt(10) = x"4c" then
								addrcnt(10) <= x"42";
							elsif addrcnt(10) = x"57" then
								addrcnt(10) <= x"4d";
							elsif addrcnt(10) = x"62" then
								addrcnt(10) <= x"58";
							elsif addrcnt(10) = x"6d" then
								addrcnt(10) <= x"63";
							elsif addrcnt(10) = x"78" then
								addrcnt(10) <= x"6e";
							elsif addrcnt(10) = x"83" then
								addrcnt(10) <= x"79";
							elsif addrcnt(10) = x"8e" then
								addrcnt(10) <= x"84";
							elsif addrcnt(10) = x"99" then
								addrcnt(10) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "001011" )or (p2_c2 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);
						if(((p2_c3 = "001011" )or (p2_c3 = "011000"))
						or ((p2_c4 = "001011" )or (p2_c4 = "011000"))or ((p2_c5 = "001011" )or (p2_c5 = "011000"))or ((p2_c6 = "001011" )or (p2_c6 = "011000"))) then
							if addrcnt(11) = x"0a" then
								addrcnt(11) <= (others => '0');
							elsif addrcnt(11) = x"15" then
								addrcnt(11) <= x"0b";
							elsif addrcnt(11) = x"20" then
								addrcnt(11) <= x"16";
							elsif addrcnt(11) = x"2b" then
								addrcnt(11) <= x"21";
							elsif addrcnt(11) = x"36" then
								addrcnt(11) <= x"2c";
							elsif addrcnt(11) = x"41" then
								addrcnt(11) <= x"37";
							elsif addrcnt(11) = x"4c" then
								addrcnt(11) <= x"42";
							elsif addrcnt(11) = x"57" then
								addrcnt(11) <= x"4d";
							elsif addrcnt(11) = x"62" then
								addrcnt(11) <= x"58";
							elsif addrcnt(11) = x"6d" then
								addrcnt(11) <= x"63";
							elsif addrcnt(11) = x"78" then
								addrcnt(11) <= x"6e";
							elsif addrcnt(11) = x"83" then
								addrcnt(11) <= x"79";
							elsif addrcnt(11) = x"8e" then
								addrcnt(11) <= x"84";
							elsif addrcnt(11) = x"99" then
								addrcnt(11) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "001100" )or (p2_c2 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
						if( ((p2_c3 = "001100" )or (p2_c3 = "011001"))
						or ((p2_c4 = "001100" )or (p2_c4 = "011001"))or ((p2_c5 = "001100" )or (p2_c5 = "011001"))or ((p2_c6 = "001100" )or (p2_c6 = "011001"))) then
							if addrcnt(12) = x"0a" then
								addrcnt(12) <= (others => '0');
							elsif addrcnt(12) = x"15" then
								addrcnt(12) <= x"0b";
							elsif addrcnt(12) = x"20" then
								addrcnt(12) <= x"16";
							elsif addrcnt(12) = x"2b" then
								addrcnt(12) <= x"21";
							elsif addrcnt(12) = x"36" then
								addrcnt(12) <= x"2c";
							elsif addrcnt(12) = x"41" then
								addrcnt(12) <= x"37";
							elsif addrcnt(12) = x"4c" then
								addrcnt(12) <= x"42";
							elsif addrcnt(12) = x"57" then
								addrcnt(12) <= x"4d";
							elsif addrcnt(12) = x"62" then
								addrcnt(12) <= x"58";
							elsif addrcnt(12) = x"6d" then
								addrcnt(12) <= x"63";
							elsif addrcnt(12) = x"78" then
								addrcnt(12) <= x"6e";
							elsif addrcnt(12) = x"83" then
								addrcnt(12) <= x"79";
							elsif addrcnt(12) = x"8e" then
								addrcnt(12) <= x"84";
							elsif addrcnt(12) = x"99" then
								addrcnt(12) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "011010" )or (p2_c2 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
						if ( ((p2_c3 = "011010" )or (p2_c3 = "100111"))
						or ((p2_c4 = "011010" )or (p2_c4 = "100111"))or ((p2_c5 = "011010" )or (p2_c5 = "100111"))or ((p2_c6 = "011010" )or (p2_c6 = "100111"))) then
							if addrcnt(13) = x"0a" then
								addrcnt(13) <= (others => '0');
							elsif addrcnt(13) = x"15" then
								addrcnt(13) <= x"0b";
							elsif addrcnt(13) = x"20" then
								addrcnt(13) <= x"16";
							elsif addrcnt(13) = x"2b" then
								addrcnt(13) <= x"21";
							elsif addrcnt(13) = x"36" then
								addrcnt(13) <= x"2c";
							elsif addrcnt(13) = x"41" then
								addrcnt(13) <= x"37";
							elsif addrcnt(13) = x"4c" then
								addrcnt(13) <= x"42";
							elsif addrcnt(13) = x"57" then
								addrcnt(13) <= x"4d";
							elsif addrcnt(13) = x"62" then
								addrcnt(13) <= x"58";
							elsif addrcnt(13) = x"6d" then
								addrcnt(13) <= x"63";
							elsif addrcnt(13) = x"78" then
								addrcnt(13) <= x"6e";
							elsif addrcnt(13) = x"83" then
								addrcnt(13) <= x"79";
							elsif addrcnt(13) = x"8e" then
								addrcnt(13) <= x"84";
							elsif addrcnt(13) = x"99" then
								addrcnt(13) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "011011" )or (p2_c2 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
						if( ((p2_c3 = "011011" )or (p2_c3 = "101000"))
						or ((p2_c4 = "011011" )or (p2_c4 = "101000"))or ((p2_c5 = "011011" )or (p2_c5 = "101000"))or ((p2_c6 = "011011" )or (p2_c6 = "101000"))) then
							if addrcnt(14) = x"0a" then
								addrcnt(14) <= (others => '0');
							elsif addrcnt(14) = x"15" then
								addrcnt(14) <= x"0b";
							elsif addrcnt(14) = x"20" then
								addrcnt(14) <= x"16";
							elsif addrcnt(14) = x"2b" then
								addrcnt(14) <= x"21";
							elsif addrcnt(14) = x"36" then
								addrcnt(14) <= x"2c";
							elsif addrcnt(14) = x"41" then
								addrcnt(14) <= x"37";
							elsif addrcnt(14) = x"4c" then
								addrcnt(14) <= x"42";
							elsif addrcnt(14) = x"57" then
								addrcnt(14) <= x"4d";
							elsif addrcnt(14) = x"62" then
								addrcnt(14) <= x"58";
							elsif addrcnt(14) = x"6d" then
								addrcnt(14) <= x"63";
							elsif addrcnt(14) = x"78" then
								addrcnt(14) <= x"6e";
							elsif addrcnt(14) = x"83" then
								addrcnt(14) <= x"79";
							elsif addrcnt(14) = x"8e" then
								addrcnt(14) <= x"84";
							elsif addrcnt(14) = x"99" then
								addrcnt(14) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "011100" )or (p2_c2 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
						if(  ((p2_c3 = "011100" )or (p2_c3 = "101001"))
						or ((p2_c4 = "011100" )or (p2_c4 = "101001"))or ((p2_c5 = "011100" )or (p2_c5 = "101001"))or ((p2_c6 = "011100" )or (p2_c6 = "101001"))) then
							if addrcnt(15) = x"0a" then
								addrcnt(15) <= (others => '0');
							elsif addrcnt(15) = x"15" then
								addrcnt(15) <= x"0b";
							elsif addrcnt(15) = x"20" then
								addrcnt(15) <= x"16";
							elsif addrcnt(15) = x"2b" then
								addrcnt(15) <= x"21";
							elsif addrcnt(15) = x"36" then
								addrcnt(15) <= x"2c";
							elsif addrcnt(15) = x"41" then
								addrcnt(15) <= x"37";
							elsif addrcnt(15) = x"4c" then
								addrcnt(15) <= x"42";
							elsif addrcnt(15) = x"57" then
								addrcnt(15) <= x"4d";
							elsif addrcnt(15) = x"62" then
								addrcnt(15) <= x"58";
							elsif addrcnt(15) = x"6d" then
								addrcnt(15) <= x"63";
							elsif addrcnt(15) = x"78" then
								addrcnt(15) <= x"6e";
							elsif addrcnt(15) = x"83" then
								addrcnt(15) <= x"79";
							elsif addrcnt(15) = x"8e" then
								addrcnt(15) <= x"84";
							elsif addrcnt(15) = x"99" then
								addrcnt(15) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "011101" )or (p2_c2 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
						if( ((p2_c3 = "011101" )or (p2_c3 = "101010"))
						or ((p2_c4 = "011101" )or (p2_c4 = "101010"))or ((p2_c5 = "011101" )or (p2_c5 = "101010"))or ((p2_c6 = "011101" )or (p2_c6 = "101010"))) then
							if addrcnt(16) = x"0a" then
								addrcnt(16) <= (others => '0');
							elsif addrcnt(16) = x"15" then
								addrcnt(16) <= x"0b";
							elsif addrcnt(16) = x"20" then
								addrcnt(16) <= x"16";
							elsif addrcnt(16) = x"2b" then
								addrcnt(16) <= x"21";
							elsif addrcnt(16) = x"36" then
								addrcnt(16) <= x"2c";
							elsif addrcnt(16) = x"41" then
								addrcnt(16) <= x"37";
							elsif addrcnt(16) = x"4c" then
								addrcnt(16) <= x"42";
							elsif addrcnt(16) = x"57" then
								addrcnt(16) <= x"4d";
							elsif addrcnt(16) = x"62" then
								addrcnt(16) <= x"58";
							elsif addrcnt(16) = x"6d" then
								addrcnt(16) <= x"63";
							elsif addrcnt(16) = x"78" then
								addrcnt(16) <= x"6e";
							elsif addrcnt(16) = x"83" then
								addrcnt(16) <= x"79";
							elsif addrcnt(16) = x"8e" then
								addrcnt(16) <= x"84";
							elsif addrcnt(16) = x"99" then
								addrcnt(16) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "011110" )or (p2_c2 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);
						if( ((p2_c3 = "011110" )or (p2_c3 = "101011"))
						or ((p2_c4 = "011110" )or (p2_c4 = "101011"))or ((p2_c5 = "011110" )or (p2_c5 = "101011"))or ((p2_c6 = "011110" )or (p2_c6 = "101011"))) then
							if addrcnt(17) = x"0a" then
								addrcnt(17) <= (others => '0');
							elsif addrcnt(17) = x"15" then
								addrcnt(17) <= x"0b";
							elsif addrcnt(17) = x"20" then
								addrcnt(17) <= x"16";
							elsif addrcnt(17) = x"2b" then
								addrcnt(17) <= x"21";
							elsif addrcnt(17) = x"36" then
								addrcnt(17) <= x"2c";
							elsif addrcnt(17) = x"41" then
								addrcnt(17) <= x"37";
							elsif addrcnt(17) = x"4c" then
								addrcnt(17) <= x"42";
							elsif addrcnt(17) = x"57" then
								addrcnt(17) <= x"4d";
							elsif addrcnt(17) = x"62" then
								addrcnt(17) <= x"58";
							elsif addrcnt(17) = x"6d" then
								addrcnt(17) <= x"63";
							elsif addrcnt(17) = x"78" then
								addrcnt(17) <= x"6e";
							elsif addrcnt(17) = x"83" then
								addrcnt(17) <= x"79";
							elsif addrcnt(17) = x"8e" then
								addrcnt(17) <= x"84";
							elsif addrcnt(17) = x"99" then
								addrcnt(17) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "011111" )or (p2_c2 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);
						if( ((p2_c3 = "011111" )or (p2_c3 = "101100"))
						or ((p2_c4 = "011111" )or (p2_c4 = "101100"))or ((p2_c5 = "011111" )or (p2_c5 = "101100"))or ((p2_c6 = "011111" )or (p2_c6 = "101100"))) then
							if addrcnt(18) = x"0a" then
								addrcnt(18) <= (others => '0');
							elsif addrcnt(18) = x"15" then
								addrcnt(18) <= x"0b";
							elsif addrcnt(18) = x"20" then
								addrcnt(18) <= x"16";
							elsif addrcnt(18) = x"2b" then
								addrcnt(18) <= x"21";
							elsif addrcnt(18) = x"36" then
								addrcnt(18) <= x"2c";
							elsif addrcnt(18) = x"41" then
								addrcnt(18) <= x"37";
							elsif addrcnt(18) = x"4c" then
								addrcnt(18) <= x"42";
							elsif addrcnt(18) = x"57" then
								addrcnt(18) <= x"4d";
							elsif addrcnt(18) = x"62" then
								addrcnt(18) <= x"58";
							elsif addrcnt(18) = x"6d" then
								addrcnt(18) <= x"63";
							elsif addrcnt(18) = x"78" then
								addrcnt(18) <= x"6e";
							elsif addrcnt(18) = x"83" then
								addrcnt(18) <= x"79";
							elsif addrcnt(18) = x"8e" then
								addrcnt(18) <= x"84";
							elsif addrcnt(18) = x"99" then
								addrcnt(18) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "100000" )or (p2_c2 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
						if( ((p2_c3 = "100000" )or (p2_c3 = "101101"))
						or ((p2_c4 = "100000" )or (p2_c4 = "101101"))or ((p2_c5 = "100000" )or (p2_c5 = "101101"))or ((p2_c6 = "100000" )or (p2_c6 = "101101"))) then
							if addrcnt(19) = x"0a" then
								addrcnt(19) <= (others => '0');
							elsif addrcnt(19) = x"15" then
								addrcnt(19) <= x"0b";
							elsif addrcnt(19) = x"20" then
								addrcnt(19) <= x"16";
							elsif addrcnt(19) = x"2b" then
								addrcnt(19) <= x"21";
							elsif addrcnt(19) = x"36" then
								addrcnt(19) <= x"2c";
							elsif addrcnt(19) = x"41" then
								addrcnt(19) <= x"37";
							elsif addrcnt(19) = x"4c" then
								addrcnt(19) <= x"42";
							elsif addrcnt(19) = x"57" then
								addrcnt(19) <= x"4d";
							elsif addrcnt(19) = x"62" then
								addrcnt(19) <= x"58";
							elsif addrcnt(19) = x"6d" then
								addrcnt(19) <= x"63";
							elsif addrcnt(19) = x"78" then
								addrcnt(19) <= x"6e";
							elsif addrcnt(19) = x"83" then
								addrcnt(19) <= x"79";
							elsif addrcnt(19) = x"8e" then
								addrcnt(19) <= x"84";
							elsif addrcnt(19) = x"99" then
								addrcnt(19) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "100001" )or (p2_c2 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
						if( ((p2_c3 = "100001" )or (p2_c3 = "101110"))
						or ((p2_c4 = "100001" )or (p2_c4 = "101110"))or ((p2_c5 = "100001" )or (p2_c5 = "101110"))or ((p2_c6 = "100001" )or (p2_c6 = "101110"))) then
							if addrcnt(20) = x"0a" then
								addrcnt(20) <= (others => '0');
							elsif addrcnt(20) = x"15" then
								addrcnt(20) <= x"0b";
							elsif addrcnt(20) = x"20" then
								addrcnt(20) <= x"16";
							elsif addrcnt(20) = x"2b" then
								addrcnt(20) <= x"21";
							elsif addrcnt(20) = x"36" then
								addrcnt(20) <= x"2c";
							elsif addrcnt(20) = x"41" then
								addrcnt(20) <= x"37";
							elsif addrcnt(20) = x"4c" then
								addrcnt(20) <= x"42";
							elsif addrcnt(20) = x"57" then
								addrcnt(20) <= x"4d";
							elsif addrcnt(20) = x"62" then
								addrcnt(20) <= x"58";
							elsif addrcnt(20) = x"6d" then
								addrcnt(20) <= x"63";
							elsif addrcnt(20) = x"78" then
								addrcnt(20) <= x"6e";
							elsif addrcnt(20) = x"83" then
								addrcnt(20) <= x"79";
							elsif addrcnt(20) = x"8e" then
								addrcnt(20) <= x"84";
							elsif addrcnt(20) = x"99" then
								addrcnt(20) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "100010" )or (p2_c2 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
						if(((p2_c3 = "100010" )or (p2_c3 = "101111"))
						or ((p2_c4 = "100010" )or (p2_c4 = "101111"))or ((p2_c5 = "100010" )or (p2_c5 = "101111"))or ((p2_c6 = "100010" )or (p2_c6 = "101111"))) then
							if addrcnt(21) = x"0a" then
								addrcnt(21) <= (others => '0');
							elsif addrcnt(21) = x"15" then
								addrcnt(21) <= x"0b";
							elsif addrcnt(21) = x"20" then
								addrcnt(21) <= x"16";
							elsif addrcnt(21) = x"2b" then
								addrcnt(21) <= x"21";
							elsif addrcnt(21) = x"36" then
								addrcnt(21) <= x"2c";
							elsif addrcnt(21) = x"41" then
								addrcnt(21) <= x"37";
							elsif addrcnt(21) = x"4c" then
								addrcnt(21) <= x"42";
							elsif addrcnt(21) = x"57" then
								addrcnt(21) <= x"4d";
							elsif addrcnt(21) = x"62" then
								addrcnt(21) <= x"58";
							elsif addrcnt(21) = x"6d" then
								addrcnt(21) <= x"63";
							elsif addrcnt(21) = x"78" then
								addrcnt(21) <= x"6e";
							elsif addrcnt(21) = x"83" then
								addrcnt(21) <= x"79";
							elsif addrcnt(21) = x"8e" then
								addrcnt(21) <= x"84";
							elsif addrcnt(21) = x"99" then
								addrcnt(21) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "100011" )or (p2_c2 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);
						if(((p2_c3 = "100011" )or (p2_c3 = "110000"))
						or ((p2_c4 = "100011" )or (p2_c4 = "110000"))or ((p2_c5 = "100011" )or (p2_c5 = "110000"))or ((p2_c6 = "100011" )or (p2_c6 = "110000"))) then
							if addrcnt(22) = x"0a" then
								addrcnt(22) <= (others => '0');
							elsif addrcnt(22) = x"15" then
								addrcnt(22) <= x"0b";
							elsif addrcnt(22) = x"20" then
								addrcnt(22) <= x"16";
							elsif addrcnt(22) = x"2b" then
								addrcnt(22) <= x"21";
							elsif addrcnt(22) = x"36" then
								addrcnt(22) <= x"2c";
							elsif addrcnt(22) = x"41" then
								addrcnt(22) <= x"37";
							elsif addrcnt(22) = x"4c" then
								addrcnt(22) <= x"42";
							elsif addrcnt(22) = x"57" then
								addrcnt(22) <= x"4d";
							elsif addrcnt(22) = x"62" then
								addrcnt(22) <= x"58";
							elsif addrcnt(22) = x"6d" then
								addrcnt(22) <= x"63";
							elsif addrcnt(22) = x"78" then
								addrcnt(22) <= x"6e";
							elsif addrcnt(22) = x"83" then
								addrcnt(22) <= x"79";
							elsif addrcnt(22) = x"8e" then
								addrcnt(22) <= x"84";
							elsif addrcnt(22) = x"99" then
								addrcnt(22) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "100100" )or (p2_c2 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
						if( ((p2_c3 = "100100" )or (p2_c3 = "110001"))
						or ((p2_c4 = "100100" )or (p2_c4 = "110001"))or ((p2_c5 = "100100" )or (p2_c5 = "110001"))or ((p2_c6 = "100100" )or (p2_c6 = "110001"))) then
							if addrcnt(23) = x"0a" then
								addrcnt(23) <= (others => '0');
							elsif addrcnt(23) = x"15" then
								addrcnt(23) <= x"0b";
							elsif addrcnt(23) = x"20" then
								addrcnt(23) <= x"16";
							elsif addrcnt(23) = x"2b" then
								addrcnt(23) <= x"21";
							elsif addrcnt(23) = x"36" then
								addrcnt(23) <= x"2c";
							elsif addrcnt(23) = x"41" then
								addrcnt(23) <= x"37";
							elsif addrcnt(23) = x"4c" then
								addrcnt(23) <= x"42";
							elsif addrcnt(23) = x"57" then
								addrcnt(23) <= x"4d";
							elsif addrcnt(23) = x"62" then
								addrcnt(23) <= x"58";
							elsif addrcnt(23) = x"6d" then
								addrcnt(23) <= x"63";
							elsif addrcnt(23) = x"78" then
								addrcnt(23) <= x"6e";
							elsif addrcnt(23) = x"83" then
								addrcnt(23) <= x"79";
							elsif addrcnt(23) = x"8e" then
								addrcnt(23) <= x"84";
							elsif addrcnt(23) = x"99" then
								addrcnt(23) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "100101" )or (p2_c2 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
						if(  ((p2_c3 = "100101" )or (p2_c3 = "110010"))
						or ((p2_c4 = "100101" )or (p2_c4 = "110010"))or ((p2_c5 = "100101" )or (p2_c5 = "110010"))or ((p2_c6 = "100101" )or (p2_c6 = "110010"))) then
							if addrcnt(24) = x"0a" then
								addrcnt(24) <= (others => '0');
							elsif addrcnt(24) = x"15" then
								addrcnt(24) <= x"0b";
							elsif addrcnt(24) = x"20" then
								addrcnt(24) <= x"16";
							elsif addrcnt(24) = x"2b" then
								addrcnt(24) <= x"21";
							elsif addrcnt(24) = x"36" then
								addrcnt(24) <= x"2c";
							elsif addrcnt(24) = x"41" then
								addrcnt(24) <= x"37";
							elsif addrcnt(24) = x"4c" then
								addrcnt(24) <= x"42";
							elsif addrcnt(24) = x"57" then
								addrcnt(24) <= x"4d";
							elsif addrcnt(24) = x"62" then
								addrcnt(24) <= x"58";
							elsif addrcnt(24) = x"6d" then
								addrcnt(24) <= x"63";
							elsif addrcnt(24) = x"78" then
								addrcnt(24) <= x"6e";
							elsif addrcnt(24) = x"83" then
								addrcnt(24) <= x"79";
							elsif addrcnt(24) = x"8e" then
								addrcnt(24) <= x"84";
							elsif addrcnt(24) = x"99" then
								addrcnt(24) <= x"8f";
							end if;
						end if;
					elsif (p2_c2 = "100110" )or (p2_c2 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
						if( ((p2_c3 = "100110" )or (p2_c3 = "110011"))
						or ((p2_c4 = "100110" )or (p2_c4 = "110011"))or ((p2_c5 = "100110" )or (p2_c5 = "110011"))or ((p2_c6 = "100110" )or (p2_c6 = "110011"))) then
							if addrcnt(25) = x"0a" then
								addrcnt(25) <= (others => '0');
							elsif addrcnt(25) = x"15" then
								addrcnt(25) <= x"0b";
							elsif addrcnt(25) = x"20" then
								addrcnt(25) <= x"16";
							elsif addrcnt(25) = x"2b" then
								addrcnt(25) <= x"21";
							elsif addrcnt(25) = x"36" then
								addrcnt(25) <= x"2c";
							elsif addrcnt(25) = x"41" then
								addrcnt(25) <= x"37";
							elsif addrcnt(25) = x"4c" then
								addrcnt(25) <= x"42";
							elsif addrcnt(25) = x"57" then
								addrcnt(25) <= x"4d";
							elsif addrcnt(25) = x"62" then
								addrcnt(25) <= x"58";
							elsif addrcnt(25) = x"6d" then
								addrcnt(25) <= x"63";
							elsif addrcnt(25) = x"78" then
								addrcnt(25) <= x"6e";
							elsif addrcnt(25) = x"83" then
								addrcnt(25) <= x"79";
							elsif addrcnt(25) = x"8e" then
								addrcnt(25) <= x"84";
							elsif addrcnt(25) = x"99" then
								addrcnt(25) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +431 ) ) and ( hsync_cnt <= (tHW + tHBP +441)) ) then
					if (p2_c3 = "000000" )or (p2_c3 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
						if(((p2_c4 = "000000" )or (p2_c4 = "001101"))or ((p2_c5 = "000000" )or (p2_c5 = "001101"))or ((p2_c6 = "000000" )or (p2_c6 = "001101"))) then
							if addrcnt(0) = x"0a" then
								addrcnt(0) <= (others => '0');
							elsif addrcnt(0) = x"15" then
								addrcnt(0) <= x"0b";
							elsif addrcnt(0) = x"20" then
								addrcnt(0) <= x"16";
							elsif addrcnt(0) = x"2b" then
								addrcnt(0) <= x"21";
							elsif addrcnt(0) = x"36" then
								addrcnt(0) <= x"2c";
							elsif addrcnt(0) = x"41" then
								addrcnt(0) <= x"37";
							elsif addrcnt(0) = x"4c" then
								addrcnt(0) <= x"42";
							elsif addrcnt(0) = x"57" then
								addrcnt(0) <= x"4d";
							elsif addrcnt(0) = x"62" then
								addrcnt(0) <= x"58";
							elsif addrcnt(0) = x"6d" then
								addrcnt(0) <= x"63";
							elsif addrcnt(0) = x"78" then
								addrcnt(0) <= x"6e";
							elsif addrcnt(0) = x"83" then
								addrcnt(0) <= x"79";
							elsif addrcnt(0) = x"8e" then
								addrcnt(0) <= x"84";
							elsif addrcnt(0) = x"99" then
								addrcnt(0) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "000001" )or (p2_c3 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
						if(((p2_c4 = "000001" )or (p2_c4 = "001110"))or ((p2_c5 = "000001" )or (p2_c5 = "001110"))or ((p2_c6 = "000001" )or (p2_c6 = "001110"))) then
							if addrcnt(1) = x"0a" then
								addrcnt(1) <= (others => '0');
							elsif addrcnt(1) = x"15" then
								addrcnt(1) <= x"0b";
							elsif addrcnt(1) = x"20" then
								addrcnt(1) <= x"16";
							elsif addrcnt(1) = x"2b" then
								addrcnt(1) <= x"21";
							elsif addrcnt(1) = x"36" then
								addrcnt(1) <= x"2c";
							elsif addrcnt(1) = x"41" then
								addrcnt(1) <= x"37";
							elsif addrcnt(1) = x"4c" then
								addrcnt(1) <= x"42";
							elsif addrcnt(1) = x"57" then
								addrcnt(1) <= x"4d";
							elsif addrcnt(1) = x"62" then
								addrcnt(1) <= x"58";
							elsif addrcnt(1) = x"6d" then
								addrcnt(1) <= x"63";
							elsif addrcnt(1) = x"78" then
								addrcnt(1) <= x"6e";
							elsif addrcnt(1) = x"83" then
								addrcnt(1) <= x"79";
							elsif addrcnt(1) = x"8e" then
								addrcnt(1) <= x"84";
							elsif addrcnt(1) = x"99" then
								addrcnt(1) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "000010" )or (p2_c3 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
						if( ((p2_c4 = "000010" )or (p2_c4 = "001111"))or ((p2_c5 = "000010" )or (p2_c5 = "001111"))or ((p2_c6 = "000010" )or (p2_c6 = "001111"))) then
							if addrcnt(2) = x"0a" then
								addrcnt(2) <= (others => '0');
							elsif addrcnt(2) = x"15" then
								addrcnt(2) <= x"0b";
							elsif addrcnt(2) = x"20" then
								addrcnt(2) <= x"16";
							elsif addrcnt(2) = x"2b" then
								addrcnt(2) <= x"21";
							elsif addrcnt(2) = x"36" then
								addrcnt(2) <= x"2c";
							elsif addrcnt(2) = x"41" then
								addrcnt(2) <= x"37";
							elsif addrcnt(2) = x"4c" then
								addrcnt(2) <= x"42";
							elsif addrcnt(2) = x"57" then
								addrcnt(2) <= x"4d";
							elsif addrcnt(2) = x"62" then
								addrcnt(2) <= x"58";
							elsif addrcnt(2) = x"6d" then
								addrcnt(2) <= x"63";
							elsif addrcnt(2) = x"78" then
								addrcnt(2) <= x"6e";
							elsif addrcnt(2) = x"83" then
								addrcnt(2) <= x"79";
							elsif addrcnt(2) = x"8e" then
								addrcnt(2) <= x"84";
							elsif addrcnt(2) = x"99" then
								addrcnt(2) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "000011" )or (p2_c3 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
						if( ((p2_c4 = "000011" )or (p2_c4 = "010000"))or ((p2_c5 = "000011" )or (p2_c5 = "010000"))or ((p2_c6 = "000011" )or (p2_c6 = "010000"))) then
							if addrcnt(3) = x"0a" then
								addrcnt(3) <= (others => '0');
							elsif addrcnt(3) = x"15" then
								addrcnt(3) <= x"0b";
							elsif addrcnt(3) = x"20" then
								addrcnt(3) <= x"16";
							elsif addrcnt(3) = x"2b" then
								addrcnt(3) <= x"21";
							elsif addrcnt(3) = x"36" then
								addrcnt(3) <= x"2c";
							elsif addrcnt(3) = x"41" then
								addrcnt(3) <= x"37";
							elsif addrcnt(3) = x"4c" then
								addrcnt(3) <= x"42";
							elsif addrcnt(3) = x"57" then
								addrcnt(3) <= x"4d";
							elsif addrcnt(3) = x"62" then
								addrcnt(3) <= x"58";
							elsif addrcnt(3) = x"6d" then
								addrcnt(3) <= x"63";
							elsif addrcnt(3) = x"78" then
								addrcnt(3) <= x"6e";
							elsif addrcnt(3) = x"83" then
								addrcnt(3) <= x"79";
							elsif addrcnt(3) = x"8e" then
								addrcnt(3) <= x"84";
							elsif addrcnt(3) = x"99" then
								addrcnt(3) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "000100" )or (p2_c3 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);
						if( ((p2_c4 = "000100" )or (p2_c4 = "010001"))or ((p2_c5 = "000100" )or (p2_c5 = "010001"))or ((p2_c6 = "000100" )or (p2_c6 = "010001"))) then
							if addrcnt(4) = x"0a" then
								addrcnt(4) <= (others => '0');
							elsif addrcnt(4) = x"15" then
								addrcnt(4) <= x"0b";
							elsif addrcnt(4) = x"20" then
								addrcnt(4) <= x"16";
							elsif addrcnt(4) = x"2b" then
								addrcnt(4) <= x"21";
							elsif addrcnt(4) = x"36" then
								addrcnt(4) <= x"2c";
							elsif addrcnt(4) = x"41" then
								addrcnt(4) <= x"37";
							elsif addrcnt(4) = x"4c" then
								addrcnt(4) <= x"42";
							elsif addrcnt(4) = x"57" then
								addrcnt(4) <= x"4d";
							elsif addrcnt(4) = x"62" then
								addrcnt(4) <= x"58";
							elsif addrcnt(4) = x"6d" then
								addrcnt(4) <= x"63";
							elsif addrcnt(4) = x"78" then
								addrcnt(4) <= x"6e";
							elsif addrcnt(4) = x"83" then
								addrcnt(4) <= x"79";
							elsif addrcnt(4) = x"8e" then
								addrcnt(4) <= x"84";
							elsif addrcnt(4) = x"99" then
								addrcnt(4) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "000101" )or (p2_c3 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);
						if( ((p2_c4 = "000101" )or (p2_c4 = "010010"))or ((p2_c5 = "000101" )or (p2_c5 = "010010"))or ((p2_c6 = "000101" )or (p2_c6 = "010010"))) then
							if addrcnt(5) = x"0a" then
								addrcnt(5) <= (others => '0');
							elsif addrcnt(5) = x"15" then
								addrcnt(5) <= x"0b";
							elsif addrcnt(5) = x"20" then
								addrcnt(5) <= x"16";
							elsif addrcnt(5) = x"2b" then
								addrcnt(5) <= x"21";
							elsif addrcnt(5) = x"36" then
								addrcnt(5) <= x"2c";
							elsif addrcnt(5) = x"41" then
								addrcnt(5) <= x"37";
							elsif addrcnt(5) = x"4c" then
								addrcnt(5) <= x"42";
							elsif addrcnt(5) = x"57" then
								addrcnt(5) <= x"4d";
							elsif addrcnt(5) = x"62" then
								addrcnt(5) <= x"58";
							elsif addrcnt(5) = x"6d" then
								addrcnt(5) <= x"63";
							elsif addrcnt(5) = x"78" then
								addrcnt(5) <= x"6e";
							elsif addrcnt(5) = x"83" then
								addrcnt(5) <= x"79";
							elsif addrcnt(5) = x"8e" then
								addrcnt(5) <= x"84";
							elsif addrcnt(5) = x"99" then
								addrcnt(5) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "000110" )or (p2_c3 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);
						if(  ((p2_c4 = "000110" )or (p2_c4 = "010011"))or ((p2_c5 = "000110" )or (p2_c5 = "010011"))or ((p2_c6 = "000110" )or (p2_c6 = "010011"))) then
							if addrcnt(6) = x"0a" then
								addrcnt(6) <= (others => '0');
							elsif addrcnt(6) = x"15" then
								addrcnt(6) <= x"0b";
							elsif addrcnt(6) = x"20" then
								addrcnt(6) <= x"16";
							elsif addrcnt(6) = x"2b" then
								addrcnt(6) <= x"21";
							elsif addrcnt(6) = x"36" then
								addrcnt(6) <= x"2c";
							elsif addrcnt(6) = x"41" then
								addrcnt(6) <= x"37";
							elsif addrcnt(6) = x"4c" then
								addrcnt(6) <= x"42";
							elsif addrcnt(6) = x"57" then
								addrcnt(6) <= x"4d";
							elsif addrcnt(6) = x"62" then
								addrcnt(6) <= x"58";
							elsif addrcnt(6) = x"6d" then
								addrcnt(6) <= x"63";
							elsif addrcnt(6) = x"78" then
								addrcnt(6) <= x"6e";
							elsif addrcnt(6) = x"83" then
								addrcnt(6) <= x"79";
							elsif addrcnt(6) = x"8e" then
								addrcnt(6) <= x"84";
							elsif addrcnt(6) = x"99" then
								addrcnt(6) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "000111" )or (p2_c3 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);
						if( ((p2_c4 = "000111" )or (p2_c4 = "010100"))or ((p2_c5 = "000111" )or (p2_c5 = "010100"))or ((p2_c6 = "000111" )or (p2_c6 = "010100"))) then
							if addrcnt(7) = x"0a" then
								addrcnt(7) <= (others => '0');
							elsif addrcnt(7) = x"15" then
								addrcnt(7) <= x"0b";
							elsif addrcnt(7) = x"20" then
								addrcnt(7) <= x"16";
							elsif addrcnt(7) = x"2b" then
								addrcnt(7) <= x"21";
							elsif addrcnt(7) = x"36" then
								addrcnt(7) <= x"2c";
							elsif addrcnt(7) = x"41" then
								addrcnt(7) <= x"37";
							elsif addrcnt(7) = x"4c" then
								addrcnt(7) <= x"42";
							elsif addrcnt(7) = x"57" then
								addrcnt(7) <= x"4d";
							elsif addrcnt(7) = x"62" then
								addrcnt(7) <= x"58";
							elsif addrcnt(7) = x"6d" then
								addrcnt(7) <= x"63";
							elsif addrcnt(7) = x"78" then
								addrcnt(7) <= x"6e";
							elsif addrcnt(7) = x"83" then
								addrcnt(7) <= x"79";
							elsif addrcnt(7) = x"8e" then
								addrcnt(7) <= x"84";
							elsif addrcnt(7) = x"99" then
								addrcnt(7) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "001000" )or (p2_c3 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
						if( ((p2_c4 = "001000" )or (p2_c4 = "010101"))or ((p2_c5 = "001000" )or (p2_c5 = "010101"))or ((p2_c6 = "001000" )or (p2_c6 = "010101"))) then
							if addrcnt(8) = x"0a" then
								addrcnt(8) <= (others => '0');
							elsif addrcnt(8) = x"15" then
								addrcnt(8) <= x"0b";
							elsif addrcnt(8) = x"20" then
								addrcnt(8) <= x"16";
							elsif addrcnt(8) = x"2b" then
								addrcnt(8) <= x"21";
							elsif addrcnt(8) = x"36" then
								addrcnt(8) <= x"2c";
							elsif addrcnt(8) = x"41" then
								addrcnt(8) <= x"37";
							elsif addrcnt(8) = x"4c" then
								addrcnt(8) <= x"42";
							elsif addrcnt(8) = x"57" then
								addrcnt(8) <= x"4d";
							elsif addrcnt(8) = x"62" then
								addrcnt(8) <= x"58";
							elsif addrcnt(8) = x"6d" then
								addrcnt(8) <= x"63";
							elsif addrcnt(8) = x"78" then
								addrcnt(8) <= x"6e";
							elsif addrcnt(8) = x"83" then
								addrcnt(8) <= x"79";
							elsif addrcnt(8) = x"8e" then
								addrcnt(8) <= x"84";
							elsif addrcnt(8) = x"99" then
								addrcnt(8) <= x"8f";
							end if;
						end if;
					elsif (p2_c3= "001001" )or (p2_c3 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);
						if(((p2_c4 = "001001" )or (p2_c4 = "010110"))or ((p2_c5 = "001001" )or (p2_c5 = "010110"))or ((p2_c6 = "001001" )or (p2_c6 = "010110"))) then
							if addrcnt(9) = x"0a" then
								addrcnt(9) <= (others => '0');
							elsif addrcnt(9) = x"15" then
								addrcnt(9) <= x"0b";
							elsif addrcnt(9) = x"20" then
								addrcnt(9) <= x"16";
							elsif addrcnt(9) = x"2b" then
								addrcnt(9) <= x"21";
							elsif addrcnt(9) = x"36" then
								addrcnt(9) <= x"2c";
							elsif addrcnt(9) = x"41" then
								addrcnt(9) <= x"37";
							elsif addrcnt(9) = x"4c" then
								addrcnt(9) <= x"42";
							elsif addrcnt(9) = x"57" then
								addrcnt(9) <= x"4d";
							elsif addrcnt(9) = x"62" then
								addrcnt(9) <= x"58";
							elsif addrcnt(9) = x"6d" then
								addrcnt(9) <= x"63";
							elsif addrcnt(9) = x"78" then
								addrcnt(9) <= x"6e";
							elsif addrcnt(9) = x"83" then
								addrcnt(9) <= x"79";
							elsif addrcnt(9) = x"8e" then
								addrcnt(9) <= x"84";
							elsif addrcnt(9) = x"99" then
								addrcnt(9) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "001010" )or (p2_c3 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);
						if( ((p2_c4 = "001010" )or (p2_c4 = "010111"))or ((p2_c5 = "001010" )or (p2_c5 = "010111"))or ((p2_c6 = "001010" )or (p2_c6 = "010111"))) then
							if addrcnt(10) = x"0a" then
								addrcnt(10) <= (others => '0');
							elsif addrcnt(10) = x"15" then
								addrcnt(10) <= x"0b";
							elsif addrcnt(10) = x"20" then
								addrcnt(10) <= x"16";
							elsif addrcnt(10) = x"2b" then
								addrcnt(10) <= x"21";
							elsif addrcnt(10) = x"36" then
								addrcnt(10) <= x"2c";
							elsif addrcnt(10) = x"41" then
								addrcnt(10) <= x"37";
							elsif addrcnt(10) = x"4c" then
								addrcnt(10) <= x"42";
							elsif addrcnt(10) = x"57" then
								addrcnt(10) <= x"4d";
							elsif addrcnt(10) = x"62" then
								addrcnt(10) <= x"58";
							elsif addrcnt(10) = x"6d" then
								addrcnt(10) <= x"63";
							elsif addrcnt(10) = x"78" then
								addrcnt(10) <= x"6e";
							elsif addrcnt(10) = x"83" then
								addrcnt(10) <= x"79";
							elsif addrcnt(10) = x"8e" then
								addrcnt(10) <= x"84";
							elsif addrcnt(10) = x"99" then
								addrcnt(10) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "001011" )or (p2_c3 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);
						if(((p2_c4 = "001011" )or (p2_c4 = "011000"))or ((p2_c5 = "001011" )or (p2_c5 = "011000"))or ((p2_c6 = "001011" )or (p2_c6 = "011000"))) then
							if addrcnt(11) = x"0a" then
								addrcnt(11) <= (others => '0');
							elsif addrcnt(11) = x"15" then
								addrcnt(11) <= x"0b";
							elsif addrcnt(11) = x"20" then
								addrcnt(11) <= x"16";
							elsif addrcnt(11) = x"2b" then
								addrcnt(11) <= x"21";
							elsif addrcnt(11) = x"36" then
								addrcnt(11) <= x"2c";
							elsif addrcnt(11) = x"41" then
								addrcnt(11) <= x"37";
							elsif addrcnt(11) = x"4c" then
								addrcnt(11) <= x"42";
							elsif addrcnt(11) = x"57" then
								addrcnt(11) <= x"4d";
							elsif addrcnt(11) = x"62" then
								addrcnt(11) <= x"58";
							elsif addrcnt(11) = x"6d" then
								addrcnt(11) <= x"63";
							elsif addrcnt(11) = x"78" then
								addrcnt(11) <= x"6e";
							elsif addrcnt(11) = x"83" then
								addrcnt(11) <= x"79";
							elsif addrcnt(11) = x"8e" then
								addrcnt(11) <= x"84";
							elsif addrcnt(11) = x"99" then
								addrcnt(11) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "001100" )or (p2_c3 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
						if( ((p2_c4 = "001100" )or (p2_c4 = "011001"))or ((p2_c5 = "001100" )or (p2_c5 = "011001"))or ((p2_c6 = "001100" )or (p2_c6 = "011001"))) then
							if addrcnt(12) = x"0a" then
								addrcnt(12) <= (others => '0');
							elsif addrcnt(12) = x"15" then
								addrcnt(12) <= x"0b";
							elsif addrcnt(12) = x"20" then
								addrcnt(12) <= x"16";
							elsif addrcnt(12) = x"2b" then
								addrcnt(12) <= x"21";
							elsif addrcnt(12) = x"36" then
								addrcnt(12) <= x"2c";
							elsif addrcnt(12) = x"41" then
								addrcnt(12) <= x"37";
							elsif addrcnt(12) = x"4c" then
								addrcnt(12) <= x"42";
							elsif addrcnt(12) = x"57" then
								addrcnt(12) <= x"4d";
							elsif addrcnt(12) = x"62" then
								addrcnt(12) <= x"58";
							elsif addrcnt(12) = x"6d" then
								addrcnt(12) <= x"63";
							elsif addrcnt(12) = x"78" then
								addrcnt(12) <= x"6e";
							elsif addrcnt(12) = x"83" then
								addrcnt(12) <= x"79";
							elsif addrcnt(12) = x"8e" then
								addrcnt(12) <= x"84";
							elsif addrcnt(12) = x"99" then
								addrcnt(12) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "011010" )or (p2_c3 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
						if (((p2_c4 = "011010" )or (p2_c4 = "100111"))or ((p2_c5 = "011010" )or (p2_c5 = "100111"))or ((p2_c6 = "011010" )or (p2_c6 = "100111"))) then
							if addrcnt(13) = x"0a" then
								addrcnt(13) <= (others => '0');
							elsif addrcnt(13) = x"15" then
								addrcnt(13) <= x"0b";
							elsif addrcnt(13) = x"20" then
								addrcnt(13) <= x"16";
							elsif addrcnt(13) = x"2b" then
								addrcnt(13) <= x"21";
							elsif addrcnt(13) = x"36" then
								addrcnt(13) <= x"2c";
							elsif addrcnt(13) = x"41" then
								addrcnt(13) <= x"37";
							elsif addrcnt(13) = x"4c" then
								addrcnt(13) <= x"42";
							elsif addrcnt(13) = x"57" then
								addrcnt(13) <= x"4d";
							elsif addrcnt(13) = x"62" then
								addrcnt(13) <= x"58";
							elsif addrcnt(13) = x"6d" then
								addrcnt(13) <= x"63";
							elsif addrcnt(13) = x"78" then
								addrcnt(13) <= x"6e";
							elsif addrcnt(13) = x"83" then
								addrcnt(13) <= x"79";
							elsif addrcnt(13) = x"8e" then
								addrcnt(13) <= x"84";
							elsif addrcnt(13) = x"99" then
								addrcnt(13) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "011011" )or (p2_c3 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
						if( ((p2_c4 = "011011" )or (p2_c4 = "101000"))or ((p2_c5 = "011011" )or (p2_c5 = "101000"))or ((p2_c6 = "011011" )or (p2_c6 = "101000"))) then
							if addrcnt(14) = x"0a" then
								addrcnt(14) <= (others => '0');
							elsif addrcnt(14) = x"15" then
								addrcnt(14) <= x"0b";
							elsif addrcnt(14) = x"20" then
								addrcnt(14) <= x"16";
							elsif addrcnt(14) = x"2b" then
								addrcnt(14) <= x"21";
							elsif addrcnt(14) = x"36" then
								addrcnt(14) <= x"2c";
							elsif addrcnt(14) = x"41" then
								addrcnt(14) <= x"37";
							elsif addrcnt(14) = x"4c" then
								addrcnt(14) <= x"42";
							elsif addrcnt(14) = x"57" then
								addrcnt(14) <= x"4d";
							elsif addrcnt(14) = x"62" then
								addrcnt(14) <= x"58";
							elsif addrcnt(14) = x"6d" then
								addrcnt(14) <= x"63";
							elsif addrcnt(14) = x"78" then
								addrcnt(14) <= x"6e";
							elsif addrcnt(14) = x"83" then
								addrcnt(14) <= x"79";
							elsif addrcnt(14) = x"8e" then
								addrcnt(14) <= x"84";
							elsif addrcnt(14) = x"99" then
								addrcnt(14) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "011100" )or (p2_c3 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
						if( ((p2_c4 = "011100" )or (p2_c4 = "101001"))or ((p2_c5 = "011100" )or (p2_c5 = "101001"))or ((p2_c6 = "011100" )or (p2_c6 = "101001"))) then
							if addrcnt(15) = x"0a" then
								addrcnt(15) <= (others => '0');
							elsif addrcnt(15) = x"15" then
								addrcnt(15) <= x"0b";
							elsif addrcnt(15) = x"20" then
								addrcnt(15) <= x"16";
							elsif addrcnt(15) = x"2b" then
								addrcnt(15) <= x"21";
							elsif addrcnt(15) = x"36" then
								addrcnt(15) <= x"2c";
							elsif addrcnt(15) = x"41" then
								addrcnt(15) <= x"37";
							elsif addrcnt(15) = x"4c" then
								addrcnt(15) <= x"42";
							elsif addrcnt(15) = x"57" then
								addrcnt(15) <= x"4d";
							elsif addrcnt(15) = x"62" then
								addrcnt(15) <= x"58";
							elsif addrcnt(15) = x"6d" then
								addrcnt(15) <= x"63";
							elsif addrcnt(15) = x"78" then
								addrcnt(15) <= x"6e";
							elsif addrcnt(15) = x"83" then
								addrcnt(15) <= x"79";
							elsif addrcnt(15) = x"8e" then
								addrcnt(15) <= x"84";
							elsif addrcnt(15) = x"99" then
								addrcnt(15) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "011101" )or (p2_c3 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
						if( ((p2_c4 = "011101" )or (p2_c4 = "101010"))or ((p2_c5 = "011101" )or (p2_c5 = "101010"))or ((p2_c6 = "011101" )or (p2_c6 = "101010"))) then
							if addrcnt(16) = x"0a" then
								addrcnt(16) <= (others => '0');
							elsif addrcnt(16) = x"15" then
								addrcnt(16) <= x"0b";
							elsif addrcnt(16) = x"20" then
								addrcnt(16) <= x"16";
							elsif addrcnt(16) = x"2b" then
								addrcnt(16) <= x"21";
							elsif addrcnt(16) = x"36" then
								addrcnt(16) <= x"2c";
							elsif addrcnt(16) = x"41" then
								addrcnt(16) <= x"37";
							elsif addrcnt(16) = x"4c" then
								addrcnt(16) <= x"42";
							elsif addrcnt(16) = x"57" then
								addrcnt(16) <= x"4d";
							elsif addrcnt(16) = x"62" then
								addrcnt(16) <= x"58";
							elsif addrcnt(16) = x"6d" then
								addrcnt(16) <= x"63";
							elsif addrcnt(16) = x"78" then
								addrcnt(16) <= x"6e";
							elsif addrcnt(16) = x"83" then
								addrcnt(16) <= x"79";
							elsif addrcnt(16) = x"8e" then
								addrcnt(16) <= x"84";
							elsif addrcnt(16) = x"99" then
								addrcnt(16) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "011110" )or (p2_c3 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);
						if( ((p2_c4 = "011110" )or (p2_c4 = "101011"))or ((p2_c5 = "011110" )or (p2_c5 = "101011"))or ((p2_c6 = "011110" )or (p2_c6 = "101011"))) then
							if addrcnt(17) = x"0a" then
								addrcnt(17) <= (others => '0');
							elsif addrcnt(17) = x"15" then
								addrcnt(17) <= x"0b";
							elsif addrcnt(17) = x"20" then
								addrcnt(17) <= x"16";
							elsif addrcnt(17) = x"2b" then
								addrcnt(17) <= x"21";
							elsif addrcnt(17) = x"36" then
								addrcnt(17) <= x"2c";
							elsif addrcnt(17) = x"41" then
								addrcnt(17) <= x"37";
							elsif addrcnt(17) = x"4c" then
								addrcnt(17) <= x"42";
							elsif addrcnt(17) = x"57" then
								addrcnt(17) <= x"4d";
							elsif addrcnt(17) = x"62" then
								addrcnt(17) <= x"58";
							elsif addrcnt(17) = x"6d" then
								addrcnt(17) <= x"63";
							elsif addrcnt(17) = x"78" then
								addrcnt(17) <= x"6e";
							elsif addrcnt(17) = x"83" then
								addrcnt(17) <= x"79";
							elsif addrcnt(17) = x"8e" then
								addrcnt(17) <= x"84";
							elsif addrcnt(17) = x"99" then
								addrcnt(17) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "011111" )or (p2_c3 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);
						if( ((p2_c4 = "011111" )or (p2_c4 = "101100"))or ((p2_c5 = "011111" )or (p2_c5 = "101100"))or ((p2_c6 = "011111" )or (p2_c6 = "101100"))) then
							if addrcnt(18) = x"0a" then
								addrcnt(18) <= (others => '0');
							elsif addrcnt(18) = x"15" then
								addrcnt(18) <= x"0b";
							elsif addrcnt(18) = x"20" then
								addrcnt(18) <= x"16";
							elsif addrcnt(18) = x"2b" then
								addrcnt(18) <= x"21";
							elsif addrcnt(18) = x"36" then
								addrcnt(18) <= x"2c";
							elsif addrcnt(18) = x"41" then
								addrcnt(18) <= x"37";
							elsif addrcnt(18) = x"4c" then
								addrcnt(18) <= x"42";
							elsif addrcnt(18) = x"57" then
								addrcnt(18) <= x"4d";
							elsif addrcnt(18) = x"62" then
								addrcnt(18) <= x"58";
							elsif addrcnt(18) = x"6d" then
								addrcnt(18) <= x"63";
							elsif addrcnt(18) = x"78" then
								addrcnt(18) <= x"6e";
							elsif addrcnt(18) = x"83" then
								addrcnt(18) <= x"79";
							elsif addrcnt(18) = x"8e" then
								addrcnt(18) <= x"84";
							elsif addrcnt(18) = x"99" then
								addrcnt(18) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "100000" )or (p2_c3 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
						if(  ((p2_c4 = "100000" )or (p2_c4 = "101101"))or ((p2_c5 = "100000" )or (p2_c5 = "101101"))or ((p2_c6 = "100000" )or (p2_c6 = "101101"))) then
							if addrcnt(19) = x"0a" then
								addrcnt(19) <= (others => '0');
							elsif addrcnt(19) = x"15" then
								addrcnt(19) <= x"0b";
							elsif addrcnt(19) = x"20" then
								addrcnt(19) <= x"16";
							elsif addrcnt(19) = x"2b" then
								addrcnt(19) <= x"21";
							elsif addrcnt(19) = x"36" then
								addrcnt(19) <= x"2c";
							elsif addrcnt(19) = x"41" then
								addrcnt(19) <= x"37";
							elsif addrcnt(19) = x"4c" then
								addrcnt(19) <= x"42";
							elsif addrcnt(19) = x"57" then
								addrcnt(19) <= x"4d";
							elsif addrcnt(19) = x"62" then
								addrcnt(19) <= x"58";
							elsif addrcnt(19) = x"6d" then
								addrcnt(19) <= x"63";
							elsif addrcnt(19) = x"78" then
								addrcnt(19) <= x"6e";
							elsif addrcnt(19) = x"83" then
								addrcnt(19) <= x"79";
							elsif addrcnt(19) = x"8e" then
								addrcnt(19) <= x"84";
							elsif addrcnt(19) = x"99" then
								addrcnt(19) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "100001" )or (p2_c3 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
						if( ((p2_c4 = "100001" )or (p2_c4 = "101110"))or ((p2_c5 = "100001" )or (p2_c5 = "101110"))or ((p2_c6 = "100001" )or (p2_c6 = "101110"))) then
							if addrcnt(20) = x"0a" then
								addrcnt(20) <= (others => '0');
							elsif addrcnt(20) = x"15" then
								addrcnt(20) <= x"0b";
							elsif addrcnt(20) = x"20" then
								addrcnt(20) <= x"16";
							elsif addrcnt(20) = x"2b" then
								addrcnt(20) <= x"21";
							elsif addrcnt(20) = x"36" then
								addrcnt(20) <= x"2c";
							elsif addrcnt(20) = x"41" then
								addrcnt(20) <= x"37";
							elsif addrcnt(20) = x"4c" then
								addrcnt(20) <= x"42";
							elsif addrcnt(20) = x"57" then
								addrcnt(20) <= x"4d";
							elsif addrcnt(20) = x"62" then
								addrcnt(20) <= x"58";
							elsif addrcnt(20) = x"6d" then
								addrcnt(20) <= x"63";
							elsif addrcnt(20) = x"78" then
								addrcnt(20) <= x"6e";
							elsif addrcnt(20) = x"83" then
								addrcnt(20) <= x"79";
							elsif addrcnt(20) = x"8e" then
								addrcnt(20) <= x"84";
							elsif addrcnt(20) = x"99" then
								addrcnt(20) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "100010" )or (p2_c3 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
						if( ((p2_c4 = "100010" )or (p2_c4 = "101111"))or ((p2_c5 = "100010" )or (p2_c5 = "101111"))or ((p2_c6 = "100010" )or (p2_c6 = "101111"))) then
							if addrcnt(21) = x"0a" then
								addrcnt(21) <= (others => '0');
							elsif addrcnt(21) = x"15" then
								addrcnt(21) <= x"0b";
							elsif addrcnt(21) = x"20" then
								addrcnt(21) <= x"16";
							elsif addrcnt(21) = x"2b" then
								addrcnt(21) <= x"21";
							elsif addrcnt(21) = x"36" then
								addrcnt(21) <= x"2c";
							elsif addrcnt(21) = x"41" then
								addrcnt(21) <= x"37";
							elsif addrcnt(21) = x"4c" then
								addrcnt(21) <= x"42";
							elsif addrcnt(21) = x"57" then
								addrcnt(21) <= x"4d";
							elsif addrcnt(21) = x"62" then
								addrcnt(21) <= x"58";
							elsif addrcnt(21) = x"6d" then
								addrcnt(21) <= x"63";
							elsif addrcnt(21) = x"78" then
								addrcnt(21) <= x"6e";
							elsif addrcnt(21) = x"83" then
								addrcnt(21) <= x"79";
							elsif addrcnt(21) = x"8e" then
								addrcnt(21) <= x"84";
							elsif addrcnt(21) = x"99" then
								addrcnt(21) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "100011" )or (p2_c3 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);
						if( ((p2_c4 = "100011" )or (p2_c4 = "110000"))or ((p2_c5 = "100011" )or (p2_c5 = "110000"))or ((p2_c6 = "100011" )or (p2_c6 = "110000"))) then
							if addrcnt(22) = x"0a" then
								addrcnt(22) <= (others => '0');
							elsif addrcnt(22) = x"15" then
								addrcnt(22) <= x"0b";
							elsif addrcnt(22) = x"20" then
								addrcnt(22) <= x"16";
							elsif addrcnt(22) = x"2b" then
								addrcnt(22) <= x"21";
							elsif addrcnt(22) = x"36" then
								addrcnt(22) <= x"2c";
							elsif addrcnt(22) = x"41" then
								addrcnt(22) <= x"37";
							elsif addrcnt(22) = x"4c" then
								addrcnt(22) <= x"42";
							elsif addrcnt(22) = x"57" then
								addrcnt(22) <= x"4d";
							elsif addrcnt(22) = x"62" then
								addrcnt(22) <= x"58";
							elsif addrcnt(22) = x"6d" then
								addrcnt(22) <= x"63";
							elsif addrcnt(22) = x"78" then
								addrcnt(22) <= x"6e";
							elsif addrcnt(22) = x"83" then
								addrcnt(22) <= x"79";
							elsif addrcnt(22) = x"8e" then
								addrcnt(22) <= x"84";
							elsif addrcnt(22) = x"99" then
								addrcnt(22) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "100100" )or (p2_c3 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
						if( ((p2_c4 = "100100" )or (p2_c4 = "110001"))or ((p2_c5 = "100100" )or (p2_c5 = "110001"))or ((p2_c6 = "100100" )or (p2_c6 = "110001"))) then
							if addrcnt(23) = x"0a" then
								addrcnt(23) <= (others => '0');
							elsif addrcnt(23) = x"15" then
								addrcnt(23) <= x"0b";
							elsif addrcnt(23) = x"20" then
								addrcnt(23) <= x"16";
							elsif addrcnt(23) = x"2b" then
								addrcnt(23) <= x"21";
							elsif addrcnt(23) = x"36" then
								addrcnt(23) <= x"2c";
							elsif addrcnt(23) = x"41" then
								addrcnt(23) <= x"37";
							elsif addrcnt(23) = x"4c" then
								addrcnt(23) <= x"42";
							elsif addrcnt(23) = x"57" then
								addrcnt(23) <= x"4d";
							elsif addrcnt(23) = x"62" then
								addrcnt(23) <= x"58";
							elsif addrcnt(23) = x"6d" then
								addrcnt(23) <= x"63";
							elsif addrcnt(23) = x"78" then
								addrcnt(23) <= x"6e";
							elsif addrcnt(23) = x"83" then
								addrcnt(23) <= x"79";
							elsif addrcnt(23) = x"8e" then
								addrcnt(23) <= x"84";
							elsif addrcnt(23) = x"99" then
								addrcnt(23) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "100101" )or (p2_c3 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
						if( ((p2_c4 = "100101" )or (p2_c4 = "110010"))or ((p2_c5 = "100101" )or (p2_c5 = "110010"))or ((p2_c6 = "100101" )or (p2_c6 = "110010"))) then
							if addrcnt(24) = x"0a" then
								addrcnt(24) <= (others => '0');
							elsif addrcnt(24) = x"15" then
								addrcnt(24) <= x"0b";
							elsif addrcnt(24) = x"20" then
								addrcnt(24) <= x"16";
							elsif addrcnt(24) = x"2b" then
								addrcnt(24) <= x"21";
							elsif addrcnt(24) = x"36" then
								addrcnt(24) <= x"2c";
							elsif addrcnt(24) = x"41" then
								addrcnt(24) <= x"37";
							elsif addrcnt(24) = x"4c" then
								addrcnt(24) <= x"42";
							elsif addrcnt(24) = x"57" then
								addrcnt(24) <= x"4d";
							elsif addrcnt(24) = x"62" then
								addrcnt(24) <= x"58";
							elsif addrcnt(24) = x"6d" then
								addrcnt(24) <= x"63";
							elsif addrcnt(24) = x"78" then
								addrcnt(24) <= x"6e";
							elsif addrcnt(24) = x"83" then
								addrcnt(24) <= x"79";
							elsif addrcnt(24) = x"8e" then
								addrcnt(24) <= x"84";
							elsif addrcnt(24) = x"99" then
								addrcnt(24) <= x"8f";
							end if;
						end if;
					elsif (p2_c3 = "100110" )or (p2_c3 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
						if( ((p2_c4 = "100110" )or (p2_c4 = "110011"))or ((p2_c5 = "100110" )or (p2_c5 = "110011"))or ((p2_c6 = "100110" )or (p2_c6 = "110011"))) then
							if addrcnt(25) = x"0a" then
								addrcnt(25) <= (others => '0');
							elsif addrcnt(25) = x"15" then
								addrcnt(25) <= x"0b";
							elsif addrcnt(25) = x"20" then
								addrcnt(25) <= x"16";
							elsif addrcnt(25) = x"2b" then
								addrcnt(25) <= x"21";
							elsif addrcnt(25) = x"36" then
								addrcnt(25) <= x"2c";
							elsif addrcnt(25) = x"41" then
								addrcnt(25) <= x"37";
							elsif addrcnt(25) = x"4c" then
								addrcnt(25) <= x"42";
							elsif addrcnt(25) = x"57" then
								addrcnt(25) <= x"4d";
							elsif addrcnt(25) = x"62" then
								addrcnt(25) <= x"58";
							elsif addrcnt(25) = x"6d" then
								addrcnt(25) <= x"63";
							elsif addrcnt(25) = x"78" then
								addrcnt(25) <= x"6e";
							elsif addrcnt(25) = x"83" then
								addrcnt(25) <= x"79";
							elsif addrcnt(25) = x"8e" then
								addrcnt(25) <= x"84";
							elsif addrcnt(25) = x"99" then
								addrcnt(25) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +442 ) ) and ( hsync_cnt <= (tHW + tHBP +452)) ) then
					if (p2_c4 = "000000" )or (p2_c4 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
						if(((p2_c5 = "000000" )or (p2_c5 = "001101"))or ((p2_c6 = "000000" )or (p2_c6 = "001101"))) then
							if addrcnt(0) = x"0a" then
								addrcnt(0) <= (others => '0');
							elsif addrcnt(0) = x"15" then
								addrcnt(0) <= x"0b";
							elsif addrcnt(0) = x"20" then
								addrcnt(0) <= x"16";
							elsif addrcnt(0) = x"2b" then
								addrcnt(0) <= x"21";
							elsif addrcnt(0) = x"36" then
								addrcnt(0) <= x"2c";
							elsif addrcnt(0) = x"41" then
								addrcnt(0) <= x"37";
							elsif addrcnt(0) = x"4c" then
								addrcnt(0) <= x"42";
							elsif addrcnt(0) = x"57" then
								addrcnt(0) <= x"4d";
							elsif addrcnt(0) = x"62" then
								addrcnt(0) <= x"58";
							elsif addrcnt(0) = x"6d" then
								addrcnt(0) <= x"63";
							elsif addrcnt(0) = x"78" then
								addrcnt(0) <= x"6e";
							elsif addrcnt(0) = x"83" then
								addrcnt(0) <= x"79";
							elsif addrcnt(0) = x"8e" then
								addrcnt(0) <= x"84";
							elsif addrcnt(0) = x"99" then
								addrcnt(0) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "000001" )or (p2_c4 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
						if( ((p2_c5 = "000001" )or (p2_c5 = "001110"))or ((p2_c6 = "000001" )or (p2_c6 = "001110"))) then
							if addrcnt(1) = x"0a" then
								addrcnt(1) <= (others => '0');
							elsif addrcnt(1) = x"15" then
								addrcnt(1) <= x"0b";
							elsif addrcnt(1) = x"20" then
								addrcnt(1) <= x"16";
							elsif addrcnt(1) = x"2b" then
								addrcnt(1) <= x"21";
							elsif addrcnt(1) = x"36" then
								addrcnt(1) <= x"2c";
							elsif addrcnt(1) = x"41" then
								addrcnt(1) <= x"37";
							elsif addrcnt(1) = x"4c" then
								addrcnt(1) <= x"42";
							elsif addrcnt(1) = x"57" then
								addrcnt(1) <= x"4d";
							elsif addrcnt(1) = x"62" then
								addrcnt(1) <= x"58";
							elsif addrcnt(1) = x"6d" then
								addrcnt(1) <= x"63";
							elsif addrcnt(1) = x"78" then
								addrcnt(1) <= x"6e";
							elsif addrcnt(1) = x"83" then
								addrcnt(1) <= x"79";
							elsif addrcnt(1) = x"8e" then
								addrcnt(1) <= x"84";
							elsif addrcnt(1) = x"99" then
								addrcnt(1) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "000010" )or (p2_c4 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
						if( ((p2_c5 = "000010" )or (p2_c5 = "001111"))or ((p2_c6 = "000010" )or (p2_c6 = "001111"))) then
							if addrcnt(2) = x"0a" then
								addrcnt(2) <= (others => '0');
							elsif addrcnt(2) = x"15" then
								addrcnt(2) <= x"0b";
							elsif addrcnt(2) = x"20" then
								addrcnt(2) <= x"16";
							elsif addrcnt(2) = x"2b" then
								addrcnt(2) <= x"21";
							elsif addrcnt(2) = x"36" then
								addrcnt(2) <= x"2c";
							elsif addrcnt(2) = x"41" then
								addrcnt(2) <= x"37";
							elsif addrcnt(2) = x"4c" then
								addrcnt(2) <= x"42";
							elsif addrcnt(2) = x"57" then
								addrcnt(2) <= x"4d";
							elsif addrcnt(2) = x"62" then
								addrcnt(2) <= x"58";
							elsif addrcnt(2) = x"6d" then
								addrcnt(2) <= x"63";
							elsif addrcnt(2) = x"78" then
								addrcnt(2) <= x"6e";
							elsif addrcnt(2) = x"83" then
								addrcnt(2) <= x"79";
							elsif addrcnt(2) = x"8e" then
								addrcnt(2) <= x"84";
							elsif addrcnt(2) = x"99" then
								addrcnt(2) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "000011" )or (p2_c4 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
						if(  ((p2_c5 = "000011" )or (p2_c5 = "010000"))or ((p2_c6 = "000011" )or (p2_c6 = "010000"))) then
							if addrcnt(3) = x"0a" then
								addrcnt(3) <= (others => '0');
							elsif addrcnt(3) = x"15" then
								addrcnt(3) <= x"0b";
							elsif addrcnt(3) = x"20" then
								addrcnt(3) <= x"16";
							elsif addrcnt(3) = x"2b" then
								addrcnt(3) <= x"21";
							elsif addrcnt(3) = x"36" then
								addrcnt(3) <= x"2c";
							elsif addrcnt(3) = x"41" then
								addrcnt(3) <= x"37";
							elsif addrcnt(3) = x"4c" then
								addrcnt(3) <= x"42";
							elsif addrcnt(3) = x"57" then
								addrcnt(3) <= x"4d";
							elsif addrcnt(3) = x"62" then
								addrcnt(3) <= x"58";
							elsif addrcnt(3) = x"6d" then
								addrcnt(3) <= x"63";
							elsif addrcnt(3) = x"78" then
								addrcnt(3) <= x"6e";
							elsif addrcnt(3) = x"83" then
								addrcnt(3) <= x"79";
							elsif addrcnt(3) = x"8e" then
								addrcnt(3) <= x"84";
							elsif addrcnt(3) = x"99" then
								addrcnt(3) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "000100" )or (p2_c4 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);
						if( ((p2_c5 = "000100" )or (p2_c5 = "010001"))or ((p2_c6 = "000100" )or (p2_c6 = "010001"))) then
							if addrcnt(4) = x"0a" then
								addrcnt(4) <= (others => '0');
							elsif addrcnt(4) = x"15" then
								addrcnt(4) <= x"0b";
							elsif addrcnt(4) = x"20" then
								addrcnt(4) <= x"16";
							elsif addrcnt(4) = x"2b" then
								addrcnt(4) <= x"21";
							elsif addrcnt(4) = x"36" then
								addrcnt(4) <= x"2c";
							elsif addrcnt(4) = x"41" then
								addrcnt(4) <= x"37";
							elsif addrcnt(4) = x"4c" then
								addrcnt(4) <= x"42";
							elsif addrcnt(4) = x"57" then
								addrcnt(4) <= x"4d";
							elsif addrcnt(4) = x"62" then
								addrcnt(4) <= x"58";
							elsif addrcnt(4) = x"6d" then
								addrcnt(4) <= x"63";
							elsif addrcnt(4) = x"78" then
								addrcnt(4) <= x"6e";
							elsif addrcnt(4) = x"83" then
								addrcnt(4) <= x"79";
							elsif addrcnt(4) = x"8e" then
								addrcnt(4) <= x"84";
							elsif addrcnt(4) = x"99" then
								addrcnt(4) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "000101" )or (p2_c4 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);
						if( ((p2_c5 = "000101" )or (p2_c5 = "010010"))or ((p2_c6 = "000101" )or (p2_c6 = "010010"))) then
							if addrcnt(5) = x"0a" then
								addrcnt(5) <= (others => '0');
							elsif addrcnt(5) = x"15" then
								addrcnt(5) <= x"0b";
							elsif addrcnt(5) = x"20" then
								addrcnt(5) <= x"16";
							elsif addrcnt(5) = x"2b" then
								addrcnt(5) <= x"21";
							elsif addrcnt(5) = x"36" then
								addrcnt(5) <= x"2c";
							elsif addrcnt(5) = x"41" then
								addrcnt(5) <= x"37";
							elsif addrcnt(5) = x"4c" then
								addrcnt(5) <= x"42";
							elsif addrcnt(5) = x"57" then
								addrcnt(5) <= x"4d";
							elsif addrcnt(5) = x"62" then
								addrcnt(5) <= x"58";
							elsif addrcnt(5) = x"6d" then
								addrcnt(5) <= x"63";
							elsif addrcnt(5) = x"78" then
								addrcnt(5) <= x"6e";
							elsif addrcnt(5) = x"83" then
								addrcnt(5) <= x"79";
							elsif addrcnt(5) = x"8e" then
								addrcnt(5) <= x"84";
							elsif addrcnt(5) = x"99" then
								addrcnt(5) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "000110" )or (p2_c4 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);
						if( ((p2_c5 = "000110" )or (p2_c5 = "010011"))or ((p2_c6 = "000110" )or (p2_c6 = "010011"))) then
							if addrcnt(6) = x"0a" then
								addrcnt(6) <= (others => '0');
							elsif addrcnt(6) = x"15" then
								addrcnt(6) <= x"0b";
							elsif addrcnt(6) = x"20" then
								addrcnt(6) <= x"16";
							elsif addrcnt(6) = x"2b" then
								addrcnt(6) <= x"21";
							elsif addrcnt(6) = x"36" then
								addrcnt(6) <= x"2c";
							elsif addrcnt(6) = x"41" then
								addrcnt(6) <= x"37";
							elsif addrcnt(6) = x"4c" then
								addrcnt(6) <= x"42";
							elsif addrcnt(6) = x"57" then
								addrcnt(6) <= x"4d";
							elsif addrcnt(6) = x"62" then
								addrcnt(6) <= x"58";
							elsif addrcnt(6) = x"6d" then
								addrcnt(6) <= x"63";
							elsif addrcnt(6) = x"78" then
								addrcnt(6) <= x"6e";
							elsif addrcnt(6) = x"83" then
								addrcnt(6) <= x"79";
							elsif addrcnt(6) = x"8e" then
								addrcnt(6) <= x"84";
							elsif addrcnt(6) = x"99" then
								addrcnt(6) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "000111" )or (p2_c4 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);
						if( ((p2_c5 = "000111" )or (p2_c5 = "010100"))or ((p2_c6 = "000111" )or (p2_c6 = "010100"))) then
							if addrcnt(7) = x"0a" then
								addrcnt(7) <= (others => '0');
							elsif addrcnt(7) = x"15" then
								addrcnt(7) <= x"0b";
							elsif addrcnt(7) = x"20" then
								addrcnt(7) <= x"16";
							elsif addrcnt(7) = x"2b" then
								addrcnt(7) <= x"21";
							elsif addrcnt(7) = x"36" then
								addrcnt(7) <= x"2c";
							elsif addrcnt(7) = x"41" then
								addrcnt(7) <= x"37";
							elsif addrcnt(7) = x"4c" then
								addrcnt(7) <= x"42";
							elsif addrcnt(7) = x"57" then
								addrcnt(7) <= x"4d";
							elsif addrcnt(7) = x"62" then
								addrcnt(7) <= x"58";
							elsif addrcnt(7) = x"6d" then
								addrcnt(7) <= x"63";
							elsif addrcnt(7) = x"78" then
								addrcnt(7) <= x"6e";
							elsif addrcnt(7) = x"83" then
								addrcnt(7) <= x"79";
							elsif addrcnt(7) = x"8e" then
								addrcnt(7) <= x"84";
							elsif addrcnt(7) = x"99" then
								addrcnt(7) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "001000" )or (p2_c4 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
						if( ((p2_c5 = "001000" )or (p2_c5 = "010101"))or ((p2_c6 = "001000" )or (p2_c6 = "010101"))) then
							if addrcnt(8) = x"0a" then
								addrcnt(8) <= (others => '0');
							elsif addrcnt(8) = x"15" then
								addrcnt(8) <= x"0b";
							elsif addrcnt(8) = x"20" then
								addrcnt(8) <= x"16";
							elsif addrcnt(8) = x"2b" then
								addrcnt(8) <= x"21";
							elsif addrcnt(8) = x"36" then
								addrcnt(8) <= x"2c";
							elsif addrcnt(8) = x"41" then
								addrcnt(8) <= x"37";
							elsif addrcnt(8) = x"4c" then
								addrcnt(8) <= x"42";
							elsif addrcnt(8) = x"57" then
								addrcnt(8) <= x"4d";
							elsif addrcnt(8) = x"62" then
								addrcnt(8) <= x"58";
							elsif addrcnt(8) = x"6d" then
								addrcnt(8) <= x"63";
							elsif addrcnt(8) = x"78" then
								addrcnt(8) <= x"6e";
							elsif addrcnt(8) = x"83" then
								addrcnt(8) <= x"79";
							elsif addrcnt(8) = x"8e" then
								addrcnt(8) <= x"84";
							elsif addrcnt(8) = x"99" then
								addrcnt(8) <= x"8f";
							end if;
						end if;
					elsif (p2_c4= "001001" )or (p2_c4 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);
						if(((p2_c5 = "001001" )or (p2_c5 = "010110"))or ((p2_c6 = "001001" )or (p2_c6 = "010110"))) then
							if addrcnt(9) = x"0a" then
								addrcnt(9) <= (others => '0');
							elsif addrcnt(9) = x"15" then
								addrcnt(9) <= x"0b";
							elsif addrcnt(9) = x"20" then
								addrcnt(9) <= x"16";
							elsif addrcnt(9) = x"2b" then
								addrcnt(9) <= x"21";
							elsif addrcnt(9) = x"36" then
								addrcnt(9) <= x"2c";
							elsif addrcnt(9) = x"41" then
								addrcnt(9) <= x"37";
							elsif addrcnt(9) = x"4c" then
								addrcnt(9) <= x"42";
							elsif addrcnt(9) = x"57" then
								addrcnt(9) <= x"4d";
							elsif addrcnt(9) = x"62" then
								addrcnt(9) <= x"58";
							elsif addrcnt(9) = x"6d" then
								addrcnt(9) <= x"63";
							elsif addrcnt(9) = x"78" then
								addrcnt(9) <= x"6e";
							elsif addrcnt(9) = x"83" then
								addrcnt(9) <= x"79";
							elsif addrcnt(9) = x"8e" then
								addrcnt(9) <= x"84";
							elsif addrcnt(9) = x"99" then
								addrcnt(9) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "001010" )or (p2_c4 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);
						if(((p2_c5 = "001010" )or (p2_c5 = "010111"))or ((p2_c6 = "001010" )or (p2_c6 = "010111"))) then
							if addrcnt(10) = x"0a" then
								addrcnt(10) <= (others => '0');
							elsif addrcnt(10) = x"15" then
								addrcnt(10) <= x"0b";
							elsif addrcnt(10) = x"20" then
								addrcnt(10) <= x"16";
							elsif addrcnt(10) = x"2b" then
								addrcnt(10) <= x"21";
							elsif addrcnt(10) = x"36" then
								addrcnt(10) <= x"2c";
							elsif addrcnt(10) = x"41" then
								addrcnt(10) <= x"37";
							elsif addrcnt(10) = x"4c" then
								addrcnt(10) <= x"42";
							elsif addrcnt(10) = x"57" then
								addrcnt(10) <= x"4d";
							elsif addrcnt(10) = x"62" then
								addrcnt(10) <= x"58";
							elsif addrcnt(10) = x"6d" then
								addrcnt(10) <= x"63";
							elsif addrcnt(10) = x"78" then
								addrcnt(10) <= x"6e";
							elsif addrcnt(10) = x"83" then
								addrcnt(10) <= x"79";
							elsif addrcnt(10) = x"8e" then
								addrcnt(10) <= x"84";
							elsif addrcnt(10) = x"99" then
								addrcnt(10) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "001011" )or (p2_c4 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);
						if(((p2_c5 = "001011" )or (p2_c5 = "011000"))or ((p2_c6 = "001011" )or (p2_c6 = "011000"))) then
							if addrcnt(11) = x"0a" then
								addrcnt(11) <= (others => '0');
							elsif addrcnt(11) = x"15" then
								addrcnt(11) <= x"0b";
							elsif addrcnt(11) = x"20" then
								addrcnt(11) <= x"16";
							elsif addrcnt(11) = x"2b" then
								addrcnt(11) <= x"21";
							elsif addrcnt(11) = x"36" then
								addrcnt(11) <= x"2c";
							elsif addrcnt(11) = x"41" then
								addrcnt(11) <= x"37";
							elsif addrcnt(11) = x"4c" then
								addrcnt(11) <= x"42";
							elsif addrcnt(11) = x"57" then
								addrcnt(11) <= x"4d";
							elsif addrcnt(11) = x"62" then
								addrcnt(11) <= x"58";
							elsif addrcnt(11) = x"6d" then
								addrcnt(11) <= x"63";
							elsif addrcnt(11) = x"78" then
								addrcnt(11) <= x"6e";
							elsif addrcnt(11) = x"83" then
								addrcnt(11) <= x"79";
							elsif addrcnt(11) = x"8e" then
								addrcnt(11) <= x"84";
							elsif addrcnt(11) = x"99" then
								addrcnt(11) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "001100" )or (p2_c4 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
						if( ((p2_c5 = "001100" )or (p2_c5 = "011001"))or ((p2_c6 = "001100" )or (p2_c6 = "011001"))) then
							if addrcnt(12) = x"0a" then
								addrcnt(12) <= (others => '0');
							elsif addrcnt(12) = x"15" then
								addrcnt(12) <= x"0b";
							elsif addrcnt(12) = x"20" then
								addrcnt(12) <= x"16";
							elsif addrcnt(12) = x"2b" then
								addrcnt(12) <= x"21";
							elsif addrcnt(12) = x"36" then
								addrcnt(12) <= x"2c";
							elsif addrcnt(12) = x"41" then
								addrcnt(12) <= x"37";
							elsif addrcnt(12) = x"4c" then
								addrcnt(12) <= x"42";
							elsif addrcnt(12) = x"57" then
								addrcnt(12) <= x"4d";
							elsif addrcnt(12) = x"62" then
								addrcnt(12) <= x"58";
							elsif addrcnt(12) = x"6d" then
								addrcnt(12) <= x"63";
							elsif addrcnt(12) = x"78" then
								addrcnt(12) <= x"6e";
							elsif addrcnt(12) = x"83" then
								addrcnt(12) <= x"79";
							elsif addrcnt(12) = x"8e" then
								addrcnt(12) <= x"84";
							elsif addrcnt(12) = x"99" then
								addrcnt(12) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "011010" )or (p2_c4 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
						if (((p2_c5 = "011010" )or (p2_c5 = "100111"))or ((p2_c6 = "011010" )or (p2_c6 = "100111"))) then
							if addrcnt(13) = x"0a" then
								addrcnt(13) <= (others => '0');
							elsif addrcnt(13) = x"15" then
								addrcnt(13) <= x"0b";
							elsif addrcnt(13) = x"20" then
								addrcnt(13) <= x"16";
							elsif addrcnt(13) = x"2b" then
								addrcnt(13) <= x"21";
							elsif addrcnt(13) = x"36" then
								addrcnt(13) <= x"2c";
							elsif addrcnt(13) = x"41" then
								addrcnt(13) <= x"37";
							elsif addrcnt(13) = x"4c" then
								addrcnt(13) <= x"42";
							elsif addrcnt(13) = x"57" then
								addrcnt(13) <= x"4d";
							elsif addrcnt(13) = x"62" then
								addrcnt(13) <= x"58";
							elsif addrcnt(13) = x"6d" then
								addrcnt(13) <= x"63";
							elsif addrcnt(13) = x"78" then
								addrcnt(13) <= x"6e";
							elsif addrcnt(13) = x"83" then
								addrcnt(13) <= x"79";
							elsif addrcnt(13) = x"8e" then
								addrcnt(13) <= x"84";
							elsif addrcnt(13) = x"99" then
								addrcnt(13) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "011011" )or (p2_c4 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
						if( ((p2_c5 = "011011" )or (p2_c5 = "101000"))or ((p2_c6 = "011011" )or (p2_c6 = "101000"))) then
							if addrcnt(14) = x"0a" then
								addrcnt(14) <= (others => '0');
							elsif addrcnt(14) = x"15" then
								addrcnt(14) <= x"0b";
							elsif addrcnt(14) = x"20" then
								addrcnt(14) <= x"16";
							elsif addrcnt(14) = x"2b" then
								addrcnt(14) <= x"21";
							elsif addrcnt(14) = x"36" then
								addrcnt(14) <= x"2c";
							elsif addrcnt(14) = x"41" then
								addrcnt(14) <= x"37";
							elsif addrcnt(14) = x"4c" then
								addrcnt(14) <= x"42";
							elsif addrcnt(14) = x"57" then
								addrcnt(14) <= x"4d";
							elsif addrcnt(14) = x"62" then
								addrcnt(14) <= x"58";
							elsif addrcnt(14) = x"6d" then
								addrcnt(14) <= x"63";
							elsif addrcnt(14) = x"78" then
								addrcnt(14) <= x"6e";
							elsif addrcnt(14) = x"83" then
								addrcnt(14) <= x"79";
							elsif addrcnt(14) = x"8e" then
								addrcnt(14) <= x"84";
							elsif addrcnt(14) = x"99" then
								addrcnt(14) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "011100" )or (p2_c4 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
						if(  ((p2_c5 = "011100" )or (p2_c5 = "101001"))or ((p2_c6 = "011100" )or (p2_c6 = "101001"))) then
							if addrcnt(15) = x"0a" then
								addrcnt(15) <= (others => '0');
							elsif addrcnt(15) = x"15" then
								addrcnt(15) <= x"0b";
							elsif addrcnt(15) = x"20" then
								addrcnt(15) <= x"16";
							elsif addrcnt(15) = x"2b" then
								addrcnt(15) <= x"21";
							elsif addrcnt(15) = x"36" then
								addrcnt(15) <= x"2c";
							elsif addrcnt(15) = x"41" then
								addrcnt(15) <= x"37";
							elsif addrcnt(15) = x"4c" then
								addrcnt(15) <= x"42";
							elsif addrcnt(15) = x"57" then
								addrcnt(15) <= x"4d";
							elsif addrcnt(15) = x"62" then
								addrcnt(15) <= x"58";
							elsif addrcnt(15) = x"6d" then
								addrcnt(15) <= x"63";
							elsif addrcnt(15) = x"78" then
								addrcnt(15) <= x"6e";
							elsif addrcnt(15) = x"83" then
								addrcnt(15) <= x"79";
							elsif addrcnt(15) = x"8e" then
								addrcnt(15) <= x"84";
							elsif addrcnt(15) = x"99" then
								addrcnt(15) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "011101" )or (p2_c4 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
						if(  ((p2_c5 = "011101" )or (p2_c5 = "101010"))or ((p2_c6 = "011101" )or (p2_c6 = "101010"))) then
							if addrcnt(16) = x"0a" then
								addrcnt(16) <= (others => '0');
							elsif addrcnt(16) = x"15" then
								addrcnt(16) <= x"0b";
							elsif addrcnt(16) = x"20" then
								addrcnt(16) <= x"16";
							elsif addrcnt(16) = x"2b" then
								addrcnt(16) <= x"21";
							elsif addrcnt(16) = x"36" then
								addrcnt(16) <= x"2c";
							elsif addrcnt(16) = x"41" then
								addrcnt(16) <= x"37";
							elsif addrcnt(16) = x"4c" then
								addrcnt(16) <= x"42";
							elsif addrcnt(16) = x"57" then
								addrcnt(16) <= x"4d";
							elsif addrcnt(16) = x"62" then
								addrcnt(16) <= x"58";
							elsif addrcnt(16) = x"6d" then
								addrcnt(16) <= x"63";
							elsif addrcnt(16) = x"78" then
								addrcnt(16) <= x"6e";
							elsif addrcnt(16) = x"83" then
								addrcnt(16) <= x"79";
							elsif addrcnt(16) = x"8e" then
								addrcnt(16) <= x"84";
							elsif addrcnt(16) = x"99" then
								addrcnt(16) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "011110" )or (p2_c4 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);
						if(  ((p2_c5 = "011110" )or (p2_c5 = "101011"))or ((p2_c6 = "011110" )or (p2_c6 = "101011"))) then
							if addrcnt(17) = x"0a" then
								addrcnt(17) <= (others => '0');
							elsif addrcnt(17) = x"15" then
								addrcnt(17) <= x"0b";
							elsif addrcnt(17) = x"20" then
								addrcnt(17) <= x"16";
							elsif addrcnt(17) = x"2b" then
								addrcnt(17) <= x"21";
							elsif addrcnt(17) = x"36" then
								addrcnt(17) <= x"2c";
							elsif addrcnt(17) = x"41" then
								addrcnt(17) <= x"37";
							elsif addrcnt(17) = x"4c" then
								addrcnt(17) <= x"42";
							elsif addrcnt(17) = x"57" then
								addrcnt(17) <= x"4d";
							elsif addrcnt(17) = x"62" then
								addrcnt(17) <= x"58";
							elsif addrcnt(17) = x"6d" then
								addrcnt(17) <= x"63";
							elsif addrcnt(17) = x"78" then
								addrcnt(17) <= x"6e";
							elsif addrcnt(17) = x"83" then
								addrcnt(17) <= x"79";
							elsif addrcnt(17) = x"8e" then
								addrcnt(17) <= x"84";
							elsif addrcnt(17) = x"99" then
								addrcnt(17) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "011111" )or (p2_c4 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);
						if( ((p2_c5 = "011111" )or (p2_c5 = "101100"))or ((p2_c6 = "011111" )or (p2_c6 = "101100"))) then
							if addrcnt(18) = x"0a" then
								addrcnt(18) <= (others => '0');
							elsif addrcnt(18) = x"15" then
								addrcnt(18) <= x"0b";
							elsif addrcnt(18) = x"20" then
								addrcnt(18) <= x"16";
							elsif addrcnt(18) = x"2b" then
								addrcnt(18) <= x"21";
							elsif addrcnt(18) = x"36" then
								addrcnt(18) <= x"2c";
							elsif addrcnt(18) = x"41" then
								addrcnt(18) <= x"37";
							elsif addrcnt(18) = x"4c" then
								addrcnt(18) <= x"42";
							elsif addrcnt(18) = x"57" then
								addrcnt(18) <= x"4d";
							elsif addrcnt(18) = x"62" then
								addrcnt(18) <= x"58";
							elsif addrcnt(18) = x"6d" then
								addrcnt(18) <= x"63";
							elsif addrcnt(18) = x"78" then
								addrcnt(18) <= x"6e";
							elsif addrcnt(18) = x"83" then
								addrcnt(18) <= x"79";
							elsif addrcnt(18) = x"8e" then
								addrcnt(18) <= x"84";
							elsif addrcnt(18) = x"99" then
								addrcnt(18) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "100000" )or (p2_c4 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
						if(  ((p2_c5 = "100000" )or (p2_c5 = "101101"))or ((p2_c6 = "100000" )or (p2_c6 = "101101"))) then
							if addrcnt(19) = x"0a" then
								addrcnt(19) <= (others => '0');
							elsif addrcnt(19) = x"15" then
								addrcnt(19) <= x"0b";
							elsif addrcnt(19) = x"20" then
								addrcnt(19) <= x"16";
							elsif addrcnt(19) = x"2b" then
								addrcnt(19) <= x"21";
							elsif addrcnt(19) = x"36" then
								addrcnt(19) <= x"2c";
							elsif addrcnt(19) = x"41" then
								addrcnt(19) <= x"37";
							elsif addrcnt(19) = x"4c" then
								addrcnt(19) <= x"42";
							elsif addrcnt(19) = x"57" then
								addrcnt(19) <= x"4d";
							elsif addrcnt(19) = x"62" then
								addrcnt(19) <= x"58";
							elsif addrcnt(19) = x"6d" then
								addrcnt(19) <= x"63";
							elsif addrcnt(19) = x"78" then
								addrcnt(19) <= x"6e";
							elsif addrcnt(19) = x"83" then
								addrcnt(19) <= x"79";
							elsif addrcnt(19) = x"8e" then
								addrcnt(19) <= x"84";
							elsif addrcnt(19) = x"99" then
								addrcnt(19) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "100001" )or (p2_c4 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
						if(((p2_c5 = "100001" )or (p2_c5 = "101110"))or ((p2_c6 = "100001" )or (p2_c6 = "101110"))) then
							if addrcnt(20) = x"0a" then
								addrcnt(20) <= (others => '0');
							elsif addrcnt(20) = x"15" then
								addrcnt(20) <= x"0b";
							elsif addrcnt(20) = x"20" then
								addrcnt(20) <= x"16";
							elsif addrcnt(20) = x"2b" then
								addrcnt(20) <= x"21";
							elsif addrcnt(20) = x"36" then
								addrcnt(20) <= x"2c";
							elsif addrcnt(20) = x"41" then
								addrcnt(20) <= x"37";
							elsif addrcnt(20) = x"4c" then
								addrcnt(20) <= x"42";
							elsif addrcnt(20) = x"57" then
								addrcnt(20) <= x"4d";
							elsif addrcnt(20) = x"62" then
								addrcnt(20) <= x"58";
							elsif addrcnt(20) = x"6d" then
								addrcnt(20) <= x"63";
							elsif addrcnt(20) = x"78" then
								addrcnt(20) <= x"6e";
							elsif addrcnt(20) = x"83" then
								addrcnt(20) <= x"79";
							elsif addrcnt(20) = x"8e" then
								addrcnt(20) <= x"84";
							elsif addrcnt(20) = x"99" then
								addrcnt(20) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "100010" )or (p2_c4 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
						if( ((p2_c5 = "100010" )or (p2_c5 = "101111"))or ((p2_c6 = "100010" )or (p2_c6 = "101111"))) then
							if addrcnt(21) = x"0a" then
								addrcnt(21) <= (others => '0');
							elsif addrcnt(21) = x"15" then
								addrcnt(21) <= x"0b";
							elsif addrcnt(21) = x"20" then
								addrcnt(21) <= x"16";
							elsif addrcnt(21) = x"2b" then
								addrcnt(21) <= x"21";
							elsif addrcnt(21) = x"36" then
								addrcnt(21) <= x"2c";
							elsif addrcnt(21) = x"41" then
								addrcnt(21) <= x"37";
							elsif addrcnt(21) = x"4c" then
								addrcnt(21) <= x"42";
							elsif addrcnt(21) = x"57" then
								addrcnt(21) <= x"4d";
							elsif addrcnt(21) = x"62" then
								addrcnt(21) <= x"58";
							elsif addrcnt(21) = x"6d" then
								addrcnt(21) <= x"63";
							elsif addrcnt(21) = x"78" then
								addrcnt(21) <= x"6e";
							elsif addrcnt(21) = x"83" then
								addrcnt(21) <= x"79";
							elsif addrcnt(21) = x"8e" then
								addrcnt(21) <= x"84";
							elsif addrcnt(21) = x"99" then
								addrcnt(21) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "100011" )or (p2_c4 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);
						if( ((p2_c5 = "100011" )or (p2_c5 = "110000"))or ((p2_c6 = "100011" )or (p2_c6 = "110000"))) then
							if addrcnt(22) = x"0a" then
								addrcnt(22) <= (others => '0');
							elsif addrcnt(22) = x"15" then
								addrcnt(22) <= x"0b";
							elsif addrcnt(22) = x"20" then
								addrcnt(22) <= x"16";
							elsif addrcnt(22) = x"2b" then
								addrcnt(22) <= x"21";
							elsif addrcnt(22) = x"36" then
								addrcnt(22) <= x"2c";
							elsif addrcnt(22) = x"41" then
								addrcnt(22) <= x"37";
							elsif addrcnt(22) = x"4c" then
								addrcnt(22) <= x"42";
							elsif addrcnt(22) = x"57" then
								addrcnt(22) <= x"4d";
							elsif addrcnt(22) = x"62" then
								addrcnt(22) <= x"58";
							elsif addrcnt(22) = x"6d" then
								addrcnt(22) <= x"63";
							elsif addrcnt(22) = x"78" then
								addrcnt(22) <= x"6e";
							elsif addrcnt(22) = x"83" then
								addrcnt(22) <= x"79";
							elsif addrcnt(22) = x"8e" then
								addrcnt(22) <= x"84";
							elsif addrcnt(22) = x"99" then
								addrcnt(22) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "100100" )or (p2_c4 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
						if(  ((p2_c5 = "100100" )or (p2_c5 = "110001"))or ((p2_c6 = "100100" )or (p2_c6 = "110001"))) then
							if addrcnt(23) = x"0a" then
								addrcnt(23) <= (others => '0');
							elsif addrcnt(23) = x"15" then
								addrcnt(23) <= x"0b";
							elsif addrcnt(23) = x"20" then
								addrcnt(23) <= x"16";
							elsif addrcnt(23) = x"2b" then
								addrcnt(23) <= x"21";
							elsif addrcnt(23) = x"36" then
								addrcnt(23) <= x"2c";
							elsif addrcnt(23) = x"41" then
								addrcnt(23) <= x"37";
							elsif addrcnt(23) = x"4c" then
								addrcnt(23) <= x"42";
							elsif addrcnt(23) = x"57" then
								addrcnt(23) <= x"4d";
							elsif addrcnt(23) = x"62" then
								addrcnt(23) <= x"58";
							elsif addrcnt(23) = x"6d" then
								addrcnt(23) <= x"63";
							elsif addrcnt(23) = x"78" then
								addrcnt(23) <= x"6e";
							elsif addrcnt(23) = x"83" then
								addrcnt(23) <= x"79";
							elsif addrcnt(23) = x"8e" then
								addrcnt(23) <= x"84";
							elsif addrcnt(23) = x"99" then
								addrcnt(23) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "100101" )or (p2_c4 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
						if( ((p2_c5 = "100101" )or (p2_c5 = "110010"))or ((p2_c6 = "100101" )or (p2_c6 = "110010"))) then
							if addrcnt(24) = x"0a" then
								addrcnt(24) <= (others => '0');
							elsif addrcnt(24) = x"15" then
								addrcnt(24) <= x"0b";
							elsif addrcnt(24) = x"20" then
								addrcnt(24) <= x"16";
							elsif addrcnt(24) = x"2b" then
								addrcnt(24) <= x"21";
							elsif addrcnt(24) = x"36" then
								addrcnt(24) <= x"2c";
							elsif addrcnt(24) = x"41" then
								addrcnt(24) <= x"37";
							elsif addrcnt(24) = x"4c" then
								addrcnt(24) <= x"42";
							elsif addrcnt(24) = x"57" then
								addrcnt(24) <= x"4d";
							elsif addrcnt(24) = x"62" then
								addrcnt(24) <= x"58";
							elsif addrcnt(24) = x"6d" then
								addrcnt(24) <= x"63";
							elsif addrcnt(24) = x"78" then
								addrcnt(24) <= x"6e";
							elsif addrcnt(24) = x"83" then
								addrcnt(24) <= x"79";
							elsif addrcnt(24) = x"8e" then
								addrcnt(24) <= x"84";
							elsif addrcnt(24) = x"99" then
								addrcnt(24) <= x"8f";
							end if;
						end if;
					elsif (p2_c4 = "100110" )or (p2_c4 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
						if( ((p2_c5 = "100110" )or (p2_c5 = "110011"))or ((p2_c6 = "100110" )or (p2_c6 = "110011"))) then
							if addrcnt(25) = x"0a" then
								addrcnt(25) <= (others => '0');
							elsif addrcnt(25) = x"15" then
								addrcnt(25) <= x"0b";
							elsif addrcnt(25) = x"20" then
								addrcnt(25) <= x"16";
							elsif addrcnt(25) = x"2b" then
								addrcnt(25) <= x"21";
							elsif addrcnt(25) = x"36" then
								addrcnt(25) <= x"2c";
							elsif addrcnt(25) = x"41" then
								addrcnt(25) <= x"37";
							elsif addrcnt(25) = x"4c" then
								addrcnt(25) <= x"42";
							elsif addrcnt(25) = x"57" then
								addrcnt(25) <= x"4d";
							elsif addrcnt(25) = x"62" then
								addrcnt(25) <= x"58";
							elsif addrcnt(25) = x"6d" then
								addrcnt(25) <= x"63";
							elsif addrcnt(25) = x"78" then
								addrcnt(25) <= x"6e";
							elsif addrcnt(25) = x"83" then
								addrcnt(25) <= x"79";
							elsif addrcnt(25) = x"8e" then
								addrcnt(25) <= x"84";
							elsif addrcnt(25) = x"99" then
								addrcnt(25) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= ( others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +453 ) ) and ( hsync_cnt <= (tHW + tHBP +463)) ) then
					if (p2_c5 = "000000" )or (p2_c5 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
						if(((p2_c6 = "000000" )or (p2_c6 = "001101"))) then
							if addrcnt(0) = x"0a" then
								addrcnt(0) <= (others => '0');
							elsif addrcnt(0) = x"15" then
								addrcnt(0) <= x"0b";
							elsif addrcnt(0) = x"20" then
								addrcnt(0) <= x"16";
							elsif addrcnt(0) = x"2b" then
								addrcnt(0) <= x"21";
							elsif addrcnt(0) = x"36" then
								addrcnt(0) <= x"2c";
							elsif addrcnt(0) = x"41" then
								addrcnt(0) <= x"37";
							elsif addrcnt(0) = x"4c" then
								addrcnt(0) <= x"42";
							elsif addrcnt(0) = x"57" then
								addrcnt(0) <= x"4d";
							elsif addrcnt(0) = x"62" then
								addrcnt(0) <= x"58";
							elsif addrcnt(0) = x"6d" then
								addrcnt(0) <= x"63";
							elsif addrcnt(0) = x"78" then
								addrcnt(0) <= x"6e";
							elsif addrcnt(0) = x"83" then
								addrcnt(0) <= x"79";
							elsif addrcnt(0) = x"8e" then
								addrcnt(0) <= x"84";
							elsif addrcnt(0) = x"99" then
								addrcnt(0) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "000001" )or (p2_c5 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
						if( ((p2_c6 = "000001" )or (p2_c6 = "001110"))) then
							if addrcnt(1) = x"0a" then
								addrcnt(1) <= (others => '0');
							elsif addrcnt(1) = x"15" then
								addrcnt(1) <= x"0b";
							elsif addrcnt(1) = x"20" then
								addrcnt(1) <= x"16";
							elsif addrcnt(1) = x"2b" then
								addrcnt(1) <= x"21";
							elsif addrcnt(1) = x"36" then
								addrcnt(1) <= x"2c";
							elsif addrcnt(1) = x"41" then
								addrcnt(1) <= x"37";
							elsif addrcnt(1) = x"4c" then
								addrcnt(1) <= x"42";
							elsif addrcnt(1) = x"57" then
								addrcnt(1) <= x"4d";
							elsif addrcnt(1) = x"62" then
								addrcnt(1) <= x"58";
							elsif addrcnt(1) = x"6d" then
								addrcnt(1) <= x"63";
							elsif addrcnt(1) = x"78" then
								addrcnt(1) <= x"6e";
							elsif addrcnt(1) = x"83" then
								addrcnt(1) <= x"79";
							elsif addrcnt(1) = x"8e" then
								addrcnt(1) <= x"84";
							elsif addrcnt(1) = x"99" then
								addrcnt(1) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "000010" )or (p2_c5 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
						if( ((p2_c6 = "000010" )or (p2_c6 = "001111"))) then
							if addrcnt(2) = x"0a" then
								addrcnt(2) <= (others => '0');
							elsif addrcnt(2) = x"15" then
								addrcnt(2) <= x"0b";
							elsif addrcnt(2) = x"20" then
								addrcnt(2) <= x"16";
							elsif addrcnt(2) = x"2b" then
								addrcnt(2) <= x"21";
							elsif addrcnt(2) = x"36" then
								addrcnt(2) <= x"2c";
							elsif addrcnt(2) = x"41" then
								addrcnt(2) <= x"37";
							elsif addrcnt(2) = x"4c" then
								addrcnt(2) <= x"42";
							elsif addrcnt(2) = x"57" then
								addrcnt(2) <= x"4d";
							elsif addrcnt(2) = x"62" then
								addrcnt(2) <= x"58";
							elsif addrcnt(2) = x"6d" then
								addrcnt(2) <= x"63";
							elsif addrcnt(2) = x"78" then
								addrcnt(2) <= x"6e";
							elsif addrcnt(2) = x"83" then
								addrcnt(2) <= x"79";
							elsif addrcnt(2) = x"8e" then
								addrcnt(2) <= x"84";
							elsif addrcnt(2) = x"99" then
								addrcnt(2) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "000011" )or (p2_c5 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
						if(  ((p2_c6 = "000011" )or (p2_c6 = "010000"))) then
							if addrcnt(3) = x"0a" then
								addrcnt(3) <= (others => '0');
							elsif addrcnt(3) = x"15" then
								addrcnt(3) <= x"0b";
							elsif addrcnt(3) = x"20" then
								addrcnt(3) <= x"16";
							elsif addrcnt(3) = x"2b" then
								addrcnt(3) <= x"21";
							elsif addrcnt(3) = x"36" then
								addrcnt(3) <= x"2c";
							elsif addrcnt(3) = x"41" then
								addrcnt(3) <= x"37";
							elsif addrcnt(3) = x"4c" then
								addrcnt(3) <= x"42";
							elsif addrcnt(3) = x"57" then
								addrcnt(3) <= x"4d";
							elsif addrcnt(3) = x"62" then
								addrcnt(3) <= x"58";
							elsif addrcnt(3) = x"6d" then
								addrcnt(3) <= x"63";
							elsif addrcnt(3) = x"78" then
								addrcnt(3) <= x"6e";
							elsif addrcnt(3) = x"83" then
								addrcnt(3) <= x"79";
							elsif addrcnt(3) = x"8e" then
								addrcnt(3) <= x"84";
							elsif addrcnt(3) = x"99" then
								addrcnt(3) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "000100" )or (p2_c5 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);
						if( ((p2_c6 = "000100" )or (p2_c6 = "010001"))) then
							if addrcnt(4) = x"0a" then
								addrcnt(4) <= (others => '0');
							elsif addrcnt(4) = x"15" then
								addrcnt(4) <= x"0b";
							elsif addrcnt(4) = x"20" then
								addrcnt(4) <= x"16";
							elsif addrcnt(4) = x"2b" then
								addrcnt(4) <= x"21";
							elsif addrcnt(4) = x"36" then
								addrcnt(4) <= x"2c";
							elsif addrcnt(4) = x"41" then
								addrcnt(4) <= x"37";
							elsif addrcnt(4) = x"4c" then
								addrcnt(4) <= x"42";
							elsif addrcnt(4) = x"57" then
								addrcnt(4) <= x"4d";
							elsif addrcnt(4) = x"62" then
								addrcnt(4) <= x"58";
							elsif addrcnt(4) = x"6d" then
								addrcnt(4) <= x"63";
							elsif addrcnt(4) = x"78" then
								addrcnt(4) <= x"6e";
							elsif addrcnt(4) = x"83" then
								addrcnt(4) <= x"79";
							elsif addrcnt(4) = x"8e" then
								addrcnt(4) <= x"84";
							elsif addrcnt(4) = x"99" then
								addrcnt(4) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "000101" )or (p2_c5 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);
						if(  ((p2_c6 = "000101" )or (p2_c6 = "010010"))) then
							if addrcnt(5) = x"0a" then
								addrcnt(5) <= (others => '0');
							elsif addrcnt(5) = x"15" then
								addrcnt(5) <= x"0b";
							elsif addrcnt(5) = x"20" then
								addrcnt(5) <= x"16";
							elsif addrcnt(5) = x"2b" then
								addrcnt(5) <= x"21";
							elsif addrcnt(5) = x"36" then
								addrcnt(5) <= x"2c";
							elsif addrcnt(5) = x"41" then
								addrcnt(5) <= x"37";
							elsif addrcnt(5) = x"4c" then
								addrcnt(5) <= x"42";
							elsif addrcnt(5) = x"57" then
								addrcnt(5) <= x"4d";
							elsif addrcnt(5) = x"62" then
								addrcnt(5) <= x"58";
							elsif addrcnt(5) = x"6d" then
								addrcnt(5) <= x"63";
							elsif addrcnt(5) = x"78" then
								addrcnt(5) <= x"6e";
							elsif addrcnt(5) = x"83" then
								addrcnt(5) <= x"79";
							elsif addrcnt(5) = x"8e" then
								addrcnt(5) <= x"84";
							elsif addrcnt(5) = x"99" then
								addrcnt(5) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "000110" )or (p2_c5 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);
						if(  ((p2_c6 = "000110" )or (p2_c6 = "010011"))) then
							if addrcnt(6) = x"0a" then
								addrcnt(6) <= (others => '0');
							elsif addrcnt(6) = x"15" then
								addrcnt(6) <= x"0b";
							elsif addrcnt(6) = x"20" then
								addrcnt(6) <= x"16";
							elsif addrcnt(6) = x"2b" then
								addrcnt(6) <= x"21";
							elsif addrcnt(6) = x"36" then
								addrcnt(6) <= x"2c";
							elsif addrcnt(6) = x"41" then
								addrcnt(6) <= x"37";
							elsif addrcnt(6) = x"4c" then
								addrcnt(6) <= x"42";
							elsif addrcnt(6) = x"57" then
								addrcnt(6) <= x"4d";
							elsif addrcnt(6) = x"62" then
								addrcnt(6) <= x"58";
							elsif addrcnt(6) = x"6d" then
								addrcnt(6) <= x"63";
							elsif addrcnt(6) = x"78" then
								addrcnt(6) <= x"6e";
							elsif addrcnt(6) = x"83" then
								addrcnt(6) <= x"79";
							elsif addrcnt(6) = x"8e" then
								addrcnt(6) <= x"84";
							elsif addrcnt(6) = x"99" then
								addrcnt(6) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "000111" )or (p2_c5 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);
						if(((p2_c6 = "000111" )or (p2_c6 = "010100"))) then
							if addrcnt(7) = x"0a" then
								addrcnt(7) <= (others => '0');
							elsif addrcnt(7) = x"15" then
								addrcnt(7) <= x"0b";
							elsif addrcnt(7) = x"20" then
								addrcnt(7) <= x"16";
							elsif addrcnt(7) = x"2b" then
								addrcnt(7) <= x"21";
							elsif addrcnt(7) = x"36" then
								addrcnt(7) <= x"2c";
							elsif addrcnt(7) = x"41" then
								addrcnt(7) <= x"37";
							elsif addrcnt(7) = x"4c" then
								addrcnt(7) <= x"42";
							elsif addrcnt(7) = x"57" then
								addrcnt(7) <= x"4d";
							elsif addrcnt(7) = x"62" then
								addrcnt(7) <= x"58";
							elsif addrcnt(7) = x"6d" then
								addrcnt(7) <= x"63";
							elsif addrcnt(7) = x"78" then
								addrcnt(7) <= x"6e";
							elsif addrcnt(7) = x"83" then
								addrcnt(7) <= x"79";
							elsif addrcnt(7) = x"8e" then
								addrcnt(7) <= x"84";
							elsif addrcnt(7) = x"99" then
								addrcnt(7) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "001000" )or (p2_c5 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
						if( ((p2_c6 = "001000" )or (p2_c6 = "010101"))) then
							if addrcnt(8) = x"0a" then
								addrcnt(8) <= (others => '0');
							elsif addrcnt(8) = x"15" then
								addrcnt(8) <= x"0b";
							elsif addrcnt(8) = x"20" then
								addrcnt(8) <= x"16";
							elsif addrcnt(8) = x"2b" then
								addrcnt(8) <= x"21";
							elsif addrcnt(8) = x"36" then
								addrcnt(8) <= x"2c";
							elsif addrcnt(8) = x"41" then
								addrcnt(8) <= x"37";
							elsif addrcnt(8) = x"4c" then
								addrcnt(8) <= x"42";
							elsif addrcnt(8) = x"57" then
								addrcnt(8) <= x"4d";
							elsif addrcnt(8) = x"62" then
								addrcnt(8) <= x"58";
							elsif addrcnt(8) = x"6d" then
								addrcnt(8) <= x"63";
							elsif addrcnt(8) = x"78" then
								addrcnt(8) <= x"6e";
							elsif addrcnt(8) = x"83" then
								addrcnt(8) <= x"79";
							elsif addrcnt(8) = x"8e" then
								addrcnt(8) <= x"84";
							elsif addrcnt(8) = x"99" then
								addrcnt(8) <= x"8f";
							end if;
						end if;
					elsif (p2_c5= "001001" )or (p2_c5 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);
						if(((p2_c6 = "001001" )or (p2_c6 = "010110"))) then
							if addrcnt(9) = x"0a" then
								addrcnt(9) <= (others => '0');
							elsif addrcnt(9) = x"15" then
								addrcnt(9) <= x"0b";
							elsif addrcnt(9) = x"20" then
								addrcnt(9) <= x"16";
							elsif addrcnt(9) = x"2b" then
								addrcnt(9) <= x"21";
							elsif addrcnt(9) = x"36" then
								addrcnt(9) <= x"2c";
							elsif addrcnt(9) = x"41" then
								addrcnt(9) <= x"37";
							elsif addrcnt(9) = x"4c" then
								addrcnt(9) <= x"42";
							elsif addrcnt(9) = x"57" then
								addrcnt(9) <= x"4d";
							elsif addrcnt(9) = x"62" then
								addrcnt(9) <= x"58";
							elsif addrcnt(9) = x"6d" then
								addrcnt(9) <= x"63";
							elsif addrcnt(9) = x"78" then
								addrcnt(9) <= x"6e";
							elsif addrcnt(9) = x"83" then
								addrcnt(9) <= x"79";
							elsif addrcnt(9) = x"8e" then
								addrcnt(9) <= x"84";
							elsif addrcnt(9) = x"99" then
								addrcnt(9) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "001010" )or (p2_c5 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);
						if(((p2_c6 = "001010" )or (p2_c6 = "010111"))) then
							if addrcnt(10) = x"0a" then
								addrcnt(10) <= (others => '0');
							elsif addrcnt(10) = x"15" then
								addrcnt(10) <= x"0b";
							elsif addrcnt(10) = x"20" then
								addrcnt(10) <= x"16";
							elsif addrcnt(10) = x"2b" then
								addrcnt(10) <= x"21";
							elsif addrcnt(10) = x"36" then
								addrcnt(10) <= x"2c";
							elsif addrcnt(10) = x"41" then
								addrcnt(10) <= x"37";
							elsif addrcnt(10) = x"4c" then
								addrcnt(10) <= x"42";
							elsif addrcnt(10) = x"57" then
								addrcnt(10) <= x"4d";
							elsif addrcnt(10) = x"62" then
								addrcnt(10) <= x"58";
							elsif addrcnt(10) = x"6d" then
								addrcnt(10) <= x"63";
							elsif addrcnt(10) = x"78" then
								addrcnt(10) <= x"6e";
							elsif addrcnt(10) = x"83" then
								addrcnt(10) <= x"79";
							elsif addrcnt(10) = x"8e" then
								addrcnt(10) <= x"84";
							elsif addrcnt(10) = x"99" then
								addrcnt(10) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "001011" )or (p2_c5 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);
						if(((p2_c6 = "001011" )or (p2_c6 = "011000"))) then
							if addrcnt(11) = x"0a" then
								addrcnt(11) <= (others => '0');
							elsif addrcnt(11) = x"15" then
								addrcnt(11) <= x"0b";
							elsif addrcnt(11) = x"20" then
								addrcnt(11) <= x"16";
							elsif addrcnt(11) = x"2b" then
								addrcnt(11) <= x"21";
							elsif addrcnt(11) = x"36" then
								addrcnt(11) <= x"2c";
							elsif addrcnt(11) = x"41" then
								addrcnt(11) <= x"37";
							elsif addrcnt(11) = x"4c" then
								addrcnt(11) <= x"42";
							elsif addrcnt(11) = x"57" then
								addrcnt(11) <= x"4d";
							elsif addrcnt(11) = x"62" then
								addrcnt(11) <= x"58";
							elsif addrcnt(11) = x"6d" then
								addrcnt(11) <= x"63";
							elsif addrcnt(11) = x"78" then
								addrcnt(11) <= x"6e";
							elsif addrcnt(11) = x"83" then
								addrcnt(11) <= x"79";
							elsif addrcnt(11) = x"8e" then
								addrcnt(11) <= x"84";
							elsif addrcnt(11) = x"99" then
								addrcnt(11) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "001100" )or (p2_c5 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
						if( ((p2_c6 = "001100" )or (p2_c6 = "011001"))) then
							if addrcnt(12) = x"0a" then
								addrcnt(12) <= (others => '0');
							elsif addrcnt(12) = x"15" then
								addrcnt(12) <= x"0b";
							elsif addrcnt(12) = x"20" then
								addrcnt(12) <= x"16";
							elsif addrcnt(12) = x"2b" then
								addrcnt(12) <= x"21";
							elsif addrcnt(12) = x"36" then
								addrcnt(12) <= x"2c";
							elsif addrcnt(12) = x"41" then
								addrcnt(12) <= x"37";
							elsif addrcnt(12) = x"4c" then
								addrcnt(12) <= x"42";
							elsif addrcnt(12) = x"57" then
								addrcnt(12) <= x"4d";
							elsif addrcnt(12) = x"62" then
								addrcnt(12) <= x"58";
							elsif addrcnt(12) = x"6d" then
								addrcnt(12) <= x"63";
							elsif addrcnt(12) = x"78" then
								addrcnt(12) <= x"6e";
							elsif addrcnt(12) = x"83" then
								addrcnt(12) <= x"79";
							elsif addrcnt(12) = x"8e" then
								addrcnt(12) <= x"84";
							elsif addrcnt(12) = x"99" then
								addrcnt(12) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "011010" )or (p2_c5 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
						if ( ((p2_c6 = "011010" )or (p2_c6 = "100111"))) then
							if addrcnt(13) = x"0a" then
								addrcnt(13) <= (others => '0');
							elsif addrcnt(13) = x"15" then
								addrcnt(13) <= x"0b";
							elsif addrcnt(13) = x"20" then
								addrcnt(13) <= x"16";
							elsif addrcnt(13) = x"2b" then
								addrcnt(13) <= x"21";
							elsif addrcnt(13) = x"36" then
								addrcnt(13) <= x"2c";
							elsif addrcnt(13) = x"41" then
								addrcnt(13) <= x"37";
							elsif addrcnt(13) = x"4c" then
								addrcnt(13) <= x"42";
							elsif addrcnt(13) = x"57" then
								addrcnt(13) <= x"4d";
							elsif addrcnt(13) = x"62" then
								addrcnt(13) <= x"58";
							elsif addrcnt(13) = x"6d" then
								addrcnt(13) <= x"63";
							elsif addrcnt(13) = x"78" then
								addrcnt(13) <= x"6e";
							elsif addrcnt(13) = x"83" then
								addrcnt(13) <= x"79";
							elsif addrcnt(13) = x"8e" then
								addrcnt(13) <= x"84";
							elsif addrcnt(13) = x"99" then
								addrcnt(13) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "011011" )or (p2_c5 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
						if( ((p2_c6 = "011011" )or (p2_c6 = "101000"))) then
							if addrcnt(14) = x"0a" then
								addrcnt(14) <= (others => '0');
							elsif addrcnt(14) = x"15" then
								addrcnt(14) <= x"0b";
							elsif addrcnt(14) = x"20" then
								addrcnt(14) <= x"16";
							elsif addrcnt(14) = x"2b" then
								addrcnt(14) <= x"21";
							elsif addrcnt(14) = x"36" then
								addrcnt(14) <= x"2c";
							elsif addrcnt(14) = x"41" then
								addrcnt(14) <= x"37";
							elsif addrcnt(14) = x"4c" then
								addrcnt(14) <= x"42";
							elsif addrcnt(14) = x"57" then
								addrcnt(14) <= x"4d";
							elsif addrcnt(14) = x"62" then
								addrcnt(14) <= x"58";
							elsif addrcnt(14) = x"6d" then
								addrcnt(14) <= x"63";
							elsif addrcnt(14) = x"78" then
								addrcnt(14) <= x"6e";
							elsif addrcnt(14) = x"83" then
								addrcnt(14) <= x"79";
							elsif addrcnt(14) = x"8e" then
								addrcnt(14) <= x"84";
							elsif addrcnt(14) = x"99" then
								addrcnt(14) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "011100" )or (p2_c5 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
						if(  ((p2_c6 = "011100" )or (p2_c6 = "101001"))) then
							if addrcnt(15) = x"0a" then
								addrcnt(15) <= (others => '0');
							elsif addrcnt(15) = x"15" then
								addrcnt(15) <= x"0b";
							elsif addrcnt(15) = x"20" then
								addrcnt(15) <= x"16";
							elsif addrcnt(15) = x"2b" then
								addrcnt(15) <= x"21";
							elsif addrcnt(15) = x"36" then
								addrcnt(15) <= x"2c";
							elsif addrcnt(15) = x"41" then
								addrcnt(15) <= x"37";
							elsif addrcnt(15) = x"4c" then
								addrcnt(15) <= x"42";
							elsif addrcnt(15) = x"57" then
								addrcnt(15) <= x"4d";
							elsif addrcnt(15) = x"62" then
								addrcnt(15) <= x"58";
							elsif addrcnt(15) = x"6d" then
								addrcnt(15) <= x"63";
							elsif addrcnt(15) = x"78" then
								addrcnt(15) <= x"6e";
							elsif addrcnt(15) = x"83" then
								addrcnt(15) <= x"79";
							elsif addrcnt(15) = x"8e" then
								addrcnt(15) <= x"84";
							elsif addrcnt(15) = x"99" then
								addrcnt(15) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "011101" )or (p2_c5 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
						if(  ((p2_c6 = "011101" )or (p2_c6 = "101010"))) then
							if addrcnt(16) = x"0a" then
								addrcnt(16) <= (others => '0');
							elsif addrcnt(16) = x"15" then
								addrcnt(16) <= x"0b";
							elsif addrcnt(16) = x"20" then
								addrcnt(16) <= x"16";
							elsif addrcnt(16) = x"2b" then
								addrcnt(16) <= x"21";
							elsif addrcnt(16) = x"36" then
								addrcnt(16) <= x"2c";
							elsif addrcnt(16) = x"41" then
								addrcnt(16) <= x"37";
							elsif addrcnt(16) = x"4c" then
								addrcnt(16) <= x"42";
							elsif addrcnt(16) = x"57" then
								addrcnt(16) <= x"4d";
							elsif addrcnt(16) = x"62" then
								addrcnt(16) <= x"58";
							elsif addrcnt(16) = x"6d" then
								addrcnt(16) <= x"63";
							elsif addrcnt(16) = x"78" then
								addrcnt(16) <= x"6e";
							elsif addrcnt(16) = x"83" then
								addrcnt(16) <= x"79";
							elsif addrcnt(16) = x"8e" then
								addrcnt(16) <= x"84";
							elsif addrcnt(16) = x"99" then
								addrcnt(16) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "011110" )or (p2_c5 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);
						if(  ((p2_c6 = "011110" )or (p2_c6 = "101011"))) then
							if addrcnt(17) = x"0a" then
								addrcnt(17) <= (others => '0');
							elsif addrcnt(17) = x"15" then
								addrcnt(17) <= x"0b";
							elsif addrcnt(17) = x"20" then
								addrcnt(17) <= x"16";
							elsif addrcnt(17) = x"2b" then
								addrcnt(17) <= x"21";
							elsif addrcnt(17) = x"36" then
								addrcnt(17) <= x"2c";
							elsif addrcnt(17) = x"41" then
								addrcnt(17) <= x"37";
							elsif addrcnt(17) = x"4c" then
								addrcnt(17) <= x"42";
							elsif addrcnt(17) = x"57" then
								addrcnt(17) <= x"4d";
							elsif addrcnt(17) = x"62" then
								addrcnt(17) <= x"58";
							elsif addrcnt(17) = x"6d" then
								addrcnt(17) <= x"63";
							elsif addrcnt(17) = x"78" then
								addrcnt(17) <= x"6e";
							elsif addrcnt(17) = x"83" then
								addrcnt(17) <= x"79";
							elsif addrcnt(17) = x"8e" then
								addrcnt(17) <= x"84";
							elsif addrcnt(17) = x"99" then
								addrcnt(17) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "011111" )or (p2_c5 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);
						if( ((p2_c6 = "011111" )or (p2_c6 = "101100"))) then
							if addrcnt(18) = x"0a" then
								addrcnt(18) <= (others => '0');
							elsif addrcnt(18) = x"15" then
								addrcnt(18) <= x"0b";
							elsif addrcnt(18) = x"20" then
								addrcnt(18) <= x"16";
							elsif addrcnt(18) = x"2b" then
								addrcnt(18) <= x"21";
							elsif addrcnt(18) = x"36" then
								addrcnt(18) <= x"2c";
							elsif addrcnt(18) = x"41" then
								addrcnt(18) <= x"37";
							elsif addrcnt(18) = x"4c" then
								addrcnt(18) <= x"42";
							elsif addrcnt(18) = x"57" then
								addrcnt(18) <= x"4d";
							elsif addrcnt(18) = x"62" then
								addrcnt(18) <= x"58";
							elsif addrcnt(18) = x"6d" then
								addrcnt(18) <= x"63";
							elsif addrcnt(18) = x"78" then
								addrcnt(18) <= x"6e";
							elsif addrcnt(18) = x"83" then
								addrcnt(18) <= x"79";
							elsif addrcnt(18) = x"8e" then
								addrcnt(18) <= x"84";
							elsif addrcnt(18) = x"99" then
								addrcnt(18) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "100000" )or (p2_c5 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
						if( ((p2_c6 = "100000" )or (p2_c6 = "101101"))) then
							if addrcnt(19) = x"0a" then
								addrcnt(19) <= (others => '0');
							elsif addrcnt(19) = x"15" then
								addrcnt(19) <= x"0b";
							elsif addrcnt(19) = x"20" then
								addrcnt(19) <= x"16";
							elsif addrcnt(19) = x"2b" then
								addrcnt(19) <= x"21";
							elsif addrcnt(19) = x"36" then
								addrcnt(19) <= x"2c";
							elsif addrcnt(19) = x"41" then
								addrcnt(19) <= x"37";
							elsif addrcnt(19) = x"4c" then
								addrcnt(19) <= x"42";
							elsif addrcnt(19) = x"57" then
								addrcnt(19) <= x"4d";
							elsif addrcnt(19) = x"62" then
								addrcnt(19) <= x"58";
							elsif addrcnt(19) = x"6d" then
								addrcnt(19) <= x"63";
							elsif addrcnt(19) = x"78" then
								addrcnt(19) <= x"6e";
							elsif addrcnt(19) = x"83" then
								addrcnt(19) <= x"79";
							elsif addrcnt(19) = x"8e" then
								addrcnt(19) <= x"84";
							elsif addrcnt(19) = x"99" then
								addrcnt(19) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "100001" )or (p2_c5 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
						if(((p2_c6 = "100001" )or (p2_c6 = "101110"))) then
							if addrcnt(20) = x"0a" then
								addrcnt(20) <= (others => '0');
							elsif addrcnt(20) = x"15" then
								addrcnt(20) <= x"0b";
							elsif addrcnt(20) = x"20" then
								addrcnt(20) <= x"16";
							elsif addrcnt(20) = x"2b" then
								addrcnt(20) <= x"21";
							elsif addrcnt(20) = x"36" then
								addrcnt(20) <= x"2c";
							elsif addrcnt(20) = x"41" then
								addrcnt(20) <= x"37";
							elsif addrcnt(20) = x"4c" then
								addrcnt(20) <= x"42";
							elsif addrcnt(20) = x"57" then
								addrcnt(20) <= x"4d";
							elsif addrcnt(20) = x"62" then
								addrcnt(20) <= x"58";
							elsif addrcnt(20) = x"6d" then
								addrcnt(20) <= x"63";
							elsif addrcnt(20) = x"78" then
								addrcnt(20) <= x"6e";
							elsif addrcnt(20) = x"83" then
								addrcnt(20) <= x"79";
							elsif addrcnt(20) = x"8e" then
								addrcnt(20) <= x"84";
							elsif addrcnt(20) = x"99" then
								addrcnt(20) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "100010" )or (p2_c5 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
						if( ((p2_c6 = "100010" )or (p2_c6 = "101111"))) then
							if addrcnt(21) = x"0a" then
								addrcnt(21) <= (others => '0');
							elsif addrcnt(21) = x"15" then
								addrcnt(21) <= x"0b";
							elsif addrcnt(21) = x"20" then
								addrcnt(21) <= x"16";
							elsif addrcnt(21) = x"2b" then
								addrcnt(21) <= x"21";
							elsif addrcnt(21) = x"36" then
								addrcnt(21) <= x"2c";
							elsif addrcnt(21) = x"41" then
								addrcnt(21) <= x"37";
							elsif addrcnt(21) = x"4c" then
								addrcnt(21) <= x"42";
							elsif addrcnt(21) = x"57" then
								addrcnt(21) <= x"4d";
							elsif addrcnt(21) = x"62" then
								addrcnt(21) <= x"58";
							elsif addrcnt(21) = x"6d" then
								addrcnt(21) <= x"63";
							elsif addrcnt(21) = x"78" then
								addrcnt(21) <= x"6e";
							elsif addrcnt(21) = x"83" then
								addrcnt(21) <= x"79";
							elsif addrcnt(21) = x"8e" then
								addrcnt(21) <= x"84";
							elsif addrcnt(21) = x"99" then
								addrcnt(21) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "100011" )or (p2_c5 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);
						if( ((p2_c6 = "100011" )or (p2_c6 = "110000"))) then
							if addrcnt(22) = x"0a" then
								addrcnt(22) <= (others => '0');
							elsif addrcnt(22) = x"15" then
								addrcnt(22) <= x"0b";
							elsif addrcnt(22) = x"20" then
								addrcnt(22) <= x"16";
							elsif addrcnt(22) = x"2b" then
								addrcnt(22) <= x"21";
							elsif addrcnt(22) = x"36" then
								addrcnt(22) <= x"2c";
							elsif addrcnt(22) = x"41" then
								addrcnt(22) <= x"37";
							elsif addrcnt(22) = x"4c" then
								addrcnt(22) <= x"42";
							elsif addrcnt(22) = x"57" then
								addrcnt(22) <= x"4d";
							elsif addrcnt(22) = x"62" then
								addrcnt(22) <= x"58";
							elsif addrcnt(22) = x"6d" then
								addrcnt(22) <= x"63";
							elsif addrcnt(22) = x"78" then
								addrcnt(22) <= x"6e";
							elsif addrcnt(22) = x"83" then
								addrcnt(22) <= x"79";
							elsif addrcnt(22) = x"8e" then
								addrcnt(22) <= x"84";
							elsif addrcnt(22) = x"99" then
								addrcnt(22) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "100100" )or (p2_c5 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
						if( ((p2_c6 = "100100" )or (p2_c6 = "110001"))) then
							if addrcnt(23) = x"0a" then
								addrcnt(23) <= (others => '0');
							elsif addrcnt(23) = x"15" then
								addrcnt(23) <= x"0b";
							elsif addrcnt(23) = x"20" then
								addrcnt(23) <= x"16";
							elsif addrcnt(23) = x"2b" then
								addrcnt(23) <= x"21";
							elsif addrcnt(23) = x"36" then
								addrcnt(23) <= x"2c";
							elsif addrcnt(23) = x"41" then
								addrcnt(23) <= x"37";
							elsif addrcnt(23) = x"4c" then
								addrcnt(23) <= x"42";
							elsif addrcnt(23) = x"57" then
								addrcnt(23) <= x"4d";
							elsif addrcnt(23) = x"62" then
								addrcnt(23) <= x"58";
							elsif addrcnt(23) = x"6d" then
								addrcnt(23) <= x"63";
							elsif addrcnt(23) = x"78" then
								addrcnt(23) <= x"6e";
							elsif addrcnt(23) = x"83" then
								addrcnt(23) <= x"79";
							elsif addrcnt(23) = x"8e" then
								addrcnt(23) <= x"84";
							elsif addrcnt(23) = x"99" then
								addrcnt(23) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "100101" )or (p2_c5 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
						if( ((p2_c6 = "100101" )or (p2_c6 = "110010"))) then
							if addrcnt(24) = x"0a" then
								addrcnt(24) <= (others => '0');
							elsif addrcnt(24) = x"15" then
								addrcnt(24) <= x"0b";
							elsif addrcnt(24) = x"20" then
								addrcnt(24) <= x"16";
							elsif addrcnt(24) = x"2b" then
								addrcnt(24) <= x"21";
							elsif addrcnt(24) = x"36" then
								addrcnt(24) <= x"2c";
							elsif addrcnt(24) = x"41" then
								addrcnt(24) <= x"37";
							elsif addrcnt(24) = x"4c" then
								addrcnt(24) <= x"42";
							elsif addrcnt(24) = x"57" then
								addrcnt(24) <= x"4d";
							elsif addrcnt(24) = x"62" then
								addrcnt(24) <= x"58";
							elsif addrcnt(24) = x"6d" then
								addrcnt(24) <= x"63";
							elsif addrcnt(24) = x"78" then
								addrcnt(24) <= x"6e";
							elsif addrcnt(24) = x"83" then
								addrcnt(24) <= x"79";
							elsif addrcnt(24) = x"8e" then
								addrcnt(24) <= x"84";
							elsif addrcnt(24) = x"99" then
								addrcnt(24) <= x"8f";
							end if;
						end if;
					elsif (p2_c5 = "100110" )or (p2_c5 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
						if(((p2_c6 = "100110" )or (p2_c6 = "110011"))) then
							if addrcnt(25) = x"0a" then
								addrcnt(25) <= (others => '0');
							elsif addrcnt(25) = x"15" then
								addrcnt(25) <= x"0b";
							elsif addrcnt(25) = x"20" then
								addrcnt(25) <= x"16";
							elsif addrcnt(25) = x"2b" then
								addrcnt(25) <= x"21";
							elsif addrcnt(25) = x"36" then
								addrcnt(25) <= x"2c";
							elsif addrcnt(25) = x"41" then
								addrcnt(25) <= x"37";
							elsif addrcnt(25) = x"4c" then
								addrcnt(25) <= x"42";
							elsif addrcnt(25) = x"57" then
								addrcnt(25) <= x"4d";
							elsif addrcnt(25) = x"62" then
								addrcnt(25) <= x"58";
							elsif addrcnt(25) = x"6d" then
								addrcnt(25) <= x"63";
							elsif addrcnt(25) = x"78" then
								addrcnt(25) <= x"6e";
							elsif addrcnt(25) = x"83" then
								addrcnt(25) <= x"79";
							elsif addrcnt(25) = x"8e" then
								addrcnt(25) <= x"84";
							elsif addrcnt(25) = x"99" then
								addrcnt(25) <= x"8f";
							end if;
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +464 ) ) and ( hsync_cnt <= (tHW + tHBP +474)) ) then
					if (p2_c6 = "000000" )or (p2_c6 = "001101") then --a
						addrcnt(0) <= addrcnt(0) + '1';
						rgb_data <= b_data(0) & g_data(0) & r_data(0);
					elsif (p2_c6 = "000001" )or (p2_c6 = "001110") then --2
						addrcnt(1) <= addrcnt(1) + '1';
						rgb_data <= b_data(1) & g_data(1) & r_data(1);
					elsif (p2_c6 = "000010" )or (p2_c6 = "001111") then --3
						addrcnt(2) <= addrcnt(2) + '1';
						rgb_data <= b_data(2) & g_data(2) & r_data(2);
					elsif (p2_c6 = "000011" )or (p2_c6 = "010000") then --4
						addrcnt(3) <= addrcnt(3) + '1';
						rgb_data <= b_data(3) & g_data(3) & r_data(3);
					elsif (p2_c6 = "000100" )or (p2_c6 = "010001") then --5
						addrcnt(4) <= addrcnt(4) + '1';
						rgb_data <= b_data(4) & g_data(4) & r_data(4);				
					elsif (p2_c6 = "000101" )or (p2_c6 = "010010") then --6
						addrcnt(5) <= addrcnt(5) + '1';
						rgb_data <= b_data(5) & g_data(5) & r_data(5);	
					elsif (p2_c6 = "000110" )or (p2_c6 = "010011") then --7
						addrcnt(6) <= addrcnt(6) + '1';
						rgb_data <= b_data(6) & g_data(6) & r_data(6);				
					elsif (p2_c6 = "000111" )or (p2_c6 = "010100") then --8
						addrcnt(7) <= addrcnt(7) + '1';
						rgb_data <= b_data(7) & g_data(7) & r_data(7);				
					elsif (p2_c6 = "001000" )or (p2_c6 = "010101") then --9
						addrcnt(8) <= addrcnt(8) + '1';
						rgb_data <= b_data(8) & g_data(8) & r_data(8);
					elsif (p2_c6= "001001" )or (p2_c6 = "010110") then --10
						addrcnt(9) <= addrcnt(9) + '1';
						rgb_data <= b_data(9) & g_data(9) & r_data(9);					
					elsif (p2_c6 = "001010" )or (p2_c6 = "010111") then --j
						addrcnt(10) <= addrcnt(10) + '1';
						rgb_data <= b_data(10) & g_data(10) & r_data(10);					
					elsif (p2_c6 = "001011" )or (p2_c6 = "011000") then --q
						addrcnt(11) <= addrcnt(11) + '1';
						rgb_data <= b_data(11) & g_data(11) & r_data(11);						
					elsif (p2_c6 = "001100" )or (p2_c6 = "011001") then --k
						addrcnt(12) <= addrcnt(12) + '1';
						rgb_data <= b_data(12) & g_data(12) & r_data(12);
					elsif (p2_c6 = "011010" )or (p2_c6 = "100111")  then --a(red)
						addrcnt(13) <= addrcnt(13) + '1';
						rgb_data <= b_data(13) & g_data(13) & r_data(13);
						
					elsif (p2_c6 = "011011" )or (p2_c6 = "101000") then --2(red)
						addrcnt(14) <= addrcnt(14) + '1';
						rgb_data <= b_data(14) & g_data(14) & r_data(14);
						
					elsif (p2_c6 = "011100" )or (p2_c6 = "101001") then --3(red)
						addrcnt(15) <= addrcnt(15) + '1';
						rgb_data <= b_data(15) & g_data(15) & r_data(15);
						
					elsif (p2_c6 = "011101" )or (p2_c6 = "101010") then --4(red)
						addrcnt(16) <= addrcnt(16) + '1';
						rgb_data <= b_data(16) & g_data(16) & r_data(16);
						
					elsif (p2_c6 = "011110" )or (p2_c6 = "101011") then --5(red)
						addrcnt(17) <= addrcnt(17) + '1';
						rgb_data <= b_data(17) & g_data(17) & r_data(17);					
					elsif (p2_c6 = "011111" )or (p2_c6 = "101100") then --6(red)
						addrcnt(18) <= addrcnt(18) + '1';
						rgb_data <= b_data(18) & g_data(18) & r_data(18);					
					elsif (p2_c6 = "100000" )or (p2_c6 = "101101") then --7(red)
						addrcnt(19) <= addrcnt(19) + '1';
						rgb_data <= b_data(19) & g_data(19) & r_data(19);
					elsif (p2_c6 = "100001" )or (p2_c6 = "101110") then --8(red)
						addrcnt(20) <= addrcnt(20) + '1';
						rgb_data <= b_data(20) & g_data(20) & r_data(20);
					elsif (p2_c6 = "100010" )or (p2_c6 = "101111") then --9(red)
						addrcnt(21) <= addrcnt(21) + '1';
						rgb_data <= b_data(21) & g_data(21) & r_data(21);
					elsif (p2_c6 = "100011" )or (p2_c6 = "110000") then --10(red)
						addrcnt(22) <= addrcnt(22) + '1';
						rgb_data <= b_data(22) & g_data(22) & r_data(22);			
					elsif (p2_c6 = "100100" )or (p2_c6 = "110001") then --j(red)
						addrcnt(23) <= addrcnt(23) + '1';
						rgb_data <= b_data(23) & g_data(23) & r_data(23);
					elsif (p2_c6 = "100101" )or (p2_c6 = "110010") then --q(red)
						addrcnt(24) <= addrcnt(24) + '1';
						rgb_data <= b_data(24) & g_data(24) & r_data(24);
					elsif (p2_c6 = "100110" )or (p2_c6 = "110011") then --k(red)
						addrcnt(25) <= addrcnt(25) + '1';
						rgb_data <= b_data(25) & g_data(25) & r_data(25);
					elsif (p2_c3 = "111111") then
						if ((hsync_cnt >= (tHW + tHBP +464 ) ) and ( hsync_cnt <= (tHW + tHBP +470)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					else
						rgb_data <= (others => '1');
					end if;
				elsif ((hsync_cnt >= (tHW + tHBP +475 ) ) and ( hsync_cnt <= (tHW + tHBP +514)) ) then
					if (p2_c3 /= "111111") then
						if ((hsync_cnt >= (tHW + tHBP +475 ) ) and ( hsync_cnt <= (tHW + tHBP +481)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
					if (p2_c4 /= "111111") then	
						if ((hsync_cnt >= (tHW + tHBP +482 ) ) and ( hsync_cnt <= (tHW + tHBP +492)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
					if (p2_c5 /= "111111") then	
						if ((hsync_cnt >= (tHW + tHBP +493 ) ) and ( hsync_cnt <= (tHW + tHBP +503)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
					if (p2_c6 /= "111111") then	
						if ((hsync_cnt >= (tHW + tHBP +504 ) ) and ( hsync_cnt <= (tHW + tHBP +514)) ) then
							rgb_data <= (others => '1');
						else 
							rgb_data <= "00000" & "001110" & "00000";
						end if;
					end if;
				else
					rgb_data <= "00000" & "001110" & "00000";
				end if;
			elsif ( ( vsync_cnt >= (tVW + tVBP +322 ) ) and ( vsync_cnt <= (tVW + tVBP + 391) ) )then 
				if ((hsync_cnt >= (tHW + tHBP +100 ) ) and ( hsync_cnt <= (tHW + tHBP +160)) ) then
					rgb_data <= (others => '1');
				elsif( (hsync_cnt >= (tHW + tHBP +399 ) ) and ( hsync_cnt <= (tHW + tHBP +400)) ) then --가운데 세로줄
					rgb_data <= (others => '1');
				elsif((hsync_cnt >= (tHW + tHBP +409 ) ) and ( hsync_cnt <= (tHW + tHBP +469)) ) then
					rgb_data <= (others => '1');
				else
					rgb_data <= "00000" & "001110" & "00000";
				end if;
			elsif (( vsync_cnt >= (tVW + tVBP + 270) ) and ( vsync_cnt <= (tVW + tVBP + 479) ) ) then 
			
				if( (hsync_cnt >= (tHW + tHBP +399 ) ) and ( hsync_cnt <= (tHW + tHBP +400)) ) then --가운데 세로줄
					rgb_data <= (others => '1');
				else
					rgb_data <= "00000" & "001110" & "00000";
				end if;	
			else
				rgb_data <= (others => '0');
			end if;
		end if;
   end process;
	

	data_addr <= addrcnt(0);
	data_addr2 <= addrcnt(1);
	data_addr3 <= addrcnt(2);
	data_addr4 <= addrcnt(3);
	data_addr5 <= addrcnt(4);
	data_addr6 <= addrcnt(5);
	data_addr7 <= addrcnt(6);
	data_addr8 <= addrcnt(7);
	data_addr9 <= addrcnt(8);
	data_addr10 <= addrcnt(9);
	data_addr11 <= addrcnt(10);
	data_addr12 <= addrcnt(11);
	data_addr13 <= addrcnt(12);
	data_addr14 <= addrcnt(13);
	data_addr15 <= addrcnt(14);
	data_addr16 <= addrcnt(15);
	data_addr17 <= addrcnt(16);
	data_addr18 <= addrcnt(17);
	data_addr19 <= addrcnt(18);
	data_addr20 <= addrcnt(19);
	data_addr21 <= addrcnt(20);
	data_addr22 <= addrcnt(21);
	data_addr23 <= addrcnt(22);
	data_addr24 <= addrcnt(23);
	data_addr25 <= addrcnt(24);
	data_addr26 <= addrcnt(25);
	data_addr27 <= addrcnt(26);
	data_addr28 <= addrcnt(27);
	data_addr29 <= addrcnt(28);
	data_addr30 <= addrcnt(29);
	data_out<= rgb_data;
	de<=de_i;

end Behavioral;

