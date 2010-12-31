function fft_plot(x,fs)
% Funcion que representa el espectro de una señal de tiempo continuo
%
% function fft_plot(x,fs)
%
% Parametros de entrada
%   x: señal
%   fs: frecuencia de muestreo

fs2=fs/2;
fs4=fs/4;
f=-fs/2:fs/512:(fs/2)-1;
a=abs (fftshift(fft(x,512)));
plot (f,a);
