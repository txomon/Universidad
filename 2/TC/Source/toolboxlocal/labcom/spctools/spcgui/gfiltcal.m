function gfiltcal(action,arg1,arg2,arg3)
%GFILTCAL	Callback functions for GFILTERD
%	GFILTCAL('ACTION',ARG1,ARG2) performs the specified
%	callback 'ACTION'.  Valid actions are:
%
%	down		- Button down callback
%	move		- Button down/move callback
%	up		- Button down/up callback
%	plotall		- Do all three plots
%	add		- Add pole or zero to plots
%	replace		- Redraw plots after phase change
%	ri_zero		- Add zero, rectangular coordinates
%	ri_pole		- Add pole, rectangular coordinates
%	ma_zero		- Add zero, polar coordinates
%	ma_pole		- Add pole, polar coordinates
%	mouse_zero	- Add pole with mouse
%	mouse_pole	- Add pole with mouse
%	delete		- Delete pole or zero with mouse
%	impulse		- Generate impulse response
%	print		- Print filter parameters in command
%			  window
%
%	See also SIGEDIT, SIGEDSAV, SIGEDLD

%       Dennis W. Brown 10-10-93, DWB 5-17-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% get handles to uicontrols and axis
gf = gcf;
tolerance = 0.00001;

if ~strcmp(action,'move') | ~strcmp(get(gf,'Pointer'),'crosshair'),
	set(gf,'Pointer','watch');
end;

if strcmp(action,'down'),

	% get current object and data
	global gf_h gf_re gf_im gf_mode gf_type ind ind1 ind2
	gf_h = get(gf,'CurrentObject');
	axes(get(gf_h,'Parent'));
	gf_re = get(gf_h,'XData');
	gf_im = get(gf_h,'YData');

	% determine what is was
	if get(gf_h,'LineStyle') == 'x',
		xx = get(finduitx(gf,'a'),'UserData');
		gf_type = 1;
	else,
		xx = get(finduitx(gf,'b'),'UserData');
		gf_type = 0;
	end;

	% find index into roots vector
	ind1 = find( ((abs(real(xx) - gf_re)) < tolerance) & ...
		((abs(imag(xx) - gf_im)) < tolerance) );

	% look for a complex conjugate
	ind2 = find( ((abs(real(xx) - gf_re)) < tolerance) & ...
		((abs(imag(xx) + gf_im)) < tolerance) );

	if isempty(ind1) & isempty(ind2),

		% flag for virtual pole
		virtual = 1;

		if get(findrdio(gf,'Minimize'),'Value'),

			index = find(abs(xx) > 1.0);
			if ~isempty(index),
				xx(index) = 1 ./ conj(xx(index));
				virtual = 0;
			end;

		elseif get(findrdio(gf,'Maximize'),'Value');

			index = find(abs(xx) < 1.0);
			if ~isempty(index),
				xx(index) = 1 ./ conj(xx(index));
				virtual = 0;
			end;
		end;

		if virtual,
		    if gf_type == 1,
			spcwarn('gfilterd: Cannot move virtual poles.','OK');
		    else,
			spcwarn('gfilterd: Error finding zero.','OK');
		    end;
%			gfiltcal('plotall');
			set(gf,'Pointer','arrow');
			return;
		end;

		% find index into roots vector
		ind1 = find( ((abs(real(xx) - gf_re)) < tolerance) & ...
			((abs(imag(xx) + gf_im)) < tolerance) );

		% look for a complex conjugate
		ind2 = find( ((abs(real(xx) - gf_re)) < tolerance) & ...
			((abs(imag(xx) - gf_im)) < tolerance) );

	end;

	% find index of roots meeting both criteria
	ind = sort([ind1(:);ind2(:)]);
	ind = ind(find(~(diff(ind))));

	% multiple roots
	nhits = length(ind);

	if (abs(gf_re) < tolerance) & (abs(gf_im) < tolerance),
		if rem(nhits,2) == 1,
			gf_mode = 1;	% at zero, single therefore real
		else,
			gf_mode = 2;	% at zero, pairs, therefore complex
		end;
	elseif abs(gf_im) < tolerance,
		gf_mode = 3;	% purely real
	elseif abs(gf_re) < tolerance,
		gf_mode = 4;	% purely imag
	else,
		gf_mode = 6;	% move anywhere
	end;

	% setup for mouse release
	set(gf_h,'ButtonDownFcn','','EraseMode','xor','MarkerSize',14,...
		'Color',abs(1-get(gf,'Color')));
	set(gf,'WindowButtonMotionFcn','gfiltcal(''move'')');
	set(gf,'WindowButtonUpFcn','gfiltcal(''up'')');
	set(gf,'Pointer','crosshair');

