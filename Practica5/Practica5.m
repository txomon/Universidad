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
            u10=[zeros(1,90) ones(1,111)];
            
            x=u5-U5;
            h=exp(-3*n)*(u-u10);
            
            y=conv(x,h);
            
            plot(N,y);
            
    end
end