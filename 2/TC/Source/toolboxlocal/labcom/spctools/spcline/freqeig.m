function [h,a] = freqeig(A,M,fs)
%FREQEIG	Evaluate eigen-based spectral estimate.
%	[h,f] = FREQEIG(A,M,FS) evaluates the frequency
%	response of a spectral estimate in the form
%
%		Q = w' P w
%
%	where w = [1 exp(jw) exp(j2w) ... exp(j(N-1)w]'
%	and P is a symmetric matrix.  The
%	algorithm exploits of the conjugate symmetric
%	property of the resulting polynomial to compute
%	the frequency response using a single FFT of
%	size M.
%
%	If the sampling frequency, FS, is not given, the
%	vector F is returned such that 1 equals the Nyquist
%	frequency.

% arg check
if nargin < 2 | nargin > 3,
	error('freqeig: Invalid number of input arguments.');
end;

if nargin == 2,
	fs = 2;
end;


% check for square
[P,n] = size(A);
if max(size(A)) == 1 | P ~= n,
	error('freqeig: Input argument A must be square matrix.');
end;

% setup for diag command
P = P-1;

% space for the polynomial
a = zeros(P+1,1);

% sum along the diagonals and upper triangle diagonals
for i = 0:P,
	a(i+1,1) = sum(diag(A,i));
end;

% vector for FFT
d = zeros(2*M,1);

% first value is the e^0 term (not times to cause we don't want
%     to include power from this guy twice.
d(1:P+1) = 2*a;

% now for the e^-jw terms (times 2 for power reasons)
d(2:P+1) = d(2:P+1)*2;

% compute psd estimate
h = ones(1,2*M) ./ real(fft(d(:).',2*M));

% return just the positive side as a column vector
h = h(1:M);
h = h(:);
