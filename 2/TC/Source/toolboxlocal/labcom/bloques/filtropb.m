function y = filtropb (x, t_x, fc, orden, db)
% function y = filtropb (x, t_x, fc, orden, db)
% Función que filtra pasobajo la señal de entrada.
% La frecuencia de corte puede variar entre 0 y la mitad de la frecuencia
% de muestreo.
% PARAMETROS DE ENTRADA;
%               x:   señal de entrada a filtrar.
%               t_x: dominio de definición.
%               fc:  frecuencia de corte del filtro.
%               orden: orden del filtro.
%               db:  atenuación en DBs de las frecuencias altas.
% PARAMETROS DE SALIDA:
%               y:   señal filtrada pasobajo.

if nargin~=5
        disp ('Error: Número de parámetros erróneo.');
else
        % Comprobamos la frecuencia de corte
        fs= 1/(t_x(2)-t_x(1));
        u=2*fc/fs;
        if (u>=1)
                error ('La frecuencia de corte debe ser menor que la mitad de la frecuencia de muestreo');
        end
        [B,A]=cheby2 (orden, db, u);
        y=filter (B,A,x);
end;
