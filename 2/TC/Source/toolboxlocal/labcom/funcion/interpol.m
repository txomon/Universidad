function [y,n_y]=interpol(x,n,L)
% function [y,n_y]=interpol(x,n,L)
% Función que realiza la interpolación de la función x por un factor L.
% Si L no es entero se redondea a su valor superior más próximo.
% 'x' debe tener más de 9 muestras.
% PARAMETROS DE ENTRADA:
%               y:   función que queremos interpolar.
%               n:   dominio de definición discreto de la función de entrada.
%               L:   factor de interpolación.
% PARAMETROS DE SALIDA:
%               y:   función interpolada.
%               n_y :dominio de definición de la función de salida.

L1=ceil(L);
if nargin~=3
        disp ('Error: Número de parámetros erróneo.');
else
        n_y=n(1):(n(2)-n(1))/L1:max(n)+(L-1)*(n(2)-n(1))/L1;
        y=interp (x,L1);
end;
