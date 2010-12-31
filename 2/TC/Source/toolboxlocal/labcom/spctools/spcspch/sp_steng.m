function [y,tscale] = sp_steng(x,frame,overlap,fs,window)
%SP_STENG Short-time energy.
%       [Y,TSCALE] = SP_STENG(X,FRAME,OVERLAP,FS) computes
%       the short-time energy of X using a size FRAME (mili-
%       seconds) and a percentage OVERLAP between successive
%       frames using a rectangular data window.  The sampling
%       frequency is given by FS. The short-time energy
%       curve is returned in Y and a time scale corresponding
%       to the end of the data frame is returned in TSCALE.
%       The curve may be displayed with the command
%       'plot(y,tscale)'.
%
%       [Y,TSCALE] = SP_STENG(X,FRAME,OVERLAP,FS,'WINDOW')
%       windows the data through the specified 'WINDOW' before
%       computing the short-time energy.  'WINDOW' can be
%       one of the following: 'hamming', 'hanning', 'bartlett',
%       'blackman' or 'triang'.
%
%       See also: SP_STENG, SP_STZCR, AVSMOOTH, MDSMOOTH
%
%       SP_STENG is implemented as a mex function on some
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
if nargin < 4
    error('sp_steng: Requires first three arguments.');
end;

% percentage must be in range 0-100
if overlap < 0 | overlap > 100,
    error('sp_steng: Overlap percentage must be in range 0-100%');
end;

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('sp_steng: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% variables
Ns = length(x);                         % number of samples
N = floor(fs * frame);                  % samples-per-frame
Ndiff = floor(N * (1 - overlap/100));   % samples between windows
L = floor((Ns-N)/Ndiff);                % number of windows
y = zeros(L,1);                         % space for answer
tscale = zeros(L,1);			        % space for indices

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
    end;
end;

% square the data and the window
datawindow = datawindow .^ 2;
x = x .^ 2;

% windows with overlap
for k=1:L
    s1 = (k-1) * Ndiff + 1;    	% start of window
    tscale(k,1) = k * Ndiff/fs;
    y(k,1) = sum(x(s1:s1+N-1,1) .* datawindow);
end;

