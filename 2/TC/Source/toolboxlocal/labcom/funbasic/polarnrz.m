function [y,t] = polarnrz(Rb,msg,fs)
%function [y,t] = polarnrz(Rb,msg,fs)
%POLARNRZ  Señal polar [-1,1] sin retorno a cero.
%	POLARNRZ (Rb,MSG) - Genera una señal en banda base
% 	polar de velocidad Rb bits por segundo, con la
%	forma especificada en MSG. La entrada MSG debe ser
%	un vector de 1's y 0's. La frecuencia de muestreo por
%	defecto es FS = 8192 Hz.
%
%	POLARNRZ (Rb,NBRBITS) - Genera una señal en banda base
% 	polar de frecuencia Rb bits por segundo, con el
%	patrón de la secuencia de NBRBITS bits. El mensaje es
%	generado como una secuencia de 1's y -1's aleatorios con 
%	Pr(1)=Pr(-1)=0.5. La frecuencia de muestreo por
%	defecto es FS = 8192 Hz.
%
%	Si la velocidadad, Rb, y la frecuencia de muestreo, FS, son
%	iguales a uno  el vector resultante contendrá valores 
%	alternados de [-1,1].
% PARAMETROS DE ENTRADA:
%	Rb:	velocidad en bits por segundo.
%	msg:	señal binaria a codificar.
%	fs: 	frecuencia de muestreo de la señal generada.
% PARAMETROS DE SALIDA:
%	y:	señal bipolar generada.
%	t:	dominio temporal de definición.

y = [];

% some error checking
if nargin == 2,
	fs = 8192;
elseif nargin < 2 | nargin > 3,
	error('antpodal: Invalid number of input arguments...');
end

% generate a message (or use theirs)
if max(size(msg)) == 1

	% the message length
	N = msg;
	clear msg;

	% make up our own message (uniform distribution)
	msg = randn(N,1);

	% make our message a binary signal
	msg = (msg >= 0);

else

	% make msg into a N x 1 vector
	msg = msg(:);

	% the message length
	N = length(msg);

end;

% change all the zeros into -1's
msg = 2 * (msg - .5 * ones(N,1));

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
