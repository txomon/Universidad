function lperigrm(x,fs,arg3,arg4)
%LPERIGRM Log periodogram plot.
%       LPERIGRM(X) computes and displays the log periodogram 
%       of X.
%
%       LPERIGRM(x,fs) displays the freq scale given by the 
%       sampling rate.  Default sampling rate is 8,192 kHz.
%
%       LPERIGRM(x,mindb) cuts plot off below mindb.  mindb
%       must be negative for this use.  Default for mindb in 
%       above use is -60 dB.
%
%       LPERIGRM(x,fs,mindb) cuts plot off below mindb and sets 
%       the sampling frequency to FS.  
%
%       LPERIGRM(x,fs,'phase') and LPERIGRM(x,fs,mindb,'phase') 
%       displays phase information.
%
%                 1  |      |2
%            X = --- | x(t) |
%                 N  |      |
%
%       See also PLOTTIME, WPERIGRM

%       LT Dennis W. Brown 8-9-93, DWB 1-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default values
y=[]; mindb = -60; phase=0;

% must have two arguments
if nargin < 1,
    error('lperigrm: Incorrect number of arguments...');
end;

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('lperigrm: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% default the sampling rate is 8192
if nargin < 2,
    fs = 8192;
end;

% check for fs < 0, if so fs is mindb
if fs < 0,
    mindb = fs;
    fs = 8192;
end;

% check arg3
if nargin >= 3
    if ~isstr(arg3),
        mindb = arg3;
    elseif strcmp(arg3,'phase'),
        phase = 1;
    else
        error('lperigrm: Argument 3 is invalid...');
    end;
end;

% check arg4
if nargin == 4,
    if strcmp(arg4,'phase'),
        phase = 1;
    else
        error('lperigrm: Argument 4 is invalid...');
    end;
end;


% ensure is a vector
x = x(:);

% number of samples
Ns = length(x);

% make sure that Nfft is a power of two
Nfft = 2^ceil(log(Ns)/log(2));

% take FFT and normalize
xf = fft(x,Nfft);
Xm = abs(xf) / Nfft;
Xp = angle(xf);

% get rid of zeros
ind = find(Xm == 0);
Xm(ind) = eps * ones(length(ind),1);

% take just positive side
Xm = Xm(1:Nfft/2);
Xp = Xp(1:Nfft/2);

% get rid of the stuff below mindb
psd = 20 * log10(abs(Xm));
ind = find(psd < mindb);
psd(ind) = mindb*ones(size(ind));

% frequency scale
fscale = (0:Nfft/2-1)/Nfft * fs;

% plot the magnitude
if phase
    clg
    subplot(1+phase,1,1);
end;
plot(fscale,psd);
title('Power Spectral Density');
ylabel('Magnitude (dB)');
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

