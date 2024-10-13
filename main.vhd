library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
    Port ( input : in STD_LOGIC_VECTOR(9 downto 0) ;
			  input_to : out STD_LOGIC_VECTOR(19 downto 0);
			  sign_input : out std_logic := '0';
			  start,reset,clock : in std_logic;
			  enable : out std_logic;
			  enable_binary : out std_logic;
			  selector : out STD_LOGIC_VECTOR(1 downto 0);
			  a : out STD_LOGIC_VECTOR(9 downto 0);
           b : out STD_LOGIC_VECTOR(9 downto 0));
end main;

architecture Behavioral of main is
type state_type is (S0,S1,S2,S3,S4,S5,S6);
signal selec : STD_LOGIC_VECTOR(1 downto 0);
signal state : state_type := S0;
signal start_in : std_logic:= '0';
signal input_ex : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
signal d_start : std_logic := '0';


begin
	
	process(reset,start,clock,input)
	
		begin
		
		if (input(9) = '1') then
			input_ex <= not(input) + 1;
			sign_input <= '1';
		else
			input_ex <= input;
			sign_input <= '0';
		end if;
		
		if reset = '0' then
			state <= S0;
			a <= (others => '0');
			b <= (others => '0');
		   input_to <= (others => '0');
			enable_binary <= '0';
			enable <= '0';
			selector <= (others => '0');
			d_start <= '0';
			
		elsif rising_edge(clock) then
			d_start <= start;
			case state is
				when S0 =>
					if start = '0' and d_start = '1' then
						input_to <= (others => '0');
						state <= S1;
						
					elsif start = '1' then
						state <= S0;
						input_to <= "10000000000000000000";
						enable_binary <= '0';
						enable <= '0';
						
					end if;
						
				when S1 =>
					if start = '0' and d_start = '1' then
						a <= input_ex;
						state <= S2;
					elsif start = '1' then
						state <= S1;
						input_to (9 downto 0) <= input_ex;
						enable_binary <= '1';
						enable <= '0';
					end if;
						
				when S2 =>
					if start = '0' and d_start = '1' then
						state <= S3;
					elsif start = '1' then
						state <= S2;
						input_to <= "00000000000000000000";
						enable_binary <= '0';
						enable <= '0';
					end if;
						
				when S3 =>
					if start = '0' and d_start = '1' then
						b <= input_ex;
						state <= S4;
					elsif start = '1' then
						state <= S3;
						input_to (9 downto 0) <= input_ex;
						enable_binary <= '1';
						enable <= '0';
					end if;
						
				when S4 =>
					if start = '0' and d_start = '1' then
						state <= S5;
					elsif start = '1' then
						state <= S4;
						input_to <= "00000000000000000000";
						enable_binary <= '0';
						enable <= '0';
					end if;
						
				when S5 =>
					if start = '0' and d_start = '1' then
						selector <= input(1 downto 0);
						state <= S6;
						
					elsif start = '1' then
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