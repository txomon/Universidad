s=0;
s=Menu('Introduce el numero de ejercicio','1','2','3','4','5','salir');
if s~=6
    switch s
        case 1
            t=-10:0.1:10;
            uno=rectpuls(t);
            dos=rectpuls(t-2);
            x=uno+dos;
            
            hold on;
            subplot(2,1,1);
            plot(t,uno);
            plot(t,dos,'g');
            plot(t,x,'r');
            hold off;
            
            
            subplot(2,1,2);
            uno=tripuls(t);
            dos=tripuls(t-2);
            x=uno+dos;
            hold on;
            plot(t,uno);
            plot(t,dos,'g');
            plot(t,x,'r');
            
            hold off;
            
            %Se superpone la suma, pero si te fijas se ve el verde y el
            %azul por debajo
        case 2
            t=-10:0.1:10;
            
            hold on;
            subplot(2,2,1);
            hold on;
            uno=tripuls(t);
            dos=cos(t);
            x=dos.*uno;
            plot(t,uno);
            plot(t,dos,'g');
            plot(t,x,'r');
            
            subplot(2,2,2);
            hold on;
            uno=rectpuls(t);
            x=dos.*uno;
            plot(t,uno);
            plot(t,dos,'g');
            plot(t,x,'r');
            
            %supongo que el 3 ese por ahi suelto significa multiplicar...
            
            subplot(2,2,3);
            hold on;
            uno=tripuls(t).*3;
            dos=4*t/t;
            x=dos+uno;
            plot(t,uno);
            plot(t,dos,'g');
            plot(t,x,'r');
            
            subplot(2,2,4);
            hold on;
            uno=rectpuls(t).*3;
            x=dos+uno;
            plot(t,uno);
            plot(t,dos,'g');
            plot(t,x,'r');
            
        case 3
            
            ConvolveGUI();
            % si cambias la funciones, con pulse amp=0.5 y Triangle 2sec
            % veras que se parece mucho a la que pretendes consequir... y
            % que el tamaño, se ve reducido a la mitad..
            %y la convolucion de a*b y b*a es la misma
        case 4
            
            
    end
end