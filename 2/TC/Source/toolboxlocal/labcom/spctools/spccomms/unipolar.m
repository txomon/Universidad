function [y] = unipolar(fb,msg,fs)
%UNIPOLAR  Baseband unipolar [0,1] signal.
%       [Y] = UNIPOLAR(FB,MSG) and [Y] = UNIPOLAR(FB,MSG,FS)
%       generates a baseband unipolar signal at bit rate, FB,
%       and sampling frequency, FS.  If MSG is a scalar, a
%       message will be generated as a random sequence of length
%       MSG with Pr(0)=Pr(1)=0.5. If MSG is a vector, it must
%       be a vector of 0's and 1's.  If not provided, the
%       sampling frequency is set to FS=8192 Hz
%
%       See also UNIPOLAR
%
%       UNIPOLAR is implemented as a mex functions on some
%       installations.
%       LT Dennis W. Brown 8-1-93, DWB 8-17-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

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
Tb = floor(fs/fb);          % this equals the number of samples per baud

% space for output
y = zeros(N*Tb,1);

% generate the output
for i = 0:N-1,

    % just have to make the ones
    y(i*Tb+1:(i+1)*Tb) = msg(i+1) * ones(Tb,1);

end;