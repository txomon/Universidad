function [X] = daniell(x,k,nfft)
%DANIELL Daniell periodogram.
%	X = DANIELL(x,K) computes the Daniell periodogram 
%	of x averaging K adjacent frequency bins of the FFT.
%
%	X = DANIELL(x,K,NFFT) sets the FFT length to NFFT.
%
%	See also AVSMOOTH, SPECT2D

%       Dennis W. Brown 4-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.


% arg check
if nargin < 2 | nargin > 3,
	error('daniell: Invalid number of input arguments.');
end

% adjust k if even
if rem(k,2) ~= 1,
	disp('daniell: Increasing k by one to force k odd.');
	k = k + 1;
end;

% default NFFT
if nargin == 2,
	if min(size(x)) == 1,
		x = x(:);
		nfft = length(x);	% use number of samples
	else
		[m,n] = size(x);	% use length of column
		nfft = m;
	end;
end;

% compute FFT
X = fft(x,nfft);

% break into individual components
Xm = abs(X);
Xp = angle(X);

% perform smoothing
[m,n] = size(X);
for i = 1:n,

	Xm(:,i) = avsmooth(Xm(:,i),k);
	Xp(:,i) = avsmooth(Xp(:,i),k);

end;

% recombine
X = Xm .* (cos(Xp) + j*sin(Xp));
