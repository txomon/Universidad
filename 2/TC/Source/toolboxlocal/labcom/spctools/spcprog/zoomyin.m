function zoomyin(gf,callback)
%ZOOMYIN	Zoom in the Y-axis.
%       ZOOMYIN(H) where H is the figure ZOOMTOOL is active in.
%
%       ZOOMYIN(H,'CALLBACK') evaluates 'CALLBACK' after
%       zoom action.
%
%       Note: ZOOMYIN is called after a "> <" push button event.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

handles = get(finduitx(gf,'zoomtool'),'UserData');
ga = handles(40);

% get some data about the current axes state
xfactor = handles(28);
xmin = handles(33);
xxlim = get(ga,'Xlim');
xlim = (xxlim - xmin) / xfactor + 1;

% get old y limits
ylim = get(ga,'YLim');

% store old on zoomyout stack
handles = get(finduitx(gf,'zoomtool'),'UserData');
zout = handles(5);				% ZyO
stack = get(zout,'UserData');
stack = [stack ; ylim];
set(zout,'UserData',stack);

% set new y limits
y = get(handles(39),'YData');
ymin = min(y(xlim(1):xlim(2)));
ymax = max(y(xlim(1):xlim(2)));
ylim = [ymin ymax];
delta = (ymax - ymin) * 0.05;
ylim(1) = ymin - delta;
ylim(2) = ymax + delta;
set(ga,'YLim',ylim);

% adjust vertical cursor lengths
set(handles(24),'YData',ylim);
set(handles(26),'YData',ylim);

if nargin == 2,
	eval(callback);
end;
