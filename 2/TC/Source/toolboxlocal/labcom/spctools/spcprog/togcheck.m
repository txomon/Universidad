function dummy=togcheck(groupnbr)
%TOGCHECK Toggle menu checkmarks.
%	TOGCHECK toggles the checkmarks on a group of
%	pull-down UIMENU submenu items.  All Children of
%	the Parent UIMENU submenu selected with the mouse
%	cursor are subject to checking.  This function
%	must be placed in the CallBack function for the
%	submenu UIMENU objects.
%
%	Example usage:
%
%	uimenu(m,'Label','Option 1','Checked','on',...
%		'Callback',['togcheck; myguiapp(''action'');']);
%	uimenu(m,'Label','Option 2','Checked','off',...
%		'Callback',['togcheck; myguiapp(''action'');']);
%
%	See also UIMENU

%       Dennis W. Brown 5-25-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% backward compatibility
if nargin == 0,

	% uimenu selected
	me = get(gcf,'CurrentMenu');

	% parent's children
	kids = get(get(me,'Parent'),'Children');

	% last one checked
	old = findobj(kids,'Checked','on');

	% toggle checkmarks
	set(old,'Checked','off','Enable','on');
	set(me,'Checked','on','Enable','off');
else

	% uimenu selected
	me = get(gcf,'CurrentMenu');

	% parent's children
	kids = flipud(get(get(me,'Parent'),'Children'));

	% find my group
	groups = get(get(me,'Parent'),'UserData');

	% children in my group
	kids = kids((groups(groupnbr,1):groups(groupnbr,2)));

	% last one checked
	old = findobj(kids,'Checked','on');

	% toggle checkmarks
	set(old,'Checked','off','Enable','on');
	set(me,'Checked','on','Enable','off');
end;
