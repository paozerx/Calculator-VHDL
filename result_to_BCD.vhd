library ieee;
use ieee.std_logic_1164.ALL;
use ieee.STD_LOGIC_ARITH.all;
use ieee.std_logic_unsigned.all;

entity result_to_BCD is
    Port ( clk_i      : in  std_logic;
           enable_in  : in  std_logic;
			  enable_cal : in std_logic;
			  enable_mux : in std_logic;
			  detect_zero : in std_logic;
			  sign  : in  std_logic;
			  sign_input  : in  std_logic;
			  selec_in  : in  STD_LOGIC_VECTOR (1 downto 0);
           data       : in  STD_LOGIC_VECTOR (19 downto 0);
			  R       : in  STD_LOGIC_VECTOR (19 downto 0);
			  overflow_add : in std_logic;
			  overflow_sub : in std_logic;
           BCD_digit_1 : out STD_LOGIC_VECTOR (3 downto 0);
           BCD_digit_2 : out STD_LOGIC_VECTOR (3 downto 0);
           BCD_digit_3 : out STD_LOGIC_VECTOR (3 downto 0);
           BCD_digit_4 : out STD_LOGIC_VECTOR (3 downto 0);
           BCD_digit_5 : out STD_LOGIC_VECTOR (3 downto 0);
           BCD_digit_6 : out STD_LOGIC_VECTOR (3 downto 0));
end result_to_BCD;

architecture Behavioral of result_to_BCD is
    signal int_data_1 : integer := 0;
    signal int_data_2 : integer := 0;
    signal int_data_3 : integer := 0;
    signal int_data_4 : integer := 0;
    signal int_data_5 : integer := 0;
    signal int_data_6 : integer := 0;
begin
    process(clk_i, data)
    begin
        if (clk_i'event and clk_i = '1') then
            if data = "10000000000000000000" and enable_in = '0' then
                int_data_1 <= 11;
                int_data_2 <= 11;
                int_data_3 <= 11;
                int_data_4 <= 10;
                int_data_5 <= 10;
                int_data_6 <= 10;
					 
            elsif data = "11000000000000000000" and enable_in = '0' then
                int_data_1 <= 12;
                int_data_2 <= 12;
                int_data_3 <= 12;
                int_data_4 <= 12;
                int_data_5 <= 12;
                int_data_6 <= 12;
					 
				elsif selec_in = "00" and enable_mux = '1' and enable_in = '1'  then
					if conv_integer(unsigned(R)) / 10 >= 10 or conv_integer(unsigned(data)) / 10 >= 10 then
						 int_data_1 <= 15;
						 int_data_2 <= 15;
						 int_data_3 <= 15;
						 int_data_4 <= 15;
						 int_data_5 <= 15;
						 int_data_6 <= 15;
					else
						 int_data_1 <= conv_integer(unsigned(R)) mod 10;
						 int_data_2 <= (conv_integer(unsigned(R)) / 10) mod 10;
						 int_data_3 <= 13;
						 int_data_4 <= conv_integer(unsigned(data)) mod 10;
						 int_data_5 <= (conv_integer(unsigned(data)) / 10) mod 10;
						 if sign = '1' then
							int_data_6 <= 14;
						 else 
							int_data_6 <= 12;
						 end if;
					end if;
					
				elsif selec_in = "01" and enable_mux = '1' and enable_in = '1'  then
					if (conv_integer(unsigned(data)) / 10000) >= 10 and enable_mux = '1' and selec_in = "01" and enable_in = '1' then
						 int_data_1 <= 15;
						 int_data_2 <= 15;
						 int_data_3 <= 15;
						 int_data_4 <= 15;
						 int_data_5 <= 15;
						 int_data_6 <= 15;
					else
						 int_data_1 <= conv_integer(unsigned(data)) mod 10;
						 int_data_2 <= (conv_integer(unsigned(data)) / 10) mod 10;
						 int_data_3 <= (conv_integer(unsigned(data)) / 100) mod 10;
						 int_data_4 <= (conv_integer(unsigned(data)) / 1000) mod 10;
						 int_data_5 <= (conv_integer(unsigned(data)) / 10000) mod 10;
						 if enable_mux = '1' and sign = '1' then
							int_data_6 <= 14;
						 else 
							int_data_6 <= 12;
						end if;
					end if;
					
				elsif selec_in = "10" and enable_mux = '1' and enable_in = '1'  then
					if selec_in = "10" and enable_mux = '1' and overflow_sub = '1' and enable_in = '1' then
						 int_data_1 <= 15;
						 int_data_2 <= 15;
						 int_data_3 <= 15;
						 int_data_4 <= 15;
						 int_data_5 <= 15;
						 int_data_6 <= 15;
					else
						 int_data_1 <= conv_integer(unsigned(data)) mod 10;
						 int_data_2 <= (conv_integer(unsigned(data)) / 10) mod 10;
						 int_data_3 <= (conv_integer(unsigned(data)) / 100) mod 10;
						 int_data_4 <= (conv_integer(unsigned(data)) / 1000) mod 10;
						 int_data_5 <= (conv_integer(unsigned(data)) / 10000) mod 10;
						 if enable_mux = '1' and sign = '1' then
							int_data_6 <= 14;
						 else 
							int_data_6 <= 12;
						end if;
					end if;
				
				elsif selec_in = "11" and enable_mux = '1' and enable_in = '1'  then
					if selec_in = "11" and enable_mux = '1' and overflow_add = '1' and enable_in = '1' then
						 int_data_1 <= 15;
						 int_data_2 <= 15;
						 int_data_3 <= 15;
						 int_data_4 <= 15;
						 int_data_5 <= 15;
						 int_data_6 <= 15;
					else
						 int_data_1 <= conv_integer(unsigned(data)) mod 10;
						 int_data_2 <= (conv_integer(unsigned(data)) / 10) mod 10;
						 int_data_3 <= (conv_integer(unsigned(data)) / 100) mod 10;
						 int_data_4 <= (conv_integer(unsigned(data)) / 1000) mod 10;
						 int_data_5 <= (conv_integer(unsigned(data)) / 10000) mod 10;
						 if enable_mux = '1' and sign = '1' then
							int_data_6 <= 14;
						 else 
							int_data_6 <= 12;
						end if;
					end if;
					 
					 
				elsif enable_cal = '1' and enable_mux = '0' and enable_in = '0' then
					if data(1 downto 0) = "00" then
						 int_data_1 <= 0;
						 int_data_2 <= 0;
					elsif data(1 downto 0) = "01" then
						 int_data_1 <= 1;
						 int_data_2 <= 0;
					elsif data(1 downto 0) = "10" then
						 int_data_1 <= 0;
						 int_data_2 <= 1;
					elsif data(1 downto 0) = "11" then
						 int_data_1 <= 1;
						 int_data_2 <= 1;
					end if;
				  int_data_3 <= 12;
				  int_data_4 <= 12;
				  int_data_5 <= 12;
				  int_data_6 <= 12;
					 
            elsif enable_mux = '0' and enable_in = '1' and enable_cal = '0' then
                int_data_1 <= conv_integer(unsigned(data)) mod 10;
                int_data_2 <= (conv_integer(unsigned(data)) / 10) mod 10;
                int_data_3 <= (conv_integer(unsigned(data)) / 100) mod 10;
                int_data_4 <= (conv_integer(unsigned(data)) / 1000) mod 10;
                int_data_5 <= (conv_integer(unsigned(data)) / 10000) mod 10;
                if enable_mux = '0' and sign_input = '1' then
						int_data_6 <= 14;
					 else 
						int_data_6 <= 12;
					end if;
					
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