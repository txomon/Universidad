function [y,t] = framdata(x,Nf,Nfft,No,fs)
%FRAMDATA Form overlapping frames of vectored data.
%	FRAMDATA(X,Nframe,Ncolumn,Noverlap) - Forms a
%	matrix whose columns contain individual frames
%	of data vector x. Each column of the output
%	matrix y is formed from Nframe consecutive samples
%	zero padded out to Ncolumn samples-per-column (if
%	necessary). Each consecutive column is formed by
%	taking the last Noverlap samples from the previous
%	frame as its first portion.
%
%	Nframe and Ncolumn must meet the condition
%		0 < Nframe <= Ncolumn
%	Nframe and Noverlap must meet the condition
%		0 <= Noverlap < Nframe
%
%	[y,tscale] = FRAMDATA(x,Nframe,Ncolumn,Noverlap,fs)
%	Returns the output vector tscale whose values correspond
%	to the start times of each frame in y based on the
%	sampling frequency fs. The sampling frequency defaults
%	to fs = 1 if not given.
%
%	The last frame receives additional zero padding if
%	there are not enough elements remaining in x to fill
%	the frame with Nframe samples.
%
%       Example:
%		>> x = 1:10
%		x =
%		     1   2   3   4   5   6   7   8   9  10
%
%		>> [y,t] = framdata(x,3,4,1,2)
%		y =
%		     1     3     5     7     9
%		     2     4     6     8    10
%		     3     5     7     9     0
%		     0     0     0     0     0
%		t =
%		     0
%		     1
%		     2
%		     3
%		     4

%       LT Dennis W. Brown 11-1-93, DWB 6-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.


% arg check
if nargin < 4 | nargin > 5,
	error('framdata: Invalid number of input arguments.');
end;

if Nf > Nfft,
	error(['framdata: Sample-per-frame, ' int2str(Nf) ...
		', cannot be greater than FFT size, ' int2str(Nfft) '.']);
end;

if No < 0,
	error('framdata: Frame overlap cannot be less than zero.');
end;

if No >= Nf,
	error(['framdata: Frame overlap cannot be greater ' ...
			'or equal samples-per-frame.']);
end;

if nargin == 4,
	fs = 1;
end;

% make x a column vector
x = x(:);

% number of samples
Ns = length(x);

% step size
Ndiff = Nf - No;

% number of full frames
L = fix((Ns-Nf+Ndiff) / Ndiff);

% partial frame?
if L*Ndiff < Ns-No,
	partial = 1;
else,
	partial = 0;
end;

% output matrix
y = zeros(Nfft,L+partial);
t = zeros(L+partial,1);

% step index
col = 0;

% up to the last frame
for k = 1:Ndiff:L*Ndiff,

	% increase column
	col = col + 1;

	% fill the frame
	y(1:Nf,col) = x(k:k+Nf-1,1);
	t(col) = (k-1)/fs;

end;

if partial,

	k = k + Ndiff;
	nleft = Ns - L * Ndiff;

	y(1:nleft,L+1) = x(k:k+nleft-1,1);
	t(L+1) = (k-1)/fs;
end;

