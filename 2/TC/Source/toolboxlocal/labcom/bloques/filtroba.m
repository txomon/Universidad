function y = filtroba (x, t_x, fci, fcs, orden, db)
% function y = filtroba (x, t_x, fci, fcs, orden, db)
% Función que filtra pasobanda la señal de entrada.
% Las frecuencias de corte pueden variar entre 0 y la mitad de la frecuencia
% de muestreo.
% PARAMETROS DE ENTRADA;
%               x:   señal de entrada a filtrar.
%               t_x: dominio de definición.
%               fci: frecuencia de corte inferior del filtro.
%               fcs: frecuencia de corte superior del filtro.
%               orden: orden del filtro.
%               db:  atenuación en DBs de las frecuencias eliminadas.
% PARAMETROS DE SALIDA:
%               y:   señal filtrada pasobanda.

if nargin~=6
        disp ('Error: Número de parámetros erróneo.');
else
        % Comprobamos la frecuencia de corte
        fs= 1/(t_x(2)-t_x(1));
        ui=2*fci/fs;
        if (ui>=1)
                error ('La frecuencia de corte inferior debe ser menor que la mitad de la frecuencia de muestreo');
        end
        us=2*fcs/fs;
        if (us>=1)
                error ('La frecuencia de corte superior debe ser menor que la mitad de la frecuencia de muestreo');
        end
        [B,A]=cheby2 (orden, db, us);
        y=filter (B,A,x);
        [B,A]=cheby2 (orden, db, ui, 'high');
        y=filter (B,A,y);
end;
