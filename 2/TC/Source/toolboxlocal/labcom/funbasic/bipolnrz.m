function [y, t] = bipolnrz(Rb,msg,fs)
%function [y, t] = bipolnrz(Rb,msg,fs)
%BIPOLNRZ  Señal bipolar [-1, 0, 1].
%	BIPOLNRZ (Rb,MSG) - Genera una señal en banda base
% 	bipolar sin retorno a cero de velocidad Rb bits por 
%	segundo, con la forma especificada en MSG. La 
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

anterior=-1;
positivos=zeros(1,length(msg));
negativos=zeros(1,length(msg));

for indice=1:length(msg)
	if msg(indice)==1
		if anterior==1
			negativos(indice)=1;
			anterior=-1;
		else
			positivos(indice)=1;
			anterior=1;
		end;
	end;
end;
y=uniponrz (Rb,positivos,fs)-uniponrz (Rb,negativos,fs);
y=y;
t=0:1/fs:(length(y)-1)/fs;
