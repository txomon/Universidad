function zoompan(action,arg1,arg2)
%SCROLL  Script to test scrolling signal display.
% Dennis W. Brown
% Naval Postgraduate School, Monterey, CA


% current values
gf = gcf;
ga = findaxes(gf,'zoomtool');
if isempty(ga),
	ga = get(gf,'CurrentAxes');
end;

if strcmp(action,'start'),

	set(gf,'Pointer','watch');

	handles = get(finduitx(gf,'zoomtool'),'UserData');

	% turn off as many propeties as possible in an attempt to optimize speed
	set(ga,'Visible','off','DrawMode','fast');
	set(ga,'XLimMode','manual','YLimMode','manual','ZLimMode','manual');
	set(ga,'XTickMode','manual','YTickMode','manual','ZTickMode','manual');
	set(ga,'XTickLabelMode','manual','YTickLabelMode','manual',...
	'ZTickLabelMode','manual');
	set(ga,'Box','off','CLimMode','manual','Clippin','off');
	set(get(ga,'title'),'Visible','off');
	set(get(ga,'xlabel'),'Visible','off');
	set(get(ga,'ylabel'),'Visible','off');

	global SPC_PAN SPC_PAN_COLOR SPC_PAN_BACK
	SPC_PAN = 1;
	SPC_PAN_COLOR = get(zoomed(gf),'Color');
	SPC_PAN_BACK = get(gf,'Color');
	set(handles(39),'Color',[1 1 1]);
	set(gf,'Color',[0 0 0]);

	set(handles(24),'Visible','off');
	set(handles(25),'Visible','off');
	set(handles(26),'Visible','off');
	set(handles(27),'Visible','off');

	set(gf,'Pointer','arrow');

elseif strcmp(action,'left'),

	zoompan('start');

	handles = get(finduitx(gf,'zoomtool'),'UserData');

	% turn other button off so user can't interrupt
	set(handles(11),'Enable','off');

	figure(gcf);

	% get some data about the current axes state
	% axis data
	xfactor = handles(28);
	xmin = handles(33);
	xmax = handles(34);
	ymin = handles(35);
	ymax = handles(36);
	set(ga,'YLim',[ymin ymax]);
	xxlim = get(ga,'Xlim');

	global SPC_PAN;
	SPC_PAN = 1;

	xlim = get(gca,'Xlim');
	win = xlim(2)-xlim(1)+xfactor;
	step = .2*win;

	for k = xxlim(1):step:xmax-win,

		if SPC_PAN == 0, break; end;

		set(ga,'xlim',[k k+win]);
		drawnow;
	end;

	% turn other button on
	set(handles(11),'Enable','on');

	if SPC_PAN == 1,

		set(ga,'XLim',[xmax-win+xfactor xmax]);
	end;

	zoompan('stop');

elseif strcmp(action,'right'),

	zoompan('start');

	figure(gcf);

	handles = get(finduitx(gf,'zoomtool'),'UserData');

	% turn other button off so user can't interrupt
	set(handles(10),'Enable','off');

	% get some data about the current axes state
	% axis data
	xfactor = handles(28);
	xmin = handles(33);
	xmax = handles(34);
	ymin = handles(35);
	ymax = handles(36);
	delta = .05 * (ymax-ymin);
	set(ga,'YLim',[ymin-delta ymax+delta]);
	xxlim = get(ga,'Xlim');

	global SPC_PAN;
	SPC_PAN = 1;

	xlim = get(gca,'Xlim');
	win = xlim(2)-xlim(1)+xfactor;
	step = -0.2*win;

	for k = xxlim(2):step:xmin+win,

		if SPC_PAN == 0, break; end;

		set(ga,'xlim',[k-win k]);
		drawnow;
	end;

	% turn other button on
	set(handles(10),'Enable','on');

	if SPC_PAN == 1,

		set(ga,'XLim',[xmin xmin+win-xfactor]);
	end;

	zoompan('stop');

