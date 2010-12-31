function [X,stddev] = blacktuk(x,arg2,arg3,arg4)
%BLACKTUK Blackman-Tukey spectral estimation.
%	[X] = BLACKTUK(x) computes
%	the Blackman-Tukey spectral estimate of x.  The mag-
%	nitude is returned in X.  The size of the FFT applied
%	to the auto-correlation function is the 
%	2^ceil(log2(2*length(x)-1)), the next power-of-two 
%	greater-than or equal-to the length of the auto-
%	correlation).  By default, a Bartlett window is 
%	applied to the autocorrelation function.
%
%	[X,STDDEV] = BLACKTUK(x,NFFT) sets the FFT length to NFFT.
%	The data is framed so that NFFT-1 data points are used
%	in the auto-correlation function.  The data frames are
%	then averaged to produce the final result with the 
%	variance of the averaged estimates returned in STDDEV.
%	Only full frames of data are used (excess is thrown-
%	away).  By default, a Bartlett window is applied to the
%	autocorrelation function.
%
%
%	[X,STDDEV] = BLACKTUK(x,'frames') or
%	[X,STDDEV] = BLACKTUK(x,NFFT,'frames') return a 
%	NFFT by L matrix where each column in X is a single 
%	frame in the periodogram.  The averaged spectral
%	estimate is not returned.
%
%	See also AVGPERGM, DANIELL, SPECT2D

%       Dennis W. Brown 4-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default
frames = 0;
N = length(x);

% arg check
if nargin < 1 | nargin > 4,
	error('blacktuk: Invalid number of input arguments.');
end

% work with N x 1 vector
x = x(:);

% default NFFT
if nargin == 1,
	nfft = 2^ceil(log2(2*N-1));
	L = 1;
	if nargout > 1,
		error('blacktuk: Invalid number of output arguments.');
	end;
elseif nargin == 2,
	if ~isstr(arg2),
		nfft = arg2;
		N = fix(nfft/2);
		L = fix(length(x)/N);
	else,
		error('blacktuk: Invalid FFT size specified.');
	end;
elseif nargin == 3,
	if isstr(arg3),
		frames = 1;
		nfft = arg2;
		N = fix(nfft/2);
		L = fix(length(x)/N);
	else,
		error('blacktuk: Invalid ''frames'' argument.');
	end;
end;

% form matrix where each column contains a frame
x = x(1:N*L);
x = reshape(x,N,L);

% room for autocorrlation and fft
X = zeros(nfft,L);

% multiply by window
rxxlen = 2*N-1;
window = bartlett(N);
for i = 1:L,
	X(1:rxxlen,i) = xcorr(window .* x(:,i),'biased');
end;
		
% compute FFT
X = fft(X,nfft);

% magnitude only
X = abs(X)/nfft;

stddev = zeros(nfft,1);
if L > 1,
	stddev = (std(X'))';
end;

if ~frames,

	X = mean(X')';

end;
