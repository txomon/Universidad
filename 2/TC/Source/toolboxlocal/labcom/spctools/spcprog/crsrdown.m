function crsrdown(callback)
% CRSRDOWN Drag cursor.
%	CRSRDOWN initiates cursor drap.
%
%	CRSRDOWN('CALLBACK') evaluates CALLBACK string after
%	mouse button is released.
%
%       See also CRSRMMOV, CRSRUP

%       Dennis W. Brown 2-5-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% current values
gf = gcf;
me = get(gf,'CurrentObject');
ga = get(me,'Parent');

% global which live while mouse button down
global crsr_h crsr_xxlim crsr_callback crsr_name crsr_dir crsr_lim

if nargin == 1,
	crsr_callback = callback;
else
	crsr_callback = '';
end;

% change pointer to indicate it can be moved
set(gf,'Pointer','fleur');

% Obtain coordinates of mouse click location in axes units
pt = get(ga,'Currentpoint');
t = pt(1,1);

% handle to cursor
crsr_h = get(gf,'CurrentObject');

% get current axis data
x = get(ga,'XLim');
y = get(ga,'YLim');

% determine cursor direction;
xdat = get(crsr_h,'XData');
if xdat(1) == xdat(2),
	crsr_dir = 1;		% vertical cursor
	crsr_lim = get(ga,'XLim');
	t = pt(1,1);
	set(crsr_h,'YData',y);
else
	crsr_dir = 0;		% horizontal cursor
	crsr_lim = get(ga,'YLim');
	t = pt(1,2);
	set(crsr_h,'Xdata',x);
end;

% get cursor name
crsr_name = get(crsr_h,'UserData');

% check to see if move will go past axis limits
crsr_xxlim = get(ga,'Xlim');
if t <= crsr_lim(1), t=crsr_lim(1); end;
if t >= crsr_lim(2), t=crsr_lim(2); end;

% setup for mouse movement or release
set(gf,'WindowButtonMotionFcn', 'crsrmmov;');
set(gf,'WindowButtonUpFcn', 'crsrup');

% move cursor to point
if crsr_dir == 1,		% vertical cursor

	% actually move the damn thing
	set(crsr_h,'XData',[t t]);

else,				% horizontal cursor

	% actually move the damn thing
	set(crsr_h,'YData',[t t]);
end;


