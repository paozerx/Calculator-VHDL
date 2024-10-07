library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
    Port ( input : in STD_LOGIC_VECTOR(9 downto 0);
			  start,reset,clock : in std_logic;
			  a : out STD_LOGIC_VECTOR(9 downto 0);
           b : out STD_LOGIC_VECTOR(9 downto 0));
end main;

architecture Behavioral of main is
type state_type is (S0,S1,S2,S3,S4,S5,S6);
signal cur_input : STD_LOGIC_VECTOR(9 downto 0);
signal selector : STD_LOGIC_VECTOR(1 downto 0);
signal state : state_type := S0
signal start_in : std_logic:= '0';

begin
	start_in <= start;
	process(reset,start,clock,input)
		if reset = '0' then
		elsif rising_edge(clock) then
			case state is
				when S0 =>
					if start_in = '0' then
						state <= S1
					else
						state <= S0
					end if;
						
				when S1 =>
					if start_in = '0' then
						state <= S2
					else
						state <= S1
					end if;
						
				when S2 =>
					if start_in = '0' then
						state <= S3
					else
						state <= S2
					end if;
						
				when S3 =>
					if start_in = '0' then
						state <= S4
					else
						state <= S3
					end if;
						
				when S4 =>
					if start_in = '0' then
						state <= S5
					else
						state <= S4
					end if;
						
				when S5 =>
					if start_in = '0' then
						state <= S6
					else
						state <= S5
					end if;
						
				when S6 =>
					if start_in = '0' then
						state <= S7
					else
						state <= S6
					end if;
			
			end case;
						
				
		end if;
	
    
end Behavioral;