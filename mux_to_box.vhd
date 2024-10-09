library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_to_box is
    Port ( input_1 : in STD_LOGIC_VECTOR(19 downto 0);
			  input_2 : in STD_LOGIC_VECTOR(19 downto 0);
			  enable : in std_logic;
			  done : out std_logic;
           output : out STD_LOGIC_VECTOR(19 downto 0));
end mux_to_box;

architecture Behavioral of mux_to_box is
begin
	process(input_1,input_2,enable)
	begin
		case enable is
			when '0' => 
				output <= input_1 ;
			when '1' => 
				output <= input_2;
				done <= '1';
		end case;
	end process;
end Behavioral;