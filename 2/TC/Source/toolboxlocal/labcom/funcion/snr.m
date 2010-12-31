function s_n_r=snr(xh,x)
%       s_n_r= snr (xh, x)
%       Función que calcula la relación señal a ruido en dB de una señal
%	cuantificada.
% PARÁMETROS DE ENTRADA:
%               xh= quantized signal.
%               x = original signal.
% PARÁMETRO DE SALIDA:
%               s_n_r = SNR in dBs.

error=x-xh;
x=x.*x;
error=error.*error;
s_n_r=10*log10(sum(x)/sum(error));


