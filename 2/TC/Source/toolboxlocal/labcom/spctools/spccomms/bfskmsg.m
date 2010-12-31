function [y] = bfskmsg(Rb,shift,fc,fs,msg)
%BFSKMSG  Binary phase-shift signal with message.
%       [Y] = BFSKMSG(RB,SHIFT,FC,MSG) generates a passband
%       binary frequency-shift keyed signal with a bit rate of
%       RB bits-per-second and a frequency seperation
%       of SHIFT Hertz centered at a carrier frequency, FC,
%       containing the binary message, MSG.  MSG must be a
%       vector of 1's and 0's.  The default sampling frequency
%       is set to 8192 Hz.
%
%       [Y] = BFSKMSG(RB,SHIFT,FC,FS,MSG) sets the sampling
%       frequency to FS.
%
%       See also BPSK, BPSKMSG, BFSK, OOK, OOKMSG

%       LT Dennis W. Brown 8-23-93, DWB 9-20-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%defaults
y = [];

% check arguments
if nargin == 4,
    if max(size(fs)) == 1,
        error('bfskmsg: Invalid sampling frequency...');
    else
        msg = fs;
        fs = 8192;
    end;
elseif nargin ~= 5,
    error('bfskmsg: Invalid number of arguments...');
end;

if fs < 2*fc,
    error('bfskmsg: Sampling frequency must be at least 2 * fc...');
end;

if fc < 2*shift,
    error('bfskmsg: Carrier frequency must be at leat 2 * shift...');
end;

% figure out if we have a vector
if min(size(msg)) ~= 1,
	error('bfskmsg: Input arg "msg" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
msg = msg(:);

% compute number of bauds during duration, round up to nearest integer
bauds = length(msg);

% baseband signal
x = unipolar(Rb,msg,fs);

% generate upper half of signal
y = dsbsc(x,fc+shift/2,fs);

% generate lower half of signal
y2 = dsbsc((x == 0),fc-shift/2,fs);

% combine the two OOK signals to create an FSK signal
y = y + y2;

