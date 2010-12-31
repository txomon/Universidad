function [y] = bpskmsg(Rb,fc,fs,msg)
%BPSKMSG  Binary phase-shift signal with message.
%       [Y] = BPSKMSG(RB,FC,MSG) generates a passband binary
%       phase-shift keyed signal with a bit rate of RB bits-
%       per-second centered at a carrier frequency of FC 
%       containing the binary message, MSG.  MSG must be a 
%       vector of 1's and 0's.  The default sampling frequency 
%       is set to 8192 Hz.
%
%       [Y] = BPSKMSG(RB,FC,FS,MSG) sets the sampling frequency
%       to FS.
%
%       See also BPSK, BPSKMSG, BFSK, OOK, OOKMSG

%       LT Dennis W. Brown 8-16-93, DWB 8-28-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% defaults
y = [];

% check arguments
if nargin == 3,
    if max(size(fs)) == 1,
        error('bpskmsg: Invalid sampling frequency...');
    else
        msg = fs;
        fs = 8192;
    end;
elseif nargin ~= 4,
    error('bpskmsg: Invalid number of arguments...');
end;

if fs < 2*fc,
    error('bpskmsg: Sampling frequency must be at least 2 * fc...');
end;

% figure out if we have a vector
if min(size(msg)) ~= 1,
	error('bpskmsg: Input arg "msg" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
msg = msg(:);

% compute number of bauds during duration, round up to nearest integer
bauds = length(msg);

% baseband signal
y = antpodal(Rb,msg,fs);

% modulate signal
y = dsbsc(y,fc,fs);

