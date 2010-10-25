function zoomprog(arg1)
%ZOOMPROG Launch SPC Toolbox program.
%       ZOOMPROG(H) adds a menu to the figure window containing
%       the figure pointed to by the handle H.  The menu allows the
%       user to launch another SPC Toolbox program with all or a
%	portion of the vector the ZOOMTOOL cursors are currently
%	attached to.  ZOOMTOOL must be active in the figure before
%	calling ZOOMPROG.
%
%       The Launch menu is
%
%       Launch
%           Full		- Sends the entire vector.
%           Limits		- Sends portion between axis limits.
%           Cursors		- Sends portion between cursors.
%		-------
%		New		- Launches a new tool.
%		Replace		- Replaces previous tool (same type).
%		-------
%		SigEdit		- Signal Editor
% 		VoicEdit	- Voice Signal Editor
%		SigFilt		- Signal Filtering Tool
%		SigModel	- Signal Modeling
%		SPScope		- Spectrum Scope (Analyzer)
%		Spect2D		- 2D Sprctral Estimation
%		Spect3D		- 3D Spectral Analysis
%
%
%       See also ZOOMTOOL, ZOOMEDIT, ZOOMPLAY, ZOOMFILT

%       Dennis W. Brown 1-29-94, DWB 6-18-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if nargin < 1,
	gf = gcf;
	arg1 = gf;
	if isempty(finduitx(gf,'zoomtool')),
		zoomtool(get(gf,'CurrentAxes'));
	end;
else
	if ~isstr(arg1),
		gf = arg1;
		if isempty(finduitx(gf,'zoomtool')),
			zoomtool(get(gf,'CurrentAxes'));
		end;
	else,
		gf = gcf;
	end;
end;

handles = get(finduitx(gf,'zoomtool'),'UserData');
ga = handles(40);

if nargin > 1,
	error('zoomprog: Invalid number of input arguments.');
end


if ~isstr(arg1),

	if findmenu(gf,'Launch'),
		error('zoomprog: Launch menu already installed in figure.');
	end;

	% add launch menu
	items = str2mat('Full','Limits','Cursors');
	m=togmenu(gf,'Launch',items,1);
	items = str2mat('New','Replace');
	togmenu(gf,'Launch',items,1);


	uimenu(m,'Label','SigEdit','CallBack','zoomprog(''SigEdit'')',...
		'Separator','on');
	uimenu(m,'Label','VoicEdit','CallBack','zoomprog(''VoicEdit'')');
	uimenu(m,'Label','SigFilt','CallBack','zoomprog(''SigFilt'')');
	uimenu(m,'Label','SigModel','CallBack','zoomprog(''SigModel'')');
	uimenu(m,'Label','SPScope','CallBack','zoomprog(''SPScope'')');
	uimenu(m,'Label','Spect2D','CallBack','zoomprog(''Spect2D'')');
	uimenu(m,'Label','Spect3D','CallBack','zoomprog(''Spect3D'')');

else,

	if ischeckd(gf,'Launch','Full'),

	    y = get(handles(39),'YData');

	else,

    		y = get(handles(39),'YData');

		% get some data about the current axes state
		xfactor = handles(28);
		xmin = handles(33);
		xxlim = get(ga,'Xlim');


		if ischeckd(gf,'Launch','Limits'),

			i = round((xxlim - xmin) / xfactor) + 1;
			y = y(i(1):i(2));

		elseif ischeckd(gf,'Launch','Cursors'),

			x1 = get(handles(24),'XData'); x1 = x1(1);
			x2 = get(handles(26),'XData'); x2 = x2(1);
			i1 = round((x1(1) - xmin) / xfactor) + 1;
			i2 = round((x2(1) - xmin) / xfactor) + 1;

			if i1 < i2,
				y = y(i1:i2);
			else,
            			y = y(i2:i1);
			end;
		else,
			error('zoomprog: Vector parsing error.');
		end;

	end;

	% get pointer to calling menu
	h = findmenu(gf,'Launch',arg1);

	% get UserData property (where handle to last figure
	%	a tool of this type was started in).
	old = get(h,'UserData');

	% Kill old tool if still there (now warning is provided)
	if ischeckd(gf,'Launch','Replace'),

		% make sure it's still open
		if any(get(0,'Children') == old),
			close(old);
		end;

	end;

	% find sampling frequency if there is one
	fs = getpopvl(gf,'Sampling Freq');
	if isempty(fs),
		fs = getpopvl(gf,'FS');
		if isempty(fs),
			fs = getpopvl(gf,'Fs');
			if isempty(fs),
				h = findmenu(gf,'Play');
				if ~isempty(h),
					fs = get(h,'UserData');
				else,
					fs = 8192;
				end;
			end;
		end;
	end;

	% launch a new one
	arg1 = lower(arg1);
	if strcmp(arg1,'sigedit'),

		newh = sigedit(y,fs);

	elseif strcmp(arg1,'sigmodel'),

		newh = sigmodel(y,fs);

	elseif strcmp(arg1,'sigfilt'),

		newh = sigfilt(y,fs);

	elseif strcmp(arg1,'voicedit'),

		newh = voicedit(y,fs);

	elseif strcmp(arg1,'spscope'),

		newh = spscope(y,fs);

	elseif strcmp(arg1,'spect2d'),

		newh = spect2d(y,fs);

	elseif strcmp(arg1,'spect3d'),

		newh = spect3d(y,fs);

	else

		error(['zoomprog: "' arg1 '" Invalid SPC program name.']);

	end;

	set(h,'UserData',newh);

end;


