function pot=potencia (x,t)
%function pot=potencia (x,t)
%Función que calcula la potencia de una selñal según la fórmula
%               E[x(t)]^2
%PARAMETROS DE ENTRADA:
%               x:   señal de entrada.
%               t:   dominio de definición de la señal de entrada.
%PARAMETROS DE SALIDA:
%               pot: potencia de la señal.

y=x.*x;
pot=sum(y)/length(y);
