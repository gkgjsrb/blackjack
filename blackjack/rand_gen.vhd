----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:50:19 06/05/2018 
-- Design Name: 
-- Module Name:    rand_gen - Behavioral 
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
use IEEE.MATH_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rand_gen is
end rand_gen;

architecture Behavioral of rand_gen is

signal rand_num : integer:=0;

begin

	process
		variable seed1, seed2 : positive;
		variable rand : real;
		variable range_of_rand : real:=52;
	begin
		uniform(seed1,seed2,rand);
		rand_num<=integer(rand*range_of_rand);
	end process;
end Behavioral;

