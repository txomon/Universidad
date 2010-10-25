function spcwarn(msg,arg2, arg3, arg4)
%SPCWARN	Warning dialog box.
%	SPCWARN(MSG, ARG2, ARG3, ARG4) calls either the
%	undocumented internal function (in some versions 
%	of Matlab) GS_MODAL_DIALOG.  In the event this 
%	function does not exists, the undocumented m-file
%	warndlg is called.  Should this function not exists
%	in the version of Matlab running, the MSG argument
%	is simplied displayed in the Matlab command window.
%	This file should be modified to best suit the 
%	version of Matlab you are running at your site.

%	Dennis W. Brown 5-1-94, DWB 5-1-94
%	Copyright (c) 1994 by Dennis W. Brown
%	May be freely distributed.
%	Not for use in commercial products.



c = computer;

if strcmp(c,'PCWIN') | strcmp(c,'SUN4'),

	% add your computer here if the command 
	%   >> gs_modal_dialog('Test','OK')
	% works in your version of matlab.

	% The gs_modal_function is available in v4.0 for
	% the PC, version 4.1 on Sun workstations and on
	% some versions of 4.2 on HP workstations.  I 
	% don't know about the rest.

	if nargin == 2,
		gs_modal_dialog(msg,arg2);
	elseif nargin == 3,
		gs_modal_dialog(msg,arg2,arg3);
	elseif nargin == 4,
		gs_modal_dialog(msg,arg2,arg3,arg4);
	end;

elseif exist('warndlg') > 1,

	% preferred if gs_modal_dialog is unavailable

	if nargin == 2,
		warndlg(msg,arg2);
	end;

else,
	% last resort

	disp(msg);

end;
