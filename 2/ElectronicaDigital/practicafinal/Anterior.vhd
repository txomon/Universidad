

-------------------------- RELOJ ------------------------------
---------------------------------------------------------------

process (mclk) 
begin
   if mclk='1' and mclk'event then 			-- controlar que sea el mclk el que cambie valores
      if rst='1' then 							-- el reset que funcione a nivel alto
			lento <= 0;								-- el contador de hasta 25000000 se pone a 0 con reset
         segundero <= 0;
			minutero <= 0;
			hora <= 0;
			hora_alarm <= 0;
			minuto_alarm <= 0;
      elsif rst='0' then
         if cmb_hora='1' then
            lento <= 0;
				segundero <= 0;
         else 
--				if lento=2 then -- para simular
				if lento=25000000 -- para la placa
					lento<=0;
					if segundero=59 then 
						segundero<=0;
						if minutero=59 then
							minutero<=0;
							if hora=23 then
								hora<=0;
							else
								hora<=hora+1;
							end if;
						else
							minutero<=minutero+1;
						end if;
					else
						segundero <= segundero +1;					
					end if;
				else
					lento <= lento + 1;
				end if;
         end if;
      end if;
   end if;
end process;

---------------------------------------------------------------
---------------------------------------------------------------
process (cmb_hora , cmb_desp)
begin



end process; 

end Behavioral;
