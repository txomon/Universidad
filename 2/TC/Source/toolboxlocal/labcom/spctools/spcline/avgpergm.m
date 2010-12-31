function [y,var] = avgpergm(x,nfft,arg3,arg4,arg5)
%AVGPERGM Average periodogram.
%	[X,VAR] = AVGPERGM(x) computes the average, non-overlap-
%	ping periodogram (Bartlett procedure) of x, the magnitude
%	is returned in X and the variance in VAR
%
%	[X,VAR] = AVGPERGM(x,NFFT) sets the FFT length to NFFT.
%
%	[X,VAR] = AVGPERGM(x,NFFT,WINDOW) uses the data smoothing
%	WINDOW.  The length of WINDOW must equal NFFT.
%
%	[X] = AVGPERGM(x,NFFT,'frames') or [X] = AVGPERGM(x,
%	NFFT,WINDOW,'frames') returns a NFFT by L matrix where each
%	column in X is a single frame in the periodogram.  The
%	averaged periodogram is not returned.
%
%	[X,VAR] = AVGPERGM(x,NFFT,FRAME) computes the average,
%	overlapping periodogram (Welch procedure) of x.  The
%	frame length and percentage of overlap is specified in
%	the FRAME argument as a two-element vector of the
%	form [FRAMELENGTH OVERLAP] where FRAMELENGTH is the
%	frame length expressed in the number of samples-per-frame
%	(must be less-than or equal-to NFFT) and OVERLAP is the
%	percentage of overlap between succesive frames.  If OVERLAP
%	is not specified, zero overlap is used.  The overlap
%	must be specified in the range 0 <= OVERLAP < 100%.
%
%	[X,VAR] = AVGPERGM(x,NFFT,FRAME,WINDOW) uses the data smoothing
%	WINDOW.  The length of WINDOW must equal the frame length.
%
%	[X] = AVGPERGM(x,NFFT,FRAME,'frames') and
%	[X] = AVGPERGM(x,NFFT,FRAME,WINDOW,'frames') return the
%	individual frames vice the average.
%
%	See also DANIELL, SPECT2D

%       Dennis W. Brown 4-23-94, 5-31-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default
window = ones(nfft,1);
frames = 0;
framelength = nfft;
overlap = 0;

% arg check
if nargin < 1 | nargin > 5,
	error('avgpergm: Invalid number of input arguments.');
end

% work with N x 1 vector
x = x(:);

% default NFFT
if nargin == 1,
	nfft = length(x);	% use number of samples
elseif nargin == 3,
	if isstr(arg3),
		frames = 1;
	else,
		if max(size(arg3)) > 2
			window = arg3(:);
		else,
			framelength = arg3(1);
			window = ones(framelength,1);
			if size(arg3) == 2,
				overlap = arg3(2);
			end;
		end;
	end;
elseif nargin == 4,

	if isstr(arg4),
		frames = 1;
		window = arg3(:);
	else,
		window = arg4(:);
		framelength = arg3(1);
		if size(arg3) == 2,
			overlap = arg3(2);
		end;
	end;
elseif nargin == 5,
	if isstr(arg5),
		frames = 1;
		window = arg4;
		framelength = arg3(1);
		if size(arg3) == 2,
			overlap = arg3(2);
		end;
	end;
end;


% error checks
if framelength > nfft,
	error('avgpergm: Frame length cannot be greater than FFT size.');
end;
if overlap < 0 | overlap >= 100,
	error('avgpergm: Overlap must be a percentage 0 <= OVERLAP < 100%');
end;
if length(window) ~= framelength,
	error('avgpergm: Window length must equal framelength');
end;

% convert overlap to number of samples
overlap = fix(framelength * overlap / 100);

% form matrix where each column contains a frame
x = framdata(x,framelength,nfft,overlap);
[m,L] = size(x);

% multiply by window is not boxcar
if ~all(window == 1),

	% ensure column vector
	window = window(:);

	for i = 1:L,
		x(1:framelength,i) = window .* x(1:framelength,i);
	end;
end;

% compute FFT
X = fft(x,nfft);

% normalize power

% magnitude only
X = (abs(X)/framelength);


var = zeros(nfft,1);
if ~frames & L ~= 1,

	var = (std(X'))';
	y = mean(X')';
else
	y = abs(X);

end;