elseif strcmp(action,'move'),

	% get current point and redraw object
	global gf_h gf_re gf_im gf_mode gf_type ind ind1 ind2
	xy = get(gca,'CurrentPoint');

	% restrict movement
	if gf_mode ~= 6,
		if gf_mode == 1 | gf_mode == 3,
			xy(1,2) = 0;	% real only
		else,
			xy(1,1) = 0;	% imag only
		end;
	end;

	set(gf_h,'XData',xy(1,1),'YData',xy(1,2));

elseif strcmp(action,'up'),

	% setup for mouse press
	set(gf,'WindowButtonMotionFcn','');
	set(gf,'WindowButtonUpFcn','');

	global gf_h gf_re gf_im gf_mode gf_type ind ind1 ind2

	% get current object and data
	xy = get(gca,'CurrentPoint');

	% get current position
	re = xy(1,1);
	im = xy(1,2);

	if abs(re) < tolerance,
		re = 0;
	end;
	if abs(im) < tolerance,
		im = 0;
	end;

	if rem(gf_mode,2) == 1,
		im = 0;
	elseif gf_mode ~= 6,
		re = 0;
	end;

	y = re + i * im;

	if gf_type

		%twas a pole
		xx = get(finduitx(gf,'a'),'UserData');
	else,
		%twas a zero
		xx = get(finduitx(gf,'b'),'UserData');
	end;

	if rem(gf_mode,2) == 1,

		% get rid of only one
		xx(ind1(1)) = NaN;

		% add one back
		xx = [xx ; real(y)];

	else,
		% get rid of both
		xx(ind1(1)) = NaN;
		if gf_mode == 2,
			xx(ind1(2)) = NaN;
		else,
			xx(ind2(1)) = NaN;
		end;

		% add new
		xx = [xx ; y ; conj(y)];
	end;

	% get rid of NaN
	xx = xx(find(~isnan(xx)));

	if gf_type

		% restore
		set(finduitx(gf,'a'),'UserData',xx);
	else,
		% restore
		set(finduitx(gf,'b'),'UserData',xx);
	end;

	clear global gf_h gf_re gf_im gf_mode gf_type ind ind1 ind2
	gfiltcal('plotall');

