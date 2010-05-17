s=0;
s=Menu('Introduce el numero de ejercicio','1','2','3','4','salir');
if s~=5
    switch s
        case 1
            n=-100:100;
            N=-200:200;
            u5=[zeros(1,95) ones(1,106)];
            U5=[zeros(1,106) ones(1,95)];
            u=[zeros(1,100) ones(1,101)];
            U10=[zeros(1,111) ones(1,90)];
            
            x=u5-U5;
            h=exp(-3*n).*(u-U10);
            
            y=conv(x,h);
            
            stem(N,y);
            
        case 2
            n=0:20;
            
            x1=[1,0,-1,4,0,6,zeros(1,15)];
            x2=[0,2,3,4,5,4,3,2,1,zeros(1,12)];
            
            y1=filter([5,0,0,3,0,0,-5],1,x1);
            y2=filter([5,0,0,3,0,0,-5],1,x2);
            subplot(2,1,1);
            stem(n,y1);
            subplot(2,1,2);
            stem(n,y2);
           
        case 3
            n=0:20;
            x=[zeros(1,10) 2*ones(1,11)];
            
            yfilt=filter([3,2,0,-3],1,x);
            yh=filter([3,2,0,-3],1,[zeros(1,10) ones(1,1) zeros(1,10)]);
            ycon=conv(yh,x);
            
            subplot(1,3,1);
            stem(n,yh);
            title('Respuesta impulsional');
            subplot(1,3,2);
            stem(n,yfilt);
            title('Respuesta Filter');
            subplot(1,3,3);
            stem(0:40,ycon);
            title('Respuesta Conv');
            
            %es la misma respuesta porque es un sistema fir
            
            
        case 4
            n=-100:100;
            y1=filter([1,0.5,3],[1,0.25,-2],0.95.^n.*cos(2*pi*n/5));
            yh=filter([1,0.5,3],[1,0.25,-2],[zeros(1,100) ones(1,1) zeros(1,100)]);
            
            y2=conv(0.95.^n.*cos(2*pi*n/5),yh);
  
            subplot(2,1,1);
            stem(n,y1);
            subplot(2,1,2);
            stem(-200:200,y2);
            
    end
end