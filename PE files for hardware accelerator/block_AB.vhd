-- Boards supported
-- HLS 
-- 2Blocks - log - adder -antilog.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.fixed_pkg.all;

entity block_AB is        
 port(
 	A: in std_logic_vector(7 downto 0); 
 	B: in std_logic_vector(7 downto 0); 
	code_word: in std_logic_vector(2 downto 0);
	clk: in std_logic;
	nRst: in std_logic;
	antilog_out: buffer std_logic_vector (7 downto 0)

 );
end entity; 

architecture rtl of block_AB is
signal output: std_logic_vector (7 downto 0);
type t_estado is (ini, log, adder, subtraction, antilog);
signal state: t_estado;
signal flag_FSM: std_logic_vector (2 downto 0) := "000";
signal storage_2: real := 0.0;   

signal  flag_mode: std_logic;

-- ADDER and SUB

signal adder_output: real := 0.0;
signal subtraction_output: real := 0.0;

--
signal A_current: std_logic_vector(7 downto 0); 
signal A_past: std_logic_vector(7 downto 0); 
signal flag_outcome: std_logic;
signal real_num_A: real; 
signal flag_A_ready: std_logic := '0';
--
signal B_current: std_logic_vector(7 downto 0); 
signal B_past: std_logic_vector(7 downto 0); 
signal real_num_B: real;
signal flag_B_ready: std_logic := '0';

signal subtraction_flag: std_logic;
signal adder_flag: std_logic;

----------------
 begin

process(clk, nRst)

variable N_A: ufixed (4 downto -5);
variable number_A_past: ufixed (2 downto -5);
variable number_A_past2: ufixed (2 downto -5);

variable N_shift_A: ufixed (2 downto -5);
variable M_A: ufixed (7 downto -5); variable MM: ufixed (7 downto -5); variable MM_1: ufixed (7 downto -5); variable MM_2: ufixed (2 downto -5);
variable M_shift_A: ufixed (2 downto -5);  
variable number_A: ufixed (2 downto -5);   
variable antilog_real: real;
variable antilog_fp: ufixed (2 downto -5);
variable antilog_M: std_logic_vector (2 downto 0);
variable antilog_N: std_logic_vector (4 downto 0);
variable antilog_shift: ufixed (4 downto -5);
--
variable N_B: ufixed (4 downto -5);
variable number_B_past: ufixed (2 downto -5);

variable N_shift_B: ufixed (2 downto -5);
variable M_B: ufixed (7 downto -5); 
variable M_shift_B: ufixed (2 downto -5);  
variable number_B: ufixed (2 downto -5);   


	begin
	if nRst = '0' then
	 A_current <= (others => '0');
	 N_A := (others => '0');   
	 N_shift_A := (others => '0');
	 M_A := (others => '0');
	 M_shift_A := (others => '0');
	 number_A := (others => '0');
	 real_num_A <= 0.0;
--
	 B_current <= (others => '0');
	 N_B := (others => '0');   
	 N_shift_B := (others => '0');
	 M_B := (others => '0');
	 M_shift_B := (others => '0');   
	 number_B := (others => '0');
	 real_num_B <= 0.0;
	-- antilog_out <= (others => '0'); 

	 number_A_past := (others => '1'); 
	 number_B_past := (others => '1'); 
output <= (others => '0');
antilog_out <= (others => '0');
 antilog_real := 0.0;
 antilog_fp := (others => '0');  
antilog_M := (others => '0');  
 antilog_N := (others => '0');  
antilog_shift := (others => '0');  

	elsif clk'event and clk = '1' then
	 A_current <= A;
	 B_current <= B;

-- A   
		-- From std_logic_vector to real
        	-- shift and placing of the real part   
		
		for k in 0 to 4 loop     
   		  N_A(k) := A_current(k);         
		end loop; 
	 	  N_shift_A := "000" & N_A(4 downto 0);

        	-----------------------------------
        	-- shift and placing of the integer part  
		for k in 0 to 7 loop        
   		 M_A(k) := A(k);   
		end loop;     
               -- M_shift_A := M_A(7 downto 5) & "00000";     
        	  -----------------------------------

        	-- number in fixed point
		If N_shift_A /= number_A_past then   -- ONLY WORKS IF THE DECIMAL PART IS DIFFERENT FROM THE DECIMAL PART OF THE PREVIOUS NUMBER 
		  number_A := M_A(7 downto 5) & N_shift_A(-1 downto -5);
		  number_A_past := N_shift_A;
		-- conversion to real (to operate exponential)
		  real_num_A <= to_real(number_A);
		end if;

  

