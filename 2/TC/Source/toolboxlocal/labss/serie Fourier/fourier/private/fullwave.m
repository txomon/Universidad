function out = fullwave(t)

% This function creates a full wave. 

% Mustayeen Nayeem, August, 2002

yy = zeros(1,length(t));
yy=sin(2*pi/20*t);

for n=1:length(yy)
    if yy(n) >= 0
        yy(n) = yy(n);
    else
        yy(n)= -yy(n);
    end
end
   
        
out = yy;