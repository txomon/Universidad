function integrar=integrar (x)
% function integrar=integrar (x)
% Función que integra una función introducida como parámetro.
% PARAMETROS DE ENTRADA:
%               x:  señal a integrar.
% PARAMETROS DE SALIDA:
%               integra: señal de salida, integral de x.

integrar=cumsum(x);

