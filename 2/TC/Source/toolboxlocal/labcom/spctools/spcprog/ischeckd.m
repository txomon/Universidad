function y = ischeckd(gf,label,submenu1,submenu2,submenu3)
%ISCHECKD  Is menu item checked.
%	Y = ISCHECKD(FIGURE) returns true if the current menu
%	item is checked.
%
%	Y = ISCHECKD(FIGURE,LABEL,SUBMENU1) 
%	Y = ISCHECKD(FIGURE,LABEL,SUBMENU1,SUBMENU2) 
%	Y = ISCHECKD(FIGURE,LABEL,SUBMENU1,SUBMENU2,SUBMENU3) 
%	return true if the specified menu item is currently 
%	checked.
%
%	See also TOGMENU, TOGCHECK, UIMENU

%       Dennis W. Brown 5-26-94, DWB 6-7-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if nargin == 1,
	onoff = get(get(gf,'CurrentMenu'),'Checked');
elseif nargin == 3,
	onoff = get(findmenu(gf,label,submenu1),'Checked');
elseif nargin == 4,
	onoff = get(findmenu(gf,label,submenu1,submenu2),'Checked');
elseif nargin == 5,
	onoff = get(findmenu(gf,label,submenu1,submenu2),'Checked');
else,
	error('ischeckd: Invalid number of input arguments.');
end;

y = strcmp(onoff,'on');
