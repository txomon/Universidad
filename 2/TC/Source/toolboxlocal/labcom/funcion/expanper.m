function expanper=expanper(fun,T,t)
% function expanper=expanper(fun,T,t)
% Funión qu realiza la expansión periódica de la función fun con el
% período T.
%PARAMETROS DE ENTRADA:
%	fun: 	función cuya expansión periódica deseamos realizar.
%	T: 	período de la función expandida.
%	t: 	rango de valores de la función fun.
%PARAMETROS DE SALIDA
%	expanper: expansión periódica de la función fun.

suma=fun;
desplazamiento=T;
while desplazamiento < 2*max(t) 			%se escoge 2*max(t)
	sumando2=retardar(fun,desplazamiento,t);
	suma=suma+sumando2;			        %porque en ese momento
	desplazamiento=desplazamiento+T;		%estamos seguros de
end;							%que habremos reali-
desplazamiento=-T;					%zado todos los posi-
while abs(desplazamiento) < 2*max(t)			%desplazmientos de la
	suma=suma+retardar(fun,desplazamiento,t);	%funci¢n fun y sus
	desplazamiento=desplazamiento-T;		%respectivas sumas.
end;
expanper=suma;
