function h = getcheck(gf,label,groupnbr)
%GETCHECK Get checked menuitem handle.
%	H = GETCHECK(FIGURE,LABEL) returns the handle of the
%	checked uimenu child of the menu LABEL in the figure
%	window specified with the handle FIGURE.
%
%	H = GETCHECK(FIGURE,LABEL,GROUP) returns the handle
%	of the checked uimenu child in the GROUP number of
%	grouped toggable menu items as setup by the TOGMENU
%	function.
%
%	See also TOGMENU, TOGCHECK, UIMENU

%       Dennis W. Brown 5-26-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


if nargin == 2,

	% uimenu selected
	h = findobj(get(findmenu(gf,label),'Children'),'Checked','on');

else,

	% parent
	p = findmenu(gf,label);

	% parent's children
	kids = flipud(get(p,'Children'));

	% find my group
	groups = get(p,'UserData');

	% children in my group
	kids = kids((groups(groupnbr,1):groups(groupnbr,2)));

	% last one checked
	h = findobj(kids,'Checked','on');

end;
