function [y] = modindex(x)
%MODINDEX  Modulation index.
%       [y] = MODINDEX(X) returns the modulation index of the AM
%       signal x.
%
%       See also DSBLC, ENVELOPE

%       LT Dennis W. Brown 9-8-93, DWB 1-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default argument
y = [];

% some error checking
if nargin ~= 1,
	error('modindex: One argument required...');
end

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('modindex: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% get the complex envelope
z = abs(hilbert(x));

% get the extremes
mmaxz = max(z);
mminz = min(z);

% plug into formula
y = (mmaxz - mminz) / (mmaxz + mminz);

