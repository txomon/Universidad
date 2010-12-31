function dummy=togcheck
%TOGRADIO Toggle radio buttons in group.
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

	% radio button selected
	me = get(gcf,'CurrentObject');

	% mother frame is in UserData
	mom = get(me,'UserData');
	
	% parent frame's buttons
	kids = get(mom,'UserData');

	% last one checked
	old = findobj(kids,'Value',1);

	% toggle buttons
	set(old,'Value',0);
	set(me,'Value',1);
end;
