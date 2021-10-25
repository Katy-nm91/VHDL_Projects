library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_generador_color is   
end entity;

architecture tb of tb_generador_color is
  signal clk: std_logic;
  signal nRst: std_logic;
  signal ena_color: std_logic;	
  signal color_generado: std_logic_vector(1 downto 0);
  signal color_ready: std_logic; 
  signal disponible_pick_clr: std_logic; 
  constant tclk: time := 20 ns;
  
  begin 
    
dut: entity work.generador_color(rtl)
port map(
    clk => clk,
    nRst => nRst,
    ena_color => ena_color,
    color_generado => color_generado,
    color_ready => color_ready
    );

process
begin
    clk <= '0';
    wait for tclk/2;
    clk <= '1';
    wait for tclk/2;
end process ;     

process
begin
  -- Inicizalización asíncrona
  nRst <= '0';
  ena_color <= '0';
  wait for tclk*4;
  wait until clk'event and clk='1';
  nRst<='1';
  -- Fin inicialización asíncrona
  
  -- Inicialización síncrona
  -- Cuando ena_color = '1' generamos un color.
  wait until clk'event and clk= '1';
  wait until clk'event and clk= '1';
  wait until clk'event and clk= '1';
  wait until clk'event and clk= '1';  
  ena_color <= '1';
  wait until clk'event and clk= '1';
  ena_color <= '0';
  wait for tclk*10;
  wait until clk'event and clk = '1';

  wait for tclk*100;             
  wait until clk'event and clk = '1';
  
  wait until clk'event and clk= '1';  
  ena_color <= '1';
  wait until clk'event and clk= '1';
  ena_color <= '0';
  
  wait for tclk*50;                  
  wait until clk'event and clk = '1';
  
  wait until clk'event and clk= '1';  
  ena_color <= '1';
  wait until clk'event and clk= '1';
  ena_color <= '0';
  wait until clk'event and clk = '1';
  wait until clk'event and clk = '1';
  
  wait until clk'event and clk= '1';  
  ena_color <= '1';
  wait until clk'event and clk= '1';
  ena_color <= '0';
  wait until clk'event and clk = '1';
  wait until clk'event and clk = '1';
  wait until clk'event and clk = '1';
  wait until clk'event and clk = '1';
  wait until clk'event and clk = '1';
  
  wait until clk'event and clk= '1';  
  ena_color <= '1';
  wait until clk'event and clk= '1';
  ena_color <= '0';
  wait until clk'event and clk = '1';
  wait until clk'event and clk = '1';
  wait until clk'event and clk = '1';
  wait until clk'event and clk = '1';
  
  assert false
  report "done"
  severity failure;
  
end process ;
end architecture;