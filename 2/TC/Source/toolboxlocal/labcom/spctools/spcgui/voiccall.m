function voiccall(action,arg1,arg2)
%VOICCALL Callback functions for SIGEDIT
%	VOICCALL('ACTION',ARG1,ARG2) performs the specified
%	callback 'ACTION'.  Valid actions are:
%
%		plottime	- Initial plot
%		zero		- Zero vector between cursors
%		mean		- Adjust signal mean
%		volume		- Adjust signal amplitude
%		fs		- Change signal sampling frequency
%		restore		- Restore original signal
%		common		- Load SPC_COMMON vector
%		redo		- Redraw signal and short-time curves
%				  after edit operations
%		zoom		- Redraw short-time curves after
%				  zooming time-domain signal
%		setcur		- Set time-domain cursor after
%				  moving short-time cursors
%		cusors		- Set short-time cursors after
%				  moving time-domain cursors
%
%	See also VOICEDIT, VOICSAVE, VOICLOAD

%       Dennis W. Brown 3-93, DWB 2-21-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

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

	global SPC_LINE

	plot(ve_tscale',arg1,SPC_LINE);

	spcaxes(ga);
	spcxlabl(ga,'Time (seconds)');
	spcylabl(ga,'Amplitude');

	zoomtool(ga,'QuitButton','off','HorizontalCursors','off', ...
		'CursorCallBack','voiccall(''cursor'');', ...
		'ZoomCallBack','voiccall(''zoom'');',...
		'Pan','off');
	zoomedit(gf,'callback','voiccall(''redo'');');
	zoomplay(gf,fs);
	zoomprog(gf);
	zoomfilt(gf,'CallBack','voiccall(''common'');');

	p = get(ga,'Position');
	th = findaxes(gf,'speech');
	pp = get(th,'Position');
	pp(3) = p(3);
	set(th,'Position',pp);
	set(gf,'Nextplot','add');

	% colors for short-time curves
	global SPC_ST_ENG SPC_ST_MAG SPC_ST_ZCR

	% compute short-time traces
	frame = str2num(get(getcheck(gf,'Frame'),'Label')) / 1000;
	overlap = str2num(get(getcheck(gf,'Overlap'),'Label'));
	if ischeckd(gf,'Short-Time','Energy'),
		[ye,tscale] = sp_steng(arg1,frame,overlap,fs);
		st_em_color = SPC_ST_ENG;
	else,
		[ye,tscale] = sp_stmag(arg1,frame,overlap,fs);
		st_em_color = SPC_ST_MAG;
	end;
	yz = [];
	if ischeckd(gf,'Short-Time','Zero-Crossings'),
		[yz,tscale] = sp_stzcr(arg1,frame,overlap,fs);
	end;
	smlen = str2num(get(getcheck(gf,'Smoothing',2),'Label'));
	if ischeckd(gf,'Smoothing','Average'),
		ye = avsmooth(ye,smlen);
		if ~isempty(yz),
			yz = avsmooth(yz,smlen);
		end;
	elseif ischeckd(gf,'Smoothing','Median'),
		ye = mdsmooth(ye,smlen);
		if ~isempty(yz),
			yz = mdsmooth(yz,smlen);
		end;
	end;

	axes(th);
	set(th,'NextPlot','replace');

	ye = ye/max(ye);
	if ~isempty(yz),
		yz = yz/max(yz);
		lin = plot(tscale,ye,st_em_color,tscale,yz,SPC_ST_ZCR);
	else
		lin = plot(tscale,ye,st_em_color);
	end;

	set(lin(1),'UserData','eng');
	set(lin(2),'UserData','zcr');
	spcaxes(th);
	set(th,'XLim',get(ga,'XLim'),'UserData','speech');
	spctitle(th,'Short-time Energy and Zero Crossings');

	p1 = zoomloc(gf,1); p1 = p1(1);
	p2 = zoomloc(gf,2); p2 = p2(1);

	crsrmake(th,'sp1','vertical',p1,'--','voiccall(''setcur'',1)');
	crsrmake(th,'sp2','vertical',p2,'-.','voiccall(''setcur'',2)');

	axes(ga);

elseif strcmp(action,'redo'),

	% get short-time axis
	th = findaxes(gf,'speech');

	% get time line
	timeline = get(zoomed(gf),'YData');
	fs = getpopvl(gf,'Sampling Freq');

	% colors for short-time curves
	global SPC_ST_ENG SPC_ST_MAG SPC_ST_ZCR

	% compose title string
	titstr = 'Short-time ';

	% compute short-time traces
	frame = str2num(get(getcheck(gf,'Frame'),'Label')) / 1000;
	overlap = str2num(get(getcheck(gf,'Overlap'),'Label'));
	if ischeckd(gf,'Short-Time','Energy'),
		[ye,tscale] = sp_steng(timeline,frame,overlap,fs);
		st_em_color = SPC_ST_ENG;
		titstr = [titstr 'Energy'];
	else,
		[ye,tscale] = sp_stmag(timeline,frame,overlap,fs);
		st_em_color = SPC_ST_MAG;
		titstr = [titstr 'Magnitude'];
	end;
	yz = [];
	if ischeckd(gf,'Short-Time','Zero-Crossings'),
		[yz,tscale] = sp_stzcr(timeline,frame,overlap,fs);
		titstr = [titstr ' and Zero-Crossings'];
	end;
	smlen = str2num(get(getcheck(gf,'Smoothing',2),'Label'));
	if ischeckd(gf,'Smoothing','Average'),
		ye = avsmooth(ye,smlen);
		if ~isempty(yz),
			yz = avsmooth(yz,smlen);
		end;
	elseif ischeckd(gf,'Smoothing','Median'),
		ye = mdsmooth(ye,smlen);
		if ~isempty(yz),
			yz = mdsmooth(yz,smlen);
		end;
	end;

	% delete old lines
	axes(th);
	delete(findline(th,'eng'));
	delete(findline(th,'zcr'));


	% make new lines
	ye = ye/max(ye);
	line('XData',tscale,'YData',ye,'UserData','eng','Color',st_em_color);
	if ~isempty(yz),
		yz = yz/max(yz);
	   line('XData',tscale,'YData',yz,'UserData','zcr','Color',SPC_ST_ZCR);
	end;

	title(titstr);

	% reset cursor positions
	p1 = zoomloc(gf,1); p1 = p1(1);
	p2 = zoomloc(gf,2); p2 = p2(1);
	crsrmove(th,'sp1',p1);
	crsrmove(th,'sp2',p2);

	% align axes
	set(th,'XLim',get(ga,'XLim'));
	axes(ga);

elseif strcmp(action,'zoom'),

	th = findaxes(gf,'speech');
	set(th,'XLim',get(ga,'XLim'));
	axes(ga);

elseif strcmp(action,'setcur'),

	% get cursor postion from speech info axis
    	th = findaxes(gf,'speech');
	x = crsrloc(th,['sp' int2str(arg1)]);

	% set the cursor on signal axis
	zoomset(ga,arg1,x);

	% align speech cursor with a datapoint in the vector
	x = zoomloc(gf,arg1);
	crsrmove(th,['sp' int2str(arg1)],x(1));

elseif strcmp(action,'cursor'),

	th = findaxes(gf,'speech');
	set(th,'XLim',get(ga,'XLim'));
	p1 = zoomloc(gf,1); p1 = p1(1);
	p2 = zoomloc(gf,2); p2 = p2(1);

	crsrmove(th,'sp1',p1);
	crsrmove(th,'sp2',p2);

	axes(ga);

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

	% redraw speech lines
	voiccall('redo');

elseif strcmp(action,'mean'),

	t = getednbr(gf,'Mean');

	y = get(zoomed(gf),'YData');
	y = y(:);

	y = y - mean(y) + t;

	set(findedit(gf,'Mean'),'String',num2str(mean(y)));

	ga = gca;

	global SPC_COMMON;
	SPC_COMMON = y;

	% redraw line
	zoomrep(ga,y);

	% redraw speech lines
	voiccall('redo');

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

	% redraw speech lines
	voiccall('redo');

elseif strcmp(action,'fs')

	% get line and recompute time scale
	y = get(zoomed(gf),'YData');
	xscale = (0:length(y)-1)/getpopvl(gf,'Sampling Freq');

	% redraw line
	zoomrep(ga,xscale,y);

	% redraw speech lines
	voiccall('redo');

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

	zoomrep(ga,xscale,signal);

	voiccall('redo');

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

	voiccall('redo');

elseif strcmp(action,'snapall'),

	% find curve axes
	ota = findaxes(gf,'speech');

	% make new figure
	nf = figure;

	% make axes for plots
	ta = axes('Units','normal','Position',...
		[0.1300    0.1100    0.7750    0.5050]);
	ca = axes('Units','normal','Position',...
		[0.1300    0.7600    0.7750    0.1500]);

	new = [ta ca];
	old = [ga ota];

    for k=1:2,

	% copy visible lines from old axis to new
	h = get(old(k),'Children');
	axes(new(k));
	for i = 1:length(h),
		if strcmp(get(h(i),'Type'),'line') & ...
				strcmp(get(h(i),'Visible'),'on'),

			cid = get(h(i),'UserData');
			if ~isstr(cid),
				% don't copy cursors from zoomtool
				if ~(cid == 1001 | cid == 1002 | ...
					cid == 2001 | cid == 2002),
				plot(get(h(i),'XData'),get(h(i),'YData'), ...
					get(h(i),'LineStyle'));
				end;
			elseif ~strcmp(cid(1:2),'sp'),

				plot(get(h(i),'XData'),get(h(i),'YData'),...
				get(h(i),'LineStyle'));
			end;
			set(new(k),'NextPlot','add');
		end;
    	end;

	% set the limits to be the same
	set(new(k),'YLim',get(old(k),'YLim'));
	set(new(k),'XLim',get(old(k),'XLim'));
	set(new(k),'Box','on');

	% labels the same
	h = get(old(k),'Title');
	title(get(h,'String'));
	set(get(new(k),'title'),'Fontname',get(h,'Fontname'));

	h = get(old(k),'XLabel');
	xlabel(get(get(old(k),'XLabel'),'String'));
	set(get(new(k),'XLabel'),'Fontname',get(h,'Fontname'));

	h = get(old(k),'YLabel');
	ylabel(get(get(old(k),'YLabel'),'String'));
	set(get(new(k),'YLabel'),'Fontname',get(h,'Fontname'));
   end;

	figure(gf);

else
	error('voiccall: Invalid action requested.');
end;

set(gf,'Pointer','arrow');
