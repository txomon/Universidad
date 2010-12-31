function [senal, tiempo, Fs]=leer_sen (x)
% function [senal,tiempo, Fs]=leer_sen (x)
% Funcion para leer la señal en formato wav introducida como cadena de caracteres.
% PARAM;ETROS DE ENTRADA:
%	x:	nombre del archivo wav a leer.
% PARAMETROS DE SALIDA:
%	senal: 	contiene las muestras de señal normalizada.
%	tiempo: eje de tiempos de la señal.
%	Fs:	frecuencia de muestreo de la señal.

% leemos la señal
[senal, Fs]=wavread (x);
senal=(senal-128);
senal=senal/max (abs(senal));
tiempo=[0:1/Fs:(size(senal,1)-1)/Fs];
senal=senal';
