function saveau(y,filename,fs)
%SAVUAU Write Sun audio file (*.au).
%	SAVEAU(Y,'filename',FS) converts Y to mu-law encoded
%	bytes and writes it to the specified audio file setting
%	the stored sampling rate to FS.  If FS is not supplied,
%	FS = 8000 Hz is used.  If an extension is left off the
%	filename, the extension ".au" is appended.
%
%	See also LOADAU, LOADVOC, SAVEVOC, LOADWAV, SAVEWAV

%       LT Dennis W. Brown 6-12-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.


% the following platform independent (big-little endian wise)
% to convert for big-endian (Sun) use only, get rid of vector
% variables and use 'uint' versions of fwrite.
	
if nargin == 2,
	fs = 8000;
elseif nargin ~= 3,
	error('saveau: Invalid number of input arguments.');
end;

% take care of extension
ind = find(filename == '.');
if isempty(ind),
	filename = [filename '.au'];
end;

% open output file
fp = fopen(filename,'wb');
if fp == -1
	error(['saveau: Cannot open ' filename ' for writing.']);
end;

% take out mean
y = y - mean(y);

% scale data to take up 95% of the dynamic range
y = 0.95 * (y / max(abs(y)));

% convert data to mu-law encoding
y = lin2mu(y);

% header parameters

% magic number to id *.au file
magic = 779316836;
magic = [46 115 110 100];
fwrite(fp,magic,'uchar');
%	fwrite(fp,magic,'uint');

% header size
hdr_size = 32;
hdr_size = [0 0 0 32];
fwrite(fp,hdr_size,'uchar');
%	fwrite(fp,hdr_size,'uint');

% data length
data_size = length(y);
s = sprintf('%08x',data_size);
fwrite(fp,hex2dec(s(1:2)),'uchar');	% high byte
fwrite(fp,hex2dec(s(3:4)),'uchar');	% middle high byte
fwrite(fp,hex2dec(s(5:6)),'uchar');	% middle low byte
fwrite(fp,hex2dec(s(7:8)),'uchar');	% low byte
%	fwrite(fp,data_size,'uint');

% encoding
%	1 = 8-bit ISDN mu-law
%	2 = 8-bit linear PCM
%	3 = 16-bit linear PCM
%	4 = 24-bit linear PCM
%	5 = 32-bit linear PCM
%	6 = 32-bit IEEE floating point
%	7 = 64-bit IEEE floating point
encoding = 1;
encoding = [0 0 0 1];
fwrite(fp,encoding,'uchar');
%	fwrite(fp,encoding,'uint');

% sample rate
s = sprintf('%08x',fs);
fwrite(fp,hex2dec(s(1:2)),'uchar');	% high byte
fwrite(fp,hex2dec(s(3:4)),'uchar');	% middle high byte
fwrite(fp,hex2dec(s(5:6)),'uchar');	% middle low byte
fwrite(fp,hex2dec(s(7:8)),'uchar');	% low byte
%	fwrite(fp,fs,'uint');

% channels
channels = 1;
channels = [0 0 0 1];
fwrite(fp,channels,'uchar');
%	fwrite(fp,channels,'uint');

% pad header out to 32 bytes
fwrite(fp,[0 0 0 0 0 0 0 0],'uchar');

% and now the data
fwrite(fp,y,'uchar');

% guess we're done now
fclose(fp);
