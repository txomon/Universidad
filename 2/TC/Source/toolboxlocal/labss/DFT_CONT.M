function [esp,f]=dft_cont(x,t,representar)
% Funcion que calcula el espectro de una señal de tiempo continuo
%
% function [esp,f]=dft_cont(x,t,representar)
%
% Parametros de entrada
%   x: señal
%   t: dominio de definicion de la señal x
%   representar: flag que indica el modo de representacion grafica
%           'no'        no se representa el espectro 
%           'mod-fas'   se representan el modulo y fase del espectro
%           'real-imag' se representa parte real e imaginaria del espectro
%           'espec'     se representa directamente el espectro
% Parametros de salida
%   esp: espectro de la señal x
%   f: dominio de definicion del espectro (entre -fs/2 y fs/2)

k=-150:150; %N puntos para el eje de frecuencia
fs=1/(t(2)-t(1)); % Frecuencia de muestreo usada
f=(-fs/2):fs/length(k):(fs/2)-1/length(k); %definicion del eje de frecuencia
esp1=x*(exp(-j*2*pi/length(k)).^(t'*k)); %Calculo de la DFT
esp=esp1/fs; %Escalado por el diferencial de t
warning off all

%representacion grafica
if strcmp(representar,'mod-fas')
	rango=(max(abs(esp))-min(abs(esp)))*.15;
    figure('numbertitle','off', 'name','Transformada Discreta de Fourier para señales de tiempo continuo')
	subplot(2,1,1)
	plot(f,abs(esp))
    if(rango~=0)
	    axis([-fs/2 fs/2 min(abs(esp))-rango max(abs(esp))+rango])
    else
        axis([-fs/2 fs/2 min(abs(esp))-1 max(abs(esp))+1])    
    end
	xlabel('-fs/2 \leq \omega \leq fs/2')
	ylabel('|X(\omega)|')
	title('Modulo de X(\omega)')
	rango=(max(angle(esp))-min(angle(esp)))*.15;
    subplot(2,1,2)
	plot(f,angle(esp))
	axis([-fs/2 fs/2 min(angle(esp))-rango max(angle(esp))+rango])
	xlabel('-fs/2 \leq \omega \leq fs/2')
	ylabel('Fase X(\omega)')
	title('Fase de X(\omega)')
    
elseif strcmp(representar,'real-imag')
   	rango=(max(real(esp))-min(real(esp)))*.15;
    figure('numbertitle','off', 'name','Transformada Discreta de Fourier para señales de tiempo continuo')
    subplot(2,1,1)
	plot(f,real(esp))
    if(rango~=0)
	    axis([-fs/2 fs/2 min(abs(esp))-rango max(abs(esp))+rango])
    else
        axis([-fs/2 fs/2 min(abs(esp))-1 max(abs(esp))+1])    
    end
	xlabel('-fs/2 \leq \omega \leq fs/2')
	ylabel('Re(X(\omega))')
	title('Parte real de X(\omega)')
   	rango=(max(imag(esp))-min(imag(esp)))*.15;
    subplot(2,1,2)
	plot(f,imag(esp))
	axis([-fs/2 fs/2 min(imag(esp))-rango max(imag(esp))+rango])
	xlabel('-fs/2 \leq \omega \leq fs/2')
	ylabel('Im(X(\omega))')
	title('Parte imaginaria de X(\omega)')
    
elseif strcmp(representar,'espec')
   	rango=(max(real(esp))-min(real(esp)))*.15;
    figure('numbertitle','off', 'name','Transformada Discreta de Fourier para señales de tiempo continuo')
    plot(f,esp)
    if(rango~=0)
	    axis([-fs/2 fs/2 min(abs(esp))-rango max(abs(esp))+rango])
    else
        axis([-fs/2 fs/2 min(abs(esp))-1 max(abs(esp))+1])    
    end
	xlabel('-fs/2 \leq \omega \leq fs/2')
	ylabel('X(\omega)')
	title('X(\omega)')
    
end
