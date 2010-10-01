function [ output_args ] = ejercicio2( Anchura)
%EJERCICIO2 Summary of this function goes here
%  Detailed explanation goes here

t=-50:0.001:50;

y=rectpuls(t,Anchura);

subplot(2,1,1);
plot(t,y);