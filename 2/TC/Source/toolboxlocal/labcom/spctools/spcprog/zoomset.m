function zoomset(ga,arg2,loc,callback)
%ZOOMSET Move specified ZOOMTOOL cursor.
%       ZOOMSET(H,CURSOR,LOCATION) moves the specified CURSOR
%       (1 or 2) to LOCATION.  If LOCATION is beyond the axes
%       limits, move cursor to limit.
%
%       ZOOMSET(H,CURSOR) where H is the axis ZOOMTOOL is
%       active in and CURSOR is the cursor number (1 or 2) or
%       the Delta X edit box (3).
%
%       ZOOMSET(H,CURSOR,'CALLBACK') or
%       ZOOMSET(H,CURSOR,LOCATION,'CALLBACK') evaluates
%       'CALLBACK' function after cursor movement.
%
%       Note: ZOOMSET is called after a ZOOMTOOL edit box event.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

gf = get(ga,'Parent');

% get some data about the current axes state
handles = get(finduitx(gf,'zoomtool'),'UserData');
xfactor = handles(28);
xmin = handles(33);
xmax = handles(34);
xxlim = get(ga,'Xlim');

% handles to readouts
handles = get(finduitx(gf,'zoomtool'),'UserData');

if nargin == 3,
	if isstr(loc),
		option = 2;
		callback = loc;
	else
		option = 1;
	end;
end;

if option == 1
	if arg2 == 1,
		set(handles(18),'String',num2str(loc));
	elseif arg2 == 2,
		set(handles(22),'String',num2str(loc));
	else
		error('zoomset: Invalid cursor number.');
	end;
end;

if arg2 == 1

	t = eval(get(handles(18),'String'));
	cursor = 1;

elseif arg2 == 2,

	t = eval(get(handles(22),'String'));
	cursor = 2;

elseif arg2 == 3,

	t = eval(get(handles(18),'String')) + ...
	        eval(get(handles(20),'String'));
	cursor = 2;

end;

% check to see if move will go past data
if t <= xmin+100*eps, t = xmin; end;
if t >= xmax-100*eps, t = xmax; end;

% calculate current index
k = round((t - xmin) / xfactor) + 1;

% get line data
y = get(handles(39),'YData');

% current point locations
cv = (k-1) * xfactor + xmin;
ch = y(k);


% move cursor to mouse click location
if cursor == 1,
	set(handles(24),'XData',[cv cv]);
	set(handles(25),'YData',[ch ch]);
	set(handles(18),'String',num2str(cv));
	set(handles(19),'String',num2str(ch));
	cvb = get(handles(26),'XData'); cvb = cvb(1);
	chb = get(handles(27),'YData'); chb = chb(1);
else
	set(handles(26),'XData',[cv cv]);
	set(handles(27),'YData',[ch ch]);
	set(handles(22),'String',num2str(cv));
	set(handles(23),'String',num2str(ch));
	cvb = get(handles(24),'XData'); cvb = cvb(1);
	chb = get(handles(25),'YData'); chb = chb(1);
end;

% adjust delta readouts
set(handles(20),'String',num2str(abs(cvb-cv)));
set(handles(21),'String',num2str(abs(chb-ch)));

% if beyond current limits, let zoomxin take over
if t < xxlim(1) | t > xxlim(2),

	zoomxin(gf);

	% zoomcallback
	call = get(finduitx(gf,'X'),'UserData');
	if ~isempty(call),
		eval(call);
	end;
end;

if exist('callback') == 1,
	eval(callback);
end;
