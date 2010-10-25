function x=idft_disc(esp,n)
% Funcion que sintetiza una señal de tiempo discreto a partir de su espectro
%
% function x=idft_disc(esp,n)
%
% Parametros de entrada
%   esp: espectro de la señal x
%   n: dominio de definicion de la señal x
% Parametros de salida
%   x: señal
ln=length(n)-1; %N puntos del eje de tiempos
k=-ln/2:ln/2; %Rango de definicion
%Calculo de la IDFT
wn=exp(-j*2*pi/ln);
nk=n'*k;
wnnk=wn.^(-nk);
x=esp*wnnk/ln;