function y = proddmod(x,Rb,B,fc,fs)
%PRODDMOD Poduct demodulate a bandpass digital signal.
%	PRODDMOD(X,RB,B,FC) - Demodulates the bandpass digital 
%	signal X using a product detector.  A product demodulator
%	is defined here as a sinusoidal mixer followed by a 
%	low-pass filter followed by a sample-and-hold block 
%	which is sub-sampled at the bit rate, t0 = RB. A cosine 
%	of FC Hz with zero-phase shift is used as the input to 
%	the sinusoidal mixer and a sixth order Chebychev Type 1 
%	lowpass filter of bandwith B is used. This detector is 
%	a coherent detector and thus requires the carrier used 
%	in modulating the bandpass digital signal to be a cosine 
%	wave with zero-phase shift. A vector containing the 
%	demodulated bit-stream is returned. The default sampling 
%	frequency of the input signal is FS = 8192 Hz.
%
%	PRODDMOD(X,RB,B,FC,FS) - Sets the sampling frequency to fs.
%
%	Note: The carrier frequency must be a multiple of the 
%	bit rate.
%
%	See also PRODDMOD, BPSK, BFKS, OOK

%       Dennis W. Brown 10-24-93, DWB 6-22-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default argument
y = [];

% some error checking
if nargin < 4 | nargin > 5,
	error('proddmod: Invalid number of input arguments...');
end
if nargin == 4,
    fs = 8192;
end;

if rem(fs,fc) ~= 0,
  error('proddmod: The carrier frequecy must be a multiple of the bit rate.');
end;

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('proddmod: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% generate demodulating signal at fc
t = 0:1/fs:(length(x)-1)/fs;
c = cos(2 * pi * fc .* t');

% product of received signal and demodulating signal
b = c .* x;

% lowpass filter
[bb,aa] = cheby1(6,1,B/fs);
d = filter(bb,aa,b);

% resample at bit rate
k = d(fs/Rb:fs/Rb:length(d));

% run through threshold detector
y = k > 0;