elseif strcmp(action,'plotall')

	aa = get(finduitx(gf,'a'),'UserData');
	bb = get(finduitx(gf,'b'),'UserData');
	gain = get(finduitx(gf,'Variables'),'UserData');

	% adjust for current phase conditions
	h = getcheck(gf,'Phase');
	st = get(h,'Label');
	if strcmp(st,'Move Zeros Only'),
		movemode = 1;
	elseif strcmp(st,'Move Poles Only'),
		movemode = 2;
	else,
		movemode = 3;
	end;
	if get(findrdio(gf,'Minimize'),'Value')
		if ~isempty(aa) & (movemode == 2 | movemode == 3),
			[aa,gg] = minphase(poly(aa));
			aa = roots(aa);
			gain = gain / gg;
		end;
		if ~isempty(bb) & (movemode == 1 | movemode == 3),
			[bb,gg] = minphase(poly(bb));
			bb = roots(bb);
			gain = gain * gg;
		end;
	elseif get(findrdio(gf,'Maximize'),'Value'),

		if ~isempty(aa),
			ind = find(abs(aa) < eps);
			aa(ind) = eps*ones(size(ind));
		end;
		if ~isempty(bb),
			ind = find(abs(bb) < eps);
			bb(ind) = eps*ones(size(ind));
		end;

		if ~isempty(aa) & (movemode == 2 | movemode == 3),
			[aa,gg] = maxphase(poly(aa));
			aa = roots(aa);
			gain = gain / gg;
		end;
		if ~isempty(bb) & (movemode == 1 | movemode == 3),
			[bb,gg] = maxphase(poly(bb));
			bb = roots(bb);
			gain = gain * gg;
		end;
	end;

	% ensure system is causal for freqz
	a = real(poly(aa));
	b = real(poly(bb));
	if isempty(a), a = 1; end;
	if isempty(b), b = 1; end;
	al = length(a);
	bl = length(b);

	nch = findchkb(gcf,'Non-Causal');
	if length(aa) >= length(bb),

		% causal system
		set(nch,'Value',0,'Enable','off');

		if al > bl,
			b = [fliplr(b) zeros(1,al-bl)];
			b = fliplr(b);
		elseif bl > al,
			a = [a zeros(1,bl-al)];
			a = fliplr(a);
		end;
	else
		% non-causal system
		set(nch,'Enable','on');

		if al > bl,
			b = [fliplr(b) zeros(1,al-bl)];
			b = fliplr(b);
		elseif bl > al,
			if get(nch,'Value'),
				a = [fliplr(a) zeros(1,bl-al)];
				a = fliplr(a);
			else,
				a = [a zeros(1,bl-al)];
			end;
		end;
	end;

	aa = cplxpair(roots(a));
	bb = cplxpair(roots(b));

	% set current axis to the polar plot
	phaax = findaxes(gf,'polar');
	axes(phaax)

	global SPC_ZEROS SPC_POLES

	zh = get(finduitx(gf,'R'),'UserData');
	ph = get(finduitx(gf,'I'),'UserData');
	delete(zh);
	delete(ph);

	% first the zeros
	zh = zeros(length(bb),1);
	for k = 1:length(bb),
		zh(k) = line('XData',real(bb(k)),'YData',imag(bb(k)),...
			'Color',SPC_ZEROS,'LineStyle','o','MarkerSize',8,...
			'UserData',k,...
			'ButtonDownFcn','gfiltcal(''down'',''zero'');');
	end;

	% then the poles
	ph = zeros(length(aa),1);
	for k = 1:length(aa),
		ph(k) = line('XData',real(aa(k)),'YData',imag(aa(k)),...
			'Color',SPC_POLES,'LineStyle','x','MarkerSize',8,...
			'UserData',k,...
			'ButtonDownFcn','gfiltcal(''down'',''pole'');');
	end;

	% prevent from autoscaling the axes to a pin point
	global SPC_GFILT_LIMIT
	if max(abs([aa ; bb])) > SPC_GFILT_LIMIT,

		pos = [-SPC_GFILT_LIMIT SPC_GFILT_LIMIT];
		set(phaax,'Xlim',pos,'Ylim',pos);

		% tell the user if there are things they can't see
		if any(abs(real([aa ; bb])) > SPC_GFILT_LIMIT) | ...
			any(abs(imag([aa ; bb])) > SPC_GFILT_LIMIT),

			global SPC_POLAR_AXIS

			spcxlabl(phaax,...
			['Pole/zeros may exist beyond axes limits (+-' ...
				int2str(SPC_GFILT_LIMIT) ');']);

			xxx = [1 1 ; 1 -1 ; -1 -1 ; -1 1 ; 1 1] * ...
					SPC_GFILT_LIMIT;

			h = line(xxx(:,1),xxx(:,2));
			set(h,'Color',SPC_POLAR_AXIS,'UserData','limits');

		end;

	else,
		axis('auto')
		xlabel('');
		h = findline(phaax,'limits');
		if ~isempty(h),
			delete(h);
		end;
	end;

	% store zero handles with zero mouse uicontrol
	set(finduitx(gf,'R'),'UserData',zh);

	% store handle with zero mouse uicontrol
	set(finduitx(gf,'I'),'UserData',ph);

	gfiltcal('response',a,b,gain);

elseif strcmp(action,'response'),

	tol = 100000000;
	a = round(tol*arg1)/tol;
	b = round(tol*arg2)/tol;
	if nargin == 4,
		gain = arg3;
	else,
		gain = 1;
	end;

	% compute transfer function
	curve = fft(gain * b,1024) ./ fft(a,1024);
	curve = curve(1:512);
	mag = abs(curve);

	% get rid of round off error
	factor = 100000;
