function [ output_args ] = ejercicio2( Anchura, f_s, a , t_1,t_0)
%EJERCICIO2 Summary of this function goes here
%  Detailed explanation goes here

t=-50:f_s:50;

x=rectpuls(t,Anchura);

subplot(3,2,[1 4]);
plot(t,x);

X=fft(x);
X=fftshift(x);
f=linspace(2/-f_s,2/f_s,length(X));

subplot(3,2,2);
plot(f,X);

canalmodulo=real(1+a*cos(2*pi*t_1*f));
canalfase=-2*pi*t_0*f;
Xsalidare=real(X).*canalmodulo;
Xsalidaimg=imag(X)+canalfase;

subplot(3,2,5);
plot(f,Xsalidare);
subplot(3,2,6);
plot(f,Xsalidaimg);

end