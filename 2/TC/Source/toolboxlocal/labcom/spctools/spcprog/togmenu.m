function hh = togmenu(gf,label,items,check,callback)
%TOGMENU Create menu with toggling checkmark menu items.
%	H = TOGMENU(FIGURE,'LABEL','ITEMS') creates a pull-down
%	menu called LABEL with submenu items specified in the
%	string matrix ITEMS in the figure window specified by
%	the handle FIGURE.  The return argument H is the handle
%	to the parent UIMENU.
%
%	H = TOGMENU(FIGURE,'LABEL','ITEMS',CHECK) checks the
%	menu item contained in row CHECK in the ITEMS string
%	matrix and sets up the menu for use with GETCHECK to
%	retrieve the handle to the checked menu item at runtime.
%
%	H = TOGMENU(FIGURE,'LABEL','ITEMS',CHECK,CALLBACK) assigns
%	the CallBack function specified in the string CALLBACK to
%	each menu item.
%
%	See also GETCHECK, TOGCHECK, UIMENU

%       Dennis W. Brown 5-26-94, DWB 6-12-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% if one already there, don't overwrite, just append to current
h = findmenu(gf,label);
if isempty(h),

	% create the base menu
	h = uimenu(gf,'Label',label);

end;

% get data on previous groups
groups = get(h,'UserData');
ng = length(groups)/2 + 1;	% our group number
old = length(get(h,'Children'));

% create the menuitems
[m,n] = size(items);
handles = zeros(m,1);

for k = 1:m,

	% create a submenu item
	handles(k) = uimenu(h,'Label',deblank(items(k,:)),...
			'CallBack',['togcheck(' num2str(ng) ');']);

end;

% put 2 element array in userdata specifying the first and last
%    menu items in this toggle list, could already be a list there
set(h,'UserData',[get(h,'UserData') ; [old+1 old+m]]);

% if there were others, add a seperator in between
if old,
	set(handles(1),'Separator','on');
end;

% check is requested
if nargin >= 4,

	set(handles(check),'Checked','on','Enable','off');

end;

% assign callbacks if requested
if nargin == 5,

	set(handles,'Callback',['togcheck(' num2str(ng) ');' callback]);

end;

if nargout == 1,
	hh = h;
end;
