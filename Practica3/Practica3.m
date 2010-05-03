s=0;
s=Menu('Introduce el numero de ejercicio','1','2','3','4','5','6','salir');
if s~=7
    switch s
        case 1
            n=0:1:240;
            n1=0:1:11;
            n2=0:1:11;
            
            subplot(2,3,1);
            stem(n,3*cos(n*3/4));%no tiene periodo
            
            subplot(2,3,2);
            stem(n1,5*cos(4*pi*n1/6));%periodo 11
            
            subplot(2,3,3);
            stem(n2,2*exp(n2*pi*1i*4/3));%periodo 11
            
            subplot(2,3,4);
            stem(n,4*exp(1i*n*3/2));%no tiene periodo
            
            subplot(2,3,5);
            x=((-2).^n1).*cos(2*pi*n1/5);
            stem(n1,x); %no tiene periodo
    
        case 2
            
            %periodo 80
            n1=0:1:320;
            subplot(2,2,1);
            y1=(3*cos(4*pi*n1/5)+5*cos(3*pi*n1/8));
            stem(n1,y1);
            axis([0 320 -10 10]);

            
            %creo que ha quedado claro que si en uno hay un numero
            %irracional y en el otro no esta ese mismo, es imposible hayar
            %una fraccion...
            subplot(2,2,2);
            y2=2*exp(1i*3*n1/4)+4*exp(pi*2*1i*n1/7);
            stem(n1,y2);
            axis([0 200 -10 10]);
            
            %periodo 7
            subplot(2,2,3);
            n3=0:1:28;
            y3=4*exp(2*pi*1i*n3/7)+3*exp(12*1i*pi*n3/14);
            stem(n3,y3);
            
            %periodo 24
            subplot(2,2,4);
            n4=0:1:96;
            y4=3*exp(1i*pi*n4/3)+4*exp(1i*3*pi*n4/4);
            stem(n4,y4);
            axis([0 96 -10 10]);
           
        case 3
            
            enes=-100:1:100;
            delta=[zeros(1,100),ones(1,1),zeros(1,100)];
            escalon=[zeros(1,99),ones(1,102)];
            delta_3=[zeros(1,102),1,zeros(1,98)];
            delta_5=[zeros(1,104),1,zeros(1,96)];
            
            x1=3*delta+2*delta_3+5*delta_5;
            subplot(14,2,1:2);
            stem(enes,x1);
            axis([0 100 0 6]);
            
            subplot(14,2,3:4);
            escalon_50=[zeros(1,150),ones(1,51)];
            x2=3*(escalon-escalon_50);
            stem(enes,x2);
            
            
                
                    z=2;
                    z11=z.^enes;
                    z=-2;
                    z12=z.^enes;
                    z=0.95;
                    z13=z.^enes;
                    z=-0.95;
                    z14=z.^enes;
                    
                    subplot(14,2,[5 7 9]);
                        stem(enes,z11);
                    subplot(14,2,[11 13 15]);
                        stem(enes,z12);
                    subplot(14,2,[17 19 21]);
                        stem(enes,z13);
                    subplot(14,2,[23 25 27]);
                        stem(enes,z14);
                
                    z=exp(2+4i);
                    z21=z.^enes;
                    z=exp(2*pi*1i/3);
                    z22=z.^enes;
                    z=exp(-2+pi*1i/5);
                    z23=z.^enes;
                    
                    subplot(14,2,[6 8 10 12]);
                        stem(enes,z21);
                    subplot(14,2,[14 16 18 20]);
                        stem(enes,z22);
                    subplot(14,2,[22 24 26 28]);
                        stem(enes,z23);
    
    
        case 4
            enes=0:1:100;

            for omega=1:4
                subplot(4,2,omega);
                stem(enes,real(exp(1i*omega*2*pi*enes/4)));
            end
            
            for omega=5:8
                subplot(4,2,omega);
                stem(enes,real(exp((1i*omega*2*pi*enes+pi)/3)));
            end
            
        case 5
            enes=0:1:100;
            hold on;
                stem(enes,3*cos(pi*enes/100));
                stem(enes,3*cos(pi*2*enes/100),'g');
                stem(enes,3*cos(pi*3*enes/100),'r');
                stem(enes,3*cos(pi*4*enes/100),'b');
                stem(enes,3*cos(pi*5*enes/100),'g');
                stem(enes,3*cos(pi*6*enes/100),'r');
                
        case 6
            enes=0:1:100;
            x=3*exp(1i*((2*pi*enes/7)+3/pi));
            a=1;
            while a~=0
            amplitud =input('Introduce un valor de amplitud:');
            a=input('Introduce un valor de frecuencia:');
            fase=input('Introduce una fase:');
            result=3*exp(1i*((2*pi*enes/7)+3/pi))+amplitud*exp(1i*((2*pi*a*enes/7)+fase/pi));
            hold on;
            stem(enes,result);
            stem(enes,x,'g');
            end

    end
    
    
    
end
