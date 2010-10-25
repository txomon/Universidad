function [y,t] = manchest(Rb,msg,fs)
%function [y,t] = manchest(Rb,msg,fs)
%%MANCHEST  Señal con código Manchester [-1, 0, 1].
%	MANCHEST (Rb,MSG) - Genera una señal en banda base
% 	con código Manchester sin retorno a cero de velocidad
%	Rb bits por segundo, con la forma especificada en MSG. La 
%	entrada MSG debe ser un vector de 1's y 0's. La 
%	frecuencia de muestreo por defecto es FS = 8192 Hz.
% PARAMETROS DE ENTRADA:
%	Rb:	velocidad en bits por segundo.
%	msg:	señal binaria a codificar.
%	fs: 	frecuencia de muestreo de la señal generada.
% PARAMETROS DE SALIDA:
%	y:	señal bipolar generada.
%	t:	dominio temporal de definición.


if nargin==2
	fs=8192;
end;

positivos=zeros(1,2*length(msg));
negativos=zeros(1,2*length(msg));

for indice=1:length(msg)
	if msg(indice)==1
		negativos(2*indice)=1;
		positivos(2*indice-1)=1;
	else
		negativos(2*indice-1)=1;
		positivos(2*indice)=1;
	end;
end;
y=uniponrz (2*Rb,positivos,fs)-uniponrz (2*Rb,negativos,fs);
t=0:1/fs:(length(y)-1)/fs;
