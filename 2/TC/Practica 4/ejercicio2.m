function [  ] = ejercicio2(  )
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here
% a)
% el filtro adaptado para un polar nrz, es como el pulso contrario
Rb=1000;
fs=32000;

hold on;
[ya,ta ] = polarnrz(Rb,[ 0 ],fs);
plot(ta,ya);
pause;
hold off;

% b)


msg= [ 1 0 0 1 0 ];

[y,t] = polarnrz(Rb,msg,fs);
hold on;
plot(t,y);

hold off;
