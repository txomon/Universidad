function fedit(cmdname)
%FEDIT	Edit function M-file or MEX source.
%	FEDIT FUNCTION opens a text editor and loads the source 
%	for the m-file FUNCTION. If FUNCTION is a MEX file, the C or 
%	FORTRAN source file is opened if it resides in the same 
%	directory as the MEX file. If FUNCTION is a built-in function 
%	or a variable or is not found, an appropriate error message is 
%	produced.
%	
%	Examples:
%	
%	Edit the FEDIT function to customize the editor used under 
%	MS-Windows MATLAB to be the MS-Windows Notepad editor.
%	
%	fedit fedit
%	
%	Note: This example will not work if your current platform 
%	is MS-Windows and you are not using Norton Desktop (or the 
%	directory ndw is not in your path). To make the changes 
%	describe below, you will have to manually load the file 
%	..\SPCTOOLS\SPCPROG\FEDIT.M into your favorite editor.
%	
%	Find the following section of code
%	
%	% form the command
%	if strcmp(computer,'SUN4'),
%		cmd = ['!textedit -Wt cour.r.14 ' f ' &'];
%	elseif strcmp(computer,'PCWIN'),
%		cmd = ['!deskedit ' f ' &'];
%	else
%		error('fedit: An editor for this computer has not been defined. See FEDIT.')
%	end;
%	
%	and change "deskedit" to "notepad" in the line below the 
%	line containing 'PCWIN'.
%	
%	To add support for another platform, add the following 
%	lines above the "else" line
%	
%	elseif strcmp(computer,'string'),
%		cmd = ['!editor ' f ' &'];
%	
%	where 'string' is that returned by the computer command 
%	and "editor" is the program name of the editor of your 
%	choice.

%       Dennis W. Brown 5-17-94, DWB 5-3-95
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% find pathname to function
f = which(cmdname);

% check to see if it's built in or whatever
if f == 5,

	% seems WHICH returns codes 5 == built-in
	disp(['fedit: ' cmdname ' built-in function.']);

elseif f == 0,

	% seems WHICH returns codes 0 == not found or variable.
	disp(['fedit: ' cmdname ' is a variable or was not found.']);

else,

	% check for mex-file
	if strcmp(computer,'SUN4'),
		ext = '.mex4';
	else,
		ext = '.mex';
	end;
	c1 = length(f)-length(ext)+1;
	c2 = length(f);
	if strcmp(f(c1:c2),ext),

		msg = ['fedit: ' cmdname ' is a mex-file'];

		if exist([f(1:c1) 'c']) == 2,

			% try looking for C code first

			% assume it's in the same directory
			f = [f(1:c1) 'c'];
			msg = [msg ', opening C source.'];

		elseif exist([f(1:c1) 'for']) == 2,

			% try looking for FORTRAN code second

			% assume it's in the same directory
			f = [f(1:c1) 'for'];
			msg = [msg ', opening FORTRAN source.'];

		else
			f = [];
			msg = [msg ', aborted.'];
		end;

		disp(msg);

	end;

	if ~isempty(f),

		% form the command
		if strcmp(computer,'SUN4'),
			cmd = ['!textedit -Wt cour.r.14 ' f ' &'];
		elseif strcmp(computer,'PCWIN'),
			cmd = ['!deskedit ' f ' &'];
		else
			error('fedit: An editor for this computer has not been defined. See FEDIT.')
		end;

		% do it
		eval(cmd);
	end;
end;
