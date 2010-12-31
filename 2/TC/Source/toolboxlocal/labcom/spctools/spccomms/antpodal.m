function [y] = antpodal(fb,msg,fs)
%ANTPODAL  Baseband anti-podal [-1,1] signal.
%	ANTPODAL(Rb,MSG) - Generates a baseband anti-podal
%	signal at bit rate, Rb, with the bit pattern specified
%	in MSG. The input argument MSG must be a vector
%	containing 1's and 0's. The sampling frequency
%	defaults to FS = 8192 Hz.
%
%	ANTPODAL(Rb,NBRBITS) - Generates a baseband anti-podal
%	signal at bit rate, Rb, with a random bit pattern NBRBITS
%	long. The message is generated as a random sequence of
%	1's and -1's with Pr(1)=Pr(-1)=0.5. The sampling frequency
%	defaults to FS = 8192 Hz.
%
%	ANTPODAL(Rb,MSG,FS) and ANTPODAL(Rb,NBRBITS,FS) - Sampling
%	frequency is set to FS.
%
%	If the bit rate, Rb, and the sampling frequency, FS, are
%	both equal to one, the resulting vector will contain
%	alternating values of [-1,1].
%
%	See also UNIPOLAR, SQWAVE, SAWWAVE, TRIWAVE, COSWAVE, SINWAVE

%       Dennis W. Brown 8-1-93, DWB 9-20-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%default output
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
Tb = floor(fs/fb);          % this equals the number of samples per baud

% space for output
y = zeros(N*Tb,1);

% generate the output
for i = 0:N-1,

	% just have to make the ones
	y(i*Tb+1:(i+1)*Tb) = msg(i+1) * ones(Tb,1);

end;


