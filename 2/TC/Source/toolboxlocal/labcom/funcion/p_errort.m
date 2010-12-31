function error=p_errort (A,s2)
% function error=p_errort (A,s2)
% Función que calcula la probabilidad de error en la detección de 
% una señal binaria ruidosa.
% PARAMETROS DE ENTRADA:
%	A:	señal unipolar	A=sqrt(2*Sr)
%	s2:	señal polar	A=sqrt(4*Sr)
% PARAMETROS DE SALIDA:
%	p_errort: probabilidad de error teórico.
%k=A/(2*sqrt(s2));
k=6;
error=exp(-k*k/2)/sqrt(2*pi*k*k);