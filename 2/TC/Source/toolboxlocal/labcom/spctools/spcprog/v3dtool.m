function v3dtool(ga,prop1,val1,prop2,val2,prop3,val3,prop4,val4,prop5,val5)
%V3DTOOL View three-dimensional plots tool.
%       V3DTOOL(H) attaches itself to the 3D axis in the figure
%       window specified by the handle H. If H is omitted, the
%       current figure is used.
%
%       V3DTOOL takes the drudgery out of typing the view command
%       over and over to find the best orientation for a three
%       dimensional plot. It can be used in figure windows which
%       have a single 3D axes. Upon its use, V3DTOOL repositions
%       the axes, leaving room for the following controls:
%
%           o A scroll bar controlling the azimuth.
%           o A scroll bar controlling the elevation.
%           o "Azimuth" and "Elevate" edit boxes to display
%             the current values of the associated scroll bars
%             or allow the desire azimuth or elevation to be
%             entered directly.
%           o A "Q"uit push button which removes the uicontrols
%             and restores the original position leaving the
%             final axes orientation.
%
%	V3DTOOL(H,'PropertyName','PropertyValue',...) allow setting
%	the following properties when V3DTOOL is initiated.
%
%		ColorMap	'hsv' | jet | cool | hot | bone | gray |
%					pink | copper
%		Shading		'faceted' | flat | interp
%		ApplyMapShade	'on' | off
%		View		[az el]
%		Auto		'on' | 'off'
%
%       Notes: Only one V3DTOOL per figure window is allowed.
%              Only one axis can be present in the figure window.
%
%       See also ZOOMTOOL

%       Dennis W. Brown 1-10-94, DWB 3-2-95
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if nargin < 1,
	gf = gcf;
	ga = gca;
	action = 'start';
elseif ~isstr(ga),
	action = 'start';
	gf = get(ga,'Parent');
else,
	action = ga;
	ga = gca;
	gf = gcf;
end;

auto = 'auto';

