----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:55:22 05/29/2018 
-- Design Name: 
-- Module Name:    FSM - Behavioral 
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

entity FSM is
	port( clk,rst : in std_logic;
			stand, bet : in std_logic;
			p1_fail, p2_fail, d_fail, d_stand : in std_logic;
			state : out std_logic_vector(1 downto 0)
		 );
end FSM;

architecture Behavioral of FSM is
	type state_type is  (b, p1, p2, d);
	signal curr_state, next_state : state_type;
begin
	
	process(rst, clk)
	begin
		if rst='1' then
			curr_state<=b;
		elsif rising_edge(clk) then
			curr_state<=next_state;
		end if;
	end process;
	
	process(curr_state,stand,bet,p1_fail,p2_fail,d_fail,d_stand)
	begin
		case curr_state is
			when	b=>
				if bet='1' then
					next_state<=p1;
				else
					next_state<=b;
				end if;
			when	p1=> 
				if stand='1' or p1_fail='1' then
					next_state<=p2;
				else
					next_state<=p1;
				end if;
			when	p2=>
				if	stand='1' or p2_fail='1' then
					next_state<=d;
				else
					next_state<=p2;
				end if;
			when	d=>
				if d_stand='1' or d_fail='1' then
					next_state<=b;
				else
					next_state<=d;
				end if;
			when others=>next_state<=curr_state;
		end case;
	end process;
	
	process(curr_state)
	begin
		if curr_state=b then
			state<="00";
		elsif curr_state=p1 then
			state<="01";
		elsif curr_state=p2 then
			state<="10";
		elsif curr_state=d then
			state<="11";
		end if;
	end process;
end Behavioral;