elseif strcmp(action,'stop'),

	set(gf,'Pointer','watch');

	handles = get(finduitx(gf,'zoomtool'),'UserData');

	% turn on the propeties we turned off
	set(ga,'Visible','on','DrawMode','fast');
	set(ga,'XLimMode','manual','YLimMode','manual','ZLimMode','auto');
	set(ga,'XTickMode','auto','YTickMode','auto','ZTickMode','auto');
	set(ga,'XTickLabelMode','auto','YTickLabelMode','auto',...
	'ZTickLabelMode','auto');
	set(ga,'Box','on','CLimMode','auto','Clippin','on');
	set(get(ga,'title'),'Visible','on');
	set(get(ga,'xlabel'),'Visible','on');
	set(get(ga,'ylabel'),'Visible','on');

	% turn cursors back on
	set(handles(24),'Visible','on');
	set(handles(26),'Visible','on');

	% make sure horiz cursors were visible before, if so, turn back on
	if strcmp(get(finduitx(gf,'Y - - -'),'Visible'),'on'),
		set(handles(25),'Visible','on');
		set(handles(27),'Visible','on');
	end;

	global SPC_PAN_COLOR SPC_PAN_BACK
	set(handles(39),'Color',SPC_PAN_COLOR);
	set(gf,'Color',SPC_PAN_BACK);
	clear global SPC_PAN SPC_PAN_COLOR SPC_PAN_BACK

	xfactor = handles(28);
	xmin = handles(33);
	xxlim = get(ga,'XLim');
	xind = round((xxlim - xmin) / xfactor) + 1;
	ylen = handles(34);

	newx = get(handles(39),'Xdata');
	newy = get(handles(39),'Ydata');

	% adjust readouts and move cursors
	i1 = xind(1); %+fix((xind(2)-xind(1))/4);
	i2 = xind(2); %+3*fix((xind(2)-xind(1))/4);
	cv1 = newx(i1);
	ch1 = newy(i1);
	cv2 = newx(i2);
	ch2 = newy(i2);
	set(handles(18),'String',num2str(cv1));
	set(handles(19),'String',num2str(cv1));
	set(handles(20),'String',num2str(abs(cv2-cv1)));
	set(handles(21),'String',num2str(abs(ch2-ch1)));
	set(handles(22),'String',num2str(cv2));
	set(handles(23),'String',num2str(ch2));
	set(handles(24),'XData',[cv1 cv1]);
	set(handles(25),'YData',[ch1 ch1]);
	set(handles(26),'XData',[cv2 cv2]);
	set(handles(27),'YData',[ch2 ch2]);

	% get zoomxful limits
	stack = get(handles(3),'UserData');

	% store in place of zoomxout stack
	set(handles(2),'UserData',stack);		% ZxO

	set(gf,'Pointer','arrow');

elseif strcmp(action,'page'),

	figure(gcf);

	% get some data about the current axes state
	% axis data
	zoom = get(finduitx(gf,'zoomtool'),'UserData');
	xfactor = zoom(28);
	xmin = zoom(33);
	xmax = zoom(34);
	ymin = zoom(35);
	ymax = zoom(36);
	xxlim = get(ga,'Xlim');

	global SPC_PAN;
	SPC_PAN = 1;

	xlim = get(gca,'Xlim');
	win = xlim(2)-xlim(1)+xfactor;
	if strcmp(arg1,'left'),
		step = .2*win;
	else,
		step = -0.2*win;
	end;

	xxlim = xxlim + step;

	if xxlim(1) < xmin,
		xxlim = [xmin xmin+win-xfactor];
	end;

	if xxlim(2) > xmax,
		xxlim = [xmax-win+xfactor xmax];
	end;

	set(ga,'xlim',xxlim);
	zoomset(ga,1,xxlim(1));
	zoomset(ga,2,xxlim(2));
	zoomxin(gf);
%	zoomyin(gf);

	% get zoomxful limits
	h = get(finduitx(gf,'zoomtool'),'UserData');
	zout = h(3);				% ZxF
	stack = get(zout,'UserData');

	% store in place of zoomxout stack
	set(h(2),'UserData',stack);		% ZxO

	set(gf,'Pointer','arrow');

end;
