function []=ejercicio2()
load hola.mat;
holapb=filtropb(hola,t,3400,5,20);
sound(holapb,32000);

pause

n=randn(size(t))/2;
z=holapb+n;
sound(z,32000)
pause
z=hola+n;
sound(z,32000)
pause

n=randn(size(t))/40;
z=holapb+n;
sound(z,32000)
pause
z=hola+n;
sound(z,32000)
pause

n=randn(size(t))/100;
z=holapb+n;
sound(z,32000)
pause
z=hola+n;
pause
sound(z,32000)