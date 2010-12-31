function [y] = sinwave(fb,duration,fs,phaseshift)
%SINWAVE  Generate sampled sine wave.
%       [Y] = SINWAVE(FB) generates one second of a FB-hertz 
%       sine wave sampled at 8192 Hz.
%
%       [Y] = SINWAVE(FB,DURATION) generates DURATION seconds 
%       of a FB-Hertz sine wave sampled at 8192 Hz.
%
%       [Y] = SINWAVE(FB,DURATION,FS) generates DURATION seconds 
%       of a FB-Hertz sine wave sampled at sampling 
%       frequency, FS.
%
%       [Y] = SINWAVE(FB,DURATION,FS,PHASESHIFT) generates 
%       DURATION seconds of a FB-Hertz sine wave sampled at 
%       sampling frequency, FS, with phaseshift, PHASESHIFT, on
%       the interval [-pi, pi].
%
%       Note: length of return vector is DURATION/FS-1/FS.  Thus
%       SINWAVE(2048,0.5,8192) returns a vector of 4096 samples.
%
%       See also COSWAVE, SAWWAVE, SQWAVE, TRIWAVE

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
	error('sinwave: Invalid number of input arguments...');
end

if nargin < 4,
    phaseshift = 0;
end;

% phase shift must bin in radians
if abs(phaseshift) > pi,
    error('sinwave: Phase shift must be in interval [-pi, pi]...');
end;

% time base
t = 0:1/fs:duration-1/fs;

% generate wave
y = sin(2 * pi * fb .* t + phaseshift)';
