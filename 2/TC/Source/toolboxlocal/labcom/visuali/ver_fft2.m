function ver_fft2 (x, y, t, fftpts, fre_visu, n_ite)
% function ver_fft2 (x, y, t, fftpts, fre_visu, n_ite)
% Función que visualiza gráficamente dos señales y sus espectros.
% PARAMETROS DE ENTRADA:
%               X:      señal a visualizar.
%               y:      señal a visualizar.
%               t:    	dominio de definición de las señales.
%               fftpts: número de puntos para hacer la fft.
%               fre_visu: número de puntos nuevos en cada visualización.
%  (opcional)	n_ite:	número de iteraciones a visualizar.
% PARAMETROS DE SALIDA:
%               Ninguno.
% Si las señales tienen distinto número de puntos, se podrucirá un error
% si la señal x es mayor que la señal y.

if ((nargin==5)|(nargin==6))
	if (nargin==5)
		n_ite=length(x);
	end;

        buffer_x = zeros (1,fftpts);
        buffer_y = zeros (1,fftpts);
        
        % Abrimos nuevas ventanas
        % Para resoluci¢n 800x600
        h_fig1 = figure('Unit','pixel','Pos',[0 100 400 500],'Name','Señal X');
        h_fig2 = figure('Unit','pixel','Pos',[400 100 400 500],'Name','Señal Y');
        % Para resoluci¢n 1024x728
        %h_fig1 = figure('Unit','pixel','Pos',[0 100 500 700],'Name','Señal X');
        %h_fig2 = figure('Unit','pixel','Pos',[512 100 500 700],'Name','Señal Y');
        
        set(0, 'CurrentF', h_fig1);
        
        %subplot211
        handels_x(1) = subplot(311);
        handels_x(2) = plot(0,0,'m','EraseMode','None');
        handels_x(3) = get(handels_x(1),'Title');
        set(handels_x(1),'Visible','off');
        
        %subplot212
        handels_x(4) = subplot(312);
        handels_x(5) = plot(0,0,'EraseMode','None');
        handels_x(6) = get(handels_x(4),'Title');
        set(handels_x(4),'Visible','off');
        
        %subplot313
        handels_x(7) = subplot(313);
        handels_x(8) = plot(0,0,'EraseMode','None');
        handels_x(9) = get(handels_x(7),'Title');
        set(handels_x(7),'Visible','off');
        
        set(h_fig1, 'UserData', handels_x);
        set(h_fig1,'NextPlot','new');
        
        handels_x = get(h_fig1,'UserData');
        
        
        set(0, 'CurrentF', h_fig2);
        
        %subplot211
        handels_y(1) = subplot(311);
        handels_y(2) = plot(0,0,'m','EraseMode','None');
        handels_y(3) = get(handels_y(1),'Title');
        set(handels_y(1),'Visible','off');
        
        %subplot212
        handels_y(4) = subplot(312);
        handels_y(5) = plot(0,0,'EraseMode','None');
        handels_y(6) = get(handels_y(4),'Title');
        set(handels_y(4),'Visible','off');
        
        %subplot313
        handels_y(7) = subplot(313);
        handels_y(8) = plot(0,0,'EraseMode','None');
        handels_y(9) = get(handels_y(7),'Title');
        set(handels_y(7),'Visible','off');
        
        set(h_fig2, 'UserData', handels_y);
        set(h_fig2,'NextPlot','new');
        
        handels_y = get(h_fig2,'UserData');
        
        
        ts=t(2)-t(1);
        indice=1;
        m=size(x,2);
        n = fftpts/2;
        freq = 2*pi*(1/ts); % Multiply by 2*pi to get radians
        w = freq*(0:n-1)./(2*(n-1));
        
        while (((indice+fftpts)<m)&(n_ite>0))
        
                buffer_x = [buffer_x(fre_visu+1:fftpts) x(indice:(indice+fre_visu))];
        
                g = fft(buffer_x(1:fftpts),fftpts);
                         
                g = g(1:n)/length(g);
                ffts = abs(g);
        
                tvec = t(indice:(indice+fftpts));
                set(handels_x(1),'Visible','on','Xlim',[min(tvec) max(tvec)],'Ylim',[min(buffer_x*.99) max(buffer_x*1.01+eps)])
                set(handels_x(2),'XData',tvec,'YData',buffer_x)
                set(handels_x(3),'String','Tiempo')
                xl = get(handels_x(1),'Xlabel');
                set(xl,'String','Tiempo (seg)')
        
                ysc = ffts(~isnan(ffts));
                if isempty(ysc)
                        ysc=[0 1];
                else
                        ysc = sort([min(ysc*.99), max(ysc*1.01+eps)]);
                end;
        
                tmp='Espectro';
        
                set(handels_x(4),'Visible','on','Xlim',[min(w(2:n)/(2*pi)), max(w(2:n)/(2*pi))],'Ylim',ysc);
                set(handels_x(5),'XData',w(1:n)/(2*pi),'YData',ffts);
                set(handels_x(6),'String', tmp);
                xl = get(handels_x(4), 'Xlabel');
                set(xl,'String','Frequency (Hz)')
                yl = get(handels_x(4), 'Ylabel');
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
                set(handels_x(7),'Visible','on','Xlim',[min(w(2:n)/(2*pi)) max(w(2:n)/(2*pi))],'Ylim',ysc)
                set(handels_x(8),'XData',w(2:n)/(2*pi),'YData',phase)
                xl = get(handels_x(7), 'Xlabel');
                set(xl, 'String', 'Frecuencia (Hz)')
                yl = get(handels_x(7), 'Ylabel');
                set(yl, 'String','Grados')                 
                drawnow;
        
                buffer_y = [buffer_y(fre_visu+1:fftpts) y(indice:(indice+fre_visu))];
        
                g = fft(buffer_y(1:fftpts),fftpts);
                         
                g = g(1:n)/length (g);
                ffts = abs(g);
        
                tvec = t(indice:(indice+fftpts));
                set(handels_y(1),'Visible','on','Xlim',[min(tvec) max(tvec)],'Ylim',[min(buffer_y*.99) max(buffer_y*1.01+eps)])
                set(handels_y(2),'XData',tvec,'YData',buffer_y)
                set(handels_y(3),'String','Tiempo')
                xl = get(handels_y(1),'Xlabel');
                set(xl,'String','Tiempo (seg)')
                ysc = ffts(~isnan(ffts));
                if isempty(ysc)
                        ysc=[0 1];
                else
                        ysc = sort([min(ysc*.99), max(ysc*1.01+eps)]);
                end;
                set(handels_y(4),'Visible','on','Xlim',[min(w(2:n)/(2*pi)), max(w(2:n)/(2*pi))],'Ylim',ysc);
                set(handels_y(5),'XData',w(1:n)/(2*pi),'YData',ffts);
                set(handels_y(6),'String', tmp);
                xl = get(handels_y(4), 'Xlabel');
                set(xl,'String','Frequency (Hz)')
                yl = get(handels_y(4), 'Ylabel');
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
                set(handels_y(7),'Visible','on','Xlim',[min(w(2:n)/(2*pi)) max(w(2:n)/(2*pi))],'Ylim',ysc)
                set(handels_y(8),'XData',w(2:n)/(2*pi),'YData',phase)
                xl = get(handels_y(7), 'Xlabel');
                set(xl, 'String', 'Frecuencia (Hz)')
                yl = get(handels_y(7), 'Ylabel');
                set(yl, 'String','Grados')                 
        
                % Aumentamos el indice para la siguiente iteraci¢n
                indice=indice+fre_visu;
                drawnow;
		n_ite=n_ite-1;
        end
        disp ('Pulsar una tecla para terminar');
        pause;
        disp ('Finalizado');
        close (h_fig1);
        close (h_fig2);
else
        disp ('Error: Número de parámetros erróneo.');
end;
