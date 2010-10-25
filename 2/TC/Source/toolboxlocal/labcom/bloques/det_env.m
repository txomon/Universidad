function [y,t_y]=det_env (x,t_x,K)
% function [y,t_y]=det_env (x,t_x,K)
% Función de detección de envolvente. Obtiene la envolvente de una señal
% simulando el paso por un filtro RC de constante K.
% PARAMETROS DE ENTRADA:
%               x:   señal de entrada.
%               t_x: dominio de definición de la señal de entrada.
%               K:   constante del filtro RC.
% PARAMETROS DE SALIDA:
%               y:   envolvente de la señal de entrada.
%               t_y: dominio de definición de la señal de salida. En
%                    este caso será el mismo que el de entrada.

if nargin~=3
        disp ('Error: Número de parámetros erróneo.');
else
        indice=1;
        t_aterior=t_x;
        t_y=t_x;
        x_anterior=0;
        y=x;
        
        while (indice<=size(x,2))
                if (x(indice)>=x_anterior)
                        x_anterior=x(indice);
                        y(indice)=x(indice);
                        t_anterior=t_x(indice);
                else
                        y(indice)=x_anterior*exp(-(t_x(indice)-t_anterior)/K);
                        x_anterior=y(indice);
                end
                indice=indice+1;
        end
end                

