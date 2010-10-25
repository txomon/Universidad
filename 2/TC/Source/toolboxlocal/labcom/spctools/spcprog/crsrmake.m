function h = crsrmake(ax,name,dir,posit,ltype,callback)
%CRSRMAKE Create axes crsr.
%       H=CRSRMAKE(AXES,'NAME','DIRECTION',POSITION,'LINETYPE')
%       creates a cursor on the axes pointed to by the handle
%       axes. If not handle is provided, the current axes is
%       used. 'NAME' is a unique identifier for the cursor and
%       is used to reference the cursor during subsequent cursor
%       operations. 'direction' can be either 'horizontal' or
%       'vertical'. POSITION is a scalar number of where the
%       cursor is to be located (x-axis location for 'vertical'
%       cursors, y-axis location for 'horizontal' cursors).
%       'LINETYPE' is any valid MATLAB linetype. An error occurs
%       if a cursor is created beyond the limits of the axes.
%
%       H=CRSRMAKE(AXES,'NAME','DIRECTION',POSITION,'LINETYPE',...
%		'CALLBACK') enables the cursor being dragged with
%	the mouse.  The 'CALLBACK' string will be executed upon
%	release of the mouse button.  A null callback string allows
%	the cursor to be dragged with no action taken when the
%	mouse button is released.
%
%       See also CRSRMOVE, CRSRDEL, CRSRON, CRSROFF

%       Dennis W. Brown 1-10-94, DWB 5-6-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% get current axis data
x = get(ax,'XLim');
y = get(ax,'YLim');

% make axes current and get color of figure ('xor' depends on figure color)
axes(ax);
if strcmp(computer,'SUN4'),
	kolor = get(get(ax,'Parent'),'Color');
	kolor = abs(1-kolor);
else,
	kolor = get(ax,'Color');
	if isstr(kolor),
		kolor = get(get(ax,'Parent'),'Color');
		kolor = abs(1-kolor);
	end;
end;

% draw the crsr
if strcmp(dir,'vertical'),

	% check the location
	if posit < x(1) | posit > x(2),
		error('crsrmake: Cursor location out of axes range...');
	end;

	% actually draw the damn thing
	h = line('Erasemode','xor','LineStyle',ltype,...
		'Xdata',[posit posit],'Ydata',y,...
		'Userdata',name);
	set(h,'Color',kolor);

elseif strcmp(dir,'horizontal'),

	% check the location
	if posit < y(1) | posit > y(2),
		error('crsrmake: Cursor location out of axes range...');
	end;

	% actually draw the damn thing
	h = line('Erasemode','xor','LineStyle',ltype,...
		'Xdata',x,'Ydata',[posit posit],...
		'Userdata',name);
	set(h,'Color',kolor);

else
    error('crsrmake: Invalid cursor direction...');
end;


% set callback if given
if nargin == 6,
	% note need double any single quotes in callback
	set(h,'ButtonDownFcn',['crsrdown(''' dblquote(callback) ''');' ]);
end;
