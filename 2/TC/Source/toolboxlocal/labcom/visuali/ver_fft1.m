function ver_fft1 (x, t, fftpts, fre_visu, n_ite)
% function ver_fft1 (x, t, fftpts, fre_visu, n_ite)
% Función que visualiza gráficamente una señal y su espectro.
% PARAMETROS DE ENTRADA:
%               X:    	señal a visualizar.
%               t:    	dominio de definición de las señales moduladas
%               fftpts: número de puntos para hacer la fft.
%               fre_visu: número de puntos nuevos en cada visualización.
%  (opcional)	n_ite:	número de iteraciones a visualizar.
% PARAMETROS DE SALIDA:
%               Ninguno.

if ((nargin==4)|(nargin==5))
	if (nargin==4)
		n_ite=length(x);
	end;
        % Abrimos una nueva ventana
        % Para resolución 800x600
        h_fig1 = figure('Unit','pixel','Pos',[100 100 600 500],'Name','Señal X');
        % Para resolución 1024x728
        %h_fig1 = figure('Unit','pixel','Pos',[200 100 600 500],'Name','Señal X');
        set(0, 'CurrentF', h_fig1);
        
        %subplot211
        handels(1) = subplot(311);
        handels(2) = plot(0,0,'m','EraseMode','None');
        handels(3) = get(handels(1),'Title');
        set(handels(1),'Visible','off');
        
        %subplot212
        handels(4) = subplot(312);
        handels(5) = plot(0,0,'EraseMode','None');
        handels(6) = get(handels(4),'Title');
        set(handels(4),'Visible','off');
        
        %subplot313
        handels(7) = subplot(313);
        handels(8) = plot(0,0,'EraseMode','None');
        handels(9) = get(handels(4),'Title');
        set(handels(7),'Visible','off');
        
        set(h_fig1, 'UserData', handels);
        set(h_fig1,'NextPlot','new');
        
        handels = get(h_fig1,'UserData');
        buffer = zeros (1,fftpts);
        
        ts=t(2)-t(1);
        indice=1;
        m=size(x,2);
        
                n = fftpts/2;
                freq = 2*pi*(1/ts); % Multiply by 2*pi to get radians
                w = freq*(0:n-1)./(2*(n-1));
        
        
        while (((indice+fftpts)<m)&(n_ite>0))
                buffer = [buffer(fre_visu+1:fftpts) x(indice:(indice+fre_visu))];
        
                y=buffer;
        
                g = fft(y(1:fftpts),fftpts);
                         
                g = g(1:n)/length(g);
                ffts = abs(g);
        
                tvec = t(indice:(indice+fftpts));
                set(handels(1),'Visible','on','Xlim',[min(tvec) max(tvec)],'Ylim',[min(buffer*.99) max(buffer*1.01+eps)])
                set(handels(2),'XData',tvec,'YData',buffer)
                set(handels(3),'String','Tiempo')
                xl = get(handels(1),'Xlabel');
                set(xl,'String','Tiempo (seg)')
        
                tmp = 'Espectro';
        
                ysc = ffts(~isnan(ffts));
                if isempty(ysc)
                        ysc=[0 1];
                else
                        ysc = sort([min(ysc*.99), max(ysc*1.01+eps)]);
                end;
                set(handels(4),'Visible','on','Xlim',[min(w(2:n)/(2*pi)), max(w(2:n)/(2*pi))],'Ylim',ysc);
                set(handels(5),'XData',w(1:n)/(2*pi),'YData',ffts);
                set(handels(6),'String', tmp);
                xl = get(handels(4), 'Xlabel');
                set(xl,'String','Frequency (Hz)')
                yl = get(handels(4), 'Ylabel');
                set(yl, 'String','Modulo')                 
        
                %For phase plot,
                phase = angle(g);
                phase = phase(2:n);
                ysc = 180/pi*phase(~isnan(phase));
                if isempty(ysc)
                        ysc=[0 1];
                else
                        ysc = sort([min(ysc*.99), max(ysc*1.01+eps)]);
                end;
                set(handels(7),'Visible','on','Xlim',[min(w(2:n)/(2*pi)) max(w(2:n)/(2*pi))],'Ylim',ysc)
                set(handels(8),'XData',w(2:n)/(2*pi),'YData',phase)
                set(handels(9), 'String',tmp)
                xl = get(handels(7), 'Xlabel');
                set(xl, 'String', 'Frecuencia (Hz)')
                yl = get(handels(7), 'Ylabel');
                set(yl, 'String','Grados')                 
        
                % Aumentamos el indice para la siguiente iteraci¢n
                indice=indice+fre_visu;
                drawnow;
		n_ite=n_ite-1;
        end
        disp ('Pulsar una tecla para terminar');
        pause;
        disp ('Finalizado');
        close;
else
        disp ('Error: Número de parámetros erróneo.');
end;
