function retardar=retardar(fun,to,t)
%function retardar=retardar(fun,to,t) 
% Realiza un retardo de la función fun de n unidades hacia la derecha
% o la izquierda.
%PARAMETROS DE ENTRADA:
%	fun: 	función que desamos retardar.
%	to: 	número de unidades del eje t que deseamos retardar.
%	t: 	rango de valores o dominio de definición de la función fun.
%PARAMETROS DE SALIDA:
%	retardo: función fun retardada.

resolucion=t(2)-t(1);
n=round(to/resolucion);
retardar=desplaza(fun,n,t);
