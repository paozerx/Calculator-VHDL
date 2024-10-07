library ieee;
use ieee.std_logic_1164.ALL;
use ieee.STD_LOGIC_ARITH.all;
use ieee.std_logic_unsigned.all; 

entity top_level is
		Port ( clock  : in  std_logic;	
             reset  : in  std_logic; 	
				 sign_o : out std_logic;
				 done : out std_logic := '1'; 
				 input  : in std_logic_vector(9 downto 0);
				 START_in   : in std_logic;
				 seven_seg_digit_1 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_2 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_3 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_4 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_5 : out STD_LOGIC_VECTOR (6 downto 0);
				 seven_seg_digit_6 : out STD_LOGIC_VECTOR (6 downto 0));
end top_level;

architecture converter of top_level is
 signal BCD_data_digit_1 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_2 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_3 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_4 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_5 : STD_LOGIC_VECTOR (3 downto 0);
 signal BCD_data_digit_6 : STD_LOGIC_VECTOR (3 downto 0);
 signal A : STD_LOGIC_VECTOR (9 downto 0);
 signal B : STD_LOGIC_VECTOR (9 downto 0);
 signal selec : STD_LOGIC_VECTOR (1 downto 0);
 signal input_tran : STD_LOGIC_VECTOR (19 downto 0);
 signal Transfer_data_binary : STD_LOGIC_VECTOR (19 downto 0);
 signal enable_mux : std_logic;
 signal enable_num : std_logic;
 signal mux_to_mux : STD_LOGIC_VECTOR (19 downto 0);
 signal result_muti : STD_LOGIC_VECTOR (19 downto 0);
 signal result_add : STD_LOGIC_VECTOR (19 downto 0);
 signal result_sub : STD_LOGIC_VECTOR (19 downto 0);
 signal result_div : STD_LOGIC_VECTOR (19 downto 0);
 signal result_div_Q : STD_LOGIC_VECTOR (9 downto 0);
 signal sign_out : STD_LOGIC_VECTOR (6 downto 0);
 signal done_o : std_logic;


 
	begin
		main: 			entity work.main(Behavioral)
									port map(
										input => input,
										input_to => input_tran,
										start => START_in,
										reset => reset,
										enable => enable_mux,
										enable_binary => enable_num,
										selector => selec,
										a => A,
										b => B,
										clock => clock);
										
		mux_2: 			entity work.mux_to_box(Behavioral)
									port map(
										input_1 => input_tran,
										input_2 => mux_to_mux,
										enable => enable_mux,
										output => Transfer_data_binary);
										
		mux_4: 			entity work.mux_to_mux(Behavioral)
									port map(
										input_1 => result_add,
										input_2 => result_sub,
										input_3 => result_muti,
										input_4 => result_div,
										enable => selec,
										output => mux_to_mux);
		
		add: 			entity work.add_gen(data_flow)
									port map(
										a => A,
									   b => B,
										c_in => '0',
										sum => result_add);
										
		sub: 			entity work.sub_gen(data_flow)
									port map(
										a => A,
									   b => B,
										c_in => '1',
										sum => result_sub);
										
		multi: 			entity work.Multiplication(Behave)
									port map(
										A => A,
									   B => B,
										START => START_in,
										RST_N => reset,
										CLK => clock,
										sign => sign_o,
										DONE => done,
										R => result_muti);
		
		div: 			entity work.division(Behave)
									port map(
										A => A,
									   B => B,
										START => START_in,
										RST_N => reset,
										CLK => clock,
										sign_bit => sign_out,
										DONE => done_o,
										Q => result_div_Q,
										R => result_div);
										
		convert_binary:		entity work.result_to_BCD(Behavioral)
									port map(
										clk_i => clock,
										data  => Transfer_data_binary,
										enable_in => enable_num,
										BCD_digit_1 => BCD_data_digit_1,
										BCD_digit_2 => BCD_data_digit_2,
										BCD_digit_3 => BCD_data_digit_3,
										BCD_digit_4 => BCD_data_digit_4,
										BCD_digit_5 => BCD_data_digit_5,
										BCD_digit_6 => BCD_data_digit_6);
		seven_seg_display_1: entity work. BCD_to_7_segmen(data_process)
									port map(
										clk_i => clock,
										BCD_i  => BCD_data_digit_1,
										seven_seg  =>seven_seg_digit_1 );
		seven_seg_display_2: entity work. BCD_to_7_segmen(data_process)
									port map(
										clk_i => clock,
										BCD_i  => BCD_data_digit_2,
										seven_seg  =>seven_seg_digit_2 );
		seven_seg_display_3: entity work. BCD_to_7_segmen(data_process)
									port map(
										clk_i => clock,
										BCD_i  => BCD_data_digit_3,
										seven_seg  =>seven_seg_digit_3 );
		seven_seg_display_4: entity work. BCD_to_7_segmen(data_process)
									port map(
										clk_i => clock,
										BCD_i  => BCD_data_digit_4,
										seven_seg  =>seven_seg_digit_4);
		seven_seg_display_5: entity work. BCD_to_7_segmen(data_process)
									port map(
										clk_i => clock,
										BCD_i  => BCD_data_digit_5,
										seven_seg  =>seven_seg_digit_5);
		seven_seg_display_6: entity work. BCD_to_7_segmen(data_process)
									port map(
										clk_i => clock,
										BCD_i  => BCD_data_digit_6,
										seven_seg  =>seven_seg_digit_6);



end converter;

