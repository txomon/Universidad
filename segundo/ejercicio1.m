function [ Precib ] = ejercicio1( Ptrans, Lcanal, Aten, Ganan)
%EJERCICIO1 Summary of this function goes here
%  Detailed explanation goes here
% como Aten=10*log(Ptrans/Precib) entonces la funcion, aislando seria

DbW=log10(Ptrans);
Precib=DbW-Lcanal*Aten+Ganan;


end