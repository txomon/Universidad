function error=p_error (b1,b2)
% function error=p_error (b1,b2)
% Función que calcula el error cometido al considerar b2 como la 
% original b1, en tanto por uno.
% PARAMETROS DE ENTRADA:
%	b1:	señal originada.
%	b2:	señal detectada.
% PARAMETROS DE SALIDA:
%	p_error: error cometido en tanto por uno.

indice=1;
m=length (b1);
error=0;
if (m~=length (b2))
	disp ('Error: b1 y b2 deben tener la misma longitud');
else
	while (indice<=m)
		if (b1(indice)~=b2(indice))
			error=error+1;
		end;
		indice=indice+1;
	end;
	error=error/m;
end;

