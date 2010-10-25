function [y]=dsblc(modsig,m,fc,fs)
%DSBLC    Double-sideband, large-carrier modulation.
%       [Y] = DSBLC(MODSIG,M,FC) and [Y] = DSBLC(MODSIG,M,FC,FS)
%       generate a double-sideband, large-carrier amplitude 
%       modulated signal. The signal contained in the vector
%       MODSIG is modulated onto a sinusoidal carrier of  
%       frequency, FC, with zero phase shift. The sampling 
%       frequency, FS, must be the same sampling frequency used 
%       to generate MODSIG or unexpected results will occur.
%       If not provided, the sampling frequency is set to 
%       FS=8192 Hz.
%
%       Note: The modulating signal must range evenly about zero
%       (specifically: max(modsig) == abs(min(modsig))) but does
%       not have to have zero mean. MODSIG is adjusted to vary 
%       on the interval [1,-1] and is then multiplied by the 
%       modulation index, M, before being mixed onto the carrier.
%       The length of the signal returned is equal to the length 
%       of the MODSIG vector. 
%
%       See also DSBSC

%       LT Dennis W. Brown 8-1-93, DWB 9-8-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default argument
y = [];

% some error checking
if nargin < 3,
	error('dsblc: First three arguments required...');
end

% default if no fourth argument
if nargin ~= 4,
	fs = 8192;
end

% figure out if we have a vector
if min(size(modsig)) ~= 1,
	error('dsblc: Input arg "modsig" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
modsig = modsig(:);

% compute the number of samples to be used
N = length(modsig);

% normalize input signal amplitude
modsig = modsig / max(abs(modsig));

% time steps for N samples at sampling frequency
t=(0:1/fs:(N-1)/fs)';

% generate carrier
c = sqrt(2) * cos( 2 * pi * fc .* t);

% generate modulated signal;
y = (1 + m * modsig) .* c;

