function zoommove
% ZOOMMOVE Button down/move callback function.
%       ZOOMMOVE Move ZOOMTOOL cursor grabbed by ZOOMDOWN to mouse
%       pointer on a WindowButtonMove event after ZOOMDOWN.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%       	ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%       	ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%       	ZOOMYOUT

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% global which live while mouse button down
global zoom_y zoom_cursor zoom_handles zoom_xxlim zoom_cvb zoom_chb

% current values
gf = gcf;
ga = zoom_handles(40);

% Obtain coordinates of mouse click location in axes units
pt = get(ga,'Currentpoint');
t = pt(1,1);

% check to see if move will go past axis limits
if t <= zoom_xxlim(1)+100*eps, t = zoom_xxlim(1); end;
if t >= zoom_xxlim(2)-100*eps, t = zoom_xxlim(2); end;

% current index
k = round((t - zoom_handles(33)) / zoom_handles(28)) + 1;

% current point locations
cv = (k-1) * zoom_handles(28) + zoom_handles(33);
ch = zoom_y(k);

% Speed note:
%  If your system to slow, you might want to comment out
%  the readout update statements below so that the readouts
%  are only updated when the mouse button is release instead
%  of as the cursor is moved.


% move cursor to mouse click location
if zoom_cursor == 1,
	set(zoom_handles(24),'XData',[cv cv]);
	set(zoom_handles(25),'YData',[ch ch]);
	set(zoom_handles(18),'String',num2str(cv));	% readout
	set(zoom_handles(19),'String',num2str(ch));	% readout
else
	set(zoom_handles(26),'XData',[cv cv]);
	set(zoom_handles(27),'YData',[ch ch]);
	set(zoom_handles(22),'String',num2str(cv));	% readout
	set(zoom_handles(23),'String',num2str(ch));	% readout
end;

% adjust delta readouts
set(zoom_handles(20),'String',num2str(abs(zoom_cvb-cv)));	% readout
set(zoom_handles(21),'String',num2str(abs(zoom_chb-ch)));	% readout


