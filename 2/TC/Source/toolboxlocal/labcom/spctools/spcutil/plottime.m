function plottime(x,arg2,arg3,arg4)
%PLOTTIME Time-domain plot.
%       PLOTTIME(X) plots the time-domain representation of X 
%       with a time axis scaled for a sampling frequency of 
%       8192 Hz.  Plots up to one second of the signal.
%
%       PLOTTIME(X,FS) sets the sampling frequency to FS Hz. 
%       The variable FS must be greater than or equal to 
%       100 Hz for this use.
%
%       PLOTTIME(X,DURATION) plots up to DURATION seconds of X.
%       The duration must be less than 100 seconds for this 
%       use.
%
%       PLOTTIME(X,FS,DURATION) - Plots up to DURATION seconds 
%       of X.
%
%       PLOTTIME(X,DURATION,OFFSET) and 
%       PLOTTIME(X,FS,DURATION,OFFSET) starts the plot at OFFSET 
%       seconds.
%
%       See also LPERIGRM, WPERIGRM

%       LT Dennis W. Brown 8-16-93, DWB 9-2-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% defaults
fs = 8192; duration = length(x)/fs; offset = 0;

% check args
if nargin >= 2,
    if arg2 >= 100
        fs = arg2;
        if nargin == 3
            duration = arg3;
        else
            duration = 1;
        end;
    else
        duration = arg2;
        if nargin == 3,
            offset = arg3;
        end;
    end;
end;

if nargin == 4,
    fs = arg2;
    duration = arg3;
    offset = arg4;
end;

% figure out if we have a vector
if min(size(x)) ~= 1,
	error('plottime: Input arg "x" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
x = x(:);

% first sample to plot
first = offset * fs + 1;

% anticipate going past the end
if duration > offset/fs + length(x)/fs,
    duration = length(x)/fs - offset/fs;
end;

% last sample to plot
last = first + duration * fs - 1;

% make freq scale
f = (first-1:last-1) / fs;

% do the plot
plot(f,x(first:last,:))
title('Time domain plot')
ylabel('Amplitude')
xlabel('Time (s)')