-- B
		-- From std_logic_vector to real
        	-- shift and placing of the real part   
		for k in 0 to 4 loop     
   		  N_B(k) := B_current(k);         
		end loop; 
	 	  N_shift_B := "000" & N_B(4 downto 0);
        	-----------------------------------
        	-- shift and placing of the integer part  
		for k in 0 to 7 loop        
   		 M_B(k) := B(k);   
		end loop;        
        	  -----------------------------------
        	-- number in fixed point
		If N_shift_B /= number_B_past then
		  number_B := M_B(7 downto 5) & N_shift_B(-1 downto -5);
		  number_B_past := N_shift_B;
		-- conversion to real (to operate exponential)
		  real_num_B <= to_real(number_B);
		end if;

-- Output	
		if flag_outcome = '1' then 
	          antilog_fp := to_ufixed(storage_2, 2, -5); 
	
		  for i in 0 to 2 loop        
   	  	   antilog_M(i) := antilog_fp(i);   
	          end loop; 

		   antilog_shift := antilog_fp (-1 downto -5) & "00000";

	 	  for i in 0 to 4 loop        
   	 	   antilog_N(i) := antilog_shift(i);   
	          end loop; 
	        output <= antilog_M(2 downto 0) & antilog_N(4 downto 0);	
		antilog_out <= output;
	       end if; 

	end if;
end process;






process(clk, nRst)
	begin
	if nRst = '0' then
		state <= ini;
	elsif clk'event and clk = '1' then
		case state is
		 when ini =>
	          if flag_FSM = "001" then
	 	     state <= log;
	          elsif flag_FSM = "101" then
	 	     state <= adder;
	          elsif flag_FSM = "110" then
	 	     state <= subtraction;
		  end if;
		 when log =>
	          if flag_FSM = "010" then
	 	     state <= adder;
		  elsif flag_FSM = "011" then
		     state <= subtraction;
		  end if;
		 when subtraction =>
	          if flag_FSM = "100" then
	 	     state <= antilog;
	          elsif flag_FSM = "000" then
	 	     state <= ini;
		  end if;
		 when adder =>
	          if flag_FSM = "100" then
	 	     state <= antilog;
	          elsif flag_FSM = "000" then
	 	     state <= ini;
   		  end if;
		 when antilog =>
	          if flag_FSM = "000" then
	 	     state <= ini;
   		  end if;
	         when others => state <= ini;
		end case;
        end if;
end process;


	


---------------------------------------------------      
  process (clk, nRst)
  
   	--variable An: integer := 0; 
  	variable num_den: real := 0.0;
  	--variable A_menos1: integer := 0;
	--variable A_mas1: integer := 0;  
	variable A_menos1_real : real := 0.0;
	variable A_mas1_real : real := 0.0;
	variable storage_1_log: real := 0.0;
	variable storage_2_log: real := 0.0;
	variable anti_storage: real := 0.0;
