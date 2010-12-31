function menushad(gf,shad,arg3)
%MENUSHAD	Add a shading pulldown menu to a figure.
%	MENUSHAD(H) adds a shading pulldown menu to a the
%	figure specified by the handle H.
%
%	MENUSHAD(H,'METHOD') set the colormap specified by
%	'METHOD' as the default (checked) shading method.
%	Valid values for 'METHOD' are 'faceted', 'flat',
%	and 'interp'.
%
%	Using the menu, the shading command can be executed
%	with the statment,
%
%	shading(lower(get(get(findmenu(gcf,'Shading'), ...
%		'UserData'),'Label')));
%
%	MENUSHAD(H,'METHOD','AUTO') automatically changes
%	the shading when the method is selected from the menu.
%
%	See also MENUCMAP

%       Dennis W. Brown 2-3-94, DWB 6-7-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


if nargin < 1,

	% get currentl shading method
	dog_s = get(get(gcf,'CurrentMenu'),'Label');

	% change the shading
	eval(['shading ' dog_s ]);

else,

	% arg check
	if nargin == 1;
		shad = 'faceted';
	elseif nargin > 3,
		error('menushad: Invalid number of input arguments.');
	end;

	if nargin == 3,
		doit = 'menushad;';
	else,
		doit = '';
	end;

	% shading menu
	items = str2mat('faceted','flat','interp');
	togmenu(gf,'Shading',items,2,doit);

	% user's choice
	h = findmenu(gf,'Shading',lower(shad));
	if isempty(h),
		error(['menushad: Invalid shading "' shad '" specified.']);
	else,
		ch = getcheck(gf,'Shading');
		set(ch,'Checked','off','Enable','on');
		set(h,'Checked','on','Enable','off');
	end;
end;
