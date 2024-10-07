library ieee;
use ieee.std_logic_1164.ALL;
use ieee.STD_LOGIC_ARITH.all;
use ieee.std_logic_unsigned.all;

entity result_to_BCD is
		Port ( clk_i  : in  std_logic;	-- system clock
				 data 	: in  STD_LOGIC_VECTOR (19 downto 0);
				 BCD_digit_1 : out STD_LOGIC_VECTOR (3 downto 0);
				 BCD_digit_2 : out STD_LOGIC_VECTOR (3 downto 0);
				 BCD_digit_3 : out STD_LOGIC_VECTOR (3 downto 0);
				 BCD_digit_4 : out STD_LOGIC_VECTOR (3 downto 0);
				 BCD_digit_5 : out STD_LOGIC_VECTOR (3 downto 0);
				 BCD_digit_6 : out STD_LOGIC_VECTOR (3 downto 0));
				 	
					  
end result_to_BCD;

architecture Behavioral of result_to_BCD is
signal int_data_1 : integer := 0;
signal int_data_2 : integer:= 0;
signal int_data_3 : integer := 0;

	begin
		process(clk_i,data)
			begin
					
				if (clk_i'event and clk_i='1') then
					if(data = "0100000000") then
						int_data_1 <= 10;
						int_data_2 <= 10;
						int_data_3 <= 10;
					else
						int_data_1 <= conv_integer(unsigned(data)) mod 10;
						int_data_2 <= (conv_integer(unsigned(data)) / 10) mod 10;
						int_data_3 <= (conv_integer(unsigned(data)) / 100) mod 10;
						int_data_4 <= (conv_integer(unsigned(data)) / 1000) mod 10;
						int_data_5 <= (conv_integer(unsigned(data)) / 10000) mod 10;
						int_data_6 <= (conv_integer(unsigned(data)) / 100000) mod 10;
					end if;

					
				end if;
				BCD_digit_1 <= conv_std_logic_vector(int_data_1, 4);
				BCD_digit_2 <= conv_std_logic_vector(int_data_2, 4);
				BCD_digit_3 <= conv_std_logic_vector(int_data_3, 4);
				BCD_digit_4 <= conv_std_logic_vector(int_data_4, 4);
				BCD_digit_5 <= conv_std_logic_vector(int_data_5, 4);
				BCD_digit_6 <= conv_std_logic_vector(int_data_6, 4);
				


				
					
		end process;

		
end Behavioral;