%	mag = fix(mag*factor)/factor;

	% get rid of round off error
	phase = angle(curve);
	factor = 100000;
	phase = fix(phase*factor)/factor;

	% frequency scale
	w = (0:511)/512;

	if get(findchkb(gf,'Normalize'),'Value'),
		mag = mag/max(mag);
	end;

	global SPC_FONTNAME SPC_TEXT_FORE

	% compute the magnitude
	magax = findaxes(gf,'mag');
	axes(magax);
	if ischeckd(gf,'Scale','Logarithmic'),
		mag = 20 * log10(mag);

		% get rid of round off error
		factor = 100000;
		mag = fix(mag*factor)/factor;

		set(get(magax,'ylabel'),'String','dB',...
			'FontName',SPC_FONTNAME,'Color',SPC_TEXT_FORE);
	else,
		set(get(magax,'ylabel'),'String','W',...
			'FontName',SPC_FONTNAME,'Color',SPC_TEXT_FORE);
	end;

	% get handles to previous lines
	magax = findaxes(gf,'mag');
	phax = findaxes(gf,'phase');
	mh = get(magax,'Children');
	ph = get(phax,'Children');

	% compute the phase
	phaax = findaxes(gf,'phase');
	axes(phaax);
	if ischeckd(gf,'Angles','Degrees'),
		phase = 180/pi * phase;
		set(get(phaax,'ylabel'),'String','Degrees',...
			'FontName',SPC_FONTNAME,'Color',SPC_TEXT_FORE);
	else,
		set(get(phaax,'ylabel'),'String','Radians',...
			'FontName',SPC_FONTNAME,'Color',SPC_TEXT_FORE);
	end;

	% set up for plots

	if ~get(findchkb(gf,'Keep Curves'),'Value'),

		% kill the children
		for k = 1:length(ph),
			delete(ph(k));
		end;
		for k = 1:length(mh),
			delete(mh(k));
		end;
	else,

		% recolor the children

		global SPC_COLOR_ORDER
		ccol = SPC_COLOR_ORDER;

		% color the children
		[m,n] = size(ccol);
		for k = 1:length(ph),
			set(ph(k),'LineStyle',':','Color',ccol(rem(k,m)+1,:));
		end;
		for k = 1:length(mh),
			set(mh(k),'LineStyle',':','Color',ccol(rem(k,m)+1,:));
		end;
	end;

	if get(findchkb(gf,'Unwrap Phase'),'Value'),
		phase = unwrap(phase);
	end;

	global SPC_TRANSFER
	axes(findaxes(gf,'mag'));
	line('XData',w,'YData',mag,'Color',SPC_TRANSFER);
	axes(findaxes(gf,'phase'));
	line('XData',w,'YData',phase,'Color',SPC_TRANSFER);

	% set tick label mode to auto
	set(phax,'YTickMode','auto','YTickLabelMode','auto','YLimMode','auto');

	if ischeckd(gf,'Angles','Radians'),

		% show scale in units of pi
		ypilabel(phax);
	end;

elseif strcmp(action,'phase'),

	% phase and degree conditions
	rap = get(findchkb(gf,'Unwrap Phase'),'Value');
	deg = ischeckd(gf,'Angles','Degrees');

	if ~rap,
		gfiltcal('plotall');
	end;

	ga = findaxes(gf,'phase'); axes(ga);

	% handles to phase lines
	ph = get(ga,'Children');

	global SPC_COLOR_ORDER SPC_TRANSFER
	ccol = SPC_COLOR_ORDER;
	[m,n] = size(ccol);
	w = (0:511)/512;

	% redo phase lines
	for k = 1:length(ph),
		temp =  get(ph(k),'YData');
		delete(ph(k));

		if deg,
			temp = temp / 180 * pi;
		end;

		if rap,
			temp = unwrap(temp);
		end;

		if deg,
			temp = temp / pi * 180;
		end;


		hh = line('XData',w,'YData',temp,...
			'LineStyle',':','Color',ccol(rem(k,m)+1,:));

		if k == 1,
			set(hh,'Color',SPC_TRANSFER,'LineStyle','-');
		end;
	end;

	% set tick label mode to auto
	phax = findaxes(gf,'phase');
	set(phax,'YTickMode','auto','YTickLabelMode','auto','YLimMode','auto');

	if ischeckd(gf,'Angles','Radians'),

		% show scale in units of pi
		ypilabel(phax);
	end;

elseif strcmp(action,'ma_pole'),

	% get values from edit boxes
	m = get(findedit(gf,'M'),'String');
	a = get(findedit(gf,'A'),'String');
	if isempty(m), m=0; else, m=eval(m,'NaN'); end;
	if isnan(m),
		spcwarn('gfilterd: Unable to evaluate magnitude.','OK');
		set(gf,'Pointer','arrow');
		return;
	end;
	if isempty(a), a=0; else, a=eval(a,'NaN'); end;
	if isnan(a),
		spcwarn('gfilterd: Unable to evaluate angle.','OK');
		set(gf,'Pointer','arrow');
		return;
	end;

	% convert from degrees if necessary
	if ischeckd(gf,'Angles','Degrees'),
		a = a * pi/180;
	end;

	y = m * cos(a) + i * m * sin(a);

	% can't be on unit circle
	if abs(1-abs(y)) < tolerance,
		spcwarn('gfilterd: Cannot located poles on unit circle.','OK');
		set(gf,'Pointer','arrow');
		return;
	end;

	aa = get(finduitx(gf,'a'),'UserData');
	if abs(imag(y)) < tolerance,
		aa = [aa ; y(1)];
	else,
		aa = [aa ; y ; conj(y)];
	end;
	set(finduitx(gf,'a'),'UserData',aa)

	% redo plots
	gfiltcal('plotall');

