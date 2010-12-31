function [y] = ld8bit(name,number,offset)
%LD8BIT   Load signed 8-bit binary data file.
%       [Y] = LD8BIT('NAME') load the entire file 'NAME' as 8-bit
%       signed data samples.
%
%       [Y] = LD8BIT('NAME',NUMBER) loads the first NUMBER
%       samples starting from the beginning of the file.
%
%       [Y] = LD8BIT('NAME',NUMBER,OFFSET) loads NUMBER samples
%       beginning at OFFSET samples from the beginning of the
%       file. If NUMBER=0, loads starting from OFFSET to the EOF.
%
%       See also LD16BIT, LD32BIT, SV8BIT, SV16BIT, SV32BIT

%       LT Dennis W. Brown 7-17-93, DWB 1-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default output
y = [];

% name must be a string
if ~isstr(name),
	error('ld8bit: Filename must be a string argument!');
end;

% open the file
fid = fopen(name,'rb');
if fid == (-1)
	error(['ld8bit: Could not open file ' name]);
end

% get file length
fseek(fid,0,'eof');
flength = ftell(fid);
fseek(fid,0,'bof');

if nargin == 1

	% read the entire file
	y = fread(fid,flength,'int8');

elseif nargin == 2

    % read some of the samples beginning at the start of file

	% error check
	if number > flength,
		fclose(fid);
		error('ld8bit: Requested number of samples greater than filelength!');
	end;

	% read samples
	fseek(fid,0,'bof');
	y = fread(fid,number,'int8');

elseif nargin == 3,

    % read some of the samples beginning somewhere in the file

	% error check (offset sample is included in number)
	if number+offset-1 > flength,
		fclose(fid);
		error('ld8bit: Requested number+offset of samples greater than filelength!');
	end;

	if number == 0,

		% read to end-of-file
		fseek(fid,offset-1,'bof');
		y = fread(fid,flength-offset+1,'int8');

	else

		% read specified number of samples
		fseek(fid,offset-1,'bof');
		y = fread(fid,number,'int8');
	end;
end;

fclose(fid);