if strcmp(action,'start'),

	% check input
	if nargin > 7,
		error('v3dtool: Invalid number of input arguments...');
	end;

	% check for only one axes
	if cntaxes(gf) ~= 1,
		error('v3dtool: Only one axes per figure allowed...');
	end;

	% check if already running in window
	if finduitx(gf,'Elevate'),
		error('v3dtool: Already running in figure window...');
	end;

	% get handle of figure axes
	ga = gca;

	% check axis
	if isempty(get(ga,'ZTickLabels')),
		error('v3dtool: Axes is not a 3D axes...');
	end;

	% lock out plotting over it until we're cleared
	set(gcf,'NextPlot','new');

	% get the axes limits and save it away
	p = get(ga,'Position');
	set(ga,'UserData',p);

	% change axis size to fit controls in window
	p = [.15 .15 .7 .75];
	set(ga,'position',p);

	% default values
	shad = 'faceted';
	cmap = 'HSV';
	v = get(ga,'view');
	az = v(1);
	el = v(2);
	invert = 'off';
	applymapshade = 'on';

	% must have first arg
	if nargin > 1,
		for i = 1:(nargin-1)/2,
			prop = eval(['prop' int2str(i)]);
			val = eval(['val' int2str(i)]);
			if strcmp(lower(prop),'shading'),
				shad = val;
			elseif strcmp(lower(prop),'colormap'),
				cmap = val;
			elseif strcmp(lower(prop),'invert'),
				invert = val;
			elseif strcmp(lower(prop),'applymapshade'),
				applymapshade = val;
			elseif strcmp(lower(prop),'view'),
				az = val(1);
				el = val(2);
			elseif strcmp(lower(prop),'auto'),
				auto = lower(val);
				if strcmp(auto,'on'),
					auto = 'auto';
				end;
			else
		  error(['v3dtool: Invalid property "' prop '" specified.']);
			end;
		end;
	end;

	% set azimuth and elevation
	v = [az el];
	view(az,el);

	% invert?
	if strcmp(invert,'on'),
		colormap(eval(lower(cmap)));
		map = colormap;
		colormap(flipud(map));
	else,
		colormap(eval(lower(cmap)));
	end;

	if strcmp(shad,'flat')
		shading flat
	elseif strcmp(shad,'interp')
		shading interp
	end;

	% get slider values
	getslider = [...
		'dog_az = get(findslid(gcf,''azimuth''),''Value'');'...
		'dog_el = get(findslid(gcf,''elevation''),''Value'');'...
	];

	% get slid edit box values
	getsledit = [...
		'dog_az = getednbr(gcf,''azimuth'');'...
		'dog_el = getednbr(gcf,''elevation'');'...
	];

	% set slider values
	setslider = [...
		'set(findslid(gcf,''azimuth''),''Value'',dog_az);'...
		'set(findslid(gcf,''elevation''),''Value'',dog_el);'...
	];

	% set slider edit boxes
	setsledit = [...
	    'set(findedit(gcf,''azimuth''),''String'',num2str(dog_az));'...
	    'set(findedit(gcf,''elevation''),''String'',num2str(dog_el));'...
	];

	% check edit box values, if in error, reset to present values,
	%   do not redraw, otherwise redraw
	chkedit = [...
	'if (abs(dog_az) > 90) | (el < 0) | (el > 90),'...
		getslider ...
		setsledit ...
	'else,' ...
		getsledit ...
		setslider ...
	'end;'...
	];

	% brightness control callback
	brightcall = [...
		'dog_bh = findslid(gcf,''bright''); '...
		'dog_b = get(dog_bh,''UserData''); '...
		'dog_v = get(dog_bh,''Value''); '...
		'brighten(-dog_b);brighten(dog_v); '...
		'set(dog_bh,''UserData'',dog_v); '...
		'clear dog_v dog_bh dog_b; '...
		];

	% slider callback
	slidecall = [getslider setsledit];

	% edit callback
	sleditcall = [getsledit chkedit];

	%slider position
	sposa = [.1 0 .8 .05];      % azimuth
	spose = [.95 .1 .05 .8];    % elevation
	sposb = [.3 .05 .3 .05];    % brightness

	% make slider contols
	h = uicontrol(gf,'Style','slider','Units','Normal',...
		'Position',sposa,'String','azimuth',...
		'UserData',ga,'Max',90,'Min',-90,'Value',v(1),...
		'Callback',slidecall);
	set(h,'Value',v(1));

	beditcolor = get(h,'BackgroundColor');

	h =uicontrol(gf,'Style','Slider','Units','Normal',...
		'Position',spose,'String','elevation',...
		'UserData',ga,'Max',90,'Min',0,...
		'Callback',slidecall);
	set(h,'Value',v(2));

	h = uicontrol(gf,'Style','slider','Units','Normal',...
		'Position',sposb,'String','bright',...
		'UserData',ga,'Max',0.99,'Min',-0.99,'Value',0,...
		'Callback',brightcall,'UserData',0);
	set(h,'Value',0);

	% label sliders
	cback = get(gf,'Color');
	cfore = get(ga,'XColor');
	uicontrol(gf,'Style','Text','Units','Normal',...
		'Position',[sposa(1)-0.05 sposa(2) 0.045 sposa(4)]',...
		'BackGround',cback,'ForeGround',cfore,...
		'String','-90','Horiz','left');

	uicontrol(gf,'Style','Text','Units','Normal',...
		'Position',[sposa(1)+sposa(3)+0.005 sposa(2) 0.05 sposa(4)]',...
		'BackGround',cback,'ForeGround',cfore,...
		'String','90','Horiz','left');

	uicontrol(gf,'Style','Text','Units','Normal',...
		'Position',[spose(1) spose(2)-0.05 spose(3) 0.05]',...
		'BackGround',cback,'ForeGround',cfore,...
		'String','0','Horiz','center');
	uicontrol(gf,'Style','Text','Units','Normal',...
		'Position',[spose(1) spose(2)+spose(4) spose(3) 0.05]',...
		'BackGround',cback,'ForeGround',cfore,...
		'String','90','Horiz','center');
	uicontrol(gf,'Style','Text','Units','Normal',...
		'Position',[sposb(1)-0.05 sposb(2) 0.045 sposb(4)]',...
		'BackGround',cback,'ForeGround',cfore,...
		'String','-1','Horiz','left');
	uicontrol(gf,'Style','Text','Units','Normal',...
		'Position',[sposb(1)+sposb(3)+0.005 sposb(2) 0.05 sposb(4)]',...
		'BackGround',cback,'ForeGround',cfore,...
		'String','1','Horiz','left');

	% text for bightness
	uicontrol(gf,'Style','text','Units','normal','UserData','azimuth',...
		'Position',[sposb(1)+sposb(3)+0.035 sposb(2) 0.15 sposb(4)],...
		'BackGround',cback,'ForeGround',cfore,...
		'String','Brightness','Horiz','left');

	% edit boxes for setting azimuth and elevation
	cback = beditcolor;
	uicontrol(gf,'Style','edit','Units','normal','UserData','azimuth',...
		'Position',[sposa(1) sposa(4) 0.1 0.05],...
		'BackGround',cback,'ForeGround',cfore,...
		'String',num2str(v(1)),'Horiz','right',...
		'CallBack',sleditcall);
	uicontrol(gf,'Style','edit','Units','normal','UserData','elevation',...
		'Position',[spose(1)-0.1 spose(2)+spose(4)-0.05 0.1 0.05],...
		'BackGround',cback,'ForeGround',cfore,...
		'String',num2str(v(2)),'Horiz','right',...
		'CallBack',sleditcall);

	% labels for text objects
	cback = get(gf,'Color');
	p = get(findedit(gf,'azimuth'),'Position');
	uicontrol(gf,'Style','text','Units','normal','UserData','azimuth',...
		'Position',[p(1) p(2)+p(4) p(3) p(4)],...
		'BackGround',cback,'ForeGround',cfore,...
		'String','Azimuth','Horiz','center');

	p = get(findedit(gf,'elevation'),'Position');
	uicontrol(gf,'Style','text','Units','normal','UserData','elevation',...
		'Position',[p(1) p(2)+p(4) p(3) p(4)],...
		'BackGround',cback,'ForeGround',cfore,...
		'String','Elevate','Horiz','center');

	% quit pushbutton
	uicontrol(gf,'Style','push','Units','normal',...
		'Position',[0.95 0 0.05 0.05],...
		'ForeGround',cfore,'String','Q','Horiz','center',...
		'CallBack','v3dtool(''quit'');');

	if strcmp(applymapshade,'on'),

		% colormap menu
		if strcmp(invert,'on'),
			menucmap(gf,cmap,'invert',auto);
		else,
			menucmap(gf,cmap,'off',auto);
		end;

		% shading menu
		menushad(gf,shad);
	end;

	% color axis edit boxes.
	cback = get(gf,'Color');
	cax = caxis;
	uicontrol(gf,'Style','text','Units','normal','UserData','azimuth',...
		'Position',[.6 .95 0.1 0.05],...
		'BackGround',cback,'ForeGround',cfore,...
		'String','CMIN','Horiz','center');

	uicontrol(gf,'Style','edit','Units','normal','UserData','azimuth',...
		'Position',[.7 .95 0.1 0.05],...
		'BackGround',beditcolor,'ForeGround',cfore,...
		'UserData','CMIN','Horiz','right',...
		'String',num2str(cax(1)),'CallBack','');
	uicontrol(gf,'Style','text','Units','normal','UserData','azimuth',...
		'Position',[.8 .95 0.1 0.05],...
		'BackGround',cback,'ForeGround',cfore,...
		'String','CMAX','Horiz','center');

	uicontrol(gf,'Style','edit','Units','normal','UserData','elevation',...
		'Position',[.9 .95 0.1 0.05],...
		'BackGround',beditcolor,'ForeGround',cfore,...
		'UserData','CMAX','Horiz','right',...
		'String',num2str(cax(2)),'CallBack','');

	% apply pushbutton
	uicontrol(gf,'Style','push','Units','normal',...
		'Position',[0.85 0.05 0.1 0.05],...
		'ForeGround',cfore,'String','Apply','Horiz','center',...
		'CallBack','v3dtool(''apply'');');