elseif strcmp(action,'ma_zero'),

	gf_b = get(finduitx(gf,'b'),'UserData');

	% get values from edit boxes
	m = get(findedit(gf,'M'),'String');
	a = get(findedit(gf,'A'),'String');
	if isempty(m), m=0; else, m=eval(m,'NaN'); end;
	if isnan(m),
		spcwarn('gfilterd: Unable to evaluate magnitude.','OK');
		set(gf,'Pointer','arrow');
		return;
	end;
	if isempty(a), a=0; else, a=eval(a,'NaN'); end;
	if isnan(a),
		spcwarn('gfilterd: Unable to evaluate angle.','OK');
		set(gf,'Pointer','arrow');
		return;
	end;

	% convert from degrees if necessary
	if ischeckd(gf,'Angles','Degrees'),
		a = a * pi/180;
	end;

	y = m * cos(a) + i * m * sin(a);

	bb = get(finduitx(gf,'b'),'UserData');
	if abs(imag(y)) < tolerance,
		bb = [bb ; y(1)];
	else,
		bb = [bb ; y ; conj(y)];
	end;
	set(finduitx(gf,'b'),'UserData',bb)

	aa = get(finduitx(gf,'a'),'UserData');
	if length(bb) > length(aa),
		set(findchkb(gf,'Non-Causal'),'Enable','on','Value',1);
	end;

	% redo plots
	gfiltcal('plotall');

elseif strcmp(action,'ri_pole'),

	% get values from edit boxes
	re = get(findedit(gf,'R'),'String');
	im = get(findedit(gf,'I'),'String');
	if isempty(re), re=0; else, re=eval(re,'NaN'); end;
	if isnan(re),
		spcwarn('gfilterd: Unable to evaluate real part.','OK');
		set(gf,'Pointer','arrow');
		return;
	end;
	if isempty(im), im=0; else, im=eval(im,'NaN'); end;
	if isnan(im),
		spcwarn('gfilterd: Unable to evaluate imaginary part.','OK');
		set(gf,'Pointer','arrow');
		return;
	end;

	% convert to polynomial
	y = re + i * im;

	% can't be on unit circle
	if abs(1-abs(y)) < tolerance,
		spcwarn('gfilterd: Cannot locate poles on unit circle.','OK');
		set(gf,'Pointer','arrow');
		return;
	end;

	aa = get(finduitx(gf,'a'),'UserData');
	if abs(imag(y)) < tolerance,
		aa = [aa ; y(1)];
	else,
		aa = [aa ; y ; conj(y)];
	end;
	set(finduitx(gf,'a'),'UserData',aa)

	% redo plots
	gfiltcal('plotall');

elseif strcmp(action,'ri_zero'),

	% get values from edit boxes
	re = get(findedit(gf,'R'),'String');
	im = get(findedit(gf,'I'),'String');
	if isempty(re), re=0; else, re=eval(re,'NaN'); end;
	if isnan(re),
		spcwarn('gfilterd: Unable to evaluate real part.','OK');
		set(gf,'Pointer','arrow');
		return;
	end;
	if isempty(im), im=0; else, im=eval(im,'NaN'); end;
	if isnan(im),
		spcwarn('gfilterd: Unable to evaluate imaginary part.','OK');
		set(gf,'Pointer','arrow');
		return;
	end;

	y = re + i * im;

	bb = get(finduitx(gf,'b'),'UserData');
	if abs(imag(y)) < tolerance,
		bb = [bb ; y(1)];
	else,
		bb = [bb ; y ; conj(y)];
	end;
	set(finduitx(gf,'b'),'UserData',bb)

	aa = get(finduitx(gf,'a'),'UserData');
	if length(bb) > length(aa),
		set(findchkb(gf,'Non-Causal'),'Enable','on','Value',1);
	end;

	% redo plots
	gfiltcal('plotall');

elseif strcmp(action,'mouse_pole'),

	% set current axis
	ga = findaxes(gf,'polar');
	axes(ga);

	% tell the user what to do
	global SPC_FONTNAME SPC_TEXT_FORE
	set(get(ga,'xlabel'),'String','Mark pole location with cursor',...
		'FontName',SPC_FONTNAME,'Color',SPC_TEXT_FORE);

	y = ginput(1);

	% clear message
	xlabel('');

	% cancel if outside limits of axis
	xlim = get(ga,'XLim');
	ylim = get(ga,'YLim');
	if ~(y(1) < xlim(1) | y(1) > xlim(2) | y(2) < ylim(1) | y(1) > ylim(2)),

		if get(findrdio(gf,'Real'),'Value'),
			y(2) = 0;
		elseif get(findrdio(gf,'Imaginary'),'Value'),
			y(1) = 0;
		end;
		y = y(1) + i * y(2);

		% can't be on unit circle
		if abs(1-abs(y)) < tolerance,
		  spcwarn('gfilterd: Cannot locate poles on unit circle.','OK');
		  set(gf,'Pointer','arrow');
		  return;
		end;

		aa = get(finduitx(gf,'a'),'UserData');
		if abs(imag(y)) < tolerance,
			aa = [aa ; y(1)];
		else,
			aa = [aa ; y ; conj(y)];
		end;
		set(finduitx(gf,'a'),'UserData',aa)

		% redo plots
		gfiltcal('plotall');

	end;

