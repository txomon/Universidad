s=0;
s=Menu('Introduce el numero de ejercicio','1','2','3','4','5','salir');
if s~=6
    switch s
        case 1
            t=-10:0.1:10;
            uno=rectpuls(t);
            dos=tripuls(t-2);
            x=uno+dos
            
            hold on;
            plot(t,uno);
            plot(t,dos,'g');
            plot(t,x,'r');
            
            %Se superpone la suma, pero si te fijas se ve el verde y el
            %azul por debajo
        case 2
            t=
    end
end