variable anti_adder_storage: real := 0.0;

	variable mult3, mult5, mult7, mult9, mult11, mult13,  mult15, mult17, mult19, mult21, mult23, mult25, mult27, mult29: real := 0.0;
	variable mult31, mult33, mult35, mult37, mult39, mult41, mult43, mult45, mult47, mult49, mult51, mult53, mult55, mult57, mult59: real := 0.0;
	variable mult61, mult63, mult65, mult67, mult69, mult71, mult73, mult75, mult77, mult79, mult81, mult83, mult85, mult87, mult88, mult89: real := 0.0;
	variable mult90, mult91, mult93, mult95, mult97, mult99, mult101, mult103, mult105, mult107, mult109, mult111, mult113, mult115, mult117: real := 0.0;
	variable mult119, mult121, mult123, mult125, mult127, mult129, mult131, mult133, mult135, mult137, mult139, mult141, mult143, mult145, mult147: real := 0.0;
	variable mult149, mult151, mult153, mult155, mult157, mult159, mult161, mult163, mult165, mult167, mult169, mult171, mult173, mult175, mult177, mult179 : real := 0.0;
	variable mult181, mult183, mult185, mult187, mult189, mult191, mult193, mult195, mult197, mult199: real := 0.0;
	variable ln_10: real := 2.302585093;	
	variable ln_A: real := 0.0;

   begin  
      if nRst = '0' then          
	A_menos1_real := 0.0;
	A_mas1_real := 0.0;
	num_den := 0.0;  
 	ln_A := 0.0;
	storage_1_log := 0.0;
	storage_2_log := 0.0;
	flag_FSM <= "000";
	A_past <= (others => '0');
	B_past <= (others => '0'); 
	flag_outcome <= '0';
	flag_B_ready <= '0';
	flag_A_ready <= '0';
