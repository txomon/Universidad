function [y]=dsbsc(modsig,fc,fs)
%DSBSC    Double-sideband, suppressed-carrier modulation.
%       [Y] = DSBSC(MODSIG,FC) and [Y] = DSBSC(MODSIG,FC,FS)
%       generates a double-sideband, suppressed-carrier amplitude
%       modulated signal. The signal contained in the vector
%       MODSIG is modulated onto a sinusoidal carrier of at
%       carrier frequency, FC. The length of the signal returned
%       is equal to the length of MODSIG. The carrier is generated
%       at the sampling frequency, FS. The sampling frequency, fs,
%       must be the same sampling frequency used to generate
%       MODSIG or unexpected results will occur.  If not
%       provided, the default sampling frequency is FS=8192 Hz.
%
%       Example:
%           To generate a OOK signal with a baud rate of 32, a
%           carrier frequency of 2,048 Hz and a sampling frequency
%           of 8,196 Hz:
%
%           >> msig = unipolar(32,50);
%           >> y = dsbsc(msig,2048);
%
%           This example produces a vector OF 50*8196/32 samples.
%
%       See also DSBLC

%       LT Dennis W. Brown 8-1-93, DWB 1-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default argument
y = [];

% some error checking
if nargin < 2 | nargin > 3
	error('dsbsc: Invalid number of input arguments...');
end

% default sampling frequency
if nargin ~= 3,
    fs = 8192;
end;

% figure out if we have a vector
if min(size(modsig)) ~= 1,
	error('dsbsc: Input arg "modsig" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
modsig = modsig(:);

% compute the number of samples to be used
N = length(modsig);

% time steps for N samples at sampling frequency
t=(0:1/fs:(N-1)/fs)';

% generate carrier
c = cos( 2 * pi * fc .* t);

% generate modulated signal;
y = modsig .* c;

