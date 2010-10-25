function desplaza=desplaza(fun,n,t)
%funcion desplaza=desplaza(fun,n,t) 
% Realiza el desplazamiento de la funci¢n fun n puntos a la derecha 
% o a la izquierda.
% PARAMETROS DE ENTRADA:
%	fun: 	función cuyo desplazamiento vamos a realizar.
%	n: 	número de puntos que vamos a desplazar la función.
%	t: 	rango de valores o dominio de definición de la función t.
%PARAMETROS DE SALIDA:
%	desplaza: función fun desplazada n puntos.

array=0 .*t;
if n>0
	union=[zeros(1,n),fun];		%función ya desplazada, pero ahora
					%deberemos eliminar los puntos
					%en exceso.
	desplaza=union(:,1:length(t));
elseif n<0 & abs(n)<=length(t)
	funtruncada=fun(:,abs(n)+1:length(t));	%valores de la funci¢n fun
						%que no se perder n.
	desplaza=[funtruncada,zeros(1,abs(n))];
elseif n<0 & abs(n)>length(t)
	desplaza=zeros(1,length(t));
else
	desplaza=fun;
end;
