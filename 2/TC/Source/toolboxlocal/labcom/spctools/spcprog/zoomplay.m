function zoomplay(gf,action,fs)
%ZOOMPLAY Play portion of vector in ZOOMTOOL.
%       ZOOMPLAY(H) adds a menu to the figure window containing
%       the figure pointed to by the handle H.  The menu allows the
%       user to send all or a portion of the vector the ZOOMTOOL
%       cursors are currently attached to.  ZOOMTOOL must be active
%	in the figure before calling ZOOMPLAY.
%
%       ZOOMPLAY(H,FS) sets the default sampling frequency the
%       vector is sent to the audio output at.  If the figure
%       window contains a popup menu label 'Sampling Freq', the
%       value currently displayed on the popup menu will override
%       the default.  If no default sampling frequency is given,
%       a value of 8192 Hz is used.
%
%       The Play menu is
%
%       Play
%           Full
%           Limits
%           Cursors
%
%       Full    - plays the entire vector.
%       Limits  - plays portion displayed between axis limits.
%       Cursors - play portion displayed between cursors.
%
%       ZOOMPLAY(H,'PORTION') sends the specified portion of the
%       vector the ZOOMTOOL cursors are attached to.
%
%       ZOOMPLAY(H,'PORTION',FS) overides the frequency display on
%       a popup menu labeled 'Sampling Freq' if present or 8192
%       Hz if not.
%
%       See also ZOOMTOOL

%       Dennis W. Brown 1-29-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% arg check
if nargin < 1,
	gf = gcf;
	action = 'start';
	fs = 8192;
elseif nargin == 1,
	action = 'start';
	fs = 8192;
elseif nargin == 2,
	if ~isstr(action),
		fs = action;
		action = 'start';
	else,
		fs = 8192;
	end;
elseif nargin > 3,
	error('zoomplay: Invalid number of input arguments.');
end

% popup menu overide
h = getpopvl(gf,'Sampling Freq');
if h,
	fs = h;
end

if strcmp(action,'start'),

	if findmenu(gf,'Play'),
		error('zoomplay: Play menu already installed in figure.');
	end;

	if isempty(finduitx(gf,'zoomtool')),
		zoomtool(get(gf,'CurrentAxes'));
	end;

	m=uimenu('Label','Play','UserData',fs);
	uimenu(m,'Label','Full','Callback','zoomplay(gcf,''full'');');
	uimenu(m,'Label','Limits','Callback','zoomplay(gcf,''limits'');');
	uimenu(m,'Label','Cursors','Callback','zoomplay(gcf,''cursors'');');

elseif strcmp(action,'full'),

	% current values
	handles = get(finduitx(gf,'zoomtool'),'UserData');
	ga = handles(40);

	y = get(handles(39),'YData');
	fs = get(findmenu(gf,'Play'),'UserData');

	sound(y,fs);

else,

	% current values
	handles = get(finduitx(gf,'zoomtool'),'UserData');
	ga = handles(40);

	y = get(handles(39),'YData');
	fs = get(findmenu(gf,'Play'),'UserData');

	% get some data about the current axes state
	xfactor = handles(28);
	xmin = handles(33);
	xxlim = get(ga,'Xlim');

	if strcmp(action,'limits'),

		i = round((xxlim - xmin) / xfactor) + 1;

		sound(y(i(1):i(2)),fs);

	elseif strcmp(action,'cursors'),

		x1 = get(handles(24),'XData'); x1 = x1(1);
		x2 = get(handles(26),'XData'); x2 = x2(1);
		i1 = round((x1(1) - xmin) / xfactor) + 1;
		i2 = round((x2(1) - xmin) / xfactor) + 1;

		if i1 < i2,
			sound(y(i1:i2),fs);
		else,
			sound(y(i2:i1),fs);
		end;

	end;
end;

