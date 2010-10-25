function [error] = sv16bit(name,x)
%SV16BIT   Save signed 16-bit binary data file.
%	SV16BIT('FILENAME',X) - Saves the data in vector X 
%	to the file 'FILENAME' as 16-bit signed integers.  
%	Data outside the range of 16-bits is clipped and a 
%	warning message is printed. SV16BIT returns
%	error = 1 failure, error = 0 success.
%
%       See also LD8BIT, LD16BIT, LD32BIT, SV8BIT, SV32BIT

%       LT Dennis W. Brown 1-23-94, DWB 6-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% return
error = 1;

% check args
if nargin ~= 2,
    error('sv16bit: Invalid number of input arguments...');
end;
if ~isstr(name),
    error('sv16bit: Filename must be a string variable...');
end;

% clip data if necessary
lim = -(2^15);
ind = find(x < lim);
if length(ind),
    x(ind) = ones(length(ind),1) * lim;
    disp(['sv16bit: Data less than ' int2str(lim) ' was clipped...']);
end;
lim = 2^15 - 1;
ind = find(x > lim);
if length(ind),
    x(ind) = ones(length(ind),1) * lim;
    disp(['sv16bit: Data greater than ' int2str(lim) ' was clipped...']);
end;

% open the file
fid = fopen(name,'wb');
if fid == (-1)
    error(['sv16bit: Could not open file ' name '...']);
end

% write the data
count = fwrite(fid,x,'int16');
fclose(fid);

if count ~= length(x),
    error(['sv16bit: Unable to write all data to ' name '...']);
end;

% return success
error = 0;
