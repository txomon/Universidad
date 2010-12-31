function plot_cuant(q)
%Funcion que permite dibujar la caracteristica de un cuantificador uniforme
%de q niveles de decision

x=-1:0.0001:1;
plot(x,q_unif(x,q))
grid on;
pause;
close;
end