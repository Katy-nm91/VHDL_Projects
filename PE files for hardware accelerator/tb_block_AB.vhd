library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_block_AB is
end entity;

architecture tb of tb_block_AB is
 
  signal A: std_logic_vector (7 downto 0);
  signal B: std_logic_vector (7 downto 0);
  signal code_word: std_logic_vector (2 downto 0);
  signal clk: std_logic;
  signal nRst: std_logic;
  signal antilog_out: std_logic_vector (7 downto 0);   
  constant tclk: time := 20 ns;   

  begin
  dut: entity Work.block_AB(rtl)
    port map (A => A, B => B, antilog_out => antilog_out, code_word => code_word, clk => clk, nRst => nRst);

 process       
begin
    clk <= '0';
    wait for tclk/2;
    clk <= '1';
    wait for tclk/2;
end process ;
               
  process
   constant period: time := 20 ns;  
    begin

  nRst <= '0';
  A <= X"00";  
  B <= X"00"; 
code_word <= "011";
  wait for tclk*4;
  wait until clk'event and clk='1';
  nRst<='1';   
  wait until clk'event and clk='1';
  --wait until clk'event and clk='1';
  -- Fin inicialización asíncrona

        A <= X"43"; 
        B <= X"23"; 

       --for i in 0 to 253 loop
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';       
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';     
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';       
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';     
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
code_word <= "100";

        A <= X"73"; 
        B <= X"53"; 

       --for i in 0 to 253 loop
       wait until clk'event and clk='1'; 
       wait until clk'event and clk='1';       
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';     
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';       
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';     
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
code_word <= "001";
        A <= X"12"; 
        B <= X"05"; 

       --for i in 0 to 253 loop
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';       
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';     
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
code_word <= "010";

        A <= X"55"; 
        B <= X"46"; 

       --for i in 0 to 253 loop
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';       
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';     
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';

code_word <= "010";

        A <= X"25"; 
        B <= X"15"; 

       --for i in 0 to 253 loop
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';       
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';     
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';
       wait until clk'event and clk='1';


--A <= A + 1;
--end loop;
assert false 
  report "done"
  severity failure;

    wait;
  end process;
end tb;