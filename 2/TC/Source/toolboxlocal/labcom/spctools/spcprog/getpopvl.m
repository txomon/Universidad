function [y] = getpopvl(fig,value)
%GETPOPVL Return current numeric value on popup menus.
%	    [H]=GETPOPVL(FIGURE,'IDENTIFIER') finds the popup menu
%       uicontrol with the Userdata property equal to
%       'IDENTIFIER'. Both 'IDENTIFIER' and the Userdata property
%       must be strings. It then parses out and returns the
%       numeric value currently shown on the popup menu. This
%       function assumes the popup menu was created with all
%       numeric values in the 'String' property
%
%       (ex: uicontrol('Style','pop','String','4|8|16|32|64',...);
%
%	An empty matrix is returned if an error occurs or the 
%	current menu item is a string.
%
%	See also IDAXES, FINDAXES, FINDCHKB, FINDEDIT, FINDFRAM,
%	    FINDMENU, FINDPUSH, FINDRDIO, FINDSLID, FINDUITX

%       Dennis W. Brown 1-10-94, DWB 6-4-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% output variables
h = [];

% find popupmenu object
h = findpopu(fig,value);

% error check
if isempty(h); y = []; return; end;

% get labels
values = get(h,'String');

% current face value
i = get(h,'Value');

% return the current number on face
y = str2num(deblank(values(i,:)));

