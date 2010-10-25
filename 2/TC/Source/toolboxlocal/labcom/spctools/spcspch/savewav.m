function y = savewav(signal,filename,fs,bits)
%SAVEWAV  Write RIFF *.wav audio file.
%	SAVEWAV(X,'FILENAME',FS) writes the data in X to
%	a WAVE (*.wav) formatted audio file.  Data should 
%	be normalized for 8-bit (values 0 to 255) or
%	16-bit storage (values -32768 to +32767).  If 8-bit
%	data is given in the range -128 to 127, an offset
%	of 128 will be applied before storing data.  If X
%	is a matrix, the data will be store as multi-channel
%	with data along the longest dimension considered a 
%	single channel.  If the sampling frequency is not
%	specified, it defaults to FS = 11.025 kHz.
%
%	SAVEWAV(X,'FILENAME',FS,BITS) forces the number of
%	bits-per-sample to BITS.  Valid values for BITS are
%	8 or 16.  The default bits-per-sample is dependent
%	upon the data.  If the data is in the range 0 to 255
%	or -128 to 127, the default is 8-bits.  Data outside
%	these ranges is considered 16-bit.  An error message
%	is produced if the data is outside the range requested.
%	The sampling frequency must be specified.
%
%	SAVEWAV returns the number of bits-per-sample the 
%	data was stored in.
%
%	See also LOADWAV, LOADVOC, SAVEVOC, LOADAU, SAVEAU

%       Dennis W. Brown 6-14-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%	This code developed from code provided by
%	Copyright (c) 1994 by Charles W. Therrien

% arg check
if nargin == 2,
	fs = 11025;
end;

if nargin == 2 | nargin == 3,

	% compute range of data to decide number of bits
	low=min(min(signal));
	high=max(max(signal));

	if (low >= 0) & (high <= 255),
		bits = 8;
	elseif (low >= -128) & (high <= 127),
		bits = 8;
		signal = signal + 128;
	elseif (low >= -32768) & (high <= 32767),

		bits = 16;

		% offer warning if data is slightly out of 8-bit range
		if (low >= -100 & high <= 355) | (low >= -228 & high <= 227),
			disp('savewav: Writing data as 16-bit.');
		end;
	else,
		error('savewav: Data out of 16-bit range.  Adust and retry.');
	end;

elseif nargin == 4,

	% for check
	low=min(min(signal));
	high=max(max(signal));

	% range too
	if bits == 8,
		if (low >= 0) & (high <= 255),
			bits = 8;
		elseif (low >= -128) & (high <= 127),
			bits = 8;
			signal = signal + 128;
		else,
			error('savewav: Data out of 8-bit range.');
		end;
	elseif bits == 16,
		if (low < -32768 | high > 32767),
			error('savewav: Data out of 8-bit range.');
		end;
	else,
		error('savewav: Invalid number of bits/sample.');
	end;

else,
	error('savewav: Invalid number of input arguments.')
end;

% adjust filename if no extension
if all(filename ~= '.')
	filename=[filename,'.wav'];
end;

% get number of channels and samples-per-channel
nchan = min(size(signal));
Ns = max(size(signal));

% make data row-wise to support interleaving of multi-channels
[m,n] = size(signal);
if n < m,
	signal = signal';
end;

% some more variables
byteps = bits/8;
totbytes = Ns * nchan * byteps;

% time to open the file
[fid,message]=fopen(filename,'wb','l');
if fid<0
	error(message)
end

% RIFF flag
fwrite(fid,'RIFF','uchar');

% filelength
fwrite(fid,36+totbytes,'ulong');

% identify as WAVE file
fwrite(fid,'WAVE','uchar');

% write format chunk
fwrite(fid,'fmt ','uchar');

fwrite(fid,16,'ulong');

% format category 1=PCM
fwrite(fid,1,'ushort');

% no. of channels
fwrite(fid,nchan,'ushort');

% sampling rate (Hz)
fwrite(fid,fs,'ulong');

% average bytes per second
fwrite(fid,fs*byteps*nchan,'ulong');

% block alignment
fwrite(fid,byteps*nchan,'ushort');

% bits per sample (specific to PCM)
fwrite(fid,bits,'ushort');

% write data chunk
fwrite(fid,'data','uchar');

% total number of bytes in signal
fwrite(fid,totbytes,'ulong');

% write the data
if bits == 8

	% write 8-bit data
	fwrite(fid,signal,'uchar');

	if rem(totbytes,2) ~= 0

		% write even number of bytes
		fwrite(fid,0,'uchar');
	end
else,
	% write 16-bit data
	fwrite(fid,signal,'short');
end

% done with file
fclose(fid);

% output requested?
if nargout == 1,
	y = bits;
elseif nargout > 1,
	error('savewav: Invalid number of output arguments.');
end;
