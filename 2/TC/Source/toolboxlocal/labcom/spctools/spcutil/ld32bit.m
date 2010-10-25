function [y] = ld32bit(name,number,offset)
%LD32BIT  Load signed 32-bit binary data file.
%       [Y] = LD32BIT('NAME') load the entire file 'NAME' as 32-bit
%       signed data samples.
%
%       [Y] = LD32BIT('NAME',NUMBER) loads the first NUMBER 
%       samples starting from the beginning of the file.
%
%       [Y] = LD32BIT('NAME',NUMBER,OFFSET) loads NUMBER samples
%       beginning at OFFSET samples from the beginning of the 
%       file. If NUMBER=0, loads starting from OFFSET to the EOF.
%
%       See also LD8BIT, LD16BIT, SV8BIT, SV16BIT, SV32BIT

%       LT Dennis W. Brown 7-17-93, DWB 1-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default output
y = [];

% name must be a string
if ~isstr(name),
	error('ld32bit: Filename must be a string argument!');
end;

% open the file
fid = fopen(name,'rb');
if fid == (-1)
	error(['ld32bit: Could not open file ' name]);
end

% get file length
fseek(fid,0,'eof');
flength = ftell(fid);
fseek(fid,0,'bof');

if nargin == 1

	% read the entire file
	y = fread(fid,flength/4,'int32');

elseif nargin == 2

    % read some of the samples beginning at the start of file

	% error check
	if number > flength/4,
		fclose(fid);
		error('ld32bit: Requested number of samples greater than filelength!');
	end;

	% read samples
	fseek(fid,0,'bof');
	y = fread(fid,number,'int32');

elseif nargin == 3,

    % read some of the samples beginning somewhere in the file

	% error check (offset sample is included in number)
	if number+offset-1 > flength/4,
		fclose(fid);
		error('ld32bit: Requested number+offset of samples greater than filelength!');
	end;

	if number == 0,

		% read to end-of-file
		fseek(fid,4*(offset-1),'bof');
		y = fread(fid,flength/4-offset+1,'int32');

	else

		% read specified number of samples
		fseek(fid,4*(offset-1),'bof');
		y = fread(fid,number,'int32');
	end;
end;

fclose(fid);

