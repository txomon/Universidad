%SPCPATH	Script to prepend the SPC Toolbox directories
%	to the MATLABPATH.
%

%	Dennis W. Brown 2-22-94
%	Naval Postgraduate School, Monterey, CA

% check for version 4.1
if ~strcmp(computer,'PCWIN') & str2num(version) < 4.1,
	disp('spctools: Matlab version 4.1 or higher required. Sorry!');
	return;
end;

% get matlab directory (net dependent)
matdir = [getenv('MATLAB') '/toolbox/spctools'];

% create new matlabpath string
newpath = [...
	matdir ':'...
	matdir '/spccomms:'...
	matdir '/spcgui:'...
	matdir '/spcline:'...
	matdir '/spcspch:'...
	matdir '/spcsspi:'...
	matdir '/spcutil:'...
	matdir '/spcprog:'...
 	matlabpath ];

matlabpath(newpath)

more on
echo on

% The SPC Toolbox directories have been prepended to
% your MATLABPATH.  Be aware, name conflicts may occur
% if more than one toolbox has a function with the
% same name as an SPC Toolbox command.
%
% For further help on commands available in the SPC
% Toolbox, type:
%
%	help spctools
%	help spccomms
%	help spcline
%	help spcgui
%	help spcspch
%	help spcsspi
%	help spcprog
%	help spcutil
%
%	For questions, email
%		Dennis Brown at dwbrown@access.digex.net
%	or
%		Monique Fargues at fargues@ece.nps.navy.mil
%
% Type "whatsnew spctools" at the Matlab prompt to
%	find out what's new with SPC Tools.
%
%
% SPC Tools last modified 3/9/95.


echo off
more off

clear newpath matdir

if exist('spcnotes') > 0,
	spcnotes
end;
