function [p] = zoomloc(gf,cursor)
%ZOOMLOC  Return ZOOMTOOL cursor location.
%       [P] = ZOOMLOC(H,CURSOR) returns a 2 element vector 
%       containing the x- and y-axis locations of the ZOOMTOOL
%       cursor specified by CURSOR.  CURSOR can be either 1 or 2.
%       P = [x-pos y-pos].  H is the handle of the figure ZOOMTOOL
%       is active in.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 1-26-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if nargin < 1 | nargin > 2,
	error('zoomloc: Invalid number of input arguments.');
end

if nargin == 1,
	cursor = gf;
	gf = gcf;
end;

handles = get(finduitx(gf,'zoomtool'),'UserData');
ga = handles(40);

% get cursor location
if cursor == 1,
	cv = get(handles(24),'XData');
	ch = get(handles(25),'YData');
	p = [cv(1) ch(1)];
elseif cursor == 2,
	cv = get(handles(26),'XData');
	ch = get(handles(27),'YData');
	p = [cv(1) ch(1)];
else
	p = [];
	error('zoomloc: Invalid cursor number.');
end;

