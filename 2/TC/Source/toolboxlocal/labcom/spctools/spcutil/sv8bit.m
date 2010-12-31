function [error] = sv8bit(name,x)
%SV8BIT   Save signed 8-bit binary data file.
%	SV8BIT('FILENAME',X) - Saves the data in vector X 
%	to the file 'FILENAME' as 8-bit signed integers.  
%	Data outside the range of 8-bits is clipped and a 
%	warning message is printed. SV8BIT returns
%	error = 1 failure, error = 0 success.
%
%       See also LD8BIT, LD16BIT, LD32BIT, SV16BIT, SV32BIT

%       LT Dennis W. Brown 1-23-94, DWB 6-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% return
error = 1;

% check args 
if nargin ~= 2,
    error('sv8bit: Invalid number of input arguments...');
end;
if ~isstr(name),
    error('sv8bit: Filename must be a string variable...');
end;

% clip data if necessary
lim = -(2^7);
ind = find(x < lim);
if length(ind),
    x(ind) = ones(length(ind),1) * lim;
    disp(['sv8bit: Data less than ' int2str(lim) ' was clipped...']);
end;
lim = 2^7 - 1;
ind = find(x > lim);
if length(ind),
    x(ind) = ones(length(ind),1) * lim;
    disp(['sv8bit: Data greater than ' int2str(lim) ' was clipped...']);
end;

% open the file
fid = fopen(name,'wb');
if fid == (-1)
    error(['sv8bit: Could not open file ' name '...']);
end

% write the data
count = fwrite(fid,x,'int8');
fclose(fid);

if count ~= length(x),
    error(['sv8bit: Unable to write all data to ' name '...']);
end;

% return success
error = 0;
