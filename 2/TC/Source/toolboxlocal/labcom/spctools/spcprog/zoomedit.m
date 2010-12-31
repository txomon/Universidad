function zoomedit(gf,action,arg1)
%ZOOMEDIT Add Play menu or play portion of vector in ZOOMTOOL.
%       ZOOMEDIT(H) adds a menu to the figure H containing
%       Only one vector can be contained in the axes.
%	ZOOMTOOL must be active in the figure before calling
%	ZOOMEDIT.
%
%       ZOOMEDIT(H,ACTION) defines an action to be taken ('cut',
%       'copy', 'paste', or 'crop'.  This is a recursive
%       function using the initial call to add the menu and
%       subsequent call to perform the action.
%
%       The Edit menu is
%
%       Edit
%           Cut
%           Copy
%           Paste
%           Crop
%
%       Cut     - Inclusive cuts the vector between the cursors.
%       Copy    - Inclusive copies the vector between the
%                   cursors.
%       Paste   - Changes mouse arrow to a crosshair and then
%                   inserts the paste buffer at the location of
%                   the next press of the left mouse button.
%       Crop    - Exclusively deletes vector outside the
%                   cursors.
%       Paste Global - Pastes the contents of the global cut and
%       	       paste buffer allowing cut and paste
%       	       operations between edit tools.
%       Save	- Saves the vector deliminated by the cursors to
%       	  a variable in the Matlab workspace.  The user
%       	  is prompted for the variable name.
%
%       The term "inclusive" includes the current point the
%           cursors are on.
%
%       See also ZOOMTOOL

%       Dennis W. Brown 1-31-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

handles = get(finduitx(gf,'zoomtool'),'UserData');
ga = handles(40);

if nargin <= 1,
	action = 'start';
	fs = 8192;
elseif nargin == 2,
	if ~isstr(action),
		fs = action;
		action == 'start';
	else,
		fs = 8192;
	end;
elseif nargin > 3,
	error('zoomedit: Invalid number of input arguments.');
end

% popup menu overide
h = getpopvl(gf,'Sampling Freq');
if h,
	fs = h;
end

%set up callback
callbackstr = [];
if strcmp(lower(action),'callback'),

	if nargin == 3,
		callbackstr = arg1;
	end;

	action = 'start';
end;

if strcmp(action,'start'),

	if findmenu(gf,'Play'),
		error('zoomedit: Edit menu already installed in figure.');
	end;

	if length(get(handles(16),'UserData')) > 1,
		error('zoomedit: Only one vector may exist in axes.');
	end;

	if strcmp(computer,'PCWIN'),
		set(gf,'MenuBar','none');
	end;

	% get a name for it
	saverequestcall = [...
		'reqstr(gcf,''Enter variable name to save''); ' ...
	];

	m=uimenu('Label','Edit');
	uimenu(m,'Label','Cut','Accelerator','X',...
		'Callback','zoomedit(gcf,''cut'');');
	uimenu(m,'Label','Copy','Accelerator','C',...
		'Callback','zoomedit(gcf,''copy'');');
	uimenu(m,'Label','Paste','Accelerator','V',...
		'Callback','zoomedit(gcf,''paste'',''local'');');
	uimenu(m,'Label','Crop','Callback','zoomedit(gcf,''crop'');',...
		'UserData',callbackstr);
%       uimenu(m,'Label','Add','Callback','zoomedit(gcf,''add'',''local'');');
	uimenu(m,'Label','Paste Global','Separator','on','Callback',...
		'zoomedit(gcf,''paste'',''global'');');
	uimenu(m,'Label','Save','Separator','on','Callback',...
		saverequestcall,'UserData','zoomedit(gcf,''copy'');zoomedsv;');

else,

	set(gf,'Pointer','watch');

	% get the line to be edited
	y = get(handles(39),'YData');
	y = y(:);

	ylen = length(y);

	% get some data about the current axes state
	xfactor = handles(28);
	xmin = handles(33);
	xxlim = get(ga,'Xlim');

	% convert cursor locations to indices
	x1 = get(handles(24),'XData'); x1 = x1(1);
	x2 = get(handles(26),'XData'); x2 = x2(1);
	i1 = round((x1(1) - xmin) / xfactor) + 1;
	i2 = round((x2(1) - xmin) / xfactor) + 1;

	% check for switched cursors
	if i1 > i2; t = i1; i1 = i2; i2 = t; end;

	% compute indices currently at the limits
	xind = round((xxlim - xmin) / xfactor) + 1;

	% perform the action
	if strcmp(action,'cut'),

		% can't include the whole vector
		if i1 == 1 & i2 == ylen,
			msg=['zoomedit: Cut aborted - can''t entire vector.'];
			spcwarn(msg,'OK');
			set(gf,'Pointer','arrow');
			return;
		end;

		% save to cut and paste buffer ('Cut' menu UserData)
		set(findmenu(gf,'Edit','Cut'),'UserData',y(i1:i2));

		% and to global buffer
		global SPC_BUFFER
		SPC_BUFFER = y(i1:i2);

		% amount chopped out
		chopped = i2-i1+1;

		% make it inclusive
		i1 = i1-1; i2 = i2 + 1;

		% collapse the vector, make sure we don't go beyond
		% the data if a cursor was at the end
		newy = [];
		if i1 > 0, 
			newy = y(1:i1);
		end;
		if i2 < ylen,
			newy = [newy ; y(i2:ylen)];
		end;

		% new x data
		newx = (0:length(newy)-1)' * xfactor + xmin;

		% set indices to point before and after cut
		if i1 < 1; i1 = 1; end;
		i2 = i1 + 1;
		if i2 > length(newy); i2 = length(newy); end;

		% redraw line
		set(handles(39),'XData',newx,'YData',newy);
		
		% new handle data
		handles(33) = newx(1);
		handles(34) = newx(length(newx));
		handles(35) = min(newy);
		handles(36) = max(newy);
		set(finduitx(gf,'zoomtool'),'UserData',handles);

		% adjust readouts and move cursors 
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

		% set limits so that was at the limits remains at the
		% limits (if not cut)
		xind(2) = xind(2) - chopped;
		xlim = newx(xind);
		set(ga,'XLim',xlim);

		% set Y limits
		ymax = max(newy(xind(1):xind(2)));
		ymin = min(newy(xind(1):xind(2)));
		del = (ymax - ymin) * 0.05;
		if del == 0; del = 1; end;
		ylim = [ymin-del ymax+del];
		set(ga,'YLim',ylim);

		% invalidate any prior zoom locations and adjust full
		set(handles(2),'UserData',[handles(33) handles(34)]);
		set(handles(3),'UserData',[handles(33) handles(34)]);
		del = (handles(36) - handles(35)) * 0.05;
		if del == 0, del == 1; end;
		set(handles(5),'UserData',[handles(35)-del handles(36)+del]);
		set(handles(6),'UserData',[handles(35)-del handles(36)+del]);

		% adjust cursor lengths
		set(handles(24),'YData',ylim);
		set(handles(25),'XData',xlim);
		set(handles(26),'YData',ylim);
		set(handles(27),'XData',xlim);

		% copy to common variable
		global SPC_COMMON
		SPC_COMMON = newy;

		% do callback if there
		c = get(findmenu(gf,'Edit','Crop'),'UserData');
		if ~isempty(c),
			eval(c);
		end;

	elseif strcmp(action,'copy'),

		% save to cut and paste buffer
		set(findmenu(gf,'Edit','Cut'),'UserData',y(i1:i2));

		% and to global buffer
		global SPC_BUFFER
		SPC_BUFFER = y(i1:i2);

	elseif strcmp(action,'paste'),

		if strcmp(arg1,'local'),

	    	    % get the local cut and paste buffer contents
	    		buffer = get(findmenu(gf,'Edit','Cut'),'UserData');

		else,
			% get the global version of same
			global SPC_BUFFER
			buffer = SPC_BUFFER;
		end;

		% if there is something in it
		if isempty(buffer),

			msg=['zoomedit: Paste aborted - can''t paste '...
				'an empty ' arg1 ' buffer.'];
			spcwarn(msg,'OK');
			set(gf,'Pointer','arrow');
			return;

		else,

			% get paste location and map to an index
			t = ginput(1);
			k = floor((t(1) - xmin) / xfactor) + 1;

			% check for beyond limits
			if k < 0, k = 1, end;
			if k > ylen, k = ylen; end;

			% make the new vector
			newy = [y(1:k) ; buffer ; y(k+1:ylen)];

			% amount added in
			added = length(buffer);

			% copy to common variable
			global SPC_COMMON
			SPC_COMMON = newy;

			% new x data
			newx = (0:length(newy)-1)' * xfactor + xmin;

			% redraw line
			set(handles(39),'XData',newx,'YData',newy);
		
			% new handle data
			handles(33) = newx(1);
			handles(34) = newx(length(newx));
			handles(35) = min(newy);
			handles(36) = max(newy);
			set(finduitx(gf,'zoomtool'),'UserData',handles);

			% endpoints of paste
			i1 = k+1;
			i2 = k + added;

			% adjust readouts and move cursors 
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

			% set limits so that all data inside limit before
			% paste is still inside limits
			xind(2) = xind(2) + added;
			xlim = newx(xind);
			set(ga,'XLim',xlim);

			% set Y limits
			ymax = max(newy(xind(1):xind(2)));
			ymin = min(newy(xind(1):xind(2)));
			del = (ymax - ymin) * 0.05;
			if del == 0; del = 1; end;
			ylim = [ymin-del ymax+del];
			set(ga,'YLim',ylim);

			% invalidate any prior zoom locations and adjust full
			set(handles(2),'UserData',[handles(33) handles(34)]);
			set(handles(3),'UserData',[handles(33) handles(34)]);
			del = (handles(36) - handles(35)) * 0.05;
			if del == 0, del == 1; end;
			set(handles(5),'UserData',[handles(35)-del ...
							handles(36)+del]);
			set(handles(6),'UserData',[handles(35)-del ...
							handles(36)+del]);

			% adjust cursor lengths
			set(handles(24),'YData',ylim);
			set(handles(25),'XData',xlim);
			set(handles(26),'YData',ylim);
			set(handles(27),'XData',xlim);
		end;

		% do callback if there
		c = get(findmenu(gf,'Edit','Crop'),'UserData');
		if ~isempty(c),
			eval(c);
		end;

	elseif strcmp(action,'add'),

		if strcmp(arg1,'local'),

			% get the local cut and paste buffer contents
			buffer = get(findmenu(gf,'Edit','Cut'),'UserData');

		else,
			% get the global version of same
			global SPC_BUFFER
			buffer = SPC_BUFFER;
		end;

		% if there is something in it
		if isempty(buffer),

			msg=['zoomedit: Paste aborted - can''t add an empty ' ...
			arg1 ' buffer.'];
			spcwarn(msg,'OK');
			set(gf,'Pointer','arrow');
	
			return;

		else,

			% get paste location and map to an index
			t = ginput(1);
			k = round((t(1) - xmin) / xfactor) + 1;

	       		 % check for beyond limits
			if k < 0, k = 1, end;
			if k > ylen, k = ylen; end;

			% make the new vector
			y(k:length(buffer)) = buffer;

			% copy to common variable
			global SPC_COMMON
			SPC_COMMON = newy;
	
			% redraw line
			zoomrep(ga,newy);

			% move cursor to surround pasted section
			zoomset(ga,1,(k-1)*xfactor + xmin);
			zoomset(ga,2,(k-1+length(buffer))*xfactor + xmin);

		end;

		% do callback if there
		c = get(findmenu(gf,'Edit','Crop'),'UserData');
		if ~isempty(c),
			eval(c);
		end;

	elseif strcmp(action,'crop'),

		% save just that between the cursors
		newy = y(i1:i2);
		oldx1 = (i1-1) * xfactor + xmin;

		% copy to common variable
		global SPC_COMMON
		SPC_COMMON = newy;

		% new x scale
		newx = (0:length(newy)-1)' * xfactor + oldx1;

		% redraw line
		set(handles(39),'XData',newx,'YData',newy);
		
		% new handle data
		handles(33) = newx(1);
		handles(34) = newx(length(newx));
		handles(35) = min(newy);
		handles(36) = max(newy);
		set(finduitx(gf,'zoomtool'),'UserData',handles);

		% endpoints of cut
		i1 = 1;
		i2 = length(newy);

		% adjust readouts and move cursors 
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

		% set X limits 
		xind = [1 length(newy)];
		xlim = newx(xind);
		set(ga,'XLim',xlim);

		% invalidate any prior zoom locations and adjust full
		set(handles(2),'UserData',[handles(33) handles(34)]);
		set(handles(3),'UserData',[handles(33) handles(34)]);
		del = (handles(36) - handles(35)) * 0.05;
		if del == 0, del == 1; end;
		set(handles(5),'UserData',[handles(35)-del handles(36)+del]);
		set(handles(6),'UserData',[handles(35)-del handles(36)+del]);

		% set Y limits
		set(ga,'YLim',[handles(35)-del handles(36)+del]);

		% adjust cursor lengths
		set(handles(25),'XData',xlim);
		set(handles(27),'XData',xlim);

		% do callback if there
		c = get(findmenu(gf,'Edit','Crop'),'UserData');
		if ~isempty(c),
			eval(c);
		end;

	end;

	set(gf,'Pointer','arrow');

end;


