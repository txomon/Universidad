function [ output_args ] = ejercicio3( audio )
%EJERCICIO3 Summary of this function goes here
% Codigo de l?nea Funcion a utilizar
% Unipolar NRZ uniponrz()
% Polar NRZ polarnrz()
% Bipolar NRZ bipolnrz()
% Unipolar RZ uniporz()
% Polar RZ polarrz()
% Bipolar RZ bipolrz()
% Manchester manchest()

%  Detailed explanation goes here

a=[ 0 1 0 1 0 1 1 1 0 0 0 1 1 0 0 1 1 1 0 0 ];
b=[ 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 ];
c=[ 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 ];

Rb=20;
fs=1000;
msg=a;

[ya1,ta1] = uniponrz(Rb,msg,fs);
[ya2,ta2] = polarnrz(Rb,msg,fs);
[ya3,ta3] = bipolnrz(Rb,msg,fs);
[ya4,ta4] = uniporz(Rb,msg,fs);
[ya5,ta5] = polarrz(Rb,msg,fs);
[ya6,ta6] = bipolrz(Rb,msg,fs);
[ya7,ta7] = manchest(Rb,msg,fs);

msg=b;

[yb1,tb1] = uniponrz(Rb,msg,fs);
[yb2,tb2] = polarnrz(Rb,msg,fs);
[yb3,tb3] = bipolnrz(Rb,msg,fs);
[yb4,tb4] = uniporz(Rb,msg,fs);
[yb5,tb5] = polarrz(Rb,msg,fs);
[yb6,tb6] = bipolrz(Rb,msg,fs);
[yb7,tb7] = manchest(Rb,msg,fs);

msg=c;

[yc1,tc1] = uniponrz(Rb,msg,fs);
[yc2,tc2] = polarnrz(Rb,msg,fs);
[yc3,tc3] = bipolnrz(Rb,msg,fs);
[yc4,tc4] = uniporz(Rb,msg,fs);
[yc5,tc5] = polarrz(Rb,msg,fs);
[yc6,tc6] = bipolrz(Rb,msg,fs);
[yc7,tc7] = manchest(Rb,msg,fs);


hold on;

subplot(3,3,1);
plot(ta1,ya1);
subplot(3,3,2);
plot(tb1,yb1);
subplot(3,3,3);
plot(tc1,yc1);

subplot(3,3,4);
plot(ta2,ya2);
subplot(3,3,5);
plot(tb2,yb2);
subplot(3,3,6);
plot(tc2,yc2);

subplot(3,3,7);
plot(ta3,ya3);
subplot(3,3,8);
plot(tb3,yb3);
subplot(3,3,9);
plot(tc3,yc3);
hold off;
pause;

subplot(4,3,1);
plot(ta4,ya4);
hold on;
subplot(4,3,2);
plot(tb4,yb4);
subplot(4,3,3);
plot(tc4,yc4);

subplot(4,3,4);
plot(ta5,ya5);
subplot(4,3,5);
plot(tb5,yb5);
subplot(4,3,6);
plot(tc5,yc5);

subplot(4,3,7);
plot(ta6,ya6);
subplot(4,3,8);
plot(tb6,yb6);
subplot(4,3,9);
plot(tc6,yc6);

subplot(4,3,10);
plot(ta7,ya7);
subplot(4,3,11);
plot(tb7,yb7);
subplot(4,3,12);
plot(tc7,yc7);



ma1=mean(ya1) 
ma2=mean(ya2) 
ma3=mean(ya3) 
ma4=mean(ya4) 
ma5=mean(ya5) 
ma6=mean(ya6) 
ma7=mean(ya7) 

mb1=mean(yb1) 
mb2=mean(yb2) 
mb3=mean(yb3) 
mb4=mean(yb4) 
mb5=mean(yb5) 
mb6=mean(yb6) 
mb7=mean(yb7) 

mc1=mean(yc1) 
mc2=mean(yc2) 
mc3=mean(yc3) 
mc4=mean(yc4) 
mc5=mean(yc5) 
mc6=mean(yc6) 
mc7=mean(yc7) 


% las que no pasan son la 1,2,4 y 5, vamos que la 3 la 6 y la 7 pasan, que
% son la Bipolar NRZ, Bipolar RZ y la Manchester

% para transmitir con una sincronia de 0'4 minimo, habria que utilizar la
% codificacion Polar NRZ o la Manchester


% d)

sptool
% 
% Pxx = PSD(ya1,length(ya1),fs,WINDOW);
% Pxx = PSD(ya2,length(ya2),fs,WINDOW);
% Pxx = PSD(ya3,length(ya3),fs,WINDOW);
% Pxx = PSD(ya4,length(ya4),fs,WINDOW);
% Pxx = PSD(ya5,length(ya5),fs,WINDOW);
% Pxx = PSD(ya6,length(ya6),fs,WINDOW);
% Pxx = PSD(ya7,length(ya7),fs,WINDOW);
% 
% Pxx = PSD(yb1,length(yb1),fs,WINDOW);
% Pxx = PSD(yb2,length(yb2),fs,WINDOW);
% Pxx = PSD(yb3,length(yb3),fs,WINDOW);
% Pxx = PSD(yb4,length(yb4),fs,WINDOW);
% Pxx = PSD(yb5,length(yb5),fs,WINDOW);
% Pxx = PSD(yb6,length(yb6),fs,WINDOW);
% Pxx = PSD(yb7,length(yb7),fs,WINDOW);
% 
% Pxx = PSD(yc1,length(yc1),fs,WINDOW);
% Pxx = PSD(yc2,length(yc2),fs,WINDOW);
% Pxx = PSD(yc3,length(yc3),fs,WINDOW);
% Pxx = PSD(yc4,length(yc4),fs,WINDOW);
% Pxx = PSD(yc5,length(yc5),fs,WINDOW);
% Pxx = PSD(yc6,length(yc6),fs,WINDOW);
% Pxx = PSD(yc7,length(yc7),fs,WINDOW);
% 

