function [y,m] = envelope(x)
%ENVELOPE Envelope detection.
%       [Y,M] = ENVELOPE(x) returns the envelope,Y, and 
%       modulation index, M, of the AM signal in vector X.
%
%       See also DSBLC, MODINDEX

%       LT Dennis W. Brown 9-8-93, DWB 9-8-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default argument
y = [];

% some error checking
if nargin ~= 1,
	error('envelope: One argument required...');
end

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('envelope: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% generate envelope
y = abs(hilbert(x));

% generate the modulation index
mmax = max(y);
mmin = min(y);
m = (mmax - mmin) / (mmax + mmin);

