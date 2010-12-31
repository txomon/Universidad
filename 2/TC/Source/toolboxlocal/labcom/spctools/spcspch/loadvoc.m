function [y,fs] = loadvoc(name,blocks)
%LOADVOC  Load Creative Voice file.
%       [Y,FS] = LOADVOC('NAME') stores the data samples from a
%       Soundblaster Creative Voice File (*.voc) into Y and the
%       sampling frequency into FS.
%
%       Currently supports only version 1.10, raw, 8-bit,
%       unpacked voice files.  Only the first data block is
%       loaded from files with multiple data blocks. The
%       filename extension ".voc" is appended to 'NAME' if no
%       filename extension is supplied. The mean is removed so
%       that the signal contains no DC offset.
%
%       See also SAVEVOC

%       Dennis W. Brown 6-8-93, DWB 6-14-93
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

%       Ref: Creative Labs, Inc., The Developer Kit for Sound
%       Blaster Series, Nov 1991, pp 4-6 to 4-12.

% default values
y = [];fs = [];

if nargin ~= 1,
    [name,pathstr] = uigetfile('*.voc',' Voice file to load? ');
    if name == 0, return; end;
else,
    pathstr = '';
end;

% name must be a string
if ~isstr(name),
	error('loadvoc: Filename must be a string argument!');
end;

% filename extension
if findstr(name,'.')==[]
	name=[name '.voc'];
end

% full name
name = [pathstr name];

% open the file
fid = fopen(name,'rb');
if fid == (-1)
    error(['loadvoc: Could not open file ' name '...']);
end

% format coverters
cint = [1 2^8]';

% confirm file is a Soundblaster file
descript = setstr(fread(fid,20,'char')');	    % note transpose on fread

% read data and convert integers to proper format
offset = fread(fid,2,'uchar');
offset = sum(offset .* cint);
flag = fread(fid,2,'uchar');
flag = sum(flag .* cint);
voice_id = fread(fid,2,'uchar');
voice_id = sum(voice_id .* cint);

% is it the right file
if strcmp(descript(1:19),'Creative Voice File') == 0
	fclose(fid);
	error('loadvoc: File is not a Creative Voice File');
end

% Another check for a voc file
if (4659-flag) ~= voice_id
	fclose(fid);
	error('loadvoc: File descriptor error.  File is corrupt.');
end

% we want voice blocks only
blk_type = fread(fid,1,'uchar');
if blk_type ~= 1
	fclose(fid);
	error('loadvoc: Voice block ID error.');
end

% get block length
blk_length = fread(fid,3,'uchar');
blk_length = sum(blk_length .* [cint ; 2^16]) - 2;

% get sampling frequency
fs = 1000000/(256 - fread(fid,1,'uchar'));

% should be packed data
packed = fread(fid,1,'uchar');
if packed ~= 0
	fclose(fid);
	error('loadvoc: Data is not 8-bit, raw samples.');
end

% get data
[y,nbr] = fread(fid,blk_length,'uchar');

% close file
fclose(fid);

% adjust to zero (remove the "dc")
y = y - 128;

if nbr ~= blk_length
	disp('All samples were not read for some unknown reason.');
end

