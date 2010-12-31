function y=canal (x, t, G, N, B)
%function y=canal (x, t, G, N, B)
%	Función que simula un canal con ganancia G, ruido aditivo 
%	de ancho de Gaussiano blanco de potencia N y con un ancho de
%	banda B.
%PARAMETROS DE ENTRADA:
%	x: señal de entrada al canal.
%	t: dominio de definición.	
%	G: ganancia del canal.
%	N: potencia de ruido del canal.
%	B: ancho de banda del canal.
%PARAMETROS DE SALIDA:
%	y: señal a la salida del canal simulado.

y=x*G;
y=y+gauss(0,N,t);
y=filtropb (y,t,B,8,60);