elseif strcmp(action,'apply'),


	% color axis callback
	cmin = getednbr(gf,'CMIN');
	cmax = getednbr(gf,'CMAX');
	if cmin < cmax,
		caxis([cmin cmax]);
	end;

	% get slid edit box values
	dog_az = getednbr(gf,'azimuth');
	dog_el = getednbr(gf,'elevation');

	% set slider values
	set(findslid(gf,'azimuth'),'Value',dog_az);
	set(findslid(gf,'elevation'),'Value',dog_el);

	% reset view
	view(dog_az,dog_el);

	% colormap
	dog_map = eval(lower(get(getcheck(gcf,'Colormap',1),'Label')));
	if ischeckd(gcf,'Colormap','Invert'),
		dog_map = flipud(dog_map);
	end;
	colormap(dog_map);

	% shading
	dog_shad = lower(get(getcheck(gcf,'Shading'),'Label'));
	shading(dog_shad);

	% reset brightness
	set(findslid(gcf,'bright'),'UserData',0,'Value',0);



elseif strcmp(action,'quit'),


	% delete all uicontrols
	delete(findobj(get(gcf,'Children'),'Type','uicontrol'));

	% delete all uimenus on menubar (children deleted automatically)
	h = findobj(get(gcf,'Children'),'Type','uimenu');
	delete(findobj(h,'Parent',gcf));

	% reposition plot
	set(gcf,'NextPlot','replace');
	set(gca,'Position',get(gca,'Userdata'));

else,

	error(['v3dtool: Invalid action ' action ' specified.']);

end;

set(gf,'Pointer','Arrow');
