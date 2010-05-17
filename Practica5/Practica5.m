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
            
            y=filter([3,2,0,-3],1,x);
            stem(n,y);
            
    end
end