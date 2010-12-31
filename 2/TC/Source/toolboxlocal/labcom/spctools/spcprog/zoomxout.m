function zoomxout(gf,callback)
%ZOOMXOUT	Zoom out the X-axis.
%       ZOOMXOUT(H) where H is the figure ZOOMTOOL is active in.
%
%       ZOOMXOUT(H,'CALLBACK') evaluates 'CALLBACK' after
%       zoom action.
%
%       Note: ZOOMXOUT is called after a "< >" push button event.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% current values
handles = get(finduitx(gf,'zoomtool'),'UserData');
ga = handles(40);

% get zoomxout stack
zout = handles(2);			% ZxO
stack = get(zout,'UserData');

% check for empty stack
if isempty(stack), return; end;

% pop last from stack
[m,n] = size(stack);
v1 = stack(m,1);
v2 = stack(m,2);
stack = stack(1:m-1,:);
set(zout,'UserData',stack);

% set new x limits
set(ga,'XLim',[v1 v2]);

% adjust horizontal cursor lengths
set(handles(25),'XData',[v1 v2]);
set(handles(27),'XData',[v1 v2]);

% turn on pan button is pan on
pan = get(handles(10),'UserData');
if strcmp(pan,'on'),

	% axis data
	handles = get(finduitx(gf,'zoomtool'),'UserData');
	xmin = handles(33);
	xmax = handles(34);

	if abs(v1-xmin) < 100*eps,

		% can't zoom right
		set(handles(11),'Visible','off');
		set(handles(14),'Visible','off');
	else
		set(handles(11),'Visible','on');
		set(handles(14),'Visible','on');
	end;

	if abs(v2-xmax) < 100*eps,

		% can't zoom right
		set(handles(10),'Visible','off');
		set(handles(13),'Visible','off');
	else
		set(handles(10),'Visible','on');
		set(handles(13),'Visible','on');
	end;

	if v1 == xmin & v2 == xmax,
		set(handles(12),'Visible','off');
	else,
		set(handles(12),'Visible','on');
	end;
end;

if nargin == 2,
	eval(callback);
end;
