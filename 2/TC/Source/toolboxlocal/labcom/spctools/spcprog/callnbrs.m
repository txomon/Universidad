function callnbrs(gf,action)



if action == 1,

	% get handle to popup menu
	hpop=get(gf,'CurrentObject');

	% "user" menu item number
	user = get(hpop,'Max');

	% "current" menu item number
	curr = get(hpop,'Value');

	% get identifier of group
	label = get(hpop,'UserData');

	% find handle to user edit box
	hedit = findedit(gf,label);

	if curr == user,

		% disable all other uicontrols
		h = findobj(get(gcf,'children'),'Type','uicontrol');
		set(h,'Enable','off');

		% User was selected
		set(hpop,'Visible','off');	% turn off popup
	        set(hedit,'Visible','on','Enable','on');% turn on user edit box
		set(finduitx(gf,label),'Enable','on');
	else,

		items = zeros(user-1,1);
		str = get(hpop,'String');
		for i = 1:user-1,
			items(i) = str2num(str(i,:));
		end;

		% make popup string
		popstr = [];
		for i = 1:length(items)
			if (items(i) - floor(items(i))) == 0,
				popstr = [popstr int2str(items(i)) '|'];
			else,
				popstr = [popstr num2str(items(i)) '|'];
			end;
		end;
		popstr = [popstr 'User'];

		% reset popup menu
		set(hpop,'String',popstr,'Value',curr);

		% execute programmer's callback
		eval(get(finduitx(gf,label),'CallBack'));
	end;
else,

	% get handle to popup menu
	hedit = get(gf,'CurrentObject');

	% get identifier of group
	label = get(hedit,'UserData');

	% find handle to user edit box
	hpop = findpopu(gf,label);

	% "user" menu item number
	user = get(hpop,'Max');

	% get range from uitext UserData
	range = get(finduitx(gf,label),'UserData');

	% clip for integer
	if range(3),
		integer = 'on';
	else,
		integer = 'off';
	end;

	% power of two
	if range(4),
		pow2 = 'on';
	else,
		pow2 = 'off';
	end;

	% set range for call to ednbrchk
	range = range(1:2);

	% check number
	ok = ednbrchk(hedit,'Range',range,'PowerOfTwo',pow2,...
		'Integer',integer,'Variable',label,...
		'Default',[]);

	if ok,
		% get Value from edit box
		newnbr = str2num(get(hedit,'String'));

		set(hedit,'Visible','off');	% turn off user edit

		items = zeros(user-1,1);
		str = get(hpop,'String');
		for i = 1:user-1,
			items(i) = str2num(str(i,:));
		end;

		% make popup string, add new number and 'User' item
		popstr = [];
		for i = 1:length(items)
			if (items(i) - floor(items(i))) == 0,
				popstr = [popstr num2str(items(i)) '|'];
			else,
				popstr = [popstr int2str(items(i)) '|'];
			end;
		end;
		if strcmp(integer,'off'),
			popstr = [popstr num2str(newnbr)];
		else,
			popstr = [popstr int2str(newnbr)];
		end;
		popstr = [popstr '|User'];

		% reset popup menu
		set(hpop,'String',popstr,'Value',user,'Visible','on');

		% enable all uicontrols
		h = findobj(get(gcf,'children'),'Type','uicontrol');
		set(h,'Enable','on');

		% execute programmer's callback
		eval(get(finduitx(gf,label),'CallBack'));

	end;
end;



