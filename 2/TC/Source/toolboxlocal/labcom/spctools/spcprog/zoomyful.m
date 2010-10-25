function zoomyful(gf,callback)
%ZOOMYFUL	Zoom full the Y-axis.
%       ZOOMYFUL(H) where H is the figure ZOOMTOOL is active in.
%
%       ZOOMYFUL(H,'CALLBACK') evaluates 'CALLBACK' after
%       zoom action.
%
%       Note: ZOOMYFUL is called after a "[ ]" push button event.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%       	ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%       	ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%       	ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


handles = get(finduitx(gf,'zoomtool'),'UserData');
ga = handles(40);

% get zoomyful limits
zout = handles(6);				% ZxF
stack = get(zout,'UserData');

% check for empty stack
if isempty(stack), return; end;

% store in place of zoomxout stack
set(handles(5),'UserData',stack);		% ZxO

% call zoomxout
if nargin == 1,
	zoomyout(gf);
else,
	zoomyout(gf,callback);
end;

