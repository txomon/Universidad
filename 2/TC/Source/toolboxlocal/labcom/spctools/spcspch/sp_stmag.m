function [y,tscale] = sp_stmag(x,frame,overlap,fs,window)
%SP_STMAG Short-time magnitude.
%       [Y,TSCALE] = SP_STMAG(X,FRAME,OVERLAP,FS) computes
%       the short-time magnitude of X using a frame size
%       of LENGTH and a percentage OVERLAP between successive
%       frames using a rectangular data window.  The sampling
%       frequency is given by FS. The short-time magnitude
%       curve is returned in Y and a time scale corresponding
%       to the end of the data frame is returned in TSCALE.
%       The curve may be displayed with the command
%       'plot(y,tscale)'.
%
%       [Y,TSCALE] = SP_STMAG(X,FRAME,OVERLAP,FS,'WINDOW')
%       windows the data through the specified 'WINDOW' before
%       computing the short-time magnitude.  'WINDOW' can be
%       one of the following: 'hamming', 'hanning', 'bartlett',
%       'blackman' or 'triang'.
%
%       See also: SP_STENG, SP_STZCR, AVSMOOTH, MDSMOOTH
%
%       SP_STMAG is implemented as a mex function on some
%       installations.

%       LT Dennis W. Brown 7-11-93, DWB 11-11-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%       Ref: Rabiner & Schafer, Digital Processing of Speech
%       Signals, 1978, ss 4.2, pp 120-126.

% default values
y = [];tscale=[];

% must have at least 3 args
if nargin < 3
    error('sp_stmag: Requires first three arguments.');
end

% percentage must be in range 0-100
if overlap < 0 | overlap > 100,
    error('sp_stmag: Overlap percentage must be in range 0-100%');
end;

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('sp_stmag: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% variables
Ns = length(x);                         % number of samples
N = floor(fs * frame);                  % samples-per-frame
Ndiff = floor(N * (1 - overlap/100));   % samples between windows
L = floor((Ns-N)/Ndiff);                % number of windows
y = zeros(L,1);                         % space for answer
tscale = zeros(L,1);			% space for time

% data window
datawindow = ones(N,1);                 % rectangular default
if nargin == 5
    if strcmp(window,'hamming')
        datawindow = hamming(N);
    elseif strcmp(window,'hanning')
        datawindow = hanning(N);
    elseif strcmp(window,'blackman')
        datawindow = blackman(N);
    elseif strcmp(window,'bartlett')
        datawindow = bartlett(N);
    elseif strcmp(window,'triang')
        datawindow = triang(N);
    end
end

% use the absolute value of x
x = abs(x);

% windows with overlap
for k=1:L
    s1 = (k-1) * Ndiff + 1;                 % start of window
    tscale(k,1) = k * Ndiff/fs;
    y(k,1) = sum(x(s1:s1+N-1,1) .* datawindow);
end

