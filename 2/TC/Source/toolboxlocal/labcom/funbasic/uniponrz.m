function [y,t] = uniponrz(Rb,msg,fs)
%function [y,t] = uniponrz(Rb,msg,fs)
%UNIPONRZ  Señal banda base unipolar con  [0 1].
%	[y,t] = UNIPONRZ(RB,MSG) y [y,t] = UNIPONRZ(RB,MSG,FS)
%	Genera una señal unipolar de velocidad Rb bits por segundo, 
%	y frecuencia de muestreo, FS. Si MSG es un escalar, el 
%	mensaje se generará como una secuencia aleatoria de 
%	longitud MSG con Pr(0)=Pr(1)=0.5. Si MSG es un vector, 
%	debe contener sólo 0's and 1's. El valor de FS es por 
%	defecto 8192 Hz.
% PARAMETROS DE ENTRADA:
%	Rb:	velocidad en bits por segundo.
%	msg:	señal binaria a codificar.
%	fs: 	frecuencia de muestreo de la señal generada.
% PARAMETROS DE SALIDA:
%	y:	señal bipolar generada.
%	t:	dominio temporal de definición.

% default output
y = [];

% some error checking
if nargin == 2,
    fs = 8192;
elseif nargin < 2 | nargin > 3,
	error('unipolar: Invalid number of input arguments...');
end

% generate a message (or use theirs)
if max(size(msg)) == 1

    % the message length
    N = msg;
    clear msg;
    % make up our own message (uniform distribution)
    msg = randn(N,1);

    % make our message a binary signal
    msg = (msg < 0);

else

    % make msg into a N x 1 vector
    msg = msg(:);

    % the message length
    N = length(msg);

end;

% compute the baud period
Tb = floor(fs/Rb);          % this equals the number of samples per baud

% space for output
y = zeros(N*Tb,1);

% generate the output
for i = 0:N-1,

    % just have to make the ones
    y(i*Tb+1:(i+1)*Tb) = msg(i+1) * ones(Tb,1);

end;
y=y';
t=0:1/fs:(length(y)-1)/fs;
