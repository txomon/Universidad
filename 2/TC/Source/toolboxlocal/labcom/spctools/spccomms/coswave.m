function [y] = coswave(fb,duration,fs,phaseshift)
%COSWAVE  Generate sampled cosine wave.
%       [Y] = COSWAVE(Fc) generates one second of a Fc-hertz
%       cosine wave sampled at 8192 Hz.
%
%       [Y] = COSWAVE(Fc,DURATION) generates DURATION seconds
%       of a Fc-Hertz cosine wave sampled at 8192 Hz.
%
%       [Y] = COSWAVE(Fc,DURATION,FS) generates DURATION seconds
%       of a Fc-Hertz cosine wave sampled at sampling
%       frequency, FS.
%
%       [Y] = COSWAVE(Fc,DURATION,FS,PHASESHIFT) generates
%       DURATION seconds of a Fc-Hertz cosine wave sampled at
%       sampling frequency, FS, with phaseshift, PHASESHIFT, on
%       the interval [-pi, pi].
%
%       Note: length of return vector is DURATION/FS-1/FS.  Thus
%       COSWAVE(2048,0.5,8192) returns a vector of 4096 samples.
%
%       See also SAWWAVE, SINWAVE, SQWAVE, TRIWAVE

%       LT Dennis W. Brown 9-6-93, DWB 9-20-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default output
y = [];

% some error checking
if nargin < 2,
    fs = 8192;
    duration = 1;
elseif nargin < 3,
    fs = 8192;
elseif nargin < 1 | nargin > 4,
	error('coswave: Invalid number of input arguments...');
end

if nargin < 4,
    phaseshift = 0;
end;

% phase shift must bin in radians
if abs(phaseshift) > pi,
    error('coswave: Phase shift must be in interval [-pi, pi]...');
end;

% time base
t = 0:1/fs:duration-1/fs;

% generate wave
y = cos(2 * pi * fb .* t + phaseshift)';



