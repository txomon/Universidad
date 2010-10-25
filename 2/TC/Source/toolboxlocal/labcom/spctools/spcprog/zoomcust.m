function zoomcust(gf,action,arg)
%ZOOMCUST Add line customization menu to ZOOMTOOL
%	ZOOMCUST(FIGURE) adds a menu allowing the user to
%	custimize the style, width and color of the current
%	line the cursors are attached to in ZOOMTOOL.
%
%	The custimization menu is
%
%		Line
%		    Style
%			Solid
%			Dash
%			Dot
%			Dash-Dot
%		    Width
%			Increase
%			Decrease
%		    Color
%			Black
%			Blue
%			Cyan
%			Green
%			Magenta
%			Red
%			White
%			Yellow
%
%	The line width is increased and decrease by one unit.
%	This may not always be visible on the monitor but should
%	be visible when printed.
%
%       See also ZOOMTOOL

%       Dennis W. Brown 7-2-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% arg check
if nargin > 3,
	error('zoomplay: Invalid number of input arguments.');
end

if nargin == 0,
	if isempty(finduitx(gcf,'zoomtool')),
		zoomtool(get(gcf,'CurrentAxes'));
	end;
	gf = gcf;
	action = 'start';
elseif nargin == 1,
	if isempty(finduitx(gcf,'zoomtool')),
		zoomtool(gcf);
	end;
	action = 'start';
end;

% current values
handles = get(finduitx(gf,'zoomtool'),'UserData');
ga = handles(40);
h = handles(39);

if strcmp(action,'start'),

	% line customization menu
	m=uimenu(gf,'Label','Line');

	mm = uimenu(m,'Label','Style');
		uimenu(mm,'Label','Solid',...
			'CallBack','zoomcust(gcf,''style'',1)');
		uimenu(mm,'Label','Dash',...
			'CallBack','zoomcust(gcf,''style'',2)');
		uimenu(mm,'Label','Dot',...
			'CallBack','zoomcust(gcf,''style'',3)');
		uimenu(mm,'Label','Dash-Dot',...
			'CallBack','zoomcust(gcf,''style'',4)');

	mm = uimenu(m,'Label','Width');
		uimenu(mm,'Label','Increase',...
			'CallBack','zoomcust(gcf,''width'',1)');
		uimenu(mm,'Label','Decrease',...
			'CallBack','zoomcust(gcf,''width'',2)');

	mm = uimenu(m,'Label','Color');
		uimenu(mm,'Label','Black',...
			'CallBack','zoomcust(gcf,''color'',1)');
		uimenu(mm,'Label','Blue',...
			'CallBack','zoomcust(gcf,''color'',2)');
		uimenu(mm,'Label','Cyan',...
			'CallBack','zoomcust(gcf,''color'',3)');
		uimenu(mm,'Label','Green',...
			'CallBack','zoomcust(gcf,''color'',4)');
		uimenu(mm,'Label','Magenta',...
			'CallBack','zoomcust(gcf,''color'',5)');
		uimenu(mm,'Label','Red',...
			'CallBack','zoomcust(gcf,''color'',6)');
		uimenu(mm,'Label','White',...
			'CallBack','zoomcust(gcf,''color'',7)');
		uimenu(mm,'Label','Yellow',...
			'CallBack','zoomcust(gcf,''color'',8)');

elseif strcmp(action,'style')

	if arg == 1,
		set(h,'LineStyle','-');
	elseif arg == 2,
		set(h,'LineStyle','--');
	elseif arg == 3,
		set(h,'LineStyle',':');
	elseif arg == 4,
		set(h,'LineStyle','-.');
	end;

elseif strcmp(action,'width')

	width = get(h,'LineWidth');

	if arg == 2,
		if width <= 1, return; end;
		width = width - 1;
		set(h,'LineWidth',width);
	elseif arg == 1,
		width = width + 1;
		set(h,'LineWidth',width);
	end;

elseif strcmp(action,'color')

	if arg == 1,
		set(h,'Color','k');
	elseif arg == 2,
		set(h,'Color','b');
	elseif arg == 3,
		set(h,'Color','c');
	elseif arg == 4,
		set(h,'Color','g');
	elseif arg == 5,
		set(h,'Color','m');
	elseif arg == 6,
		set(h,'Color','r');
	elseif arg == 7,
		set(h,'Color','w');
	elseif arg == 8,
		set(h,'Color','y');
	end;
end;

