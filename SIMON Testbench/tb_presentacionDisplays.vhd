library ieee;
use ieee.std_logic_1164.all;

entity tb_presentacionDisplay is

end entity;

architecture test of tb_presentacionDisplay is

signal clk:                 std_logic;
signal nRst:                std_logic;
signal modo:                std_logic;
signal lon:                 std_logic;
signal rec:                 std_logic;
signal start:               std_logic;
signal tic_1s:              std_logic;
signal tic_1ms:	        	   std_logic;
signal mostrando_secuencia: std_logic;
signal parpadeo_fin:		 	   std_logic; 
signal longitud_programada_BCD: std_logic_vector(15 downto 0);
signal recor_BCD:               std_logic_vector(15 downto 0);
signal cuenta_num_mostrado_bcd:   std_logic_vector(15 downto 0);
signal num_memoria_bcd:        std_logic_vector(15 downto 0); 
signal posicion_secuencia_BCD:  std_logic_vector(15 downto 0);
signal puntuacion_out_bcd:          std_logic_vector(15 downto 0);
signal presentacion:        std_logic_vector (7 downto 0);
signal mux_display:         std_logic_vector (7 downto 0);
constant tclk:       time := 20 ns;

  begin

  dut: entity Work.presentacionDisplays(rtl)
    port map(clk                 => clk,
             nRst                => nRst,
             modo                => modo,
             lon                 => lon,
             rec                 => rec,
             start               => start,
             tic_1s              => tic_1s,
             tic_1ms              => tic_1ms,
             mostrando_secuencia => mostrando_secuencia,
             parpadeo_fin => parpadeo_fin,
             longitud_programada_bcd => longitud_programada_bcd,
             cuenta_num_mostrado_bcd => cuenta_num_mostrado_bcd,
             recor_bcd               => recor_bcd,
             num_memoria_bcd => num_memoria_bcd,
             posicion_secuencia_bcd  => posicion_secuencia_bcd,
             puntuacion_out_bcd          => puntuacion_out_bcd,
             presentacion        => presentacion,
             mux_display         => mux_display
             );
      
  --Se genera escalado para la lectura del test
process
  begin
    tic_1ms <= '0';
    wait for tclk*5;
    tic_1ms <= '1';
    wait for tclk;
end process ;      

process
  begin
    tic_1s <= '0';
    wait for tclk*50;
    tic_1s <= '1';
    wait for tclk;
end process ;      

reloj : process
  begin
    clk <= '0';
    wait for tclk/2;
    clk <= '1';
    wait for tclk;
  end process ; 

  prueba : process
  begin
    -- Inicizalizacion asincrona
    nRst         <=  '0';
    wait for tclk;
    wait until clk'event and clk='1';
    nRst    <= '1';
    -- Fin inicializacion asincrona

    -- Inicializacion sincrona
    modo                <= '1';
    Lon                 <= '0';
    rec                 <= '0';
    start               <= '0';
    longitud_programada_bcd <= "0000000000100000";
    recor_bcd              <= "0000000000000000";
    posicion_secuencia_bcd <= "0000000000000000";
    puntuacion_out_bcd          <= "0000000000000000";
    wait for 45*tclk;
    wait until clk'event and clk='1';

    --Pasamos al modo de configurar longitud

    modo                <= '0';
    lon                 <= '1';
    wait for 45*tclk;
    wait until clk'event and clk='1';
    
    --Se borra un numero de la longitud

    longitud_programada_bcd <= "0000000000000010";
    wait for 45*tclk;
    wait until clk'event and clk='1';
    longitud_programada_bcd <= "0010010100110000";
    wait for 45*tclk;
    wait until clk'event and clk='1';

    --Pasamos a modo config de nuevo

    modo                <= '1';
    lon                 <= '0';
    wait for 45*tclk;
    wait until clk'event and clk='1';

    --Pasamos al modo partida

    modo                  <= '0';
    start                 <= '1';
    wait for 45*tclk;
    wait until clk'event and clk='1';

    --Se avanza unas posiciones de secuencia y la puntuacion

    posicion_secuencia_bcd  <= "0000000000000100";
    puntuacion_out_bcd          <= "0000000000010000";
    wait for 45*tclk;
    wait until clk'event and clk='1';

    --Se avanza unas posiciones de secuencia y la puntuacion

    posicion_secuencia_bcd  <= "0000100000110011";
    puntuacion_out_bcd          <= "0111000001000011";
    wait for 45*tclk;
    wait until clk'event and clk='1';

    --Acaba la partida 

    start <= '0';
    recor_bcd <= "0111000001000011";
    wait for 300*tclk;
    wait until clk'event and clk='1';

    --Se vuelve al modo configuracion

    modo <= '1';
    wait for 45*tclk;
    wait until clk'event and clk='1';

    --Se va al modo recor

    rec <= '1';
    modo <= '0';
    wait for 90*tclk;
    wait until clk'event and clk='1';

   assert false
    report "fone"
    severity failure;

  end process; 
 end test;
   