elseif strcmp(action,'mouse_zero'),

	% set current axis
	ga = findaxes(gf,'polar');
	axes(ga);

	% tell the user what to do
	global SPC_FONTNAME SPC_TEXT_FORE
	set(get(ga,'xlabel'),'String','Mark zero location with cursor',...
		'FontName',SPC_FONTNAME,'Color',SPC_TEXT_FORE);

	% get location
	y = ginput(1);

	% clear message
	xlabel('');

	% cancel if outside limits of axis
	xlim = get(ga,'XLim');
	ylim = get(ga,'YLim');
	if ~(y(1) < xlim(1) | y(1) > xlim(2) | y(2) < ylim(1) | y(1) > ylim(2)),

		if get(findrdio(gf,'Real'),'Value'),
			y(2) = 0;
		elseif get(findrdio(gf,'Imaginary'),'Value'),
			y(1) = 0;
		end;
		y = y(1) + i * y(2);

		bb = get(finduitx(gf,'b'),'UserData');
		if abs(imag(y)) < tolerance,
			bb = [bb ; y(1)];
		else,
			bb = [bb ; y ; conj(y)];
		end;
		set(finduitx(gf,'b'),'UserData',bb)

		aa = get(finduitx(gf,'a'),'UserData');
		if length(bb) > length(aa),
			set(findchkb(gf,'Non-Causal'),'Enable','on','Value',1);
		end;

		% redo plots
		gfiltcal('plotall');

	end;

elseif strcmp(action,'delete'),

	if strcmp(arg1,'start'),

		% set the buttondown function for each pair
		zh = get(finduitx(gf,'I'),'UserData');
		set(zh,'ButtonDownFcn','gfiltcal(''delete'',''me'');');
		ph = get(finduitx(gf,'R'),'UserData');
		set(ph,'ButtonDownFcn','gfiltcal(''delete'',''me'');');

		set(findpush(gf,'Delete'),'Callback',...
			'gfiltcal(''delete'',''cancel'');');

		% set current axis and give user the message
		set(gf,'Pointer','crosshair');

		axes(findaxes(gf,'polar'));
		global SPC_FONTNAME SPC_TEXT_FORE
		set(get(findaxes(gf,'polar'),'xlabel'),'String',...
			'Click cursor on item to delete',...
			'FontName',SPC_FONTNAME,'Color',SPC_TEXT_FORE);

	elseif strcmp(arg1,'cancel'),

		% cancel delete operation, setup for move
		zh = get(finduitx(gf,'R'),'UserData');
		set(zh,'ButtonDownFcn','gfiltcal(''down'');');
		ph = get(finduitx(gf,'I'),'UserData');
		set(ph,'ButtonDownFcn','gfiltcal(''down'');');

		% change pointer back
		set(gf,'NextPlot','new','Pointer','arrow');

		set(findpush(gf,'Delete'),'Callback',...
			'gfiltcal(''delete'',''start'');');

		% clear message
		xlabel('');

	else,

		xlabel('');
		set(gf,'NextPlot','new','Pointer','arrow');

		% cancel delete callback, setup for move
		zh = get(finduitx(gf,'R'),'UserData');
		set(zh,'ButtonDownFcn','gfiltcal(''down'');');
		ph = get(finduitx(gf,'I'),'UserData');
		set(ph,'ButtonDownFcn','gfiltcal(''down'');');

		h = get(gf,'CurrentObject');
		axes(get(h,'Parent'));
		re = get(h,'XData');
		im = get(h,'YData');

		% determine what is was
		if get(h,'LineStyle') == 'x',
			xx = get(finduitx(gf,'a'),'UserData');
			type = 1;
		else,
			xx = get(finduitx(gf,'b'),'UserData');
			type = 0;
		end;

		% find index into roots vector
		ind1 = find( ((abs(real(xx) - re)) < tolerance) & ...
			((abs(imag(xx) - im)) < tolerance) );

		% look for a complex conjugate
		ind2 = find( ((abs(real(xx) - re)) < tolerance) & ...
			((abs(imag(xx) + im)) < tolerance) );

		if isempty(ind1) & isempty(ind2),

			if get(findrdio(gf,'Minimize'),'Value'),

				index = find(abs(xx) > 1.0);
				xx(index) = 1 ./ conj(xx(index));

			elseif get(findrdio(gf,'Maximize'),'Value');

				index = find(abs(xx) < 1.0);
				xx(index) = 1 ./ conj(xx(index));
			else,
			    if type == 1,
			spcwarn('gfilterd: Cannot delete virtual poles.','OK');
			    else,
			spcwarn('gfilterd: Error finding zero.','OK');
			    end;
			gfiltcal('delete','cancel');
			set(gf,'Pointer','arrow');
			return;
		end;

		% find index into roots vector
		ind1 = find( ((abs(real(xx) - gf_re)) < tolerance) & ...
			((abs(imag(xx) + gf_im)) < tolerance) );

		% look for a complex conjugate
		ind2 = find( ((abs(real(xx) - gf_re)) < tolerance) & ...
			((abs(imag(xx) - gf_im)) < tolerance) );

	end;
		% find index of roots meeting both criteria
		ind = sort([ind1(:);ind2(:)]);
		ind = ind(find(~(diff(ind))));

		% multiple roots
		nhits = length(ind);

		if (abs(re) < tolerance) & (abs(im) < tolerance),
			mode = 1;	% at zero, delete only one
		elseif abs(im) < tolerance,
			mode = 3;	% purely real, delete one
		elseif abs(re) < tolerance,
			mode = 4;	% purely imag delete pair
		else,
			mode = 6;	% delete conjugate pair
		end;

		if type

			%twas a pole
			xx = get(finduitx(gf,'a'),'UserData');
		else,
			%twas a zero
			xx = get(finduitx(gf,'b'),'UserData');
		end;

		if rem(mode,2) == 1,

			% get rid of only one
			xx(ind1(1)) = NaN;

		else,
			% get rid of both
			xx(ind1(1)) = NaN;
			if mode == 2,
				xx(ind1(2)) = NaN;
			else,
				xx(ind2(1)) = NaN;
			end;
		end;

		% get rid of NaN
		xx = xx(find(~isnan(xx)));

		if type

			% restore
			set(finduitx(gf,'a'),'UserData',xx);
		else,
			% restore
			set(finduitx(gf,'b'),'UserData',xx);
		end;

		set(findpush(gf,'Delete'),'Callback',...
			'gfiltcal(''delete'',''start'');');

		% redo plots
		gfiltcal('plotall');

	end;

