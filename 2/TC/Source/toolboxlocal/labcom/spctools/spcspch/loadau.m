function [y,fs] = loadau(name)
%loadau	Read Sun audio file (*.au).
%	[Y,FS] = LOADAU('FILENAME') reads the audio file in
%	'FILENAME' returning the audio data in Y and the
%	sampling frequency in FS.  This routine currently
%	supports only 8-bit data.  If the data is mu-law
%	encoded, it is converted to linear values between
%	plus and minus one.  If the filename does not have
%	an extension, a ".au" extension is automatically
%	added.
%
%	See also SAVEAU, LOADVOC, SAVEVOC, LOADWAV, SAVEWAV

%       LT Dennis W. Brown 6-12-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% the following is platform independent (big-little endian wise)
% to convert strictly for big endian (sun), change 4 to 1 and 'uchar'
% to 'uint' in fread statements and git rid of folowing sum statement.

if nargin ~= 1,
	error('loadau: Invalid number of input arguments.');
end;

if ~isstr(name),
	error('loadau: Filename must be a string.');
end;

% take care of extension
ind = find(name == '.');
if isempty(ind),
	name = [name '.au'];
end;

% open the file
fp = fopen(name,'rb');

% check to see if fopen was successful
if fp < 1,
	error(['loadau: Could not open file "' name '".']);
end;

% read the au file header
c = [2^24 2^16 2^8 1]';

% magic number identifies *.au format
magic = fread(fp,4,'uchar');
magic = sum(magic .* c);

% size of header block
hdr_size = fread(fp,4,'uchar');
hdr_size = sum(hdr_size .* c);

% size of data (starts after header block
data_size = fread(fp,4,'uchar');
data_size = sum(data_size .* c);

% encoding scheme
%	1 = 8-bit ISDN mu-law
%	2 = 8-bit linear PCM
%	3 = 16-bit linear PCM
%	4 = 24-bit linear PCM
%	5 = 32-bit linear PCM
%	6 = 32-bit IEEE floating point
%	7 = 64-bit IEEE floating point
encoding = fread(fp,4,'uchar');
encoding = sum(encoding .* c);

% print notice if not mu-law
if encoding > 2,
	disp('loadau: Audio data is 16-bit or higher.');
end;

% sampling frequency
fs = fread(fp,4,'uchar');
fs = sum(fs .* c);

% number of channels
channels = fread(fp,4,'uchar');
channels = sum(channels .* c);

% print notice if more than 1
if channels > 1,
	disp('loadau: Audio data is multi-channel.');
end;

% we've read 24 bytes, now skip to data
junk = fread(fp,hdr_size-24,'uchar');

% now read the data
[y,len] = fread(fp,inf,'uchar');
fclose(fp);

% if mu-law, convert
if encoding == 1,
	y = mu2lin(y);
end;

