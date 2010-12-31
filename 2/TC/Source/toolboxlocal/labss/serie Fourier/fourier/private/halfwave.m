function out = halfwave(t)

% This function creates a full wave. 

% Mustayeen Nayeem, August, 2002

yy = zeros(1,length(t));
yy=cos(2*pi/20*t);

for n=1:length(yy)
    if yy(n) >= 0
        yy(n) = yy(n);
    else
        yy(n)= 0;
    end
end
   
        
out = yy;