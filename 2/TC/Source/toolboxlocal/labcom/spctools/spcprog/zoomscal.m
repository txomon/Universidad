function zoomset(ga,arg1)
%ZOOMSCAL Switch between linear and logrithmic scaling.
%	ZOOMSET(H,'mode') switches the scaling of the axis
%	zoomtool is located in to mode 'linear' or mode
%	'log'arithmic.
%
%	ZOOMSET(H) switches scaling to the checked scaling
%	menu item ('Scale','Linear' or 'Logarithmic').
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 4-23-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

gf = get(ga,'Parent');

oldpoint = get(gf,'Pointer');
set(gf,'Pointer','watch');

% get handles to zoomtool uicontrols
handles = get(finduitx(gf,'zoomtool'),'UserData');
xfactor = handles(28);
xmin = handles(33);
ymax = handles(34);
xxlim = get(ga,'XLim');

% if no arg1 get menu, use it instead
if ischeckd(gf,'Scale','Linear'),
	arg1 = 'linear';
else,
	arg1 = 'log';
end;

% get handles to zoomtool line objects
hc = get(handles(16),'UserData');

newmax = [];
newmin = [];

if strcmp(arg1,'linear'),

	for i = 1:length(hc),

		% get y data
		y = get(hc(i),'YData');

		% make linear
		y = 10.^(y/20);

		% find 
		newmax = [newmax max(y)];
		newmin = [newmin min(y)];

		% replace y data
		set(hc(i),'YData',y);

	end;

	spcylabl(ga,'Power (W)');
else

	for i = 1:length(hc),

		% get y data
		y = get(hc(i),'YData');

		% make logarithmic
		y = 20*log10(y);

		% find 
		newmax = [newmax max(y)];
		newmin = [newmin min(y)];

		% replace y data
		set(hc(i),'YData',y);

	end;

	spcylabl(ga,'Power (dB)');
end;

% new extremes
newmax = max(newmax);
newmin = min(newmin);


% new handle data
handles(35) = newmin;
handles(36) = newmax;
set(finduitx(gf,'zoomtool'),'UserData',handles);

% set new y-limits
del = (handles(36) - handles(35)) * 0.05;
if del == 0, del == 1; end;
ylim = [newmin-del newmax+del];
set(ga,'YLim',ylim);

% adjust cursor lengths
set(handles(24),'YData',ylim);
set(handles(26),'YData',ylim);

% reset pointer
set(gf,'Pointer',oldpoint);
