library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
    Port ( input : in STD_LOGIC_VECTOR(9 downto 0);
			  selector : in STD_LOGIC_VECTOR(1 downto 0);
			  a : out STD_LOGIC_VECTOR(9 downto 0);
           b : out STD_LOGIC_VECTOR(9 downto 0);
			  cur_input : out STD_LOGIC_VECTOR(9 downto 0);
           result : out STD_LOGIC_VECTOR(9 downto 0));
end main;

architecture Behavioral of main is
begin
    
end Behavioral;