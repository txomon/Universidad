function [esp,f]=dft_disc(x,n,representar)
% Funcion que calcula el espectro de una señal discreta
%
% function [esp,f]=dft_disc(x,t,representar)
%
% Parametros de entrada
%   x: señal
%   n: dominio de definicion de la señal x
%   representar: flag que indica el modo de representacion grafica
%           'no'        no se representa el espectro 
%           'mod-fas'   se representan el modulo y fase del espectro
%           'real-imag' se representa parte real e imaginaria del espectro
%           'espec'     se representa directamente el espectro
% Parametros de salida
%   esp: espectro de la señal x
%   f: dominio de definicion del espectro (entre -pi y pi)

ln=length(n)-1;
k=-ln/2:ln/2;

f=-pi:2*pi/length(k):pi-1/length(k); %definicion del eje de frecuencia entre -pi y pi 
esp=x*(exp(-j*2*pi/length(k)).^(n'*k)); %Calculo de la DFT

%Calculo de la DFT para representar, definida entre -2pi y 2pi para que se
%vea la periodicidad del espectro
k_disp=-100:100;   %n de puntos del eje de frecuencias para representar entre 2pi y -2pi
f_disp=-2*pi:4*pi/length(k_disp):2*pi-1/length(k_disp); %definicion del eje de frecuencia
esp_disp=x*(exp(-j*pi/50).^(n'*k_disp)); %Calculo de la DFT

warning off all
%Representacion grafica
if strcmp(representar,'mod-fas')
    figure('numbertitle','off', 'name','Transformada Discreta de Fourier')
	rango=(max(abs(esp_disp))-min(abs(esp_disp)))*.15;
	subplot(2,1,1)
	plot(f_disp,abs(esp_disp))
    if(rango~=0)
	    axis([-2*pi 2*pi min(abs(esp_disp))-rango max(abs(esp_disp))+rango])
    else
        axis([-2*pi 2*pi min(abs(esp_disp))-1 max(abs(esp_disp))+1])    
    end
	set(gca,'XTick',-2*pi:pi:2*pi)
	set(gca,'XTickLabel',{'-2pi','-pi','0','pi','2pi'})
	xlabel('-2\pi \leq \Omega \leq 2\pi')
	ylabel('|X(\Omega)|')
	title('Modulo de X(\Omega)')
	rango=(max(angle(esp_disp))-min(angle(esp_disp)))*.15;
    subplot(2,1,2)
	plot(f_disp,angle(esp_disp))
	axis([-2*pi 2*pi min(angle(esp_disp))-rango max(angle(esp_disp))+rango])
	set(gca,'XTick',-2*pi:pi:2*pi)
	set(gca,'XTickLabel',{'-2pi','-pi','0','pi','2pi'})
	xlabel('-2\pi \leq \Omega \leq 2\pi')
	ylabel('Fase X(\Omega)')
	title('Fase de X(\Omega)')
    pause
    close
elseif strcmp(representar,'real-imag')
   	rango=(max(real(esp_disp))-min(real(esp_disp)))*.15;
    figure('numbertitle','off', 'name','Transformada Discreta de Fourier')
	subplot(2,1,1)
	plot(f_disp,real(esp_disp))
	if(rango~=0)
	    axis([-2*pi 2*pi min(abs(esp_disp))-rango max(abs(esp_disp))+rango])
    else
        axis([-2*pi 2*pi min(abs(esp_disp))-1 max(abs(esp_disp))+1])    
    end
    set(gca,'XTick',-2*pi:pi:2*pi)
	set(gca,'XTickLabel',{'-2pi','-pi','0','pi','2pi'})
	xlabel('-2\pi \leq \Omega \leq 2\pi')
	ylabel('Re(X(\omega))')
	title('Parte real de X(\omega)')
   	rango=(max(imag(esp_disp))-min(imag(esp_disp)))*.15;
    subplot(2,1,2)
	plot(f_disp,imag(esp_disp))
	axis([-2*pi 2*pi min(imag(esp_disp))-rango max(imag(esp_disp))+rango])
	set(gca,'XTick',-2*pi:pi:2*pi)
	set(gca,'XTickLabel',{'-2pi','-pi','0','pi','2pi'})
	xlabel('-2\pi \leq \Omega \leq 2\pi')
	ylabel('Im(X(\omega))')
	title('Parte imaginaria de X(\omega)')
    pause
    close
elseif strcmp(representar,'espec')
   	rango=(max(real(esp_disp))-min(real(esp_disp)))*.15;
    figure('numbertitle','off', 'name','Transformada Discreta de Fourier')
	plot(f_disp,esp_disp)
	if(rango~=0)
	    axis([-2*pi 2*pi min(abs(esp_disp))-rango max(abs(esp_disp))+rango])
    else
        axis([-2*pi 2*pi min(abs(esp_disp))-1 max(abs(esp_disp))+1])    
    end
	set(gca,'XTick',-2*pi:pi:2*pi)
	set(gca,'XTickLabel',{'-2pi','-pi','0','pi','2pi'})
	xlabel('-2\pi \leq \Omega \leq 2\pi')
	ylabel('X(\omega)')
	title('X(\omega)')
    pause
    close
end
