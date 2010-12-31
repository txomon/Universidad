function menucmap(gf,cmap,invert,auto)
%MENUCMAP	Adds a colormap pulldown menu to a figure.
%	MENUCMAP(H) adds a colormap pulldown menu to a the
%	figure specified by the handle H.
%
%	MENUCMAP(H,'MAP') set the colormap specified by 'MAP'
%	as the default (checked) colormap.  Valid values for
%	'MAP' are 'hsv', 'jet', 'cool', 'hot', 'gray', 'pink',
%	and 'copper'.
%
%	Using the menu, the colormap command can be executed
%	with the statment,
%
%	colormap(lower(get(get(findmenu(gcf,'Colormap'), ...
%		'UserData'),'Label')));
%
%	See also MENUSHAD

%       Dennis W. Brown 2-3-94, DWB 6-7-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


if nargin < 1,

	% currently checked colormap
	cmap = lower(get(getcheck(gcf,'Colormap',1),'Label'));

	% should it be inverted?
	if ischeckd(gcf,'Colormap','Invert'),

		% invert it
		set(gcf,'ColorMap',flipud(eval(lower(cmap))));
	else,
		% don't invert it
		set(gcf,'ColorMap',eval(lower(cmap)));
	end;

else,
	% arg check
	if nargin == 1,
		cmap = 'HSV';
		invert = 'off';
		auto = 'off';
	elseif nargin == 2,
		invert = 'off';
		auto = 'off';
	elseif nargin == 3,
		auto = 'off';
	elseif nargin > 4,
		error('menucmap: Invalid number of input arguments.');
	end;

	if strcmp(lower(auto),'auto'),
		doit = 'menucmap;';
	else,
		doit = '';
	end;

	togzcr = ['dog_h = get(gcf,''CurrentMenu'');'...
		  'if strcmp(get(dog_h,''Checked''),''on''),'...
			'set(dog_h,''Checked'',''off'');'...
		  'else,'...
			'set(dog_h,''Checked'',''on'');'...
		  'end;'...
		  'clear dog_h;'];

	% colormap menu
	items = str2mat('HSV','Jet','Cool','Hot','Bone','Gray','Pink','Copper');
	togmenu(gf,'Colormap',items,2,doit);
	togmenu(gf,'Colormap','Invert',1,[togzcr doit]);
	set(findmenu(gf,'Colormap','Invert'),'Enable','on','Checked','off',...
		'CallBack',[togzcr doit]);

	% if user specified which should be checked
	h = findmenu(gf,'Colormap',cmap);
	if isempty(h),
		error(['menucmap: Invalid colormap "' cmap '" specified.']);
	else,
		ch = getcheck(gf,'Colormap');
		set(ch,'Checked','off','Enable','on');
		set(h,'Checked','on','Enable','off');
	end;

	% if it is to inverted
	if strcmp(lower(invert),'invert'),
		set(findmenu(gf,'Colormap','Invert'),'Checked','on');
	end;

end;
