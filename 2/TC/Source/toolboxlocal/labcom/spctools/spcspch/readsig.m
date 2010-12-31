function [y,fs] = readsig(filename,bits)
%READSIG  Read signal file.
%	[Y,FS] = READSIG('FILENAME') reads the signal
%	stored in the file 'FILENAME'.  The filename
%	extension determines the read routine used.
%	Supported extensions are:
%
%	[Y,FS] = READSIG('FILENAME',BITS) number of bits
%	to read if the signal is stored in a flat integer
%	file format.  Giving a BITS argument will overide
%	the default read routine defined for the file
%	extension.  Support integer bit sizes are 8, 16, 32.
%
%		Extension	Read routine
%		---------	------------
%		*.au		auread
%		*.voc		loadvoc
%		*.wav		wavread
%		*.tim		loadsspi
%		*.*		ld8bit, ld16bit, ld32bit
%
%	If the file storage format does not include a
%	sampling frequency, a value FS = 1 is returned.

%	Dennis W. Brown 6-7-94, DWB 6-12-94
%	Copyright (c) 1994 by Dennis W. Brown
%	May be freely distributed.
%	Not for use in commercial products.


if nargin < 1 | nargin > 2,
	error('readsig: Invalid number of input arguments.');
end;

% default sampling frequency
fs = 1;

% trim off extension
ext = filename(find(filename == '.'):length(filename));

if nargin == 2,

	if bits == 8,

		y = ld8bit(filename);

	elseif bits == 16,

		y = ld16bit(filename);

	elseif bits == 32,

		y = ld32bit(filename);

	else,

		error(['readsig: Integer lengths of ' num2str(bits) ...
				 '-bits not supported.']);
	end;
else,
	% read based on filetype
	if strcmp(lower(ext),'.au'),

		% requires SPC Toolbox auread routine
		[y,fs] = loadau(filename);

	elseif strcmp(lower(ext),'.voc'),

		[y,fs] = loadvoc(filename);

	elseif strcmp(lower(ext),'.wav'),

		[y,fs] = loadwav(filename);

		if min(size(y)) ~= 1,
		  spcwarn('readsig: Multichannel data. Channel 1 loaded.','OK');
		  y = y(:,1);
		end;

	elseif strcmp(lower(ext),'.tim'),

		y = loadsspi(filename);

	else,
		error(['readsig: Filetype ' ext ' not supported!']);

	end;

end;


