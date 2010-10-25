%SPC2FLOP Copy SPC Toolbox to a MS-DOS formatted diskette.
%	SPC2FLOP Executes a C-shell script to copy the SPC 
%	Toolbox to a floppy disk for loading onto an MS-DOS
%	machine.  Type "whatsnew spctools" for the latest
%	information.

%	Dennis W. Brown 4-20-94
%	Naval Postgraduate School, Monterey, CA


clc
echo on

% The SPC Toolbox will be copied to a MS-DOS formatted
% disk in drive "a:".  Ignore the "No match" messages.
% Any error messages means something is wrong (i.e. did
% you put the disk all the way in, is it a 1.4M disk, etc).
%

pause % press a key to continue (control-C to abort)
echo off
clc

% bang out and run the C-Shell script.
!/tools4/matlab/toolbox/spctools/spc2flop
