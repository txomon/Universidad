function y = alaw(x, A)
%ALAW    A-law compression for signals with
%-----         assumed maximum value of 1
%
%   Usage:   y = alaw(x, A);
%
%      x : input signal, column vector with max value 1
%      A : compression parameter (A=87.6 used for telephony)
%
%  see also ALAWINV
if nargin ==1
        A=87.6;
end;

m=length(x);
y=zeros(size(x));
for indice=1:m
        if abs(x(indice))<(1/A)
                y(indice) = A*x(indice)/(1+log (A));
        else
                y(indice) = ((1+log (A*abs(x(indice))))/(1+log (A)))*sign(x(indice));
        end;
    end;

