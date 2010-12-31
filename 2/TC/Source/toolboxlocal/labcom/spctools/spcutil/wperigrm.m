function wperigrm(x,arg2,arg3)
%WPERIGRM Linear periodogram plot.
%       WPERIGRM(X) computes and displays the periodogram of X.
%
%       WPERIGRM(X,FS) displays the freq scale given by the 
%       sampling rate, FS.  Default sampling rate is 8,192 Hz.
%
%       WPERIGRM(X,'PHASE') or WPERIGRM(X,FS,'PHASE') display
%       phase information.
%
%                 1  |      |2
%            X = --- | x(t) |
%                 N  |      |
% 
%       See also PLOTTIME, LPERIGRM

%       LT Dennis W. Brown 8-17-93, DWB 9-2-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default values
y=[]; phase=0; fs = 8192;

% must have two arguments
if nargin < 1,
    error('wperigrm: Incorrect number of arguments...');
end;

% check arg2
if nargin == 2,
    if isstr(arg2),
        phase = 1;
    else
        fs = arg2;
    end;
end;

% check arg3
if nargin == 3,
    if strcmp(arg3,'phase'),
        phase = 1;
    else
        error('wperigrm: Argument 3 is invalid...');
    end;
end;


% figure out if we have a vector
if min(size(x)) ~= 1,
	error('wperigrm: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% number of samples
Ns = length(x);

% make sure that Nfft is a power of two
Nfft = 2^ceil(log(Ns)/log(2));

% take FFT and normalize
% take FFT and normalize
xf = fft(x,Nfft);
Xm = abs(xf).^2 / Nfft;
Xp = angle(xf);

% take just positive side
Xm = Xm(1:Nfft/2);
Xp = Xp(1:Nfft/2);

% frequency scale
fscale = (0:Nfft/2-1)/Nfft * fs;

% plot the magnitude
plot(fscale,Xm);
title('Power Spectral Density');
ylabel('Relative Magnitude (W)');
xlabel('Frequency (Hz)');

if phase,
    % plot the phase
    subplot(2,1,2);
    plot(fscale,Xp);
    title('Phase');
    ylabel('Angle (rad)');
    xlabel('Frequency (Hz)');
end;

% do it
drawnow;
% done
