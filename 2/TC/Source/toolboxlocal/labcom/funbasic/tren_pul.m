function tren_pul=tren_pul (ancho,altura,periodo,t)
% function tren_pul=tren_pul (ancho,altura,periodo,t)
% Función que genera un tren de pulsos.
% PARAMETROS DE ENTRADA:
%	ancho: 	anchura del pulso.
%	altura:	altura del pulso.
%	periodo:	periodo de los pulsos.
%	t: 	rango de valores o dominio de definición.
% PARAMETROS DE SALIDA:
%	tren_pul: tren de pulsos.

if nargin~=4
        disp ('Error: Número de parámetros erróneo.');
else
	paso=t(2)-t(1);
	indice_sup=ancho/paso+1;
	tren1=ones(1,indice_sup);
	tren2=zeros(1,length(t)-indice_sup);
	tren=[tren1 tren2];
	tren_pul=expanper (tren,periodo,t);
end
