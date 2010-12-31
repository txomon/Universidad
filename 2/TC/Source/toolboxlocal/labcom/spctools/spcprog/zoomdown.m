function zoomdown(callback)
%ZOOMDOWN Button down callback.
%       ZOOMTOOL moves the nearest ZOOMTOOL cursor to mouse
%       pointer on a ButtonDown event associated with
%       currently "zoomed" line object.
%
%       ZOOMDOWN('CALLBACK') evaluates CALLBACK
%       string after a cursor movement.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 1-10-94, DWB 3-1-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% current values
gf = gcf;

% global which live while mouse button down
global zoom_y zoom_cursor zoom_handles zoom_callback zoom_xxlim zoom_cvb zoom_chb

zoom_handles = get(finduitx(gf,'zoomtool'),'UserData');
ga = zoom_handles(40);

if nargin == 1,
	zoom_callback = callback;
else
	zoom_callback = '';
end;

% get some data about the current axes state
zoom_xfactor = zoom_handles(28);
zoom_xmin = zoom_handles(33);
zoom_xxlim = get(ga,'Xlim');

% Obtain coordinates of mouse click location in axes units
pt = get(ga,'Currentpoint');
t = pt(1,1);

% check to see if move will go past axis limits
if t <= zoom_xxlim(1)+100*eps, return; end;
if t >= zoom_xxlim(2)-100*eps, return; end;

% current index
k = round((t - zoom_xmin) / zoom_xfactor) + 1;

% get line data
zoom_y = get(zoom_handles(39),'YData');

% setup for mouse movement or release
set(gf,'WindowButtonMotionFcn', 'zoommove;');
set(gf,'WindowButtonUpFcn', 'zoomup');

% current point locations
cv = (k-1) * zoom_xfactor + zoom_xmin;
ch = zoom_y(k);

% find closest vertical cursor to mouse click location
c1 = get(zoom_handles(24),'XData');
c2 = get(zoom_handles(26),'XData');
if abs(cv - c1) < abs(cv - c2)
	zoom_cursor = 1;
	set(zoom_handles(24),'XData',[cv cv]);
	set(zoom_handles(25),'YData',[ch ch]);
	set(zoom_handles(18),'String',num2str(cv));
	set(zoom_handles(19),'String',num2str(ch));
	zoom_cvb = get(zoom_handles(26),'XData'); zoom_cvb = zoom_cvb(1);
	zoom_chb = get(zoom_handles(27),'YData'); zoom_chb = zoom_chb(1);
else
	zoom_cursor = 2;
	set(zoom_handles(26),'XData',[cv cv]);
	set(zoom_handles(27),'YData',[ch ch]);
	set(zoom_handles(22),'String',num2str(cv));
	set(zoom_handles(23),'String',num2str(ch));
	zoom_cvb = get(zoom_handles(24),'XData'); zoom_cvb = zoom_cvb(1);
	zoom_chb = get(zoom_handles(25),'YData'); zoom_chb = zoom_chb(1);
end;


