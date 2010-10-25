function [y,sigma] = setsnrbw(signal,noise,SNR,fc,bw,fs);
%SETSNRBW Set bandwidth signal-to-noise ratio.
%       [Y,SIGMA] = SETSNRBW(SIGNAL,NOISE,SNR,FC,BW,FS) returns 
%       the additive signal such that the total in-band signal-
%       to-noise ratio is equal to SNR decibels. The in-band SNR
%       is defined as the energy within the bandwidth +-bw
%       centered about fc.  The sampling frequency is used to 
%       compute the spectrum of the noise, and then use the 
%       energy located withing the band to compute the SNR.
%
%       The output signal is defined by
%
%           x[n] = s[n] + sigma * w[n]                    (1)
%
%       for which sigma is computed such that
%
%                           (     Var(s[n])      )
%           SNR = 10 * log10(--------------------)        (2)
%                           (      2             )
%                           ( sigma  * Var(w[n]) )
%
%       where SNR is the  desired signal-to-noise ratio.  Once
%       solved for sigma, x[n] can be generated.  Note, only the
%       amplitude of the noise signal is adjusted to give the 
%       desired SNR.  (To derive equation (2), simply substitute
%       equation (1) into the general formula for signal-to-noise
%       ratio.
%
%       [Y,SIGMA] = SETSNR(SIGNAL,SNR,FC,BW) function generates 
%       and adds Gaussian white noise to produce the output 
%       signal SNR.  The sampling frequency defaults to fs=8192 Hz.
%
%       See also SETSNR

%       LT Dennis W. Brown 7-18-94, DWB 10-2-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% check the args
if nargin == 4,
    bw = fc;
    fc = SNR;
    SNR = noise;
    noise = randn(length(signal),1);
    fs = 8192;
elseif nargin ~= 6,
    error('setsnrbw: Invalid number of arguments...');
end;

% figure out if we have vectors
if min(size(signal)) ~= 1,
    error('setsnrbw: Input arg "signal" must be a 1xN or Nx1 vector...');
end;
if min(size(noise)) ~= 1,
    error('setsnrbw: Input arg "noise" must be a 1xN or Nx1 vector...');
end;

% check lengths
if length(signal) ~= length(noise),
    error('setsnrbw: Signal and noise vectors are not same lengths...');
end;

fft_length = 2^ceil(log2(length(noise)));        % maximum even power of two

sn = abs(fft(noise,fft_length)/fft_length).^2;
ss = abs(fft(signal,fft_length)/fft_length).^2;

T = 1/fft_length * fs;

% compute power in band
pn = 2*sum(sn(floor((fc-bw)/T):ceil((fc+bw)/T)));
std(signal)^2;
ps = 2*sum(ss(floor((fc-bw)/T):ceil((fc+bw)/T)));

% spectrums overlap?
if pn == 0,
    error('setsnrbw: Signal and noise spectrums do not overlap...');
end;

% compute mulitiplier to adjust amplitude of noise
sigma = std(signal)^2 / (pn * 10^(SNR/10));
%sigma = ps / (pn * 10^(SNR/10));

% adjust noise and add the two together
y = signal + sqrt(sigma) * noise;


