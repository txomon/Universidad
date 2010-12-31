function armacrsr(ga,morb,cursor)

gf = get(ga,'Parent');

zoom = get(finduitx(gf,'zoomtool'),'UserData');
xfactor = zoom(22);
xmin = zoom(23);
xxlim = get(gca,'XLim');


if morb == 1,

	% model cursors

	if cursor == 1,
		h = findedit(gf,'MB');
		x = str2num(get(h,'String'));
		if isempty(x),
			set(h,'String',num2str(crsrloc(ga,'modstart')));
			return;
		end;
	elseif cursor == 2,
		h = findedit(gf,'ME');
		x = str2num(get(h,'String'));
		if isempty(x),
			set(h,'String',num2str(crsrloc(ga,'modend')));
			return;
		end;
	elseif cursor == 3,
		h = findedit(gf,'MD');
		x = str2num(get(h,'String'));
		if isempty(x),
			set(h,'String',num2str(abs(crsrloc(ga,'modstart') ...
				- crsrloc(ga,'modend'))));
			return;
		end;
		h = findedit(gf,'MB');
		x = x + abs(str2num(get(h,'String')));
		h = findedit(gf,'ME');		% handle needed later
	elseif cursor == 4,
		h = findedit(gf,'MB');
		x = crsrloc(ga,'modstart');
	elseif cursor == 5,
		h = findedit(gf,'ME');
		x = crsrloc(ga,'modend');
	end;

%	if x <= xxlim(1),
%		x = xxlim(1);
%	elseif x >= xxlim(2),
%		x = xxlim(2);
%	end;

	% round to nearest point
	x = round((x - xmin) / xfactor) + 1;
	x = (x-1)*xfactor + xmin;

	if cursor == 1 | cursor == 4,
		crsrmove(ga,'modstart',x);
		set(h,'String',num2str(x));
		if get(findchkb(gf,'Lock MB-PB'),'Value'),
			crsrmove(ga,'perstart',x);
			set(findedit(gf,'PB'),'String',num2str(x));
			delta = abs(x - crsrloc(ga,'perend'));
			set(findedit(gf,'PD'),'String',num2str(delta));
		end;
	else,
		crsrmove(ga,'modend',x);
		set(h,'String',num2str(x));
	end;

	delta = abs(crsrloc(ga,'modstart') - crsrloc(ga,'modend'));
	set(findedit(gf,'MD'),'String',num2str(delta));

else,

	% period cursors

	if cursor == 1,
		h = findedit(gf,'PB');
		x = str2num(get(h,'String'));
		if isempty(x),
			set(h,'String',num2str(crsrloc(ga,'perstart')));
			return;
		end;
	elseif cursor == 2,
		h = findedit(gf,'PE');
		x = str2num(get(h,'String'));
		if isempty(x),
			set(h,'String',num2str(crsrloc(ga,'perend')));
			return;
		end;
	elseif cursor == 3,
		h = findedit(gf,'PD');
		x = str2num(get(h,'String'));
		if isempty(x),
			set(h,'String',num2str(abs(crsrloc(ga,'perstart') ...
				- crsrloc(ga,'perend'))));
			return;
		end;
		h = findedit(gf,'PB');
		x = x + abs(str2num(get(h,'String')));
		h = findedit(gf,'PE');		% handle needed later
	elseif cursor == 4,
		h = findedit(gf,'PB');
		x = crsrloc(ga,'perstart');
	elseif cursor == 5,
		h = findedit(gf,'PE');
		x = crsrloc(ga,'perend');
	end;

%	if x < xxlim(1),
%		x = xxlim(1);
%	elseif x > xxlim(2),
%		x = xxlim(2);
%	end;

	% round to nearest point
	x = round((x - xmin) / xfactor) + 1;
	x = (x-1)*xfactor + xmin;

	if cursor == 1 | cursor == 4,
		crsrmove(ga,'perstart',x);
		set(h,'String',num2str(x));
		if get(findchkb(gf,'Lock MB-PB'),'Value'),
			crsrmove(ga,'modstart',x);
			set(findedit(gf,'MB'),'String',num2str(x));
			delta = abs(x - crsrloc(ga,'modend'));
			set(findedit(gf,'MD'),'String',num2str(delta));
		end;
	else,
		crsrmove(ga,'perend',x);
		set(h,'String',num2str(x));
	end;

	delta = abs(crsrloc(ga,'perstart') - crsrloc(ga,'perend'));
	set(findedit(gf,'PD'),'String',num2str(delta));

end;
