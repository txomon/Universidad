function [ output_args ] = ejercicio2( audiowav )
%EJERCICIO2 Summary of this function goes here
%  Detailed explanation goes here



%% a)
hold on;
subplot(1,3,1);
hist(audiowav.data,1000);
xalaw=alaw(audiowav.data,87.6);
subplot(1,3,2);
hist(xalaw,1000);
xinvalaw=alawinv(xalaw,87.6);
subplot(1,3,3);
hist(xinvalaw,1000);
%sound(xinvalaw);
pause;
hold off;
hist(xinvalaw,1000);

subplot(3,1,1);
hold on;
sound(audiowav.data);
pause;
x1=q_unif(audiowav.data, 16,-1,1);
hist(x1,1000);
sound(x1);
pause;
x2=alaw(audiowav.data,87.6);
subplot(3,1,2);
sound(x2);
pause;
hist(x2,1000);
subplot(3,1,3);
hist(audiowav.data,1000);

xerr=audiowav.data-x2;
hist(xerr,1000);

%% b)

subplot(3,1,1);
x1=q_unif(audiowav.data, 16,-1,1);
hist(x1,1000);
hold on;
subplot(3,1,2);
x2=alaw(audiowav.data,87.6);
hist(x2,1000);
subplot(3,1,3);
hist(audiowav.data,1000);
hold off;

sound(x1);
pause;
sound(x2);
pause;
sound(audiowav.data);

subplot(1,1,1);
xerr=audiowav.data-x2;
hist(xerr,1000);

%% c)
