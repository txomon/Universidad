function reqfile(gf,mask,str,callback)
%REQFILE   File name request dialog.
%	REQSTR(H,'MASK','STRING','CALLBACK') opens UIGETFILE 
%	displaying the 'STRING' prompt and listing file 
%	according to the 'MASK' specification.  When the user
%	closes UIGETFILE by selecting a file, the callback 
%	function is executed. If the 'Cancel' button is chosen, 
%	UIGETFILE closes and the callback function is not evaluated.
%	An invisible uicontrol 'text' object named 'Answer' is used 
%	to pass the string back to the calling function in the 
%	'UserData' field of 'Answer'.  In the special case where
%	REQFILE is called from the 'Workspace' menu, the filename
%	is appended with "#x" where x is the number of bits from
%	the Workspace.FileLoad.Integer.x-Bit menus are selected.
%
%       See also WORKMENU, SAVEEDIT, LOADEDIT

%       Dennis W. Brown 6-7-94, DWB 6-12-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if nargin ~= 4,
    error('reqfile: Invalid number of input arguments.');
end;

% create a text uicontrol to pass the value back
ha = finduitx(gf,'Answer');
if isempty(ha),
	ha = uicontrol(gf,'Style','text','Units','normal',...
	'Position',[0 0 .1 .1],...
	'String','Answer','Visible','off'...
	);
end;

% presumably the calling function, stores this handle in 
% the OK button so the callback function can find it
h = get(gf,'CurrentMenu');

[file,path] = uigetfile(mask,str);

if file == 0,
	return;
else
	if findmenu(gf,'Workspace'),
		if ischeckd(gf,'Workspace','File Load','Integer','8 Bit'),
			file = [file '#8'];
		elseif ischeckd(gf,'Workspace','File Load','Integer','16 Bit'),
			file = [file '#16'];
		elseif ischeckd(gf,'Workspace','File Load','Integer','32 Bit'),
			file = [file '#32'];
		end;
	end;

	% user responded properly, store the string and call the calling
	%   callback from the menu whose handle is in the OK button
	if ~isempty(path),
		set(finduitx(gf,'Answer'),'UserData',[path file]);
	else,
		set(finduitx(gf,'Answer'),'UserData',file);
	end;

end;

eval(callback);

