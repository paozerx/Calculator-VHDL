library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
    Port ( input : in STD_LOGIC_VECTOR(9 downto 0);
			  selector : in STD_LOGIC_VECTOR(1 downto 0);
			  a : out STD_LOGIC_VECTOR(9 downto 0);
           b : out STD_LOGIC_VECTOR(9 downto 0));
end main;

architecture Behavioral of main is
type state_type is (S0,S1,S2,S3,S4,S5);
signal cur_input out STD_LOGIC_VECTOR(9 downto 0);

begin
    
end Behavioral;