%SPCDATA	Script to load SPC Toolbox test data.

%	Dennis W. Brown 2-22-94
%	Naval Postgraduate School, Monterey, CA

% check for version 4.1
if ~strcmp(computer,'PCWIN') & str2num(version) < 4.1,
	disp('spctools: Matlab version 4.1 or higher required. Sorry!');
	return;
end;

% get matlab directory (net dependent)
matdir = [getenv('MATLAB') '/toolbox/spctools'];


% speech file
seatsit = loadvoc([matdir '/seatsit.voc']);
eval(['load ' matdir '/t0x']);
eval(['load ' matdir '/uuu']);
eval(['load ' matdir '/datax']);

clear matdir

who
