function [triangu,t]=triangu(anchura,altura,Fs)
%Función triángulo(anchura, altura,Fs)
%PARAMETROS DE ENTRADA:
%	anchura: anchura del pulso triangular.
%	altura:	altura delpulso triangular.
%	Fs:	frecuencia de muestreo.
%PARAMETROS DE SALIDA:
%	triang: la propia función triángulo.
%	t:	dominio de definición.
pulso=ones(1,anchura*Fs/2);
triangu=conv(pulso,pulso);
triangu=triangu/max(triangu)*altura;
t=0:1/32000:(length(triangu)-1)/32000;
