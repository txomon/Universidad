function crsrup
%CRSRUP	Move cursor on mouse button up.
%
%	See also CRSRDOWN, CRSRUP

%	Dennis W. Brown 1-10-94
%	Copyright (c) 1994 by Dennis W. Brown
%	May be freely distributed.
%	Not for use in commercial products.

% can do this since user has click on line to activate, making
%   it the current figure
gf = gcf;
me = get(gf,'CurrentObject');
ga = get(me,'Parent');

% change pointer to indicate it can't be moved
set(gf,'Pointer','arrow');

% global which live while mouse button down
global crsr_h crsr_lim crsr_callback crsr_name crsr_dir crsr_lim

% Obtain coordinates of mouse click location in axes units
pt = get(ga,'Currentpoint');
if crsr_dir,
	t = pt(1,1);
else
	t = pt(1,2);
end;

% check to see if move will go past axis limits
if t <= crsr_lim(1), t = crsr_lim(1); end;
if t >= crsr_lim(2), t = crsr_lim(2); end;

% setup for mouse movement or release
set(gf,'WindowButtonMotionFcn','');
set(gf,'WindowButtonUpFcn','');

if crsr_dir == 1,		% vertical cursor

	% actually move the damn thing
	set(crsr_h,'XData',[t t]);

else,				% horizontal cursor

	% actually move the damn thing
	set(crsr_h,'YData',[t t]);
end;

% do callback
if ~isempty(crsr_callback),
	eval(crsr_callback);
end;

% globals which live while mouse button down
clear global crsr_h crsr_lim crsr_callback crsr_name crsr_dir crsr_lim


