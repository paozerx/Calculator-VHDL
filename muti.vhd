library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Multiplication is
    generic ( N : integer := 5 );
    port( CLK, RST_N, START : in  std_logic;
          A, B : in  std_logic_vector( N-1 downto 0 );
          R    : out std_logic_vector( 2*N-1 downto 0 );
          DONE : out std_logic := '0'; 
			 sign : out std_logic);
end Multiplication;

architecture Behave of Multiplication is
    type state_type is (S0, S1);
    signal Data_A : std_logic_vector(2*N-1 downto 0) := (others => '0');
    signal Data_B : std_logic_vector(N-1 downto 0) := (others => '0');
    signal Data_Product : std_logic_vector(2*N-1 downto 0) := (others => '0');
    signal bit_counter : integer := 0;
    signal state : state_type := S0;
    signal P_done : std_logic := '0';
    signal S_Start : std_logic := '0';
	 signal A_ex : std_logic_vector(N-1 downto 0) ;
	 signal B_ex : std_logic_vector(N-1 downto 0) ;
	 signal sign_iex : std_logic;
begin
    S_Start <= START;
	 
	 process (A,B)
	 begin
		if A(N-1) = '1' and  B(N-1) = '1'then
			A_ex <= not(A) + 1;
			B_ex <= not(B) + 1;
		
			
		elsif A(N-1) = '0' and  B(N-1) = '1' then
			A_ex <= A;
			B_ex <= not(B) + 1;
			
			
		elsif A(N-1) = '1' and  B(N-1) = '0' then
			A_ex <= not(A) + 1;
			B_ex <= B;
		elsif A(N-1) = '0' and  B(N-1) = '0' then
			A_ex <= A;
			B_ex <= B;
			
		end if;
	end process;

    process (RST_N, CLK, START,A,B)
    begin
			if A(N-1) = '1' and  B(N-1) = '1'then
				sign_iex <= '1';
				
			elsif A(N-1) = '0' and  B(N-1) = '1' then
				sign_iex <= '0';
				
			elsif A(N-1) = '1' and  B(N-1) = '0' then
				sign_iex <= '0';
			elsif A(N-1) = '0' and  B(N-1) = '0' then
				sign_iex <= '1';
			end if;
			
        if RST_N = '0' then  -- Asynchronous reset (active-low)
            state <= S0;
            Data_A <= (others => '0');
            Data_B <= (others => '0');
            Data_Product <= (others => '0');
            R <= (others => '0');
				sign_iex <= '1';
				DONE <= '0';
			
			sign <= '1';
        elsif rising_edge(CLK) then
            case state is
                when S0 =>
                    if S_Start = '0' then  -- Check Start for multiply process
                        Data_A(N-1 downto 0) <= A_ex;  -- Keep data A
                        Data_B <= B_ex;  -- Keep data B
                        state <= S1;  -- Active START, go to S1
                    else
                        state <= S0;  -- Non-active START, remain in S0
                        DONE <= '0';
                    end if;
                when S1 =>  -- Multiplication process
                    if bit_counter < (N+1) then
                        state <= S1;
                        if Data_B(bit_counter) = '1' then
                            Data_Product <= Data_Product + Data_A;
                            Data_A <= std_logic_vector(shift_left(unsigned(Data_A), 1));  -- Shift-left Data_A by 1 bit
                            R <= Data_Product;
                            bit_counter <= bit_counter + 1;
                        else
                            Data_A <= std_logic_vector(shift_left(unsigned(Data_A), 1));  -- Shift-left Data_A by 1 bit
                            R <= Data_Product;
                            bit_counter <= bit_counter + 1;
                        end if;
                    else
                        bit_counter <= 0;
                        Data_Product <= (others => '0');
                        Data_A <= (others => '0');
                        Data_B <= (others => '0');
                        state <= S0;
                        DONE <= '1';
                    end if;
						  sign <= sign_iex;
            end case;
        end if;
		  
    end process;
end Behave;
