function cola=q (x)
% function cola=q (x)
% Función que calcula la el área de una cola gaussiana.
% PARAMETROS DE ENTRADA:
%	x:	límite inferior de la integral
% PARAMETROS DE SALIDA:
%	cola: 	area de la cola.
cola=exp(-x*x/2)/sqrt(2*pi*x*x);