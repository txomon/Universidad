function [y] = bpsk(Rb,fc,arg3,arg4)
%BPSK    Binary phase-shift keyed signal.
%       [Y] = BPSK(RB,FC) generates a randomly-keyed, one-
%       second long binary phase-shift keyed signal with a bit
%       rate of RB bits-per-second at a carrier frequency of FC.
%       The default sampling rate is set to 8192 Hz.
%
%       [Y] = BPSK(RB,FC,DURATION) generates a randomly-
%       keyed, binary phase-shift keyed signal of DURATION
%       seconds long.
%
%       [Y] = PBSK(RB,FC,DURATION,FS) sets the sampling frequency
%       to fs.
%
%       See also BPSKMSG, BFSK, BFSKMSG, OOK, OOKMSG

%       LT Dennis W. Brown 8-16-93, DWB 9-20-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% defaults
y = []; fs = 8192; duration = 1;

% check arguments
if nargin < 2,
    error('bpsk: First two arguments required...');
end;

if nargin >= 3,
    if arg3 > 0,
        duration = arg3;
    else,
        error('bpsk: Invalid duration specified...');
    end;
end;

if nargin == 4,
    fs = arg4
end;

if fs < 2*fc,
    error('bpsk: Sampling frequency must be at least 2 * fc...');
end;

% compute number of bauds during duration, round up to nearest integer
bauds = ceil(Rb * duration);

% baseband signal
y = antpodal(Rb,bauds,fs);

% modulate signal
y = dsbsc(y,fc,fs);

