----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:25:48 06/05/2018 
-- Design Name: 
-- Module Name:    LFSR - Behavioral 
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

entity LFSR is
	port(clk,rst,en : in std_logic;
		  cnt : out std_logic_vector(5 downto 0)
		  );	
end LFSR;

architecture Behavioral of LFSR is
signal count_i : std_logic_vector(99 downto 0);
signal feedback : std_logic;

begin
	feedback<=not(count_i(99) xor count_i(33));
	process(clk)
	begin
		if rising_edge(clk) then
			if rst='1' then
				count_i<=(others=>'0');
			elsif en='1' then
				count_i<=count_i(98 downto 0) & feedback;
			end if;
		end if;
	end process;
	cnt<=count_i(99 downto 97) & count_i(2 downto 0);
end Behavioral;

