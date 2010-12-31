function [y,fs,bits,fmt]=loadwav(name)
%LOADWAV  Read RIFF *.wav audio file.
%	[Y,FS,MODE,FORMAT] = LOADWAV('FILENAME') reads
%	the file FILENAME as a MS-Windows RIFF formatted
%	*.wav audio file.  If a filename extension is not
%	included, a '.wav' extension is added.  Function
%	read 8- and 16-bit PCM encoded wave files and
%	returns the sampled data in Y, sampling frequency
%	in FS and number of sampling bits in MODE.  The
%	return argument FORMAT is a 5x1 vector specifying
%
%	FORMAT(1)	format category (should be 1=PCM)
%	FORMAT(2)	number of channels
%	FORMAT(3)	sampling rate (same as fs)
%	FORMAT(4)	average bytes per second (for buffering)
%	FORMAT(5)	block alignment of data
%
%	Multi-channel data is returned such that each column
%	is a single channel.
%
%	Note: 8-bit data is stored as unsigned bytes in the
%	range fo 0 to 255.  LOADWAV automatically subtracts
%	128 from the data so that it is centered about zero
%	in the range -128 to +127.
%
%	See also SAVEWAV, LOADVOC, SAVEVOC, LOADAU, SAVEAU

%       Dennis W. Brown 6-14-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%	This code developed from code provided by
%	Copyright (c) 1994 by Charles W. Therrien

% arg check
if nargin ~= 1,
	error('loadwav: Invalid number of input arguments.')
end

% adjust filename if necessary
if all(name ~= '.'),
	name = [name '.wav'];
end

% open file
[fid,message]=fopen(name,'rb','l');
if fid < 0
	error(message)
end

% check for RIFF file
if any(fread(fid,4,'uchar')~= ['RIFF']')
	fclose(fid);
	error(['loadwav: ' name ' is not in RIFF format.'])
end

% spacer
fread(fid,1,'ulong');

% check for 'WAVE' file
if any(fread(fid,4,'uchar') ~= ['WAVE']')
	fclose(fid);
	error(['loadwav: ' name ' is not a WAVE sound file.'])
end

% read format chunk
while any(fread(fid,4,'uchar') ~= ['fmt ']')

	% loop to ignore any unknown chunk
	[message,errno]=ferror(fid);		% check for EOF
	if errno ~= 0
		fclose(fid);
		error(['loadwav: Format chunk not found.' message])
	end
	nsize=fread(fid,1,'ulong');
	fread(fid,nsize,'uchar');
end

% spacer
fread(fid,1,'ulong');

% get format data
fmt(1)=fread(fid,1,'ushort');     % format category (should be 1 for PCM)
fmt(2)=fread(fid,1,'ushort');     % no. of channels
fmt(3)=fread(fid,1,'ulong');      % sampling rate (Hz)
fmt(4)=fread(fid,1,'ulong');      % average bytes per second
fmt(5)=fread(fid,1,'ushort');     % block alignment

% check data format
if fmt(1) ~= 1
	fclose(fid);
	error('loadwav: Non PCM encoded data not supported.')
end

% pick out sampling frequency for return
fs=fmt(3);

% check bits per sample
bits=fread(fid,1,'ushort');       % bits per sample
if bits == 8
	byps=1;
elseif bits == 16
	byps=2;
else
	fclose(fid);
	error('loadwav: Only 8- and 16-bit data supported');
end

% pick out number of channels
nc=fmt(2);

% read data chunk
while any(fread(fid,4,'uchar') ~= ['data']'),

	% loop and ignore any unknown chunk
	[message,errno]=ferror(fid);		% check for EOF
	if errno ~= 0
		fclose(fid);
		error(['loadwav: Data chunk not found. ' message])
	end
	nsize=fread(fid,1,'ulong');
	fread(fid,nsize,'uchar');
end

% length of data in bytes
nbytes=fread(fid,1,'ulong');
if byps == 1
	y=fread(fid,nbytes,'uchar');	% read 8-bit data
else
	y=fread(fid,nbytes/2,'short');	% read 16-bit data
end

% done with file
fclose(fid);

% if multichannel, reshape so each column is a channel.  the data
%   is interleaved so this works.
if nc > 1,
	y = reshape(y,nc,nbytes/byps/nc)';
end;

% shift to zero (get rid of "dc")
if bits == 8,
	y = y - 128;
end;


