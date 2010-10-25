function zoomxful(gf,callback)
%ZOOMXFUL	Zoom X-axis to full limits.
%       ZOOMXFUL(H) where H is the figure ZOOMTOOL is active in.
%
%       ZOOMXFUL(H,'CALLBACK') evaluates 'CALLBACK' after
%       zoom action.
%
%       Note: ZOOMXFUL is called after a "[ ]" push button event.
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


% get zoomxful limits
zout = handles(3);				% ZxF
stack = get(zout,'UserData');

% check for empty stack
if isempty(stack), return; end;

% store in place of zoomxout stack
set(handles(2),'UserData',stack);		% ZxO

% turn off visibility of pan controls
set(handles(10),'Visible','off');
set(handles(11),'Visible','off');
set(handles(12),'Visible','off');
set(handles(13),'Visible','off');
set(handles(14),'Visible','off');

% call zoomxout
if nargin == 1,
	zoomxout(gf);
else
	zoomxout(gf,callback);
end;
