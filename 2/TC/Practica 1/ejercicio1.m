function [ Precib ] = ejercicio1( Ptrans, Lcanal, Aten, Ganan)
%EJERCICIO1 Summary of this function goes here
%  Detailed explanation goes here
% como Aten=10*log(Ptrans/Precib) entonces la funcion, aislando seria

DbW=log10(Ptrans);
Precib=DbW-Lcanal*Aten+Ganan;

% La tabla queda asi:
% Ptrans | Lcanal | Aten | Ganan ===>  Precib
% ------------------------------
% 10000  | 10     | 0.05 | 200   ===>  203.5000
% 10000  | 1000   | 0.05 | 200   ===>  154
% 100    | 1000   | 0.05 | 1000  ===>  952
% 100    | 10     | 0.01 | 10    ===>  11.9

end