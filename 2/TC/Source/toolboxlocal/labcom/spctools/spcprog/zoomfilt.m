function zoomfilt(arg1,prop1,val1)
%ZOOMFILT	Launch SPC Toolbox program.
%       ZOOMFILT(H) adds a menu to the figure window containing
%       the figure pointed to by the handle H.  The menu allows the
%       user to launch another SPC Toolbox program with all or a
%	portion of the vector the ZOOMTOOL cursors are currently
%	attached to.  ZOOMTOOL must be active before calling 
%	ZOOMFILT.
%
%       The Filter menu is
%
%	Filter
%		Analog		- Analog prototype filters
%		Adapt LMS	- Adaptive LMS filters
%			ALE	- Adaptive Line Enhancer
%
%
%       See also ZOOMTOOL

%       Dennis W. Brown 1-29-94, DWB 6-20-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if nargin < 1,
	gf = gcf;
	arg1 = gf;
else
	if ~isstr(arg1),
		gf = arg1;
	else,
		gf = gcf;
	end;
end;

handles = get(finduitx(gf,'zoomtool'),'UserData');
ga = handles(40);

if ~isstr(arg1),

	if findmenu(gf,'Filter'),
		error('zoomfilt: Filter menu already installed in figure.');
	end;

	% default callbacks
	callback = '';

	% must have first arg
	if nargin < 1,
		error('ednbrchk: Must call with first four arguments.');
	elseif nargin > 1,
		for i = 1:(nargin-1)/2,
			prop = eval(['prop' int2str(i)]);
			val = eval(['val' int2str(i)]);
			if strcmp(lower(prop),'callback'),
				callback = val;
			else
				error(['ednbrchk: Invalid property ' prop ' specified.']);
			end;
		end;
	end;

	% store callbacks as invisible uicontrol text objects
	uicontrol(gf,'Style','text','Visible','off','String','callback',...
		'UserData',callback);

	m=uimenu('Label','Filter');
	ana = uimenu(m,'Label','Analog','Callback','zoomfilt(''analog'');');
%	smo = uimenu(m,'Label','Smoothing');
%	  uimenu(smo,'Label','Average','CallBack','zoomfilt(''average'')',...
%		'Separator','on');
%	  uimenu(smo,'Label','Median','CallBack','zoomfilt(''median'')');

	lms = uimenu(m,'Label','Adapt LMS');
	  uimenu(lms,'Label','Line Enhancer','CallBack','zoomfilt(''ale'')');

else,

	% get vector to filter
	y = get(handles(39),'YData');

	% Kill old filtering tool if still there (no warning is provided)
	oldtool = get(findmenu(gf,'Filter'),'UserData');
	if ~isempty(find(get(0,'Children') == oldtool)),
		close(oldtool);
	end;

	% find sampling frequency if there is one
	fs = getpopvl(gf,'Sampling Freq');
	if isempty(fs),
		fs = getpopvl(gf,'FS');
		if isempty(fs),
			fs = getpopvl(gf,'Fs');
			if isempty(fs),
				fs = 1;
			end;
		end;
	end;

	% launch a new one
	arg1 = lower(arg1);
	if strcmp(arg1,'analog'),
	
		callstr = get(finduitx(gf,'callback'),'UserData');
		newh = sigfilt(y,fs,callstr,gf);
		
	elseif strcmp(arg1,'average'),

%		newh = smofldsg(y,fs,'average');

	elseif strcmp(arg1,'median'),

%		newh = smofldsg(y,fs,'average');

	elseif strcmp(arg1,'ale'),

		callstr = get(finduitx(gf,'callback'),'UserData');
		newh = aledsgn(gf,y,fs,callstr);

	else

		error(['zoomfilt: "' arg1 '" Invalid SPC filter name.']);

	end;

	set(findmenu(gf,'Filter'),'UserData',newh);

end;


