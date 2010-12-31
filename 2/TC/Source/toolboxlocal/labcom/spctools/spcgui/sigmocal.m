function sigmocal(action,arg1,arg2)
%SIGMOCAL Callback functions for SIGMODEL
%	SIGMOCAL('ACTION',ARG1,ARG2) performs the specified
%	callback 'ACTION'.  Valid actions are:
%
%		plottime	- Initial plot
%		curadj		- Adjust height of Model and Period
%				  cursors after a zoom operation.
%		fs		- Change signal sampling frequency
%		restore		- Restore original signal
%		common		- Load SPC_COMMON vector
%		arma		- Open ARMA modeling dialog box
%		redo		- Reset plot after change (fs,
%				  common, restore).
%
%	See also SIGMODEL, ARMADSGN

%       Dennis W. Brown 3-93, DWB 4-17-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

gf = gcf;
ga = findaxes(gf,'zoomtool');

set(gf,'Pointer','watch');

if strcmp(action,'plottime'),

	figure(gf);
	set(gf,'NextPlot','add','CurrentAxes',ga);

	axes(findaxes(gf,'zoomtool'));
	axis('auto');

	x = arg1;
	fs = getpopvl(gf,'Sampling Freq');
	if fs ~= 1,
		xscale = (0:length(x)-1)/fs;
	else,
		xscale = 1:length(x);
	end;
	firstsamp = xscale(1);
	lastsamp = xscale(length(xscale));

	global SPC_LINE SPC_FONTNAME SPC_TEXT_FORE SPC_AXIS SPC_COLOR_ORDER

	plot(xscale',x,SPC_LINE);

	set(ga,'Color',SPC_AXIS,'FontName',SPC_FONTNAME, ...
		'XColor',SPC_TEXT_FORE,'YColor',SPC_TEXT_FORE, ...
		'ColorOrder',SPC_COLOR_ORDER);

	zoomtool(ga,'QuitButton','off','HorizontalCursors','off', ...
		'CursorCallBack','','Pan','off', ...
		'ZoomCallBack','sigmocal(''curadj'');');
	zoomedit(gf,'callback','sigmocal(''fs'');');
	zoomplay(gf,fs);
	zoomprog(gf);

	m = uimenu(gf,'Label','Model');
	  uimenu(m,'Label','AR/MA/ARMA','CallBack','sigmocal(''arma'');');

	zoomset(ga,1,firstsamp);
	zoomset(ga,2,lastsamp);

	global SPC_MODEL_MARKS SPC_PERIOD_MARKS
	h=crsrmake(ga,'modstart','vertical',firstsamp,'-','armacrsr(gca,1,4);');
	h=crsrmake(ga,'modend','vertical',lastsamp,'-','armacrsr(gca,1,5);');
	h=crsrmake(ga,'perstart','vertical',firstsamp,':','armacrsr(gca,2,4);');
	h=crsrmake(ga,'perend','vertical',lastsamp,':','armacrsr(gca,2,5);');

	set(findedit(gf,'MB'),'String',num2str(firstsamp));
	set(findedit(gf,'ME'),'String',num2str(lastsamp));
	set(findedit(gf,'MD'),'String',num2str(lastsamp));
	set(findedit(gf,'PB'),'String',num2str(firstsamp));
	set(findedit(gf,'PE'),'String',num2str(lastsamp));
	set(findedit(gf,'PD'),'String',num2str(lastsamp));

	ar_pperiod = (lastsamp - firstsamp)/fs;
	set(findedit(gf,'period'),'String',num2str(ar_pperiod));

elseif strcmp(action,'curadj')

	yy = get(ga,'Ylim');
	set(findline(ga,'modstart'),'YData',yy);
	set(findline(ga,'modend'),'YData',yy);
	set(findline(ga,'perstart'),'YData',yy);
	set(findline(ga,'perend'),'YData',yy);

elseif strcmp(action,'fs')

	% get line and recompute time scale
	x = get(zoomed(gf),'YData');

	sigmocal('redo',x);

elseif strcmp(action,'restore'),

	signal = get(findmenu(gf,'Workspace','Restore'),'UserData');

	% is it a file?
	if isstr(signal),

		ind = find(signal == '#');
		if isempty(ind),
			[signal,fs] = readsig(signal);
		else,
			bits = str2num(signal(ind(1)+1:length(signal)));
			signal = signal(1:ind-1);
			[signal,fs] = readsig(signal,bits);
		end;

		% set sampling freq popup menu
		h = findpopu(gf,'Sampling Freq');
		max = get(h,'Max');

		% get current values
		items = zeros(max-1,1);
		str = get(h,'String');
		for i = 1:max-1,
			items(i) = str2num(str(i,:));
		end;

		if find(fs == items),

			% sampling freq already in popup menu
			set(h,'Value',find(fs == items));

		else,
			% add new sampliing freq
			popstr = [];
			for i = 1:max-1,
				popstr = [popstr int2str(items(i)) '|'];
			end;
			popstr = [popstr int2str(fs) '|User'];

			% reset popup menu
			set(h,'String',popstr,'Value',max);
		end;
	end;

	sigmocal('redo',signal);

elseif strcmp(action,'common')

    global SPC_COMMON;

    if min(size(SPC_COMMON)) ~= 1 | length(SPC_COMMON) < 2,
	msg = 'Invalid common vector! (it''s scalar or a matrix or empty)';
	spcwarn(msg,'OK');
	set(gf,'Pointer','arrow','NextPlot','new');
	return;
    end;

    sigmocal('redo',SPC_COMMON);

elseif strcmp(action,'redo')

	% signal
	x = arg1; clear arg1;

	% get sampling frequency
	fs = getpopvl(gf,'Sampling Freq');
	if fs ~= 1,
		xscale = (0:length(x)-1)/fs;
	else,
		xscale = 1:length(x);
	end;
	firstsamp = xscale(1);
	lastsamp = xscale(length(xscale));


	zoomrep(ga,xscale,x);

	zoomset(ga,1,firstsamp);
	zoomset(ga,2,lastsamp);

	ylim = get(ga,'YLim');
	h = crsrmove(ga,'modstart',firstsamp);
	set(h,'YData',ylim);
	h = crsrmove(ga,'modend',lastsamp);
	set(h,'YData',ylim);
	h = crsrmove(ga,'perstart',firstsamp);
	set(h,'YData',ylim);
	h = crsrmove(ga,'perend',lastsamp);
	set(h,'YData',ylim);

	set(findedit(gf,'MB'),'String',num2str(firstsamp));
	set(findedit(gf,'ME'),'String',num2str(lastsamp));
	set(findedit(gf,'MD'),'String',num2str(lastsamp));
	set(findedit(gf,'PB'),'String',num2str(firstsamp));
	set(findedit(gf,'PE'),'String',num2str(lastsamp));
	set(findedit(gf,'PD'),'String',num2str(lastsamp));

	ar_pperiod = (lastsamp - firstsamp)/fs;
	set(findedit(gf,'period'),'String',num2str(ar_pperiod));

elseif strcmp(action,'arma'),

	h = get(findmenu(gf,'Workspace','Quit'),'UserData');
	if isempty(find(get(0,'Children') == h)),

		signal = get(zoomed(gf),'YData');

		h = armadsgn(gf,'Data',signal);
		% store design in close
		set(findmenu(gf,'Workspace','Quit'),'UserData',h);

	else,
		figure(h);
	end;


else
	error(['sigmocal: Invalid action "' action '" requested.']);
end;


set(gf,'Pointer','arrow','NextPlot','new');
