function [y] = ld16bit(name,number,offset)
%LD16BIT  Load signed 16-bit binary data file.
%       [Y] = LD16BIT('NAME') load the entire file 'NAME' as 16-bit
%       signed data samples.
%
%       [Y] = LD16BIT('NAME',NUMBER) loads the first NUMBER
%       samples starting from the beginning of the file.
%
%       [Y] = LD16BIT('NAME',NUMBER,OFFSET) loads NUMBER samples
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
	error('ld16bit: Filename must be a string argument!');
end;

% open the file
fid = fopen(name,'rb');
if fid == (-1)
	error(['ld16bit: Could not open file ' name]);
end

% get file length
fseek(fid,0,'eof');
flength = ftell(fid);
fseek(fid,0,'bof');

if nargin == 1

	% read the entire file
	y = fread(fid,flength/2,'int16');

elseif nargin == 2

    % read some of the samples beginning at the start of file

	% error check
	if number > flength/2,
		fclose(fid);
		error('ld16bit: Requested number of samples greater than filelength!');
	end;

	% read samples
	fseek(fid,0,'bof');
	y = fread(fid,number,'int16');

elseif nargin == 3,

    % read some of the samples beginning somewhere in the file

	% error check (offset sample is included in number)
	if number+offset-1 > flength/2,
		fclose(fid);
		error('ld16bit: Requested number+offset of samples greater than filelength!');
	end;

	if number == 0,

		% read to end-of-file
		fseek(fid,2*(offset-1),'bof');
		y = fread(fid,flength/2-offset+1,'int16');

	else

		% read specified number of samples
		fseek(fid,2*(offset-1),'bof');
		y = fread(fid,number,'int16');
	end;
end;

fclose(fid);

