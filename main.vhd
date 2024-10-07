library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
    Port ( input : in STD_LOGIC_VECTOR(9 downto 0);
			  input_to : out STD_LOGIC_VECTOR(19 downto 0);
			  start,reset,clock : in std_logic;
			  enable : out std_logic;
			  enable_binary : out std_logic;
			  selector : out STD_LOGIC_VECTOR(1 downto 0);
			  a : out STD_LOGIC_VECTOR(9 downto 0);
           b : out STD_LOGIC_VECTOR(9 downto 0));
end main;

architecture Behavioral of main is
type state_type is (S0,S1,S2,S3,S4,S5,S6);
signal cur_input : STD_LOGIC_VECTOR(19 downto 0);
signal selec : STD_LOGIC_VECTOR(1 downto 0);
signal state : state_type := S0;
signal start_in : std_logic:= '0';


begin
	start_in <= start;
	
	process(reset,start,clock,input)
	
		begin
		
		if reset = '0' then
			state <= S0;
			a <= (others => '0');
			b <= (others => '0');
		   input_to <= (others => '0');
			enable_binary <= '0';
			enable <= '0';
			selector <= (others => '0');
			
		elsif rising_edge(clock) then
			case state is
				when S0 =>
					if start_in = '0' then
						state <= S1;
					else
						state <= S0;
						input_to <= "10000000000000000000";
						enable_binary <= '0';
						enable <= '0';
						
					end if;
						
				when S1 =>
					if start_in = '0' then
						a <= input;
						state <= S2;
					else
						state <= S1;
						input_to (9 downto 0) <= input;
						enable_binary <= '1';
						enable <= '0';
					end if;
						
				when S2 =>
					if start_in = '0' then
						state <= S3;
					else
						state <= S2;
						input_to <= "00000000000000000000";
						enable_binary <= '0';
						enable <= '0';
					end if;
						
				when S3 =>
					if start_in = '0' then
						b <= input;
						state <= S4;
					else
						state <= S3;
						input_to (9 downto 0) <= input;
						enable_binary <= '1';
						enable <= '0';
					end if;
						
				when S4 =>
					if start_in = '0' then
						state <= S5;
					else
						state <= S4;
						input_to <= "00000000000000000000";
						enable_binary <= '0';
						enable <= '0';
					end if;
						
				when S5 =>
					if start_in = '0' then
						selector <= input(1 downto 0);
						state <= S6;
						
					else
						state <= S5;
						input_to <= "00000000000000000000";
						enable_binary <= '0';
						enable <= '0';
					end if;
						
				when S6 =>
						state <= S6;
						enable_binary <= '1';
						enable <= '1';
			end case;
						
				
		end if;
	end process;
    
end Behavioral;