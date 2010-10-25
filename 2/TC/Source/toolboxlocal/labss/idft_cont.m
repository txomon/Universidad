function [xi,ti]=idft_cont(esp,f,t)
% Funcion que sintetiza una señal de tiempo continuo a partir de su espectro
%
% function [xi,ti]=idft_cont2(esp,f,t)
%
% Parametros de entrada
%   esp: espectro de la señal x
%   f: dominio de definicion del espectro (entre -fs/2 y fs/2)
%   t: dominio de definicion de la señal x
% Parametros de salida
%   xi: señal recuperada
%   ti: dominio de definicion de la señal recuperada

ln=length(t)-1;
k=-ln/2:ln/2; %N puntos para el eje de tiempos

wn=exp(-j*2*pi/length(k));
nk=f'*k;
wnnk=wn.^(-nk);
x1=esp*wnnk/length(k);
x1=esp*wnnk;

xi=x1*(f(2)-f(1))*(t(2)-t(1)); %Escalado de la señal
%Definicion de un eje de tiempos con el mismo n de puntos que la señal
%recuperada
ts=1/2/(t(2)-t(1))/(f(2)-f(1)); % Frecuencia de muestreo usada
ti=(-ts/2)*2/3:ts*2/3/length(k):(ts/2)*2/3-1/length(k); %definicion del eje de tiempo
z=1
while(ti(z)<t(1))
    z=z+1
end
xi=xi(z:(length(xi)-z))
ti=ti(z:(length(ti)-z))
