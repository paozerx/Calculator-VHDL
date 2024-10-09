library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity division is
    generic ( N : integer := 10);
    port( CLK, RST_N : in std_logic;
          A, B : in std_logic_vector( N-1 downto 0 ):= (others => '0');
          R : out std_logic_vector( 2*N-1 downto 0 ):= (others => '0'); 
			 Q : out std_logic_vector( 2*N-1 downto 0 ):= (others => '0');
			 sign_bit : out std_logic );
end division ;

architecture Behave of division is
    type state_type is (S0,S1);
    signal Data_A : std_logic_vector( 2*N-1 downto 0 ):= (others => '0');
    signal Data_B : std_logic_vector( 2*N-1 downto 0 ):= (others => '0'); 
    signal quotient : std_logic_vector( N-1 downto 0 ):= (others => '0');
    signal bit_counter : integer := 0;
    signal state : state_type := S0;
    signal S_Start : std_logic := '0';
	 signal pro_a : std_logic_vector(N-1 downto 0);
	 signal pro_b : std_logic_vector(N-1 downto 0);
	 signal sign_bit_data : std_logic;
	 signal diff_of_r_d : std_logic_vector(2*N-1 downto 0);
begin
	
	 process(A,B)
	 begin 
			if A(9) ='1' and B(9) ='1' then 
				pro_a <= not(A) + 1 ;
				pro_b <= not(B) + 1 ;
			elsif A(9) ='0' and B(9) ='0' then 
				pro_a <= A ;
				pro_b <= B ;
			elsif A(9) ='1' and B(9) ='0' then 
				pro_a <= not(A) + 1 ;
				pro_b <= B ;
			elsif A(9) ='0' and B(9) ='1' then 
				pro_a <= A ;
				pro_b <= not(B) + 1 ;
			end if;
		end process ;
				
			
    S_Start <= '0';
    
    process (RST_N, CLK,A,B)
    begin
			if A(9) ='1' and B(9) ='1' then 
				sign_bit_data <= '0';
			elsif A(9) ='0' and B(9) ='0' then 
				sign_bit_data <= '0';
			elsif A(9) ='1' and B(9) ='0' then 
				sign_bit_data <= '1';
			elsif A(9) ='0' and B(9) ='1' then 
				sign_bit_data <= '1';
			end if;
			
		  
        if RST_N = '0' then -- async. reset (active-low)
            state <= S0;
            Data_A <= (others => '0');
            Data_B <= (others => '0');
            R <= (others => '0');
				Q <= (others => '0');
				sign_bit <= '0';
				
				
        sign_bit_data <= '0';
        elsif rising_edge(CLK) then
            case state is
                when S0 =>
                    if S_Start = '0' then  -- check start for multipli process
                        Data_A(2*N-1 downto N) <= pro_a; --Keep data A 10 bit front
                        Data_B(N-1 downto 0) <= pro_b;   --Keep data B 10 bit back
                        state <= S1;            -- goto S1 when START bit Active
                    else
                        state <= S0; -- Non Active START bit goto s1
                    end if;
                
                when S1 => -- Multipli process
						  diff_of_r_d <= Data_B - Data_A; 
                    if (bit_counter < N) then
								if diff_of_r_d(2*N-1) = '1' then --check msb bit of reminder - divisor            
									 Data_B <= diff_of_r_d + Data_A; 
                            Data_A <= std_logic_vector(shift_right(unsigned(Data_A), 1)); --shift_left data_A 1 bit
									 quotient <= std_logic_vector(shift_left(unsigned(quotient),1)); -- shift_right quotient 1 bit
                            R <= Data_B;
									 Q(N-1 downto 0) <= quotient ; 
                            bit_counter <= bit_counter + 1;
                        else
                            Data_A <= std_logic_vector(shift_right(unsigned(Data_A), 1)); --shift_left data_A 1 bit
									 quotient <= std_logic_vector(shift_left(unsigned(quotient),1)); -- shift_right quotient 1 b
									 quotient(0) <= '1';
									 Data_B <= diff_of_r_d ; 
									 R <= Data_B;
									 Q(N-1 downto 0) <= quotient ; 
                            bit_counter <= bit_counter + 1;
                        end if;
                    else
                        bit_counter <= 0;
                        quotient <= (others => '0');
                        Data_A <= (others => '0');
                        Data_B <= (others => '0');
                        state <= S0;
                    end if;
							sign_bit <= sign_bit_data;
                when others =>
                    state <= S0;
            end case;
        end if;
    end process;
end Behave;