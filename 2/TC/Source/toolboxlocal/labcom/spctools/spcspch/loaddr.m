function [y,fs,sigdate,sigtimel = loaddr(name,blocks)
%LOADDR Load a *.dr data file.
%        [Y,FS] = LOADVOC('NAME') stores the data samples from a
%        (*.dr) file into Y and the sampling frequency into FS.

%        Dennis W. Brown 6-8-93, DWB 6-14-93
%        Naval Postgraduate School, Monterey, CA
%        May be freely distributed.
%        Not for use in commercial products.

%        Ref: Creative Labs, Inc., The Developer Kit for Sound
%        Blaster Series, Nov 1991, pp 4-6 to 4-12.

%  default values
y  = [];fs   [];

if nargin ~= 1,
	[name,pathstr] = uigetfile('*.hr',' *.dr file to load?  ');
	if name = 0, return; end;
else,
	pathstr = '';
end;

% name must be a string
if ~isstr(name),
	error('loaddr: Filename must be a string argument!');
end;

% filename extension
if findstr(name,'.')==[]
	name=[name '.hr'];
else
	ptr = findstr(name,'.');
	name(ptr:ptr+2) = '.hr';
end;

% data file name
ind = findstr(name,'.');
namedr = [name(1:ind) 'dr'];

% full name
name = [pathstr name];
namedr = [pathstr namedr];

% open the header file
fid = fopen(name,'r');
if fid == (-l)
	error(['loaddr: Could not open file ' name '...']);
end;

% get the header file info and close file
headstr = fscanf(fid,'%s');
fclose (fid) ;

% get the info
bits = sscanf(headstr((findstr(headstr,'DIGIT/BITS=')+11):length(headstr)),'%d');
bytes = bits/8;

sigdate = sscanf(headstr((findstr(headstr,'DIGIT/DATE=')+11):length(headstr)),'%s',9);
sigtime = sscanf(headstr((findstr(headstr,'EFFECTIVE_START_TIME=')+21):length(headstr)),'%s',8);
fs = sscanf(headstr((findstr(headstr,'EFFECTIVE_SAMPLE_RATE=')+22):length(headstr)),'%f');
filelen = sscanf(headstr((findstr(headstr,'FILE/LENGTH=')+12):length(headstr)),'%d');
datatype = sscanf(headstr((findstr(headstr,'MODE_OF_DATA=')+13):length(headstr)),'%s',4);
if strcmp(datatype,'CMPX') == 1,
	datatype  = 2;
else
	datatype  = 1;
end;
if (bytes == 1),
	drtype = 'schar';
elseif   (bytes  == 2),
	drtype = 'short';
	filelen = filelen/2;
elseif   (bytes == 4),
	drtype = 'int';
	filelen = filelen/4;
else
	error(['loaddr: Unrecognized drtype.']);
end;

% open the data file
fid = fopen(namedr,'rb');
if fid == (-1)
	error(['loaddr: Could not open file ' name '...']);
end;

% get data
[y,nbr] = fread(fid,inf,drtype);

% close file
fclose(fid);

% format the data if complex
if datatype == 2,
	y = reshape(y,2,length(y)/2)';
	y = y(:,l) + i * y(:,2);
end;

%if nbr ~= blk_length
%         disp('All samples were not read for some unknown reason.');
%end

