function sigedcal(action,arg1,arg2)
%SIGEDCAL Callback functions for SIGEDIT
%	SICEDCAL('ACTION',ARG1,ARG2) performs the specified
%	callback 'ACTION'.  Valid actions are:
%
%		plottime	- Initial plot
%		zero		- Zero vector between cursors
%		mean		- Adjust signal mean
%		volume		- Adjust signal amplitude
%		fs		- Change signal sampling frequency
%		restore		- Restore original signal
%		common		- Load SPC_COMMON vector
%
%	See also SIGEDIT, SIGEDSAV, SIGEDLD

%       Dennis W. Brown 3-93, DWB 2-21-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% base objects
gf = gcf;
ga = findaxes(gf,'zoomtool');

set(gf,'Pointer','watch');

if strcmp(action,'plottime'),

	figure(gf);
	set(gf,'NextPlot','add');

	axes(findaxes(gf,'zoomtool'));
	axis('auto');

	fs = getpopvl(gf,'Sampling Freq');
	ve_tscale = (0:length(arg1)-1)/fs;

	global SPC_LINE SPC_FONTNAME SPC_TEXT_FORE SPC_AXIS

	plot(ve_tscale',arg1,SPC_LINE);

  	xlabel('Time (seconds)');
	set(get(ga,'xlabel'),'FontName',SPC_FONTNAME);
	ylabel('Amplitude');
	set(get(ga,'ylabel'),'FontName',SPC_FONTNAME);
	set(ga,'Color',SPC_AXIS,'FontName',SPC_FONTNAME, ...
		'XColor',SPC_TEXT_FORE,'YColor',SPC_TEXT_FORE);

	zoomtool(ga,'QuitButton','off','HorizontalCursors','off');

	zoomedit(gf);
	zoomplay(gf,fs);
	zoomprog(gf);
	zoomfilt(gf,'CallBack','sigedcal(''common'');');

elseif strcmp(action,'zero'),

	y = get(zoomed(gf),'YData');
	y = y(:);

	i1 = zoomind(gf,1);
	i2 = zoomind(gf,2);

	if i1 > i2; t = i1; i1 = i2; i2 = t; end;

	y(i1:i2) = zeros(i2-i1+1,1);

	global SPC_COMMON;
	SPC_COMMON = y;

	% redraw line
	zoomrep(ga,y);

elseif strcmp(action,'mean'),

	t = getednbr(gf,'Mean');

	y = get(zoomed(gf),'YData');
	y = y(:);

	y = y - mean(y) + t;

	set(findedit(gf,'Mean'),'String',num2str(mean(y)));

	global SPC_COMMON;
	SPC_COMMON = y;

	% redraw line
	zoomrep(ga,y);

elseif strcmp(action,'volume'),

	mult = get(findslid(gcf,'Amplitude'),'Value') / 100;

	y = get(zoomed(gf),'YData');
	y = y(:);

	if get(findpopu(gf,'Amplitude'),'Value') == 1,
		y = mult * y;
	else,
		i1 = zoomind(gf,1);
		i2 = zoomind(gf,2);

		if i1 > i2; t = i1; i1 = i2; i2 = t; end;

		y(i1:i2) = y(i1:i2) * mult;

	end;

	global SPC_COMMON;
	SPC_COMMON = y;

	% redraw line
	zoomrep(ga,y);

elseif strcmp(action,'fs')

	% get line and recompute time scale
	y = get(zoomed(gf),'YData');
	xscale = (0:length(y)-1)/getpopvl(gf,'Sampling Freq');

	% redraw line
	zoomrep(ga,xscale,y);


elseif strcmp(action,'restore')

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

	xscale = (0:length(signal)-1)/getpopvl(gf,'Sampling Freq');

	zoomrep(ga,xscale(:),signal(:));

elseif strcmp(action,'common')

	global SPC_COMMON;

	if min(size(SPC_COMMON)) ~= 1 | length(SPC_COMMON) < 2,
		msg = 'Invalid common vector! (it''s scalar or a matrix or empty)';
		spcwarn(msg,'OK');
		set(gf,'Pointer','arrow');
		return;
	end;

	y = SPC_COMMON;
	xscale = (0:(length(y)-1))/getpopvl(gcf,'Sampling Freq');

	zoomrep(ga,xscale,y);

else
	error('sigedcal: Invalid action requested.');
end;

set(gf,'Pointer','arrow');
