function [y] = sqwave(fb,duration,fs,polarity)
%SQWAVE   Generate sampled square wave.
%       [Y] = SQWAVE(FB,'antipodal') or [Y] = SQWAVE(Fb) 
%       generates one second of a baseband, square wave at cycle
%       frequency, FB, and sampling frequency 8192 Hz.
%
%       [Y] = SQWAVE(FB,DURATION,'antipodal') and
%       [Y] = SQWAVE(FB,DURATION) generates DURATION seconds of 
%       a baseband, square wave at cycle frequency, FB, and a 
%       sampling frequency of 8192 Hz.
%
%       [Y] = SQWAVE(FB,DURATION,FS,'antipodal') and
%       [Y] = SQWAVE(FB,DURATION,FS) generates DURATION seconds 
%       of a baseband, square wave at cycle frequency, FB, and a
%       sampling frequency of FS Hertz.
%
%       'antipodal' varies the amplitude on the interval [-1,1]
%       vice [0,1].
%
%       See also COSWAVE, SAWWAVE, SINWAVE, TRIWAVE

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
    else        polarity = 'unipolar';
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
	error('sqwave: Invalid number of input arguments...');
end
% so we can speak in half cycles
if fb ~= 1,
    fb = fb*2;
end;

% compute the baud period
Tb = floor(fs/fb);          % this equals the number of samples per half cycle

% compute number of cycles
nbrbauds = floor(duration * fb);

% space for output
y = zeros(nbrbauds*Tb,1);

% generate the output
for i = 0:2:nbrbauds-1,

    % just have to make the ones for the odd i
    y(i*Tb+1:(i+1)*Tb) = ones(Tb,1);

end;

if strcmp(polarity,'antipodal'),

    % antipodal case requires extra work
    for i = 1:2:nbrbauds-1,

        % make the zeros into -1's
        y(i*Tb+1:(i+1)*Tb) = -1 * ones(Tb,1);

    end;

end;


