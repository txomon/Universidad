function [y] = triwave(fb,duration,fs,polarity)
%TRIWAVE  Generate sampled triangular wave.
%       [Y] = TRIWAVE(FB,'antipodal') or [Y] = TRIWAVE(Fb) 
%       generates one second of a baseband, triangular wave at 
%       cycle frequency, FB, and sampling frequency 8192 Hz.
%
%       [Y] = TRIWAVE(FB,DURATION,'antipodal') and
%       [Y] = TRIWAVE(FB,DURATION) generates DURATION seconds of 
%       a baseband, triangular wave at cycle frequency, FB, and a 
%       sampling frequency of 8192 Hz.
%
%       [Y] = TRIWAVE(FB,DURATION,FS,'antipodal') and
%       [Y] = TRIWAVE(FB,DURATION,FS) generates DURATION seconds 
%       of a baseband, triangular wave at cycle frequency, FB,
%       and a sampling frequency of FS Hertz.
%
%       'antipodal' varies the amplitude on the interval [-1,1]
%       vice [0,1].
%
%       See also COSWAVE, SAWWAVE, SINWAVE, SQWAVE

%       LT Dennis W. Brown 8-23-93, DWB 9-20-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default output
y = [];

% some error checking
if nargin < 2,
    duration = 1;
    fs = 8192;
    polarity = 'unipolar';
elseif nargin < 3,
    if isstr(duration),
        polarity = 'antipodal';
        duration = 1;
    else
        polarity = 'unipolar';
    end;
    fs = 8192;
elseif nargin < 4,
    if isstr(fs),
        polarity = 'antipodal';
        fs = 8192;
    else
        polarity = 'unipolar';
    end;
elseif nargin < 1 | nargin > 4,
	error('triwave: Invalid number of input arguments...');
end

% compute the cycle period
Tb = floor(fs/fb);          % this equals the number of samples per baud

% create the ramp up and down to form the wave.  must treat odd and
% even number of samples differently to make a mathematically perfect
% model of a triangular wave.

onecycle = zeros(Tb,1);
if rem(Tb,2) == 0,

    % even number of samples
    onecycle(1:Tb/2+1) = (0:Tb/2) * 2 / Tb;

    % second half
    onecycle(Tb/2+2:Tb) = flipud(onecycle(2:Tb/2));

else,

    % odd number of samples
    onecycle(1:ceil(Tb/2)) = (0:Tb/2) * 2 / (Tb+0.5);

    % second half
    onecycle(ceil(Tb/2)+1:Tb) = flipud(onecycle(2:ceil(Tb/2)));

end;

% compute number of cycles
nbrcycles = floor(duration * fb);

% space for output
y = zeros(nbrcycles*Tb,1);

% generate the output
for i = 0:nbrcycles-1,
    % assemble the cycles
    y(i*Tb+1:(i+1)*Tb,1) = onecycle;

end;

if strcmp(polarity,'antipodal'),

    y = 2 * y - 1;

end;