function [y] = sawwave(fb,duration,fs,polarity)
%SAWWAVE  Generate sampled sawtooth wave.
%       [Y] = SAWWAVE(FB,'antipodal') or [Y] = SAWWAVE(Fb) 
%       generates one second of a baseband, sawtooth wave at 
%       cycle frequency, FB, and sampling frequency 8192 Hz.
%
%       [Y] = SAWWAVE(FB,DURATION,'antipodal') and
%       [Y] = SAWWAVE(FB,DURATION) generates DURATION seconds of 
%       a baseband, sawtooth wave at cycle frequency, FB, and a 
%       sampling frequency of 8192 Hz.
%
%       [Y] = SAWWAVE(FB,DURATION,FS,'antipodal') and
%       [Y] = SAWWAVE(FB,DURATION,FS) generates DURATION seconds 
%       of a baseband, sawtooth wave at cycle frequency, FB,
%       and a sampling frequency of FS Hertz.
%
%       'antipodal' varies the amplitude on the interval [-1,1]
%       vice [0,1].
%
%       See also COSWAVE, SINWAVE, SQWAVE, TRIWAVE

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
	error('sawwave: Invalid number of input arguments...');
end

% compute the cycle period
Tb = floor(fs/fb);          % this equals the number of samples per baud

% create the ramp up to form the wave.
onecycle = (0:Tb-1) / (Tb-1);

% compute number of cycles
nbrcycles = floor(duration * fb);

% space for output
y = zeros(nbrcycles*Tb,1);

% generate the output
for i = 0:nbrcycles-1,

    % assemble the cycles
    y(i*Tb+1:(i+1)*Tb) = onecycle;

end;

if strcmp(polarity,'antipodal'),

    y = 2 * y - 1;

end;

