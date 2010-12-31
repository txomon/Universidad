function [y] = subfam(signal1,signal2,Ns)

% function [y] = subfam(signal1,signal2,Ns)
%
% the subfam algorithm
%
% by Dennis W. Brown, Last modified 7/17/93

% default output
y = [];

% must have two arguments
if nargin < 2,
    error('subfam: Incorrect number of arguments...');
end;

% default the number of samples
if nargin == 2,
    Ns = 4096;
end;

% check that Ns is a power of two
temp = log(Ns)/log(2);
if temp-floor(temp) ~= 0,
    error('Ns is not a power of two');
end;

% take hilbert transform
h1 = hilbert(signal1);
h2 = hilbert(signal2);

% upconvert
f1 = fft(h1);
f2 = fft(h2);
f1 = ifft([f1(Ns/4+1:Ns) ; f1(1:Ns/4)]);
f2 = ifft([f2(Ns/4+1:Ns) ; f2(1:Ns/4)]);

% multiply f1 times the conjugate of f2
y = f1 .* conj(f2);

% return complex spectrum
y = fft(y);

% but shift it so that it matches the SSPI convention
y = fftshift(y);

