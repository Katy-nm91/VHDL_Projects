-- Generador aleatorio de colores
-- Se obtiene el valor del color aleatorio cuando se requiere
-- y además, una señal de salida que indican la validación del color 
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity generador_color is
  port (
	clk:  			in std_logic;
	nRst:			in std_logic;
	ena_color:		in std_logic;						                            -- enable para generar color
    
	color_generado: buffer std_logic_vector(1 downto 0);       -- Dato de entrada de la memoria
	color_ready: buffer std_logic); 					                      -- activa habilitacion de escritura (WR) de la memoria				                 
end entity;  

architecture rtl of generador_color is	
signal generador: std_logic_vector(1 downto 0);
signal fdc: std_logic;

begin
process(clk, nRst)
   begin
     if nRst = '0' then
        generador <= (others => '0');
     elsif clk'event and clk = '1' then
       if fdc = '1' then
          generador <= (others => '0');
       elsif ena_color = '0' then
          generador <= generador + 1;
      end if;
    end if;
end process;
  
fdc <= '1' when generador = 2 and ena_color = '0' else '0';
       
color_generado <=  "01" when generador = 0 and ena_color = '1' else
                   "10" when generador = 1 and ena_color = '1' else
                   "11" when generador = 2 and ena_color = '1' else
                   "00";     

-- Color valido               
color_ready <= '1' when color_generado /= "00" and ena_color ='1'
                 	else '0';

  
end architecture ; 