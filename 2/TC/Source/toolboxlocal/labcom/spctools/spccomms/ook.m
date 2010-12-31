function [y] = ook(Rb,fc,arg3,arg4)
%OOK     On-off keyed signal.
%       [Y] = OOK(RB,SHIFT,FC) generates a randomly-keyed, one-
%       second long binary on-off keyed signal with a bit rate 
%       of RB bits-per-second and a frequency seperation of 
%       SHIFT Hz centered at a carrier frequency of FC.  The 
%       default sampling rate is set to 8192 Hz.
%
%       [Y] = OOK(RB,SHIFT,FC,DURATION) generates a randomly-
%       keyed, binary on-off keyed signal of DURATION seconds 
%       long.
%
%       [Y] = OOK(RB,SHIFT,FC,DURATION,FS) set the sampling
%       frequency to FS.
%
%       See also BPSK, BPSKMSG, BFSK, BFSKMSG, OOKMSG

%       LT Dennis W. Brown 8-16-93, DWB 8-17-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%defaults
y = []; fs = 8192; duration = 1;

% check arguments
if nargin < 2,
    error('ook: First two arguments required...');
end;

if nargin >= 3,
    if arg3 > 0,
        duration = arg3;
    else,
        error('ook: Invalid duration specified...');
    end;
end;

if nargin == 4,
    fs = arg4;
end;

if fs < 2*fc,
    error('ook: Sampling frequency must be at least 2 * fc...');
end;

% compute number of bauds during duration, round up to nearest integer
bauds = ceil(Rb * duration);

% baseband signal
x = unipolar(Rb,bauds,fs);

% modulate signal
y = dsbsc(x,fc,fs);

