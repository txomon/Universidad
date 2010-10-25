function [y,sigma] = setsnr(signal,noise,SNR);
%SETSNR   Set signal-to-noise ratio.
%       [Y,SIGMA] = SETSNR(SIGNAL,NOISE,SNR) returns the additive
%       signal such that the total signal-to-noise ratio is equal
%       to SNR decibels. The term "total" implies the noise power
%       in all frequencies from 0 to fs/2 is used in the compu- 
%       tation of the SNR.
%
%       The output signal is defined by
%
%           x[n] = s[n] + sigma * w[n]                        (1)
%
%       for which sigma is computed such that
%
%                           (     Var(s[n])      )
%           SNR = 10 * log10(--------------------)            (2)
%                           (      2             )
%                           ( sigma  * Var(w[n]) )
%
%       where SNR is the  desired signal-to-noise ratio.  Once 
%       solved for sigma, x[n] can be generated.  Note, only 
%       the amplitude of the noise signal is adjusted to give 
%       the desired SNR.  (To derive equation (2), simply 
%       substitute equation (1) into the general formula for 
%       signal-to-noise ratio.
%
%       [Y,SIGMA] = SETSNR(SIGNAL,SNR) function generates and
%       adds Gaussian white noise to produce the desired
%       signal SNR.
%
%       See also SETSNRBW

%       LT Dennis W. Brown 7-18-94, DWB 8-28-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% check the args
if nargin == 2,
    SNR = noise;
    noise = randn(length(signal),1);
elseif nargin ~= 3,
    error('setsnr: Invalid number of arguments...');
end;

% figure out if we have vectors
if min(size(signal)) ~= 1,
    error('setsnr: Input arg "signal" must be a 1xN or Nx1 vector...');
end;
if min(size(noise)) ~= 1,
    error('setsnr: Input arg "noise" must be a 1xN or Nx1 vector...');
end;

% check lengths
if length(signal) ~= length(noise),
    error('setsnr: Signal and noise vectors are not same lengths...');
end;

% compute mulitiplier to adjust amplitude of noise
sigma = std(signal)^2 / (std(noise)^2 * 10^(SNR/10));

% adjust noise and add the two together
y = signal + sqrt(sigma) * noise;

