library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_to_mux is
    Port ( input_1 : in STD_LOGIC_VECTOR(19 downto 0);
           input_2 : in STD_LOGIC_VECTOR(19 downto 0);
           input_3 : in STD_LOGIC_VECTOR(19 downto 0);
           input_4 : in STD_LOGIC_VECTOR(19 downto 0);
           enable  : in STD_LOGIC_VECTOR(1 downto 0);
           output  : out STD_LOGIC_VECTOR(19 downto 0));
end mux_to_mux;

architecture Behavioral of mux_to_mux is
begin
    process(input_1, input_2, input_3,input_4,  enable)
    begin
        case enable is
            when "11" => 
					if input_1(9) = '1' then
							output(9 downto 0) <= not(input_1(9 downto 0)) + 1;
						else 
							output(9 downto 0) <= input_1(9 downto 0);
						end if;
            when "10" => 
						if input_2(9) = '1' then
							output(9 downto 0) <= not(input_2(9 downto 0)) + 1;
						else 
							output(9 downto 0) <= input_2(9 downto 0);
						end if;
            when "01" => 
					output <= input_3;
            when "00" => 
					output <= input_4;
            when others => output <= (others => '0'); 
        end case;
    end process;
end Behavioral;
