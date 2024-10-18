library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity division is
    generic ( N : integer := 10);
    port( CLK,RST_N : in std_logic;
          A, B : in std_logic_vector( N-1 downto 0 ):= (others => '0');
          R : out std_logic_vector( 2*N-1 downto 0 ):= (others => '0'); 
			 Q : out std_logic_vector( 2*N-1 downto 0 ):= (others => '0');
			 detect_zero : out std_logic ;
			 sign_bit : out std_logic  
			 );
end division ;

architecture Behave of division is
    type state_type is (S0,S1,S2);
    signal Data_A : std_logic_vector( 2*N-1 downto 0 ):= (others => '0');-- dividant
    signal Data_B : std_logic_vector( 2*N-1 downto 0 ):= (others => '0'); -- divisor
    signal quotient : std_logic_vector( N-1 downto 0 ):= (others => '0');
	 signal reminder : std_logic_vector(2*N-1 downto 0):= (others => '0');
    signal bit_counter : integer := 0;
    signal state : state_type := S0;
    signal S_Start : std_logic := '0';
	 signal pro_a : std_logic_vector(N-1 downto 0);
	 signal pro_b : std_logic_vector(N-1 downto 0);
	 signal sign_bit_data : std_logic;
	
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
    
    process (CLK,RST_N,A,B)
    begin
			if A(9) ='1' and B(9) ='1' and A /= "0000000000" and B /=  "0000000000" then 
				sign_bit_data <= '0';
			elsif A(9) ='0' and B(9) ='0' and A /= "0000000000" and B /=  "0000000000" then 
				sign_bit_data <= '0';
			elsif A(9) ='1' and B(9) ='0' and A /= "0000000000" and B /=  "0000000000" then 
				sign_bit_data <= '1';
			elsif A(9) ='0' and B(9) ='1' and A /= "0000000000" and B /=  "0000000000" then 
				sign_bit_data <= '1';
			elsif A = "0000000000" and B /=  "0000000000"  then
				sign_bit_data <= '0';
			elsif B ="0000000000"  then
				 detect_zero <= '1';
			end if;
			
		  
				
		if RST_N = '0' then 
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
                    if S_Start = '0' then  
                        Data_B(2*N-1 downto N) <= pro_b; 
                        Data_A(N-1 downto 0) <= pro_a;   
                        state <= S1;            
                    else
                        state <= S0; 
                    end if;
                
                when S1 => 
                    if (bit_counter < N+1) then
								Data_A <= Data_A - Data_B ;
								state <= S2;
							else 
								bit_counter <= 0 ;
								Data_A <= (others => '0');
								Data_B <= (others => '0');
								quotient <= (others => '0');
								state <= S0;
								Q(N-1 downto 0) <= quotient ;
								R <= Data_A(2*N-1 downto 0) ;
							end if ;
					when S2 => 
								if Data_A(2 * N -1) = '1' then            
									 Data_A <= Data_B + Data_A ;
                            Data_B <= std_logic_vector(shift_right(unsigned(Data_B), 1)); 
									 quotient <= std_logic_vector(shift_left(unsigned(quotient),1)); 
                            bit_counter <= bit_counter + 1;
                        else                       
									 quotient <= std_logic_vector(shift_left(unsigned(quotient),1)); 
									 quotient(0) <= '1';
									 Data_B <= std_logic_vector(shift_right(unsigned(Data_B), 1)); 								 
                            bit_counter <= bit_counter + 1;
                        end if;
									state <= S1 ;
                    
							
							sign_bit <= sign_bit_data;
                when others =>
                    state <= S0;
            end case;
        end if;
    end process;
end Behave;