function x=alawinv (y,A)
%ALAWINV    A-law decompression for signals with
%-----         assumed maximum value of 1
%
%   Usage:   x = mulawinv (y, mu);
%
%      y : input signal, column vector with max value 1
%      A : compression parameter (A=87.6 used for telephony)
%
%  see also ALAW
%       

if nargin ==1
        A=87.6;
end;

m=length(y);
x=zeros(size(y));
for indice=1:m
        if abs(y(indice))<(1/(1+log(A)))
                x(indice) = y(indice)*(1+log (A))/A;
        else
                x(indice) = 1/A*exp((1+log (A))*abs(y(indice))-1)*sign(y(indice));
        end;
    end;


