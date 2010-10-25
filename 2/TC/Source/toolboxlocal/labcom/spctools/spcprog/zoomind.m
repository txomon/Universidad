function [i] = zoomind(gf,cursor)
%ZOOMIND  Return ZOOMTOOL cursor location.
%       [I] = ZOOMIND(H,CURSOR) returns the index of the into
%       the line the cursors are attached to. CURSOR can be
%       either 1 or 2.  H is the handle of the figure ZOOMTOOL
%       is active in.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT ZOOMLOC

%       Dennis W. Brown 1-29-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if nargin < 1 | nargin > 2,
	error('zoomind: Invalid number of input arguments.');
end

if nargin == 1,
	cursor = gf;
	gf = gcf;
end;

handles = get(finduitx(gf,'zoomtool'),'UserData');
ga = handles(40);

% get cursor location
if cursor == 1,
	x = get(handles(24),'XData'); x = x(1);
elseif cursor == 2,
	x = get(handles(26),'XData'); x = x(1);
else
	i = [];
	error('zoomind: Invalid cursor number.');
end;

% get some data about the current axes state
zoom_xfactor = handles(28);
zoom_xmin = handles(33);


% current index
i = round((x - zoom_xmin) / zoom_xfactor) + 1;

