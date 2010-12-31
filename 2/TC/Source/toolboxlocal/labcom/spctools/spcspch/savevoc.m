function savevoc(x,name,fs)
%SAVEVOC  Save Creative Voice file.
%       SAVEVOC(X,NAME,FS) saves the data in vector X to a 
%       Soundblaster Creative Voice File (*.voc) named NAME. 
%       Default sampling frequency is FS=8192 Hz. 
%
%       Currently supports only version 1.10, raw, 8-bit, 
%       unpacked voice files.  Save the vector X to a single
%       data block. The filename extension ".voc" is appended 
%       to 'NAME' if no filename extension is supplied. Zero is
%       offset to +128 and any data less than zero or greater
%       than 255 is clipped.
%
%       See also LOADVOC

%       LT Dennis W. Brown 6-8-93, DWB 1-23-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%       Ref: Creative Labs, Inc., The Developer Kit for Sound 
%       Blaster Series, Nov 1991, pp 4-6 to 4-12.

% name must be a string
if ~isstr(name),
	error('savevoc: Filename must be a string argument!');
end;

if nargin < 2
	error('savevoc: Requires first 2 arguments.');
elseif nargin == 2
	fs = 8192;
end

% filename extension
if findstr(name,'.')==[]
	name=[name,'.voc'];
end

% open the file
fid = fopen(name,'wb');
if fid == (-1)
    error(['savevoc: Could not open file ' name '...']);
end

% add Soundblaster creative voice file ID's
fwrite(fid,['Creative Voice File' 26],'uchar');

% offset to data
fwrite(fid,[26 0],'uchar');

% voice file format version number 1.10
fwrite(fid,[10 1],'uchar');

% voice file identification code
fwrite(fid,[41 17],'uchar');

% block type 1 terminator (voice data)
fwrite(fid,1,'uchar');

% data block length (3 bytes long);
s = dec2hex(length(x) + 2);
for k=1:(6-length(s)), s = ['0' s]; end;
fwrite(fid,hex2dec(s(5:6)),'uchar');	% low byte
fwrite(fid,hex2dec(s(3:4)),'uchar');	% middle byte
fwrite(fid,hex2dec(s(1:2)),'uchar');	% high byte

% time constant for sampling rate
fwrite(fid,[256-1000000/fs],'uchar');

% packing method (0 for 8-bit raw samples);
fwrite(fid,0,'uchar');

% offset and clip data if necessary
x = x + 128;
ind = find(x < 0);
if length(ind),
    x(ind) = zeros(length(ind),1);
    disp('savevoc: Data less than -128 was clipped...');
end;
ind = find(x > 255);
if length(ind),
    x(ind) = ones(length(ind),1) * 255;
    disp('savevoc: Data greater than 127 was clipped...');
end;

% finally, the data
fwrite(fid,x,'uchar');

% now terminate the file
fwrite(fid,0,'uchar');

% close files
fclose(fid);

