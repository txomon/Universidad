function [y,t]=filtrorc (x, t, RC)
% function y=filtrorc (x, t, R, C)
% Función que filtra la señal introducida como parámetro con
% un filtro RC pasobajo.
% PARAMETROS DE ENTRADA:
%	x:	señal a filtrar.
%	t:	dominio de definición de la señal a filtrar.
%	RC:	valor de la constante del filtro.
% PARAMETROS DE SALIDA:
%	y:	señal filtrada.

% Calculamos la respuesta frecuencial de la señal

fftpts=length(x);
n = fftpts/2;
ts=t(2)-t(1);
freq = 2*pi*(1/ts); 	% Multiplicamos por 2*pi para tener radianes
w = freq*(0:n-1)./(2*(n-1));
y1=1./(1+i*RC*w);
y2=abs(ifft(y1,fftpts))*length(y1);
yf=conv(x,y2);
y=yf(ceil(fftpts/2):ceil(fftpts/2)+fftpts-1);
t=0:ts:ts*(length(y)-1);

