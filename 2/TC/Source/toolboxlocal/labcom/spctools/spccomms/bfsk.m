function [y] = bfsk(Rb,shift,fc,arg4,arg5)
%BFSK     Binary frequency-shift keyed signal.
%       [Y] = BFSK(RB,SHIFT,FC) generates a randomly-keyed, one-
%       second long binary frequency-shift keyed signal with a
%       bit rate of RB bits-per-second and a frequency sepera-
%       tion of SHIFT Hz centered at a carrier frequency of FC.
%       The default sampling rate is set to 8192 Hz.
%
%       [Y] = BFSK(RB,SHIFT,FC,DURATION) generates a randomly-
%       keyed, binary frequency-shift keyed signal of DURATION
%       seconds long.
%
%       [Y] = BFSK(RB,SHIFT,FC,DURATION,FS) set the sampling
%       frequency to FS.
%
%       See also BPSK, BPSKMSG, BFSKMSG, OOK, OOKMSG

%       LT Dennis W. Brown 8-16-93, DWB 8-17-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%defaults
y = []; fs = 8192; duration = 1;

% check arguments
if nargin < 3,
    error('bfsk: First three arguments required...');
end;

if nargin >= 4,
    if arg4 > 0,
        duration = arg4;
    else,
        error('bfsk: Invalid duration specified...');
    end;
end;

if nargin == 5,
    fs = arg5;
end;

if fs < 2*fc,
    error('bfsk: Sampling frequency must be at least 2 * fc...');
end;

if fc < 2*shift,
    error('bfsk: Carrier frequency must be at leat 2 * shift...');
end;

% compute number of bauds during duration, round up to nearest integer
bauds = ceil(Rb * duration);

% baseband signal
x = unipolar(Rb,bauds,fs);

% generate upper half of signal
y = dsbsc(x,fc+shift/2,fs);

% generate lower half of signal
y2 = dsbsc((x == 0),fc-shift/2,fs);

% combine the two OOK signals to create an FSK signal
y = y + y2;

