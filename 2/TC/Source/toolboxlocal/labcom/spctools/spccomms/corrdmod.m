function y = corrdmod(x,Rb,fc,fs)
%CORRDMOD Correlation demodulate a bandpass digital signal.
%	CORRDMOD(X,RB,FC) - Demodulates the bandpass digital
%	signal X using a correlation demodulator.  A correlation
%	demodulator is defined here as a sinusoidal mixer followed
%	by an integrate-and-dump filter.  The integration period
%	is over a single bit-period defined by T = 1/rb.  A cosine
%	of FC Hz with zero-phase shift is used as the input to the 
%	sinusoidal mixer.  This detector is a coherent detector and
%	thus requires the carrier used in modulating the bandpass
%	digital signal to be a cosine wave with zero-phase shift.
%	This demodulator will work with the digital modulators
%	provided in the SPC Toolbox.  The default sampling frequency
%	of the input signal is FS = 8192 Hz.
%
%	CORRDMOD(X,RB,FC,FS) - Sets sampling frequency to FS.
%
%	Note: The carrier frequency must be a multiple of the 
%	bit rate.
%
%	See also PRODDMOD, BPSK, BFKS, OOK

%       Dennis W. Brown 7-11-93, DWB 9-14-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default argument
y = [];

% some error checking
if nargin < 3 | nargin > 4,
	error('corrdmod: Invalid number of input arguments...');
end
if nargin == 3,
    fs = 8192;
end;

if rem(fs,fc) ~= 0,
  error('corrdmod: The carrier frequecy must be a multiple of the bit rate.');
end;

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('corrdmod: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% generate demodulating signal at fc
t = 0:1/fs:(length(x)-1)/fs;
c = cos(2 * pi * fc .* t');

% product of received signal and demodulating signal
b = c .* x;

% reshape to better do in matlab
% reshaped such that each column of dd has the number of samples
% of a single bit and the number of columns of dd equal the number
% of bits in the message
m = fs/Rb;
n = Rb*length(b)/fs;
if m*n ~= length(b),
    error('corrdmod: Not an even number of samples per bit in signal...');
end;
dd = reshape(b,m,n);

% perform the integration over the period of on bit (column in this case)
ddd = sum(dd)';

% run through threshold detector
y = ddd > 0;

