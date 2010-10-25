function [y,sigma] = setsnr(signal,noise,SNR);
%SETSNR   Set signal-to-noise ratio.
%       [Y,SIGMA] = SETSNR(SIGNAL,NOISE,SNR) 
%       Devuelve una la señal 'y' como suma de la señal de entrada 'signal'
%	y el ruido 'noise' ajustando la potencia de éste en el ancho 
%	de banda de 0 Hz hasta fs/2 de modo que la relación señal/ruido
%	sea igual a SNR dB.
%	La señal de salida se define según:
%           x[n] = s[n] + sigma * w[n]                        
%       donde sigma se calcula según:
%                           (     Var(s[n])      )
%           SNR = 10 * log10(--------------------)
%                           (      2             )
%                           ( sigma  * Var(w[n]) )
%       donde SNR es la relación S/N deseada.
%	Se ajusta la amplitud del ruido, no el de la señal.
%       solved for sigma, x[n] can be generated.  Note, only 
%       [Y,SIGMA] = SETSNR(SIGNAL,SNR) genera y añade
%       ruido gaussiano blanco para obtener la relación SNR.

% check the args
if nargin == 2,
    SNR = noise;
    noise = randn(size (signal));
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
