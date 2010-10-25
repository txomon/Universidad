function P = spectrm2(x,y,m,noverlap)
%SPECTRUM Power spectrum estimate of one or two data sequences.
%	P = SPECTRUM(X,Y,M) performs FFT analysis of the two sequences
%	X and Y using the Welch method of power spectrum estimation.
%	The X and Y sequences of N points are divided into K sections of
%	M points each (M must be a power of two). Using an M-point FFT,
%	successive sections are Hanning windowed, FFT'd and accumulated.
%	SPECTRUM returns the M/2 by 8 array
%	   P = [Pxx Pyy Pxy Txy Cxy Pxxc Pyyc Pxyc]
%	where
%	   Pxx  = X-vector power spectral density
%	   Pyy  = Y-vector power spectral density
%	   Pxy  = Cross spectral density
%	   Txy  = Complex transfer function from X to Y
%	         (Use ABS and ANGLE for magnitude and phase)
%	   Cxy  = Coherence function between X and Y
%	   Pxxc,Pyyc,Pxyc = Confidence range (95 percent).
%
%	See SPECPLOT to plot these results.
%	P = SPECTRUM(X,Y,M,NOVERLAP) specifies that the M-point sections
%	should overlap NOVERLAP points.
%	Pxx = SPECTRUM(X,M) and SPECTRUM(X,M,NOVERLAP) return the single
%	sequence power spectrum and confidence range.
%
%   	See also ETFE, SPA, and ARX in the Identification Toolbox.

%	J.N. Little 7-9-86
%	Revised 4-25-88 CRD, 12-20-88 LS, 8-31-89 JNL, 8-11-92 LS
%	Copyright (c) 1986-92 by the MathWorks, Inc.

%	The units on the power spectra Pxx and Pyy are such that, using
%	Parseval's theorem:
%
%	     SUM(Pxx)/LENGTH(Pxx) = SUM(X.^2)/LENGTH(X) = COV(X)
%
%	The RMS value of the signal is the square root of this.
%	If the input signal is in Volts as a function of time, then
%	the units on Pxx are Volts^2*seconds = Volt^2/Hz.
%	To normalize Pxx so that a unit sine wave corresponds to
%	one unit of Pxx, use Pn = 2*SQRT(Pxx/LENGTH(Pxx))
%
%	Here are the covariance, RMS, and spectral amplitude values of
%	some common functions:
%         Function   Cov=SUM(Pxx)/LENGTH(Pxx)   RMS        Pxx
%         a*sin(w*t)        a^2/2            a/sqrt(2)   a^2*LENGTH(Pxx)/4
%Normal:  a*rand(t)         a^2              a           a^2
%Uniform: a*rand(t)         a^2/12           a/sqrt(12)  a^2/12
%
%	For example, a pure sine wave with amplitude A has an RMS value
%	of A/sqrt(2), so A = SQRT(2*SUM(Pxx)/LENGTH(Pxx)).
%
%	See Page 556, A.V. Oppenheim and R.W. Schafer, Digital Signal
%	Processing, Prentice-Hall, 1975.

if (nargin == 2), m = y; noverlap = 0; end

% ------- dwb start
w = hanning(w);
if ((nargin == 3) & (max(size(m)) == y)),    % m contain vector with window
    w = m;
    m = y;
    nargin = 2;
    noverlap = 0;
% --|----- dwb end
% --v
elseif (nargin == 3)
	if (max(size(y)) == 1)
		noverlap = m;
		m = y;
		nargin = 2;
	else
		noverlap = 0;
	end
end

x = x(:);		% Make sure x and y are column vectors
y = y(:);
n = max(size(x));	% Number of data points
k = fix((n-noverlap)/(m-noverlap));	% Number of windows
					% (k = fix(n/m) for noverlap=0)
index = 1:m;

% ---- inactive mathworks code
% w = hanning(m);		% Window specification; change this if you want:
%			% (Try HAMMING, BLACKMAN, BARTLETT, or your own)
% --- 

KMU = k*norm(w)^2;	% Normalizing scale factor

if (nargin == 2)	% Single sequence case.
	Pxx = zeros(m,1); Pxx2 = zeros(m,1);
	for i=1:k
		xw = w.*detrend(x(index));
		index = index + (m - noverlap);
		Xx = abs(fft(xw)).^2;
		Pxx = Pxx + Xx;
		Pxx2 = Pxx2 + abs(Xx).^2;
	end
	% Select first half
	select = [1:m/2];
	Pxx = Pxx(select);
	Pxx2 = Pxx2(select);
	cPxx = zeros(m/2,1);
	if k > 1
		c = (k.*Pxx2-abs(Pxx).^2)./(k-1);
		c = max(c,zeros(m/2,1));
		cPxx = sqrt(c);
	end
	pp = 0.95; % 95 percent confidence.
	f = sqrt(2)*erfinv(pp);  % Equal-tails.
	P = [Pxx f.*cPxx]/KMU;
	return
end

Pxx = zeros(m,1); % Dual sequence case.
Pyy = Pxx; Pxy = Pxx; Pxx2 = Pxx; Pyy2 = Pxx; Pxy2 = Pxx;

for i=1:k
	xw = w.*detrend(x(index));
	yw = w.*detrend(y(index));
	index = index + (m - noverlap);
	Xx = fft(xw);
	Yy = fft(yw);
	Yy2 = abs(Yy).^2;
	Xx2 = abs(Xx).^2;
	Xy  = Yy .* conj(Xx);
	Pxx = Pxx + Xx2;
	Pyy = Pyy + Yy2;
	Pxy = Pxy + Xy;
	Pxx2 = Pxx2 + abs(Xx2).^2;
	Pyy2 = Pyy2 + abs(Yy2).^2;
	Pxy2 = Pxy2 + Xy .* conj(Xy);
end

% Select first half
select = [1:m/2];

Pxx = Pxx(select);
Pyy = Pyy(select);
Pxy = Pxy(select);
Pxx2 = Pxx2(select);
Pyy2 = Pyy2(select);
Pxy2 = Pxy2(select);

cPxx = zeros(m/2,1);
cPyy = cPxx;
cPxy = cPxx;
if k > 1
   c = max((k.*Pxx2-abs(Pxx).^2)./(k-1),zeros(m/2,1));
   cPxx = sqrt(c);
   c = max((k.*Pyy2-abs(Pyy).^2)./(k-1),zeros(m/2,1));
   cPyy = sqrt(c);
   c = max((k.*Pxy2-abs(Pxy).^2)./(k-1),zeros(m/2,1));
   cPxy = sqrt(c);
end

Txy = Pxy./Pxx;
Cxy = (abs(Pxy).^2)./(Pxx.*Pyy);

pp = 0.95; % 95 percent confidence.
f = sqrt(2)*erfinv(pp);  % Equal-tails.

P = [ [Pxx Pyy Pxy]./KMU ...
      Txy Cxy ...
      f.*[cPxx cPyy cPxy]./KMU ];

