function  [] = ejercicio1 (a)

load hola.mat;
n=randn(size(t));

z=hola+n;

z_P=potencia(z)
x_P=potencia(hola)
y_P=potencia(n)
sound(z,32000)
pause

x_P
n=randn(size(t))/2;
z=hola+n;
z_P=potencia(z)
y_P
sound(z,32000)
pause


x_P
n=randn(size(t))/40;
z=hola+n;
z_P=potencia(z)
y_P
sound(z,32000)
pause

x_P
n=randn(size(t))/100;
z=hola+n;
z_P=potencia(z)
y_P
sound(z,32000)