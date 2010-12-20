function [ output_args ] = ejercicio1( input_args )
%EJERCICIO1 Summary of this function goes here
%  Detailed explanation goes here


% Rb=1000;
% fs=32000;
% msg=randint(1,1000);
% [xtrans,xdef]=polarnrz(Rb,msg,fs);
% 
% N=0.1;
% %for N=0:20000;
% N=N*0.01;
% N %1.67W es ya... imposible
% G=1;
% B=4.9*10^3;
% yrecib=canal(xtrans,xdef,G,N,B);
% 
% 
% % 
% % subplot(2,1,1);
% % plot(xdef,xtrans);
% % axis([0 0.4 -2 2]);
% % subplot(2,1,2);
% % plot(xdef,yrecib);
% % axis([0 0.4 -2 2]);
% 
% pause;
% 
% %end
% % 
% % eyediagram(yrecib,32);
% 
% pause;
% fs=100000;
% [xtrans,xdef]=polarnrz(Rb,msg,fs);
% 
% N=0.01;
% for B=1:3;
% yrecib=canal(xtrans,xdef,G,N,B*1000);
% eyediagram(yrecib,200);
% pause
% end;
% 
% B=4;
% N=0.02;
% yrecib=canal(xtrans,xdef,G,N,B*1000);
% eyediagram(yrecib,200);
% pause;
% 
% N=0.08;
% yrecib=canal(xtrans,xdef,G,N,B*1000);
% eyediagram(yrecib,200);
% pause;
% 
% N=0.1;
% yrecib=canal(xtrans,xdef,G,N,B*1000);
% eyediagram(yrecib,200);
% pause;
fd=4800;
fs=48000;
cosalzado=rcosine(fd,fs);


msg=randint(1,1000);
a=rcosflt(msg,fd,fs);
warning off MATLAB:colon:operandsNotRealScalar
t2=[0:size(a)-1];t=t2';
plot(t,a);

eyediagram(a,10,2,4);
=======
Rb=1000;
fs=32000;
msg=randint(1,1000);
[xtrans,xdef]=polarnrz(Rb,msg,fs);

N=0.1;
%for N=0:20000;
N=N*0.01;
N %1.67W es ya... imposible
G=1;
B=4.9*10^3;
yrecib=canal(xtrans,xdef,G,N,B);



subplot(2,1,1);
plot(xdef,xtrans);
axis([0 0.4 -2 2]);
subplot(2,1,2);
plot(xdef,yrecib);
axis([0 0.4 -2 2]);

pause;

%end

eyediagram(yrecib,32);

pause;
fs=100000;
[xtrans,xdef]=polarnrz(Rb,msg,fs);

N=0.01;
for B=1:3;
yrecib=canal(xtrans,xdef,G,N,B*1000);
eyediagram(yrecib,200);
end;
pause;

B=4;
N=0.02;
yrecib=canal(xtrans,xdef,G,N,B*1000);
eyediagram(yrecib,100);
pause;

N=0.08;
yrecib=canal(xtrans,xdef,G,N,B*1000);
eyediagram(yrecib,100);
pause;

N=0.1;
yrecib=canal(xtrans,xdef,G,N,B*1000);
eyediagram(yrecib,100);
pause;
