
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_gestion_memoria is
end entity;

architecture tb of tb_gestion_memoria is
  signal clk:                         std_logic;
  signal nRst:                        std_logic;
  signal reset:                       std_logic;
  signal rd:                          std_logic;
  signal wr:                          std_logic;
  signal nueva_lectura:               std_logic;
  signal d_in:                        std_logic_vector(1 downto 0);  
  signal longitud_programada_bin:         std_logic_vector(13 downto 0); 
  signal d_out:                       std_logic_vector(1 downto 0);  
  signal num_colores:                 std_logic_vector(13 downto 0); 
  signal full:             std_logic;                                                 
  signal fin_lectura_secuencia:       std_logic;

  constant tclk:   time := 20 ns; 

begin
  process
  begin
    clk <= '0';
    wait for tclk/2;
    clk <= '1';
    wait for tclk/2;
  end process;


  dut: entity work.gestion_memoria(rtl)
  port map (
    clk                   => clk,
    nRst                  => nRst,
    reset                 => reset,
    rd                    => rd,
    wr                    => wr,
    nueva_lectura         => nueva_lectura,
    d_in                  => d_in,
    longitud_programada_bin => longitud_programada_bin,
    d_out                 => d_out,
    num_colores           => num_colores, 
    full       => full,                                           
    fin_lectura_secuencia =>fin_lectura_secuencia
    );

  process
  begin
    -- Inicialización síncrona
    nRst <= '0';
    d_in <= "01";
    reset <= '0';
    nueva_lectura <= '0';
    wr <= '0'; 
    rd <= '0';   
    longitud_programada_bin <= "00000000001010" ;  
    wait for tclk*4;
    wait until clk'event and clk = '1';
    nRst <= '1';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    -- Fin iniciacilización asíncrona
    
    -- Inicialización síncrona                                     
 
    -- Escribo 5 colores
    wait until clk'event and clk = '1';
    wr <= '1';     
    d_in <= "01";
    wait until clk'event and clk = '1';
    wr <= '0';
    wait until clk'event and clk = '1';
    wr <= '1';      
    d_in <= "10";
    wait until clk'event and clk = '1';
    wr <= '0';
    wait until clk'event and clk = '1';
    wr <= '1';        
    d_in <= "11";
    wait until clk'event and clk = '1';
    wr <= '0';
    wait until clk'event and clk = '1';
    wr <= '1';        
    d_in <= "10";
    wait until clk'event and clk = '1';
    wr <= '0';
    wait until clk'event and clk = '1';
    wr <= '1';         
    d_in <= "11";
    wait until clk'event and clk = '1';
    wr <= '0';
    
    -- Leo 5 colores con 6 lecturas: comprobar lectura
    wait until clk'event and clk = '1';   
    rd <= '1';
    wait until clk'event and clk = '1';
    rd <= '0';          
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';   
    rd <= '1';
    wait until clk'event and clk = '1';
    rd <= '0';           
    wait until clk'event and clk = '1'; 
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';  
    rd <= '1';
    wait until clk'event and clk = '1';
    rd <= '0';          
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';    
    rd <= '1';
    wait until clk'event and clk = '1';
    rd <= '0';           
    wait until clk'event and clk = '1'; 
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';    
    rd <= '1';
    wait until clk'event and clk = '1';
    rd <= '0';           
    wait until clk'event and clk = '1'; 
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';    
    rd <= '1';
    wait until clk'event and clk = '1';
    rd <= '0';           
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';  
      
    nueva_lectura   <= '1';
    wait until clk'event and clk = '1';
    nueva_lectura   <= '0';

    -- Escribo 5 colores: compruebo memoria llena
    wait until clk'event and clk = '1';
    wr <= '1';       
    d_in <= "11";
    wait until clk'event and clk = '1';
    wr <= '0';
    wait until clk'event and clk = '1';
    wr <= '1';          
    d_in <= "01";
    wait until clk'event and clk = '1';
    wr <= '0';
    wait until clk'event and clk = '1';
    wr <= '1';          
    d_in <= "10";
    wait until clk'event and clk = '1';
    wr <= '0';
    wait until clk'event and clk = '1';
    wr <= '1';          
    d_in <= "11";
    wait until clk'event and clk = '1';
    wr <= '0';
    wait until clk'event and clk = '1';
    wr <= '1';       
    d_in <= "01";
    wait until clk'event and clk = '1';

    -- LECTURA:
   wait until clk'event and clk = '1';     
   rd      <= '1';
   wait until clk'event and clk = '1';
   rd      <= '0';           
   wait until clk'event and clk = '1'; 
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';    
   rd      <= '1';
   wait until clk'event and clk = '1';
   rd      <= '0';   
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';     
   rd      <= '1';
   wait until clk'event and clk = '1';
   rd      <= '0';  
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';  
   rd      <= '1';
   wait until clk'event and clk = '1';
   rd      <= '0';           
   wait until clk'event and clk = '1'; 
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';    
   rd      <= '1';
   wait until clk'event and clk = '1';
   rd      <= '0';   
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';     
   rd      <= '1';
   wait until clk'event and clk = '1';
   rd      <= '0';  
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1'; 
   rd      <= '1';
   wait until clk'event and clk = '1';
   rd      <= '0';           
   wait until clk'event and clk = '1'; 
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';    
   rd      <= '1';
   wait until clk'event and clk = '1';
   rd      <= '0';   
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';     
   rd      <= '1';
   wait until clk'event and clk = '1';
   rd      <= '0';  
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';  

    wait for 15*tclk;
    wait until clk'event and clk='1';
     
    assert false
    report "fone"
    severity failure;

  end process;
end tb;