function zoomrep(ga,newx,newy)
%ZOOMREP Replace "zoomed" line in ZOOMTOOL.
%       ZOOMREP(H,YDATA) replaces the "zoomed" line with YDATA in
%       the ZOOMTOOL active in the axes pointed to by the handle
%       H.  The horizontal scaling remains the same, starting
%       from zero.
%
%       ZOOMREP(H,XDATA,YDATA) replaces the "zoomed" line with
%       YDATA using XDATA for the horizontal scaling.
%
%       This function make low-level graphic calls to replace
%       the 'zoomed' line in ZOOMTOOL without destroying the
%       cursors and other objects which maybe contained in the
%       data.  There should only be the 'zoomed' line in the
%       ZOOMTOOL (see Toggle property of ZOOMTOOL).  The low-
%       level nature of this function saves is quicker and
%       smoother than successive calls to ZOOMCLR, PLOT, and
%       ZOOMTOOL which would accomplish the same task.
%
%       All the necessary changes are made to adapt ZOOMTOOL to
%       the new line are made dependent upon the calling form.
%       For example, when only the YDATA is given, the data
%       displyed in the axes limits is still visible even more
%       points may have been added or some taken away as happens
%       with cut and past operations.  When called with both
%       XDATA and YDATA, ZOOMTOOL is essentially reinitialized.
%
%       See also ZOOMTOOL, WORKMENU, ZOOMCLR, ZOOMEDIT

%       Dennis W. Brown 1-31-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% arg check
if nargin < 2 | nargin > 3,
	error('zoomrep: Invalid number of input arguments.');
end;

% parent figure
gf = get(ga,'Parent');

% get handles to zoomtool uicontrols
h = finduitx(gf,'zoomtool');
if isempty(h),
	error('zoomrep: ZOOMTOOL not loaded in requested axes.');
end;
handles = get(h,'UserData');
oldxfactor = handles(28);
oldxmin = handles(33);
oldxxlim = get(ga,'XLim');

% compute indices currently at the limits
oldxind = round((oldxxlim - oldxmin) / oldxfactor) + 1;

% cursor indices before
cv1 = get(handles(24),'XData'); cv1 = cv1(1);
cv2 = get(handles(26),'XData'); cv2 = cv2(1);
i1 = round((cv1(1) - oldxmin) / oldxfactor) + 1;
i2 = round((cv2(1) - oldxmin) / oldxfactor) + 1;

% make sure args are correct
if nargin == 2,
	newy = newx;
	newx = [];
end;

% get new y data facts
newylen = length(newy);
newymin = min(newy);
newymax = max(newy);

% generate newx data if needed
if nargin == 2 & newylen ~= handles(37),

	% data is different length, regenerate xdata using old xfactor and xmin
	newx = (0:(newylen-1)) * oldxfactor + oldxmin;
end;

if nargin == 3,

	% is xdata same as old
	if min(newx) == handles(33) & max(newx) == handles(34) & newylen == handles(37),

		% just replace y data
		newx = [];
	end;
end;

if isempty(newx),

	% redraw line
	set(handles(39),'YData',newy);

	% use old xdata
	newxmin = handles(33);
	newxmax = handles(34);
	newxfactor = handles(28);

	% adjust y zoomout vector to new y
	oldxzoom = get(handles(2),'UserData');
	if ~isempty(oldxzoom),

		% convert to indices, get new y values corresponding and restore
		ind = round((oldxzoom - ones(size(oldxzoom))* oldxmin) / ...
				     oldxfactor) + 1;

		[m,n] = size(ind);

		newyzoom = zeros(size(ind));

		for k = 1:m,

			newyzoom(k,:) = [min(newy(ind(k,1):ind(k,2)))  ...
				max(newy(ind(k,1):ind(k,2)))];

		end;

		ydelta = diff(newyzoom')' * 0.05;
		ydelta = ydelta * ones(length(newyzoom)/2,1);
		newyzoom = [newyzoom(:,1)-ydelta newyzoom(:,2)+ydelta];
		set(handles(5),'UserData',newyzoom);
	end;

	% adjust new y zoom limits limit
	ydelta = (newymax - newymin) * 0.05;
	if ydelta == 0, ydelta == 1, end;
	set(handles(6),'UserData',[newymin-ydelta newymax+ydelta]);

	% leave the x-axis limits and cursor positions alone, adjust y-limits
	% to ensure signal is displayed
	ymax = max(newy(oldxind(1):oldxind(2)));
	ymin = min(newy(oldxind(1):oldxind(2)));
	ydelta = (ymax - ymin) * 0.05;
	if ydelta == 0; ydelta = 1; end;
	ylim = [ymin-ydelta ymax+ydelta];
	set(ga,'YLim',ylim);

	% adjust vertical cursor lengths
	set(handles(24),'YData',ylim);
	set(handles(26),'YData',ylim);

	% relocate horizontal cursors
	set(handles(25),'YData',[newy(i1) newy(i1)]);
	set(handles(27),'YData',[newy(i2) newy(i2)]);

	% update y-axis readouts
	set(handles(19),'String',num2str(newy(i1)));
	set(handles(21),'String',num2str(abs(newy(i2)-newy(i1))));
	set(handles(23),'String',num2str(newy(i2)));

else,

	% new data
	newxmin = min(newx);
	newxmax = max(newx);
	newxfactor = (newxmax - newxmin) / (length(newx) - 1);
	newxlen = length(newx);

	if newylen ~= newxlen,
		error('zoomrep: New XData and YData not equal length.');
	end;

	% redraw line
	set(handles(39),'XData',newx,'YData',newy);

	% invalidate prior zooms
	set(handles(1),'UserData',[]);
	set(handles(4),'UserData',[]);
	set(handles(3),'UserData',[1 newylen]);
	ydelta = (newymax - newymin) * 0.05;
	if ydelta == 0, ydelta = 1; end;
	ylim = [newymin-ydelta newymax+ydelta];
	set(handles(6),'UserData',ylim);

	% reset limits
	xlim = [newx(1) newx(newxlen)];
	set(ga,'XLim',xlim,'YLim',ylim);

	% reset cursor positions
	i1 = fix(newxlen/4);
	i2 = fix(newxlen*3/4);
	cv1 = newx(i1);
	ch1 = newy(i1);
	cv2 = newx(i2);
	ch2 = newy(i2);

	% 18	x - - edit		'zoomed' axes handle
	% 19	y - - text		'zoomed' axes handle
	% 20	delta edit		'zoomed' axes handle
	% 21	delta text		'zoomed' axes handle
	% 22	x - . edit		'zoomed' axes handle
	% 23	x - . text		'zoomed' axes handle
	% 24	- - vertical cursor line (1001)
	% 25	- - horiz cursor line (1002)
	% 26	- . vertical cursor line (2001)
	% 27	- . horiz cursor line (2002)

	% adjust readouts and move cursors
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

	% adjust cursor lengths
	set(handles(24),'YData',ylim);
	set(handles(25),'XData',xlim);
	set(handles(26),'YData',ylim);
	set(handles(27),'XData',xlim);


end;

% new handle data
% 28	none			xfactor
% 33	none			min(x)
% 34	none			max(x)
% 35	none			min(y)
% 36	none			max(y)
% 37	none			length(y)
handles(33) = newxmin;
handles(34) = newxmax;
handles(28) = newxfactor;
handles(35) = newymin;
handles(36) = newymax;
handles(37) = newylen;
set(finduitx(gf,'zoomtool'),'UserData',handles);

