function [y] = ookmsg(Rb,fc,fs,msg)
%OOKMSG  On-off keyed signal with message.
%       [Y] = OOKMSG(RB,FC,MSG) generates a passband on-off 
%       keyed signal with a bit rate of RB bits-per-second
%       centered at a carrier frequency, FC, containing the 
%       binary message, MSG.  MSG must be a vector of 1's and 
%       0's.  The default sampling frequency is set to 8192 Hz.
%
%       [Y] = OOKMSG(RB,SHIFT,FC,FS,MSG) sets the sampling
%       frequency to FS.
%
%       See also BPSK, BPSKMSG, BFSK, BfSKMSG, OOK

%       LT Dennis W. Brown 8-16-93, DWB 11-7-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%defaults
y = [];

% check arguments
if nargin == 3,
    if max(size(fs)) == 1,
        error('ookmsg: Invalid sampling frequency...');
    else
        msg = fs;
        fs = 8192;
    end;
elseif nargin ~= 4,
    error('ookmsg: Invalid number of arguments...');
end;

if fs < 2*fc,
    error('ookmsg: Sampling frequency must be at least 2 * fc...');
end;

% figure out if we have a vector
if min(size(msg)) ~= 1,
	error('ookmsg: Input arg "msg" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
msg = msg(:);

% compute number of bauds during duration, round up to nearest integer
bauds = length(msg);

% baseband signal
x = unipolar(Rb,msg,fs);

% modulate signal
y = dsbsc(x,fc,fs);

