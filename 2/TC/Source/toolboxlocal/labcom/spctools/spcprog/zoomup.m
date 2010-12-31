function zoomup
%ZOOMUP	Button up callback function.
%       ZOOMUP moves cursor grabbed by ZOOMDOWN to current 
%       mouse location and executes the cursor move callback
%       function if given in the call to ZOOMDOWN.
%
%       Note: ZOOMUP is called after a button up event after 
%       	ZOOMDOWN.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%       	ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%       	ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%       	ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% current values
gf = gcf;

% global which live while mouse button down
global zoom_y zoom_cursor zoom_handles zoom_xxlim zoom_callback
ga = zoom_handles(40);

% Obtain coordinates of mouse click location in axes units
pt = get(ga,'Currentpoint');
t = pt(1,1);

% check to see if move will go past axis limits
if t <= zoom_xxlim(1)+100*eps, t = zoom_xxlim(1); end;
if t >= zoom_xxlim(2)-100*eps, t = zoom_xxlim(2); end;

% current index
k = round((t - zoom_handles(33)) / zoom_handles(28)) + 1;

% setup for mouse movement or release
set(gf,'WindowButtonMotionFcn','');
set(gf,'WindowButtonUpFcn','');

% current point locations
cv = (k-1) * zoom_handles(28) + zoom_handles(33);
ch = zoom_y(k);

% move cursor to mouse click location
% move cursor to mouse click location
if zoom_cursor == 1,
	set(zoom_handles(24),'XData',[cv cv]);
	set(zoom_handles(25),'YData',[ch ch]);
	set(zoom_handles(18),'String',num2str(cv));
	set(zoom_handles(19),'String',num2str(ch));
	cvb = get(zoom_handles(26),'XData'); cvb = cvb(1);
	chb = get(zoom_handles(27),'YData'); chb = chb(1);
else
	set(zoom_handles(26),'XData',[cv cv]);
	set(zoom_handles(27),'YData',[ch ch]);
	set(zoom_handles(22),'String',num2str(cv));
	set(zoom_handles(23),'String',num2str(ch));
	cvb = get(zoom_handles(24),'XData'); cvb = cvb(1);
	chb = get(zoom_handles(25),'YData'); chb = chb(1);
end;

% adjust delta readouts
set(zoom_handles(20),'String',num2str(abs(cvb-cv)));
set(zoom_handles(21),'String',num2str(abs(chb-ch)));

% global which live while mouse button down
clear global zoom_y zoom_cursor zoom_handles zoom_xxlim zoom_cvb zoom_chb


% do callback
if ~isempty(zoom_callback),
	eval(zoom_callback);
end;
clear global zoom_callback
