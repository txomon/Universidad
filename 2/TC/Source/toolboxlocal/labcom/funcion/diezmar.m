function [y, n_y]=diezmar(x,n,M)
%function [y, n_y]=diezmar(x,n,M)
% Esta función realiza un diezmado de la señal de entrada por un factor M.
% Si M no es entero, se redondea a su valor entero inmediatamente superior.
% 'x' debe tener al menos 25 muestras.
%PARAMETROS DE ENTRADA:
%               x:   función a diezmar.
%               n:   dominio de definición de la función de entrada.
%               M:   factor de diezmado.
%PARAMETROS DE SALIDA:
%               y:   función diezmada.
%               n_y: nuevo dominio de deficinión.

if nargin~=3
        disp ('Error: Número de parámetros erróneo.');
else
        M1=ceil(M);
        n_y=n(1):(n(2)-n(1))*M1:max(n);
        y=decimate(x,M1);
end;

