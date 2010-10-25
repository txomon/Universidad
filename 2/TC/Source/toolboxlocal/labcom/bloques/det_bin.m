function mensaje=det_bin (x,t,t0,Fs,Vlim,sentido)
% function mensaje=det_bin (x,t,t0,Fs,Vlim,sentido)
% 	Función que muestrea una señal a una frecuencia de Fs y decide
%	el valor digital de la señal muestreada según el umbral Vlim.
% PARAMETROS DE ENTRADA:
%	x:	señal a muestrear.
%	t:	dominio de definición.
%	t0:	retardo incial para empezar a muestrear.
%	Fs:	frecuencia de muestreo.
%	Vlim:	umbral de detección. 
%	signo:	Si es 'n', a un valor inferior a Vlim se le asigna
%		un '1' y a uno superior un '0', si el cualquier otra
%		cosa, se asignan al revés, si se introduce más de un 
%		carácter da errores.
% PARAMETROS DE SALIDA:
%	mensaje: señal binaria detectada.
frec_muestreo=1/(t(2)-t(1));
paso=1/Fs*frec_muestreo;
indice=round(t0*frec_muestreo+1);
mensaje=[];
m=length(t);
while (indice<m)
	if (x(indice)>Vlim)
		if (sentido=='n')
			mensaje=[mensaje 0];
		else
			mensaje=[mensaje 1];
		end;
	else
		if (sentido=='n')
			mensaje=[mensaje 1];
		else
			mensaje=[mensaje 0];
		end;
	end;
	indice=indice+paso;
end;