elseif strcmp(action,'snapshot'),

	% handles to old axes
	ppol = findaxes(gf,'polar');
	mmag = findaxes(gf,'mag');
	pphs = findaxes(gf,'phase');

	% new figure
	h = figure;

	% new axes
	pol = subplot(1,2,1);
	mag = subplot(2,2,2);
	phs = subplot(2,2,4);

	% copy axes
	snapshot(ppol,pol);
	snapshot(mmag,mag);
	snapshot(pphs,phs);

	% make polar axis same color as figure axis
	kolor = get(pol,'XColor');
	h = get(pol,'Children');
	t = findobj(h,'LineStyle',':');
	set(t,'Color',kolor);
	t = findobj(h,'LineStyle','-');
	set(t,'Color',kolor);
	spctitle(pol,'Poles and Zeros');
	drawnow;

	% back to tool figure
	figure(gf);


elseif strcmp(action,'print'),

	aa = get(finduitx(gf,'a'),'UserData');
	bb = get(finduitx(gf,'b'),'UserData');
	gain = get(finduitx(gf,'Variables'),'UserData');

	% adjust for current phase conditions
	h = getcheck(gf,'Phase');
	st = get(h,'Label');
	if strcmp(st,'Move Zeros Only'),
		movemode = 1;
	elseif strcmp(st,'Move Poles Only'),
		movemode = 2;
	else,
		movemode = 3;
	end;
	if get(findrdio(gf,'Minimize'),'Value')
		if ~isempty(aa) & (movemode == 2 | movemode == 3),
			[aa,gg] = minphase(poly(aa));
			aa = roots(aa);
			gain = gain / gg;
		end;
		if ~isempty(bb) & (movemode == 1 | movemode == 3),
			[bb,gg] = minphase(poly(bb));
			bb = roots(bb);
			gain = gain * gg;
		end;
	elseif get(findrdio(gf,'Maximize'),'Value'),

		if ~isempty(aa),
			ind = find(abs(aa) < eps);
			aa(ind) = eps*ones(size(ind));
		end;
		if ~isempty(bb),
			ind = find(abs(bb) < eps);
			bb(ind) = eps*ones(size(ind));
		end;

		if ~isempty(aa) & (movemode == 2 | movemode == 3),
			[aa,gg] = maxphase(poly(aa));
			aa = roots(aa);
			gain = gain / gg;
		end;
		if ~isempty(bb) & (movemode == 1 | movemode == 3),
			[bb,gg] = maxphase(poly(bb));
			bb = roots(bb);
			gain = gain * gg;
		end;
	end;

	% ensure system is causal for freqz
	a = real(poly(aa));
	b = real(poly(bb));
	if isempty(a), a = 1; end;
	if isempty(b), b = 1; end;
	al = length(a);
	bl = length(b);

	nch = findchkb(gcf,'Non-Causal');
	if length(aa) >= length(bb),

		% causal system
		set(nch,'Value',0,'Enable','off');

		if al > bl,
			b = [fliplr(b) zeros(1,al-bl)];
			b = fliplr(b);
		elseif bl > al,
			a = [a zeros(1,bl-al)];
			a = fliplr(a);
		end;
	else
		% non-causal system
		set(nch,'Enable','on');

		if al > bl,
			b = [fliplr(b) zeros(1,al-bl)];
			b = fliplr(b);
		elseif bl > al,
			if get(nch,'Value'),
				a = [fliplr(a) zeros(1,bl-al)];
				a = fliplr(a);
			else,
				a = [a zeros(1,bl-al)];
			end;
		end;
	end;

	aa = cplxpair(roots(a));
	bb = cplxpair(roots(b));

	% print data in command window
	disp(' ');
	disp('----------------------------------------');
	disp('Filter Polynomials');
	disp('----------------------------------------');
	format short

	% get root data and pad as necessary
	if length(bb),
		gf_b_r = real(bb);
		gf_b_i = imag(bb);
		gf_b_m = abs(bb);
		gf_b_a = angle(bb);
		b_disp = zeros(length(bb),4);
		b_disp(1:length(gf_b_r),1) = gf_b_r;
		b_disp(1:length(gf_b_i),2) = gf_b_i;
		b_disp(1:length(gf_b_m),3) = gf_b_m;
		if ischeckd(gf,'Angles','Degrees'),
			b_disp(1:length(gf_b_a),4) = gf_b_a/pi*180;
		else,
			b_disp(1:length(gf_b_a),4) = gf_b_a/pi;
		end;
		disp('Zeros');
		disp('      Real      Imag       Mag     Angle');
		disp(b_disp);
	end;
	if length(aa),
		gf_a_r = real(aa);
		gf_a_i = imag(aa);
		gf_a_m = abs(aa);
		gf_a_a = angle(aa);
		a_disp = zeros(length(aa),4);
		a_disp(1:length(gf_a_r),1) = gf_a_r;
		a_disp(1:length(gf_a_i),2) = gf_a_i;
		a_disp(1:length(gf_a_m),3) = gf_a_m;
		if ischeckd(gf,'Angles','Degrees'),
			a_disp(1:length(gf_a_a),4) = gf_a_a/pi*180;
		else,
			a_disp(1:length(gf_a_a),4) = gf_a_a/pi;
		end;
		disp('Poles');
		disp('      Real      Imag       Mag     Angle');
		disp(a_disp);
 	   end;

	tol = 100000000;
	a = round(tol*a)/tol;
	b = round(tol*b)/tol;

