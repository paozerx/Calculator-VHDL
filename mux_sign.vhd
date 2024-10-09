library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux_sign is
    Port ( add : in STD_LOGIC_VECTOR(19 downto 0);
           sub : in STD_LOGIC_VECTOR(19 downto 0);
           sign_muti : in std_logic;
           sign_div : in std_logic;
           enable  : in STD_LOGIC_VECTOR(1 downto 0);
           output  : out std_logic);
end mux_sign;

architecture Behavioral of mux_sign is
signal sign_add : std_logic;
signal sign_sub : std_logic;
begin
    process(enable,add,sub,sign_muti,sign_div)
    begin
		  sign_add <= add(9);
		  sign_sub <= sub(9);
        case enable is
            when "00" => 
					output <= sign_add;
            when "01" => 
					output <= sign_sub;
            when "10" => 
					output <= sign_muti;
            when "11" => 
					output <= sign_div;
            when others => output <= '0'; 
        end case;
    end process;
end Behavioral;