function [y,tscale] = sp_stzcr(x,frame,overlap,fs,window)
%SP_STZCR Short-time zero crossings.
%       [Y,TSCALE] = SP_STZCR(X,FRAME,OVERLAP,FS) computes the
%       short-time zero-crossing rate of X using a frame size
%       of LENGTH and a percentage OVERLAP between successive
%       frames using a rectangular data window.  The sampling
%       frequency is given by FS. The short-time zero-crossing
%       curve is returned in Y and a time scale corresponding
%       to the end of the data frame is returned in TSCALE.
%       The curve may be displayed with the command
%       'plot(y,tscale)'.
%
%       See also: SP_STMAG, SP_STZCR, AVSMOOTH, MDSMOOTH
%
%       SP_STZCR is implemented as a mex function on some
%       installations.

%       LT Dennis W. Brown 7-11-93, DWB 11-11-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%       Ref: Rabiner & Schafer, Digital Processing of Speech
%       Signals, 1978, ss 4.3, pp 127-130.

% window argument is not used but is here to maintain consistency with
% the other sp_ routines.

% default values
y = [];tscale = [];

% must have at least 3 args
if nargin < 4
    error('sp_stzcr: Requires first four arguments.');
end

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('sp_stzcr: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% variables
Ns = length(x);                             % number of samples
N = floor(fs * frame);                      % samples per frame
Ndiff = floor(N * (1 - overlap/100));       % samples between windows
L = floor((Ns-N)/Ndiff);                    % number of windows
y = zeros(L,1);                             % space for answer
tscale = zeros(L,1);			            % space for time

% use the absolute value of x
t = abs( sgn( x(2:Ns,1) ) - sgn( x(1:Ns-1,1) ) );

% windows with overlap
for k=1:L
    s1 = (k-1) * Ndiff + 1;                     % start of window
    tscale(k,1) = k * Ndiff/fs;
    y(k,1) = sum(t(s1:s1+N-1,1))/2/N;

end

