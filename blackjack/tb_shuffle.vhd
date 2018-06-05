--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:18:36 06/05/2018
-- Design Name:   
-- Module Name:   D:/emha/blackjack/tb_shuffle.vhd
-- Project Name:  blackjack
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shuffle
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_shuffle IS
END tb_shuffle;
 
ARCHITECTURE behavior OF tb_shuffle IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shuffle
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         card0 : OUT  std_logic_vector(5 downto 0);
         card1 : OUT  std_logic_vector(5 downto 0);
         card2 : OUT  std_logic_vector(5 downto 0);
         card3 : OUT  std_logic_vector(5 downto 0);
         card4 : OUT  std_logic_vector(5 downto 0);
         card5 : OUT  std_logic_vector(5 downto 0);
         card6 : OUT  std_logic_vector(5 downto 0);
         card7 : OUT  std_logic_vector(5 downto 0);
         card8 : OUT  std_logic_vector(5 downto 0);
         card9 : OUT  std_logic_vector(5 downto 0);
         card10 : OUT  std_logic_vector(5 downto 0);
         card11 : OUT  std_logic_vector(5 downto 0);
         card12 : OUT  std_logic_vector(5 downto 0);
         card13 : OUT  std_logic_vector(5 downto 0);
         card14 : OUT  std_logic_vector(5 downto 0);
         card15 : OUT  std_logic_vector(5 downto 0);
         card16 : OUT  std_logic_vector(5 downto 0);
         card17 : OUT  std_logic_vector(5 downto 0);
         card18 : OUT  std_logic_vector(5 downto 0);
         card19 : OUT  std_logic_vector(5 downto 0);
         card20 : OUT  std_logic_vector(5 downto 0);
         card21 : OUT  std_logic_vector(5 downto 0);
         card22 : OUT  std_logic_vector(5 downto 0);
         card23 : OUT  std_logic_vector(5 downto 0);
         card24 : OUT  std_logic_vector(5 downto 0);
         card25 : OUT  std_logic_vector(5 downto 0);
         card26 : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal card0 : std_logic_vector(5 downto 0);
   signal card1 : std_logic_vector(5 downto 0);
   signal card2 : std_logic_vector(5 downto 0);
   signal card3 : std_logic_vector(5 downto 0);
   signal card4 : std_logic_vector(5 downto 0);
   signal card5 : std_logic_vector(5 downto 0);
   signal card6 : std_logic_vector(5 downto 0);
   signal card7 : std_logic_vector(5 downto 0);
   signal card8 : std_logic_vector(5 downto 0);
   signal card9 : std_logic_vector(5 downto 0);
   signal card10 : std_logic_vector(5 downto 0);
   signal card11 : std_logic_vector(5 downto 0);
   signal card12 : std_logic_vector(5 downto 0);
   signal card13 : std_logic_vector(5 downto 0);
   signal card14 : std_logic_vector(5 downto 0);
   signal card15 : std_logic_vector(5 downto 0);
   signal card16 : std_logic_vector(5 downto 0);
   signal card17 : std_logic_vector(5 downto 0);
   signal card18 : std_logic_vector(5 downto 0);
   signal card19 : std_logic_vector(5 downto 0);
   signal card20 : std_logic_vector(5 downto 0);
   signal card21 : std_logic_vector(5 downto 0);
   signal card22 : std_logic_vector(5 downto 0);
   signal card23 : std_logic_vector(5 downto 0);
   signal card24 : std_logic_vector(5 downto 0);
   signal card25 : std_logic_vector(5 downto 0);
   signal card26 : std_logic_vector(5 downto 0);

   -- Clock period definitions
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shuffle PORT MAP (
          rst => rst,
          clk => clk,
          card0 => card0,
          card1 => card1,
          card2 => card2,
          card3 => card3,
          card4 => card4,
          card5 => card5,
          card6 => card6,
          card7 => card7,
          card8 => card8,
          card9 => card9,
          card10 => card10,
          card11 => card11,
          card12 => card12,
          card13 => card13,
          card14 => card14,
          card15 => card15,
          card16 => card16,
          card17 => card17,
          card18 => card18,
          card19 => card19,
          card20 => card20,
          card21 => card21,
          card22 => card22,
          card23 => card23,
          card24 => card24,
          card25 => card25,
          card26 => card26
        );
 
   -- Stimulus process
	clk <= not clk after 20 ns;
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst<='1' after 5ns,
			  '0' after 40ns;
		
      -- insert stimulus here 

      wait;
   end process;

END;
