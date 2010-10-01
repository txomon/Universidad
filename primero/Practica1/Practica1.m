s=0;
if s<10%esto en este caso no sirve para nada
 s=Menu('Elija el ejercicio','1','2','3','4','5','6','7','8','9','salir');%elijo el menu y las opciones
    if s==1%para el ejercicio uno
   
   %si, que sea suficientemente pequeña en relacion al periodo que se quiere representar     
        
        T0=(10^(-3));%inicializo la separacion
        hold on;%hago que se mantengan los dibujos (para dibujar encima de cada uno
        t1=0:(T0/20):4*T0;%inicializo los tiempos
        x=3*cos(2*pi*10^3*t1);%doy valores segun la funcion
        plot(t1,x);%dibujamos la funcion
        
        t2=0:(T0/10):4*T0;%inicializamos los tiempos
        x=3*cos(2*pi*10^3*t2);
        plot(t2,x,'b');
        
        
        t3=0:(T0/5):T0*4;
        x=3*cos(2*pi*10^3*t3);
        plot(t3,x,'r');
        
        t4=0:(T0/2):4*T0;
        x=3*cos(2*pi*10^3*t4);
        plot(t4,x,'g');
        
        t5=0:(T0/1000):4*T0;
        x=3*cos(2*pi*10^3*t5);
        plot(t5,x,'c');
        
        hold off;
    end
    if s==2
   %se observa que como hay uno que tiene la frecuencia mas pequeña que
   %otro, el que tiene la frecuencia mas pequeña tiene que tener mas
   %valores por unidad
        t1=0:(1/(8*10^3)):(10^(-3));
        t2=0:(1/(180*10^3)):(10^(-3));
        hold on;
        plot(t1,4*cos(2*pi*t1*9*10^3),'c');
        plot(t2,4*cos(2*pi*t2*9*10^3),'g');
        hold off;
    end 
    if s==3
   %si
        t=0:1/500000:0.04;
        hold on;
        x=5*exp(i*2*pi*100*t);
        plot(t,real(x));
        plot(t,imag(x));
        hold off;
    end
    if s==4
   
        
        hold on;
        t=0:10^-5:0.08;
        y=3*cos(2*pi*50*t+4/pi);
        plot(t,imag(y));
        plot(t,real(y),'g');
        y=(3/2)*exp(i*pi/4)*exp(i*2*pi*50*t)+(3/2)*exp(i*-pi/4)*exp(-i*2*pi*50*t);
        plot(t,imag(y),'c');
        plot(t,real(y),'r');
        hold off;
        
    end
    
    if s==5
       %si
       
        hold on;
        t=0:10^-6:0.25;
        y=exp(2*i*pi*400*t)+exp(2*i*50*t);
        plot(t,imag(y),'g');
        plot(t,real(y),'b');
        hold off;     
                
    end
    
    if s==6
        
    %no
        hold on;
        a=0.58;
        t=0:10^-6:a;
        y=exp(i*2*pi*50*t)+exp(i*400*t);
        plot(t,y);
        hold off;
    end
    
    if s==7
       
        hold on;
        t=-1:10^-3:1;
        y=rectpuls(t);
        plot(t,y);
        hold off;
    end
    
    if s==8
        hold on;
        t=-1:10^-3:1;
        y=tripuls(t);
        plot(t,y);
        hold off;
        
    end
    
    if s==9
        
        hold on;
        a=5;
        t1=-a:10^-3:a;
        y=sinc(t);
        a=10;
        t2=-a:10^-3:a;
        z=sinc(t2);
        subplot(1,2,1);
        plot(t,y);
        subplot(1,2,2);
        plot(t2,z);
        
    end
    
    
end
