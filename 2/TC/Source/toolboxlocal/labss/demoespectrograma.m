%Cargar la señal ezetz que esta muestrada a fs=16000Hz
s_ezetz=wavread('331.wav');

%Eliminar parte del silencio anterior y posterior
s_ezetz=s_ezetz(7000:length(s_ezetz)-6000);

disp('El espectrograma es una vista superior del grafico que se presenta a continuacion.')
disp('La grafica ira poco a poco aumentando de precision y girando para acercarse a la')
disp('vista del espectro que se tiene en un espectrograma.')
disp(' ')
disp('Pulsa una tecla para continuar')
pause
%Calculo del espectrograma con pocas ventanas
[B,f,t]=specgram(s_ezetz,2048,8000,2048,1024);

%Eje de tiempos en segundos
s=t'./16000*10000;

%Pasar el modulo del espectro a dBs e invertirlo para que la vista se
%parezca mas a la normal
modB=abs(B);
Blog=20*log10(modB);
Blog=flipud(Blog);

%Representar los espectros
figure('numbertitle','off', 'name','Demo del Espectrograma')
waterfall(f',s,Blog')

%Etiquetar los ejes
title('''Espectrograma'' de Ezetz','FontSize',12)
xlabel('f(Hz)')
ylabel('t(sg)')
zlabel('|H(f)| (dB)')
%set(gca,'XTick',0:1000:4000)
%set(gca,'XTickLabel',{'4000','3000','2000','1000','0'})


%Cambiar el angulo de vision poco a poco para que se vaya pareciendo mas al
%del espectrograma normal
view(75,46)
pause(.35)
view(80,50)
pause(.35)

%Aumenta la precision para parecerse mas a lo que muestra specgram
[B,f,t]=specgram(s_ezetz,1024,8000,512,256);
s=t'./16000*10000;
modB=abs(B);
Blog=20*log10(modB);
Blog=flipud(Blog);
waterfall(f',s,Blog')
title('''Espectrograma'' de Ezetz','FontSize',12)
xlabel('f(Hz)')
ylabel('t(sg)')
zlabel('|H(f)| (dB)')
set(gca,'XTick',0:1000:4000)
set(gca,'XTickLabel',{'4000','3000','2000','1000','0'})

view(80,60)
pause(.35)
view(80,70)
pause(.35)

%Las ultimas con mas precision para que sea como el que muestra specgram
[B,f,t]=specgram(s_ezetz,1024,8000,256,128);
s=t'./16000*10000;
modB=abs(B);
Blog=20*log10(modB);
Blog=flipud(Blog);
waterfall(f',s,Blog')
title('''Espectrograma'' de Ezetz','FontSize',12)
xlabel('f(Hz)')
ylabel('t(sg)')
zlabel('|H(f)| (dB)')
set(gca,'XTick',0:1000:4000)
set(gca,'XTickLabel',{'4000','3000','2000','1000','0'})

view(80,80)
pause(.35)
view(80,86)
pause(.35)

disp('Pulsa una tecla para ver el espectrograma')
pause
%Demo del espectrograma de Matlab
specgramdemo(s_ezetz,16000)