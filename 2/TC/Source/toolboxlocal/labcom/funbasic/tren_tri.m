function tren_tri=tren_tri (ancho,altura,periodo,t)
%function tren_tri=tren_tri (ancho,altura,periodo,t)
% Función que genera un tren de pulsos en forma de diente de sierra.
% 			|\____|\____|\____|\___
% PARAMETROS DE ENTRADA:
%      	ancho: anchura del triángulo.
%       altura: altura del triángulo.
%	periodo: periodo de los triángulos.
%	t: rango de valores o dominio de definici¢n.
% PARAMETROS DE SALIDA:
%	tren_tri: tren de triángulos.

if nargin~=4
        disp ('Error: Número de parámetros erróneo.');
else
	tren=triangu (ancho,altura,t);
	tren_tri=expanper (tren,periodo,t);
end