%	ind = find(a ~= 0);
%	a = a / a(ind(1));
%	ind = find(b ~= 0);
%	b = b / b(ind(1));

	format short
	disp('Zero Polynomial');
	disp(gain*real(b));
	disp('Pole Polynomial');
	disp(real(a));

elseif strcmp(action,'impulse'),

	gf_a = real(poly(get(finduitx(gf,'a'),'UserData')));
	gf_b = real(poly(get(finduitx(gf,'b'),'UserData')));

	if findfig('Impulse Response'),
		close(findfig('Impulse Response'));
	end;

	s = get(0,'ScreenSize');
	if s(3) > 640,
		x_pos = .5;
		x_wid = .5;
	else
		x_pos = .1;
		x_wid = .9;
	end;

	GF_pos = [0 x_pos x_wid x_wid/1.5];

	figure('units','normal','position',GF_pos,...
		'Name','Impulse Response');

	% add close menu
	m = uimenu('Label','Figure');
	uimenu(m,'Label','Close','CallBack','close(gcf);');

	imp = [1;zeros(99,1)];
	y = filter(gf_b,gf_a,imp);
	plot(0:99,y);

	global SPC_FONTNAME;

	set(gca,'FontName',SPC_FONTNAME);
	title('Impulse Response');
	set(get(gca,'title'),'FontName',SPC_FONTNAME);
	xlabel('n');
	set(get(gca,'xlabel'),'FontName',SPC_FONTNAME);
	ylabel('Magnitude');
	set(get(gca,'ylabel'),'FontName',SPC_FONTNAME);

else,
	error(['gfiltcal: Undefined function "' action '"...']);
end


if ~strcmp(get(gf,'Pointer'),'crosshair'),
	set(gf,'Pointer','arrow');
end;
