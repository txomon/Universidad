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
            
    end
end