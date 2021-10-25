-- Estructural 
-- Simon sin teclado para poder realizar testbench

library ieee;
use ieee.std_logic_1164.all;

entity SIMON_sin_tec is 
port( clk:				       	in std_logic;
      nRst:					      in std_logic;
      tecla:          in std_logic_vector(3 downto 0);
      tecla_valida_reg: in std_logic;
      duracion_pulso:   in std_logic;
      flanco_bajada_col: in std_logic;
      columna_color: in std_logic_vector (1 downto 0);
      
      
      presentacion:			buffer std_logic_vector (7 downto 0);
      barra_leds:     buffer std_logic_vector(2 downto 0);
      leds:           buffer std_logic_vector (2 downto 0);
	    mux_display:			 buffer std_logic_vector (7 downto 0));
end entity;
   	         
	    
architecture struct of SIMON_sin_tec is
  signal tic_1ms:				std_logic;
  signal parpadeo_fin: 	std_logic;
  
  signal rd: 	std_logic;
  signal color_ready: 	std_logic;
  signal ena_color: std_logic;
  signal d_out: 	std_logic_vector(1 downto 0);
  signal color_salida: 	std_logic_vector(1 downto 0);
  signal we_mem: 	std_logic;
  signal full: 	std_logic;
  signal fin_lectura_secuencia: 	std_logic;
  
  signal color_generado: std_logic_vector(1 downto 0);
  signal tic_1s:				std_logic;
  signal tiempo_secuencia:				std_logic;
  signal rst_time:				std_logic;
  signal recor:				std_logic_vector(13 downto 0);
  signal start:				std_logic;
  signal modo:				std_logic;
  signal lon:				std_logic;
  signal rec:				std_logic;  
  signal mostrando_secuencia: std_logic;
   
  signal longitud_programada_bin: 	std_logic_vector(13 downto 0);
  signal puntuacion_out: 	std_logic_vector(13 downto 0);
  signal cuenta_num_mostrado: std_logic_vector(13 downto 0);
  signal posicion_secuencia: 	std_logic_vector(13 downto 0);
  signal longitud_programada_bcd: 	std_logic_vector(15 downto 0);
  signal recor_bcd: 	std_logic_vector(15 downto 0);
  signal cuenta_num_mostrado_bcd: std_logic_vector(15 downto 0); 
  signal posicion_secuencia_bcd: 	std_logic_vector(15 downto 0);
  signal puntuacion_out_bcd: 	std_logic_vector(15 downto 0);
  
  signal reset: std_logic;
  signal nueva_lectura: std_logic;
  signal num_memoria_bcd: std_logic_vector(15 downto 0);
  signal num_colores: std_logic_vector(13 downto 0);
  
begin	    
  				      
	
	MEMORIA: entity work.gestion_memoria(rtl)
		port map( clk 		 => clk,
				      nRst		 => nRst,
				      reset	 => reset,
				      nueva_lectura => nueva_lectura,                              
				      rd	 => rd,
				      wr => color_ready,
				      d_in => color_generado,
				      longitud_programada_bin => longitud_programada_bin,   
				      
				      d_out => d_out,
				      we_mem => we_mem,
				      num_colores => num_colores,
				      full => full,
				      fin_lectura_secuencia => fin_lectura_secuencia);
				      			      
		
		CONTROL_C: entity work.CONTROL(struct)
		port map( clk 		 => clk,
				      nRst		 => nRst,
				      tecla	 => tecla,
				      tecla_valida_reg => tecla_valida_reg,                              
				      we_mem	 => we_mem,
				      full => full,
				      fin_lectura_secuencia => fin_lectura_secuencia,
				      columna_color => columna_color,   				      
				      d_out => d_out,			  				      
				      tic_1s => tic_1s, 
				      flanco_bajada_col => flanco_bajada_col,
				      tiempo_secuencia => tiempo_secuencia,
				      
				      color_ready => color_ready,
				      start => start,
				      color_generado => color_generado,
				      puntuacion_out => puntuacion_out,
				      rec => rec,
				      recor => recor,
				      modo => modo,
				      lon => lon,
				      parpadeo_fin => parpadeo_fin,
				      color_salida => color_salida,
				      rd => rd,
				      nueva_lectura => nueva_lectura,
				      mostrando_secuencia => mostrando_secuencia,
				      longitud_programada_bin => longitud_programada_bin,
				      rst_time => rst_time,
				      reset => reset,
				      cuenta_num_mostrado => cuenta_num_mostrado,
				      posicion_secuencia => posicion_secuencia);
				      
				      
  TEMPORIZADOR: entity work.timer(rtl)
		port map( clk 		 => clk,
				      nRst		 => nRst,
				      rst_time	 => rst_time,
				      
				      tic_1ms => tic_1ms,                         				      
				      tic_1s	 => tic_1s,
				      tiempo_secuencia => tiempo_secuencia);			
				      
				      	      
	CONVERSOR_BIN_TO_BCD: entity work.bin_to_bcd(rtl)
		port map( longitud_prog_bin 		=> longitud_programada_bin,
				      recor		 => recor,
				      cuenta_num_mostrado => cuenta_num_mostrado,
				      posicion_secuencia	 => posicion_secuencia,
				      puntuacion_out => puntuacion_out,  
				      mostrando_secuencia => mostrando_secuencia,                            
				      reset	 => reset,
				      rec => rec,
				      start => start,
				      lon => lon,
				      num_colores => num_colores,
				      
				      cuenta_num_mostrado_bcd => cuenta_num_mostrado_bcd,
				      num_memoria_bcd => num_memoria_bcd,
				      longitud_programada_bcd => longitud_programada_bcd,
				      recor_bcd => recor_bcd,
				      posicion_secuencia_bcd => posicion_secuencia_bcd, 
				      puntuacion_out_bcd => puntuacion_out_bcd);				      
				       
	
	PRESENTAR_DISP: entity work.presentacionDisplays(rtl)
		port map( clk 		 => clk,
				      nRst		 => nRst,
				      tic_1ms	 => tic_1ms,
				      modo => modo,                              
				      Lon	 => lon,
				      rec => rec,
				      start => start,
				      mostrando_secuencia => mostrando_secuencia,
				      parpadeo_fin => parpadeo_fin,
				      tic_1s => tic_1s,
				      longitud_programada_bcd => longitud_programada_bcd,   
				      recor_bcd => recor_bcd,
				      posicion_secuencia_bcd => posicion_secuencia_bcd,
				      puntuacion_out_bcd => puntuacion_out_bcd,
				      num_memoria_bcd => num_memoria_bcd,
				      cuenta_num_mostrado_bcd => cuenta_num_mostrado_bcd,
				         			      
				      presentacion => presentacion,
				      mux_display => mux_display);		
	
	PRESENTAR_LEDS: entity work.presentacionLeds(rtl)
		port map( clk 		 => clk,
				      nRst		 => nRst,
				      start	 => start,
				      tic_1ms => tic_1ms,                         				      
				      duracion_pulso	 => duracion_pulso,
				      mostrando_secuencia => mostrando_secuencia,
				      color_salida => color_salida,
				      columna_color => columna_color,
				      
				      barra_leds => barra_leds,
				      leds => leds);
				      			      
				      	      		      
end struct;				      