subtraction_flag <= '0';   
adder_flag <= '0';
flag_mode <= '0';
      
      elsif clk'event and clk = '1' then
  	case state is
	     when ini =>   
	        flag_outcome <= '0';	
		if (A_current /= "00000000" and A_current /= A_past) and (B_current /= "00000000" and B_current /= B_past) and (code_word = "011" or code_word = "100") then
	        flag_FSM <= "001";
 		flag_mode <= '1';
		A_past <= A_current;
		B_past <= B_current;
	        flag_A_ready <= '1';
 	        flag_B_ready <= '0';  
		elsif (A_current /= "00000000" and A_current /= A_past) and (B_current /= "00000000" and B_current /= B_past) and code_word = "001" then
	        flag_FSM <= "101";
		flag_mode <= '0';
 		A_past <= A_current;
		B_past <= B_current;
		elsif (A_current /= "00000000" and A_current /= A_past) and (B_current /= "00000000" and B_current /= B_past) and code_word = "010"  then
  	        flag_FSM <= "110";
		flag_mode <= '0'; 
		A_past <= A_current;
		B_past <= B_current;   
  	        end if;

	     when log =>
	        if flag_A_ready = '1' and flag_B_ready = '0' then
		   A_menos1_real := real_num_A - 1.0;
		   A_mas1_real := real_num_A + 1.0; 
		elsif flag_A_ready = '0' and flag_B_ready = '1' then
		   A_menos1_real := real_num_B - 1.0;
		   A_mas1_real := real_num_B + 1.0;  	
		end if;  

		    num_den := A_menos1_real/A_mas1_real; 
		    mult3 := num_den ** 3.0; mult5 := num_den ** 5.0; mult7 := num_den ** 7.0; mult9 := num_den ** 9.0;
		    mult11 := num_den ** 11.0; mult13 := num_den ** 13.0; mult15 := num_den ** 15.0; mult17 := num_den ** 17.0; mult19 := num_den ** 19.0; 
		    mult21 := num_den ** 21.0; mult23 := num_den ** 23.0; mult25 := num_den ** 25.0; mult27 := num_den ** 27.0; mult29 := num_den ** 29.0;                                                     
		    mult31 := num_den ** 31.0; mult33 := num_den ** 33.0; mult35 := num_den ** 35.0; mult37 := num_den ** 37.0; mult39 := num_den ** 39.0;
		    mult41 := num_den ** 41.0; mult43 := num_den ** 43.0; mult45 := num_den ** 45.0; mult47 := num_den ** 47.0; mult49 := num_den ** 49.0;
		    mult51 := num_den ** 51.0; mult53 := num_den ** 53.0; mult55 := num_den ** 55.0; mult57 := num_den ** 57.0; mult59 := num_den ** 59.0;
		    mult61 := num_den ** 61.0; mult63 := num_den ** 63.0; mult65 := num_den ** 65.0; mult67 := num_den ** 67.0; mult69 := num_den ** 69.0;
		    mult71 := num_den ** 71.0; mult73 := num_den ** 73.0; mult75 := num_den ** 75.0; mult77 := num_den ** 77.0; mult79 := num_den ** 79.0;
		    mult81 := num_den ** 81.0; mult83 := num_den ** 83.0; mult85 := num_den ** 85.0; mult87 := num_den ** 87.0; mult89 := num_den ** 89.0;
		    mult91 := num_den ** 91.0; mult93 := num_den ** 93.0; mult95 := num_den ** 95.0; mult97 := num_den ** 97.0; mult99 := num_den ** 99.0;
		    mult101 := num_den ** 101.0; mult103 := num_den ** 103.0; mult105 := num_den ** 105.0; mult107 := num_den ** 107.0; mult109 := num_den ** 109.0;
		    mult111 := num_den ** 111.0; mult113 := num_den ** 113.0; mult115 := num_den ** 115.0; mult117 := num_den ** 117.0; mult119 := num_den ** 119.0;
		    mult121 := num_den ** 121.0; mult123 := num_den ** 123.0; mult125 := num_den ** 125.0; mult127 := num_den ** 127.0; mult129 := num_den ** 129.0;
		    mult131 := num_den ** 131.0; mult133 := num_den ** 133.0; mult135 := num_den ** 135.0; mult137 := num_den ** 137.0; mult139 := num_den ** 139.0;
		    mult141 := num_den ** 141.0; mult143 := num_den ** 143.0; mult145 := num_den ** 145.0; mult127 := num_den ** 147.0; mult149 := num_den ** 149.0;
		    mult151 := num_den ** 151.0; mult153 := num_den ** 153.0; mult155 := num_den ** 155.0; mult157 := num_den ** 157.0; mult159 := num_den ** 159.0;
		    mult161 := num_den ** 161.0; mult163 := num_den ** 163.0; mult165 := num_den ** 165.0; mult167 := num_den ** 167.0; mult169 := num_den ** 169.0;
		    mult171 := num_den ** 171.0; mult173 := num_den ** 173.0; mult175 := num_den ** 175.0; mult177 := num_den ** 177.0; mult179 := num_den ** 179.0;
		    mult181 := num_den ** 181.0; mult183 := num_den ** 183.0; mult185 := num_den ** 185.0; mult187 := num_den ** 187.0; mult189 := num_den ** 189.0;
		    mult191 := num_den ** 191.0; mult193 := num_den ** 193.0; mult195 := num_den ** 195.0; mult197 := num_den ** 197.0; mult199 := num_den ** 199.0;


	ln_A := 2.0 *( num_den + (1.0/3.0)*mult3 + (1.0/5.0)*mult5 + (1.0/7.0)*mult7 + (1.0/9.0)*mult9 + (1.0/11.0)*mult11 + (1.0/13.0)*mult13 + (1.0/15.0)*mult15 + (1.0/17.0)*mult17 + (1.0/19.0)*mult19 
	+ (1.0/21.0)*mult21 + (1.0/23.0)*mult23  + (1.0/25.0)*mult25  + (1.0/27.0)*mult27 + (1.0/29.0)*mult29 + (1.0/31.0)*mult31 + (1.0/33.0)*mult33 + (1.0/35.0)*mult35 + (1.0/37.0)*mult37 + (1.0/39.0)*mult39
	+ (1.0/41.0)*mult41 + (1.0/43.0)*mult43 + (1.0/45.0)*mult45 + (1.0/47.0)*mult47 + (1.0/49.0)*mult49 + (1.0/51.0)*mult51 + (1.0/53.0)*mult53 + (1.0/55.0)*mult55 + (1.0/57.0)*mult57 + (1.0/59.0)*mult59
	+ (1.0/61.0)*mult61 + (1.0/63.0)*mult63 + (1.0/65.0)*mult65 + (1.0/67.0)*mult67 + (1.0/69.0)*mult69 + (1.0/71.0)*mult71 + (1.0/73.0)*mult73 + (1.0/75.0)*mult75 + (1.0/77.0)*mult77 + (1.0/79.0)*mult79
	+ (1.0/83.0)*mult83 + (1.0/85.0)*mult85 + (1.0/87.0)*mult87 + (1.0/89.0)*mult81 + (1.0/89.0)*mult81 + (1.0/91.0)*mult91 + (1.0/93.0)*mult93 + (1.0/97.0)*mult97 + (1.0/99.0)*mult99 + (1.0/101.0)*mult101
	+ (1.0/103.0)*mult103 + (1.0/105.0)*mult105 + (1.0/107.0)*mult107 + (1.0/109.0)*mult109 + (1.0/111.0)*mult111 + (1.0/113.0)*mult113 + (1.0/115.0)*mult115 + (1.0/117.0)*mult117 + (1.0/119.0)*mult119 
	+ (1.0/121.0)*mult121 + (1.0/123.0)*mult123 + (1.0/125.0)*mult125 + (1.0/127.0)*mult127 + (1.0/129.0)*mult129 + (1.0/131.0)*mult131 + (1.0/133.0)*mult133 + (1.0/135.0)*mult135 + (1.0/137.0)*mult137
	+ (1.0/139.0)*mult139 + (1.0/141.0)*mult141 + (1.0/143.0)*mult143 + (1.0/145.0)*mult145 + (1.0/147.0)*mult147 + (1.0/149.0)*mult149 + (1.0/151.0)*mult151 + (1.0/153.0)*mult153 + (1.0/155.0)*mult155
	+ (1.0/157.0)*mult157 + (1.0/159.0)*mult159 + (1.0/161.0)*mult161 + (1.0/163.0)*mult163 + (1.0/165.0)*mult165 + (1.0/167.0)*mult167 + (1.0/169.0)*mult169 + (1.0/171.0)*mult171 + (1.0/173.0)*mult173 
	+ (1.0/175.0)*mult175 + (1.0/177.0)*mult177 + (1.0/179.0)*mult179 + (1.0/181.0)*mult181 + (1.0/183.0)*mult183 + (1.0/185.0)*mult185 + (1.0/187.0)*mult187 + (1.0/189.0)*mult189 + (1.0/191.0)*mult191
 	+ (1.0/193.0)*mult193 + (1.0/195.0)*mult195 + (1.0/197.0)*mult197 + (1.0/199.0)*mult199);

	        if flag_A_ready = '1' and flag_B_ready = '0' then
		   storage_1_log := ln_A/ln_10; 
	           flag_A_ready <= '0';
	           flag_B_ready <= '1';    
		   	-- flag_FSM <= "11";  	
		elsif flag_A_ready = '0' and flag_B_ready = '1' then
	           storage_2_log := ln_A/ln_10;	 
			-- flag_FSM <= "11"; 
	           flag_A_ready <= '0';
	           flag_B_ready <= '0'; 
   	           if code_word = "011" then
	              flag_FSM <= "010";
	           elsif code_word = "100" then
		      flag_FSM <= "011";
	           end if;
		end if;
  
  	     when antilog =>   
		if adder_flag = '1' then
	          anti_storage := 10**adder_output; --std_logic_vector(to_unsigned(10**An, antilog_out'length));
                  storage_2 <= anti_storage;
		  adder_flag <= '0';
		elsif subtraction_flag = '1' then 
	          anti_storage := 10**subtraction_output; --std_logic_vector(to_unsigned(10**An, antilog_out'length));
                  subtraction_flag <= '0';
                  storage_2 <= anti_storage;
		end if;
	        flag_outcome <= '1';
		flag_mode <= '0';
		flag_FSM <= "000";

	    when adder =>

		if flag_mode = '1' then
		 adder_output <= storage_1_log + storage_2_log;
		 --storage_2 <= adder_output;
	         adder_flag <= '1';
		 flag_FSM <= "100";
                else
	         storage_2  <= real_num_A + real_num_B;
		 --storage_2 <= adder_output;
                 flag_outcome <= '1';
		 flag_FSM <= "000";
		end if;
		

	    when subtraction => 

		if flag_mode = '1' then
		 subtraction_output <= storage_1_log - storage_2_log;
		 subtraction_flag <= '1';
		 flag_FSM <= "100";
                else
		 storage_2 <= real_num_A - real_num_B;
		 --storage_2 <= subtraction_output;
                 flag_outcome <= '1';
		 flag_FSM <= "000";
		end if;


	      when others => storage_2 <= 0.0;

	end case;
     end if;   
  end process;



end rtl;
