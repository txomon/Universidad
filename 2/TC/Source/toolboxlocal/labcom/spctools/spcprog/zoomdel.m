function zoomdel(ga,option);
%ZOOMDEL Delete lines from ZOOMTOOL.
%	ZOOMDEL(H,'OPTION') deletes lines from ZOOMTOOL 
%	according to the the specified OPTION.  H is the 
%	axis ZOOMTOOL is active in.
%
%	Options:
%		'current' - deletes current line cursors are
%				attached to.
%		'others'  - deletes all lines except the one
%				the cursors are attached to.
%
%	See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%		ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMDEL ZOOMTOOL
%		ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%		ZOOMYOUT

%       Dennis W. Brown 6-20-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

gf = get(ga,'Parent');

% get handles to zoomtool uicontrols
handles = get(finduitx(gf,'zoomtool'),'UserData');
xfactor = handles(28);
xmin = handles(33);
xxlim = get(ga,'XLim');

% get handles to all the lines
lineh = get(handles(16),'UserData');

% see if anything can be deleted
if length(lineh) <= 1,
	spcwarn('zoomdel: No more lines can be deleted.','OK');
	return;
end;

% get current line
hcur = handles(39);

option = lower(option);

% pushbutton used?
if strcmp(option,'current'),

	% get oldlines buttondown
	buttondown = get(hcur,'ButtonDownFcn');

	% delete line from zoomtool
	delete(hcur);

	% next three steps pick next line to toggle too
	
	% find current line's index
	i = find(lineh == hcur);

	% get the next on in order
	i = i + 1;

	% wrap if necessary
	if i > length(lineh),
		i = 1;
	end;

	% handle of new line
	hnew = lineh(i);

	% delete from line handle list and replace list
	lineh = lineh(find(lineh ~= hcur));
	set(handles(16),'UserData',lineh);

	% if only one line left, turn off toggle button
	if length(lineh) <= 1,
		set(handles(16),'Visible','off');
	end;

	% re-identify the current line
	set(handles(17),'UserData',hnew);

	% set buttondown of new to that of old
	set(hnew,'ButtonDownFcn',buttondown);

	% new line data
	newx = get(hnew,'XData');
	newy = get(hnew,'YData');
	ylen = length(newy);

	% new handle data
	handles(33) = newx(1);
	handles(34) = newx(length(newx));
	handles(28) = (handles(34) - handles(33)) / (ylen - 1);
	handles(35) = min(newy);
	handles(36) = max(newy);
	handles(39) = hnew;
	set(finduitx(gf,'zoomtool'),'UserData',handles);

	% reset local variables
	xfactor = handles(28);
	xmin = handles(33);

	% cursor values before
	cv1 = get(handles(24),'XData'); cv1 = cv1(1);
	cv2 = get(handles(26),'XData'); cv2 = cv2(1);

	% calculate closest indices on new line
	i1 = round((cv1(1) - xmin) / xfactor) + 1;
	i2 = round((cv2(1) - xmin) / xfactor) + 1;

	% compute closest limit indices according to new line
	%  note xxlim is axis limits before changing lines
	xind = round((xxlim - xmin) / xfactor) + 1;

	% set limits so that all data within limits is shown
	if xind(1) > ylen, xind(1) = 1; end;
	if xind(2) > ylen, xind(2) = ylen; end;

	xindbefore = xind;
	xlim = newx(xind);
	set(ga,'XLim',xlim);

	% adjust readouts and move cursors 
	if i1 > ylen, i1 = xind(1)+fix((xind(2)-xind(1))/4); end;
	if i2 > ylen, i2 = xind(1)+3*fix((xind(2)-xind(1))/4); end;
	cv1 = newx(i1);
	ch1 = newy(i1);
	cv2 = newx(i2);
	ch2 = newy(i2);
	set(handles(18),'String',num2str(cv1));
	set(handles(19),'String',num2str(ch1));
	set(handles(20),'String',num2str(abs(cv2-cv1)));
	set(handles(21),'String',num2str(abs(ch2-ch1)));
	set(handles(22),'String',num2str(cv2));
	set(handles(23),'String',num2str(ch2));
	set(handles(24),'XData',[cv1 cv1]);
	set(handles(25),'YData',[ch1 ch1]);
	set(handles(26),'XData',[cv2 cv2]);
	set(handles(27),'YData',[ch2 ch2]);

	% set Y limits (this assumes all lines the same length)
	newmax = [];
	newmin = [];
	for i = 1:length(lineh),
		
		% get line data
		yy = get(lineh(i),'YData');

		% find extemes
		newmax = [newmax max(yy(xind(1):xind(2)))];
		newmin = [newmin min(yy(xind(1):xind(2)))];

	end;
	newmax = max(newmax);
	newmin = min(newmin);
	del = (newmax - newmin) * 0.05;
	if del == 0; del = 1; end;
	ylim = [newmin-del newmax+del];
	set(ga,'YLim',ylim);

	if xindbefore(1) ~= xind(1) | xindbefore(2) ~= xind(2),

		% different lengths than before

		% invalidate any prior zoom locations and adjust full
		set(handles(2),'UserData',[handles(33) handles(34)]);
		set(handles(3),'UserData',[handles(33) handles(34)]);
		del = (handles(36) - handles(35)) * 0.05;
		if del == 0, del == 1; end;
		set(handles(5),'UserData',[handles(35)-del handles(36)+del]);
		set(handles(6),'UserData',[handles(35)-del handles(36)+del]);
	end;

	% adjust cursor lengths (uncomment statement with ylim if adjusting
	%	ylimits above)
	set(handles(24),'YData',ylim);
	set(handles(25),'XData',xlim);
	set(handles(26),'YData',ylim);
	set(handles(27),'XData',xlim);


elseif strcmp(option,'others'),

	% lines to delete
	lineh = lineh(find(lineh ~= hcur));

	% delete em
	delete(lineh);

	% turn visibility of toggle button off and store toggle handles away
	set(handles(16),'UserData',hcur,'Visible','off');

	% compute closest limit indices 
	xind = round((xxlim - xmin) / xfactor) + 1;

	% set Y limits 
	ymax = handles(36);
	ymin = handles(35);
	del = (ymax - ymin) * 0.05;
	if del == 0; del = 1; end;
	ylim = [ymin-del ymax+del];
	set(ga,'YLim',ylim);

else,
	error(['zoomdel: Invalid option ' option ' specified.']);
end;


% since we effectively just toggled the lines, to the toggle callback
togglecallback = get(finduitx(gf,'X - - -'),'UserData');
if ~isempty(togglecallback),
	eval(togglecallback);
end;
