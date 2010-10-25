function sigdecal(action,arg1,arg2)
%SIGDEMCAL Support file for sigdemod.m.

%       Dennis W. Brown 3-93, DWB 5-12-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% base objects
gf = gcf;
ga = get(gf,'CurrentAxes');

set(gf,'Pointer','watch');

if strcmp(action,'apply'),

	% get variables
	signal = get(findmenu(gf,'Apply'),'UserData');
	vf_fft = getpopvl(gf,'FFT');
	fs = getpopvl(gf,'FS');

	% design the filter
	sigdecal('design');
    	vf_acoef = get(finduitx(gf,'Lower'),'UserData');
    	vf_bcoef = get(finduitx(gf,'Upper'),'UserData');

	% apply the filter
	signal = filter(vf_bcoef,vf_acoef,signal);

	% save changes to common variable
	global SPC_COMMON;
	SPC_COMMON = signal;

	% store filtered signal away
	set(findmenu(gf,'Apply'),'UserData',signal);

	h = findline(findaxes(gcf,'freq'),'old');
	if ~isempty(h),
		delete(h);
	end;

	% replot the filtered vector
	sigdecal('plotfreq');

	if ~isempty(findmenu(gf,'Apply','Use')),
		set(findmenu(gf,'Apply','Use'),'Enable','on');
	end;

	% updata signal window
	if ischeckd(gf,'Filter','Display Signal'),

		h = get(findmenu(gf,'Apply','Filter'),'UserData');
		if isempty(find(get(0,'Children') == h)),
			h = figure('Name','Time-Domain Signal');
			tscale = (0:1/fs:((length(signal)-1)/fs))';
			plot(tscale,signal);
			zoomtool;
			zoomplay(h,fs);
			zoomprog(h);
			set(findmenu(gf,'Apply','Filter'),'UserData',h);

			if (strcmp(computer,'PCWIN')),
				set(h,'MenuBar','none');
			end;
		else,
			zoomrep(findaxes(h,'zoomtool'),signal);
		end;
	end;
	
	% updata demod windows
	sm = ischeckd(gf,'Demod','Signal');
	am = ischeckd(gf,'Demod','AM');
	fm = ischeckd(gf,'Demod','FM');
	pm = ischeckd(gf,'Demod','PM');
	n = sm + am + fm + pm;
	ok = get(findmenu(gf,'Demod'),'Enable');
	if strcmp(ok,'on') & n > 0,

		h = get(findmenu(gf,'Demod'),'UserData');
		if ~isempty(find(get(0,'Children') == h)),
			close(h);
		end;
		
		h = figure('Name','Demodulated Signal');
		set(findmenu(gf,'Demod'),'UserData',h);
		
		
		tscale = (0:1/fs:((length(signal)-1)/fs))';
		
		ni = 1;
		if sm,
			ax = subplot(n,1,ni);
			plot(tscale,signal);
			title('Signal');
			ni = ni+1;
		end;
		
		f1 = crsrloc(ga,'freq1');
		f2 = crsrloc(ga,'freq2');
		fc = (f1 + f2) / 2;
		
		if am,
			x = signal .* cos(2*pi*fc*tscale);
			ax = subplot(n,1,ni);
			plot(tscale,x);
			title('AM Demodulated Signal');
			ni = ni + 1;
		end;

		if fm | pm,
			xq = hilbert(signal) .* exp(-j * 2 * pi * fc * tscale);
		end;
		
		if fm,
			x = diff(unwrap(angle(xq)));
			ax = subplot(n,1,ni);
			plot(tscale(2:length(tscale)),x);
			title('FM Demodulated Signal');
			ni = ni + 1;
		end;

		if pm,
			x = angle(xq);
			ax = subplot(n,1,ni);
			plot(tscale,x);
			title('PM Demodulated Signal');
			ni = ni + 1;
		end;
		
		if n == 1,
			zoomtool(ax);
		else
			zoomtool(ax,'Pan','off');
		end;

	end;

elseif strcmp(action,'scale'),

	% cutoff freq cursors
	ga = findaxes(gf,'freq');
	f1 = crsrloc(ga,'freq1');
	f2 = crsrloc(ga,'freq2');
	delete(findline(ga,'freq1'));
	delete(findline(ga,'freq2'));

	% get line objects
	hc = findobj(get(ga,'Children'),'Type','line')';

	newmax = [];
	newmin = [];

	if ischeckd(gf,'Scale','Linear'),

		for i = 1:length(hc),

			% get y data
			y = get(hc(i),'YData');

			% make linear
			y = 10.^(y/20);

			% find
			newmax = [newmax max(y)];
			newmin = [newmin min(y)];

			% replace y data
			set(hc(i),'YData',y);

		end;

		spcylabl(ga,'Power (W)')

	else

		for i = 1:length(hc),
			% get y data
			y = get(hc(i),'YData');

			% make logarithmic
			y = 20*log10(y);

			% find
			newmax = [newmax max(y)];
			newmin = [newmin min(y)];

			% replace y data
			set(hc(i),'YData',y);

		end;

		spcylabl(ga,'Power (dB)')
	end;

	% new extremes
	newmax = max(newmax);
	newmin = min(newmin);
	newmin = newmin - 0.05 * abs(newmin - newmax);
	newmax = newmax + 0.05 * abs(newmin - newmax);
	set(ga,'YLim',[newmin newmax]);

	% cutoff freq cursors
	vf_type = lower(get(getcheck(gf,'Filter',2),'Label'));
	crsrmake(ga,'freq1','vertical',f1,'--','sigdecal(''drawtrans'');');
	crsrmake(ga,'freq2','vertical',f2,'-.','sigdecal(''drawtrans'');');
	if strcmp(vf_type,'bandpass') | strcmp(vf_type,'stopband'),
		crsron(findaxes(gf,'freq'),'freq2');
	else,
		crsroff(findaxes(gf,'freq'),'freq2');
	end;

elseif strcmp(action,'fullmag'),

	% cutoff freq cursors
	ga = findaxes(gf,'freq');
	f1 = crsrloc(ga,'freq1');
	f2 = crsrloc(ga,'freq2');
	delete(findline(ga,'freq1'));
	delete(findline(ga,'freq2'));

	% get line objects
	hc = findobj(get(ga,'Children'),'Type','line')';

	newmax = [];
	newmin = [];

	for i = 1:length(hc),

		% get y data
		y = get(hc(i),'YData');

		% find
		newmax = [newmax max(y)];
		newmin = [newmin min(y)];

	end;

	% new extremes
	newmax = max(newmax);
	newmin = min(newmin);
	newmin = newmin - 0.05 * abs(newmin - newmax);
	newmax = newmax + 0.05 * abs(newmin - newmax);
	set(ga,'YLim',[newmin newmax]);

	% cutoff freq cursors
	vf_type = lower(get(getcheck(gf,'Filter',2),'Label'));
	crsrmake(ga,'freq1','vertical',f1,'--','sigdecal(''drawtrans'');');
	crsrmake(ga,'freq2','vertical',f2,'-.','sigdecal(''drawtrans'');');
	if strcmp(vf_type,'bandpass') | strcmp(vf_type,'stopband'),
		crsron(findaxes(gf,'freq'),'freq2');
	else,
		crsroff(findaxes(gf,'freq'),'freq2');
	end;

elseif strcmp(action,'design'),

	fs = getpopvl(gf,'FS');
	vf_Rp = getpopvl(gf,'Ripple');
	vf_Rs = getpopvl(gf,'Atten');
	vf_filter = lower(get(getcheck(gf,'Filter',1),'Label'));
	vf_type = lower(get(getcheck(gf,'Filter',2),'Label'));
	ga = findaxes(gf,'freq');
	f1 = crsrloc(ga,'freq1');
	f2 = crsrloc(ga,'freq2');
	if f1 > f2,
		t=f1; f1 = f2; f2 = t;
		crsrmove(ga,'freq1',f1);
		crsrmove(ga,'freq2',f2);
	end;
	set(findedit(gf,'lower'),'String',num2str(f1));
	set(findedit(gf,'upper'),'String',num2str(f2));
	if f1 == 0, return; end;


	if (strcmp(vf_type,'bandpass') | strcmp(vf_type,'stopband')) ...
			& f2 == 0,
		spcwarn('sigdemod: Lower cutoff frequency cannot be zero.','OK');
		set(gf,'Pointer','arrow');
		return;
	end;

	% filter order
	if strcmp(vf_filter,'fir'),
		vf_length = getpopvl(gf,'FIR');
	else,
		vf_length = getpopvl(gf,'IIR');
	end;

	% make adjustments as required for signal processing toolbox functions
	if strcmp(vf_type,'highpass') | strcmp(vf_type,'stopband'),
		if rem(vf_length,2)==1,
		vf_length=vf_length+1;
		disp(['sigdemod: Filter length must be even for highpass or stopband filters.']);
		disp(['sigdemod: Filter length adjusted to ' int2str(vf_length)]);
		end;
	end;

	if strcmp(vf_filter,'fir'),

		% get window too
		vf_window = gtfirwin(gf,vf_length+1);
	end,

	% set digital cutoff frequencies
	if strcmp(vf_type,'bandpass') | ...
			strcmp(vf_type,'stopband'),
		Wn = 2/fs * [f1 f2];
	else,
		Wn = 2*f1/fs;
	end;

	% design the filter
	if strcmp(vf_filter,'fir'),

		vf_acoef = 1;
		if strcmp(vf_type,'lowpass') | strcmp(vf_type,'bandpass'),
			vf_bcoef = fir1(vf_length,Wn,vf_window);
		else,
			vf_bcoef = fir1(vf_length,Wn,vf_type,vf_window);
		end;

	elseif strcmp(vf_filter,'butterworth'),

		if strcmp(vf_type,'lowpass') | strcmp(vf_type,'bandpass'),
			[vf_bcoef,vf_acoef] = butter(vf_length,Wn);
		else,
			[vf_bcoef,vf_acoef] = butter(vf_length,Wn,vf_type);
		end;

	elseif strcmp(vf_filter,'cheby type 1'),

		if strcmp(vf_type,'lowpass') | strcmp(vf_type,'bandpass'),
			[vf_bcoef,vf_acoef] = cheby1(vf_length,vf_Rp,Wn);
		else,
			[vf_bcoef,vf_acoef] = cheby1(vf_length,vf_Rp,Wn,vf_type);
		end;

	elseif strcmp(vf_filter,'cheby type 2'),

		if strcmp(vf_type,'lowpass') | strcmp(vf_type,'bandpass'),
			[vf_bcoef,vf_acoef] = cheby2(vf_length,vf_Rs,Wn);
		else,
			[vf_bcoef,vf_acoef] = cheby2(vf_length,vf_Rs,Wn,vf_type);
		end;

	elseif strcmp(vf_filter,'elliptical'),

		if strcmp(vf_type,'lowpass') | strcmp(vf_type,'bandpass'),
			[vf_bcoef,vf_acoef] = ellip(vf_length,vf_Rp,vf_Rs,Wn);
		else,
			[vf_bcoef,vf_acoef] = ellip(vf_length,vf_Rp,vf_Rs,Wn,vf_type);
		end;
	end;

	% store coefficients
	set(finduitx(gf,'Lower'),'UserData',vf_acoef);
	set(finduitx(gf,'Upper'),'UserData',vf_bcoef);

elseif strcmp(action,'plottime'),

	set(gf,'NextPlot','add');
	ga = findaxes(gf,'time');
	axes(ga);

	signal = get(findmenu(gf,'Apply'),'UserData');
	vf_fft = getpopvl(gf,'FFT');
	fs = getpopvl(gf,'FS');
	vf_tscale = (0:length(signal)-1)/fs;

	global SPC_LINE SPC_FONTNAME SPC_TEXT_FORE SPC_AXIS;
	plot(vf_tscale,signal,SPC_LINE);

	spcaxes(ga);
	set(ga,'XLim',[0 max(vf_tscale)],'UserData','time');

	spcxlabl(ga,'Time (seconds)');
	spcylabl(ga,'Amplitude');

	crsrmake(ga,'time1','vertical',length(signal)/4/fs,'--','');
	crsrmake(ga,'time2','vertical',3*length(signal)/4/fs,'-.','');

elseif strcmp(action,'plotfreq');

	signal = get(findmenu(gf,'Apply'),'UserData');
	fs = getpopvl(gf,'FS');
	vf_fft = getpopvl(gf,'FFT');
	fscale = fs*(0:vf_fft/2-1)/vf_fft;

	set(gf,'NextPlot','add');
	ga = findaxes(gf,'freq');
	axes(ga)

	% zero pad if necessary
	if length(signal) < vf_fft,
		signal = [signal(:) ; zeros(vf_fft - length(signal),1)];
	end;

	% take Welch spectrum using signal processing toolbox
	vf_ss = spectrm2(signal,vf_fft,hanning(vf_fft));
	vf_spectrum = sqrt(2*vf_ss(:,1)/vf_fft)/2;
	fscale = fs*(0:vf_fft/2-1)/vf_fft;

	% align for proper display on dB scale with xfer function
	nfactor = get(findmenu(gf,'Filter','FIR'),'UserData');
	if isempty(nfactor),
		nfactor = 0 - 20*log10(max(vf_spectrum));
		set(findmenu(gf,'Filter','FIR'),'UserData',nfactor);
	end;

	h = findline(ga,'spectrum');
	olddata = [];
	if ~isempty(h),
		olddata = get(h,'YData');
		oldlimits = get(ga,'YLim');
	end;

	global SPC_LINE
	if ischeckd(gf,'Scale','Linear'),

		h = plot(fscale',vf_spectrum,SPC_LINE);
		set(h,'UserData','spectrum');
		spcylabl(ga,'Relative Watts (W)');

	else,

		h = plot(fscale',20*log10(vf_spectrum) + nfactor,SPC_LINE);
		set(h,'UserData','spectrum');
		spcylabl(ga,'Magnitude (dB)');

	end;

	% maximize usage of x axis
	set(ga,'XLim',[0 max(fscale)]);

	% label it
	spcxlabl(ga,'Frequency (Hz)');
	spcaxes(ga);
	spctitle(ga,'Power Spectal Density (Welch Estimate)');

	% line order
	global SPC_COLOR_ORDER
	set(ga,'UserData','freq','ColorOrder',SPC_COLOR_ORDER);

	if ~isempty(olddata) & length(olddata) == vf_fft/2,
		h = line(fscale',olddata);
		set(h,'LineStyle',':','UserData','old');
		set(ga,'YLim',oldlimits);
	end;

	% cutoff freq cursors
	vf_filter = lower(get(getcheck(gf,'Filter',1),'Label'));
	vf_type = lower(get(getcheck(gf,'Filter',2),'Label'));
	f1 = getednbr(gf,'lower');
	f2 = getednbr(gf,'upper');

	% make sure they're not beyond the limits
	if f1 > fs/2,
		f1 = fs/8;
		set(findedit(gf,'lower'),'String',num2str(f1));
	end;
	if f2 >= fs/2-1/fs,
		f2 = 3*fs/8;
		set(findedit(gf,'upper'),'String',num2str(f2));
	end;
	if f1 > f2,
		t = f1; f1 = f2; f2 = t;
		set(findedit(gf,'lower'),'String',num2str(f1));
		set(findedit(gf,'upper'),'String',num2str(f2));
	end;

	% ok to make em now
	crsrmake(ga,'freq1','vertical',f1,'--','sigdecal(''drawtrans'');');
	crsrmake(ga,'freq2','vertical',f2,'-.','sigdecal(''drawtrans'');');
	if strcmp(vf_type,'bandpass') | strcmp(vf_type,'stopband'),
		crsron(findaxes(gf,'freq'),'freq2');
	else,
		crsroff(findaxes(gf,'freq'),'freq2');
	end;

	% display transfer function
	sigdecal('drawtrans');

	set(ga,'ButtonDownFcn','sigdecal(''sety'')');

elseif strcmp(action,'sety'),

	p = get(ga,'CurrentPoint');

	ga = findaxes(gf,'freq');

	ylim = get(ga,'YLim');

	if ischeckd(gf,'Scale','Logarithmic'),
		if p(1,2) > 0,
			set(ga,'YLim',[ylim(1) ceil(p(1,2))]);
		else,
			set(ga,'YLim',[floor(p(1,2)) ylim(2)]);
		end;
	else
		set(ga,'YLim',[ylim(1) p(1,2)]);
	end;

	% adjust cursor lengths
	ylim = get(ga,'YLim');
	set(findline(ga,'freq1'),'YData',ylim);
	set(findline(ga,'freq2'),'YData',ylim);

elseif strcmp(action,'drawtrans'),

	ga = findaxes(gf,'freq');
	fs = getpopvl(gf,'FS');

	% only if cutoff freq has been set
	if f1 == 0, return; end;

	% if filter curve already on graph, delete it
	trans = findline(ga,'transfer');
	if ~isempty(trans), delete(trans); end;

	% get the y axis limit to use later
	ylim = get(ga,'YLim');

	% design the filter, retrieve coeficients
	sigdecal('design');
    	vf_acoef = get(finduitx(gf,'Lower'),'UserData');
    	vf_bcoef = get(finduitx(gf,'Upper'),'UserData');

	% compute the transfer function
	[h,w] = freqz(vf_bcoef,vf_acoef,512);
	z = find(h == 0);
	h(z) = ones(length(z),1) * eps;
	h = abs(h);

	% set axes up to add transfer function to it
	set(gf,'NextPlot','add');
	set(ga,'NextPlot','add');

	% plot the transfer function
	global SPC_TRANSFER
	if ischeckd(gf,'Scale','Logarithmic'),
		h = 20*log10(h);
	end;
	vf_trans = plot(w/pi * fs/2,h,SPC_TRANSFER);
	set(vf_trans,'UserData','transfer');

	% ensure lower axis limits same as before, show top of xfer
	top = max(h);
	top = top + 0.05 * abs(top - ylim(1));
	set(ga,'YLim',[ylim(1) top]);
	set(findline(ga,'freq1'),'YData',[ylim(1) top]);
	set(findline(ga,'freq2'),'YData',[ylim(1) top]);

	% set axes back to replace mode
	set(ga,'NextPlot','replace');
	set(gf,'NextPlot','new');

elseif strcmp(action,'setfilter'),

	vf_filter = lower(get(getcheck(gf,'Filter',1),'Label'));

	if strcmp(vf_filter,'fir'),

		set(findpopu(gf,'Ripple'),'Visible','off');
		set(findpopu(gf,'Atten'),'Visible','off');
		set(findpopu(gf,'FIR'),'Visible','on');
		set(findpopu(gf,'IIR'),'Visible','off');
	else
		% adjust controls for IIR
		if strcmp(vf_filter,'butterworth') | ...
			strcmp(vf_filter,'cheby type 2'),

			% no bandpass spec for these
			set(findpopu(gf,'Ripple'),'Visible','off');
		else,
			set(findpopu(gf,'Ripple'),'Visible','on');
		end;
		if strcmp(vf_filter,'cheby type 2') | ...
				strcmp(vf_filter,'elliptical'),
			set(findpopu(gf,'Atten'),'Visible','on');
		else,
			set(findpopu(gf,'Atten'),'Visible','off');
		end;
		set(findpopu(gf,'FIR'),'Visible','off');
		set(findpopu(gf,'IIR'),'Visible','on');
	end;

	% draw transfer function
	sigdecal('drawtrans');

elseif strcmp(action,'settype'),

	% get filter type from popupmenu
	vf_type = lower(get(getcheck(gf,'Filter',2),'Label'));

	% turn upper cutoff freq user box on or off as necessary
	if strcmp(vf_type,'bandpass') | strcmp(vf_type,'stopband'),
		set(findedit(gf,'upper'),'Visible','on');
		crsron(findaxes(gf,'freq'),'freq2');
	else,
		set(findedit(gf,'upper'),'Visible','off');
		crsroff(findaxes(gf,'freq'),'freq2');
	end;

	% Enable demodulation for bandpass only
	if strcmp(vf_type,'bandpass')
		set(findmenu(gf,'Demod'),'Enable','on');
	else
		set(findmenu(gf,'Demod'),'Enable','off');
	end;
	
	% draw transfer function
	sigdecal('drawtrans');

elseif strcmp(action,'play'),

	fs = getpopvl(gf,'FS');
	signal = get(findmenu(gf,'Apply'),'UserData');
	ga = zoomed(gf);
	t1 = crsrloc(ga,'time1');
	t2 = crsrloc(ga,'time2');
	if t1 > t2, t=t1; t1=t2; t2=t; end;
	i1 = floor(t1 * fs) - 1;
	i2 = floor(t2 * fs) - 1;

	if strcmp(arg1,'full'),
		sound(signal,fs);
	else,
		sound(signal(i1:i2),fs);
	end;

elseif strcmp(action,'f_length'),

	vf_filter = lower(get(getcheck(gf,'Filter',1),'Label'));

        % reset user menu items
        if strcmp(vf_filter,'fir'),
		set(findpopu(gf,'FIR'),'Visible','on');
		set(findpopu(gf,'IIR'),'Visible','off');
	else,
		set(findpopu(gf,'FIR'),'Visible','off');
		set(findpopu(gf,'IIR'),'Visible','on');
	end;

	% draw transfer function
	sigdecal('drawtrans');

elseif strcmp(action,'lower'),

	% get filter type from popupmenu
	vf_type = lower(get(getcheck(gf,'Filter',2),'Label'));
	fs = getpopvl(gf,'FS');

	% turn upper cutoff freq user box on or off as necessary
	ga = findaxes(gf,'freq');
	if strcmp(vf_type,'bandpass') | strcmp(vf_type,'stopband'),
		range = [0 crsrloc(ga,'freq2')];
	else,
		range = [0 fs/2];
	end;

	% check value
	if ~ednbrchk(findedit(gf,'lower'),'Range',range,...
		'Integer','off','Variable','Lower'), return; end;

 	% make sure we have focus
 	figure(gf);

	% get lower cutoff frequency from user
	lower = eval(get(findedit(gf,'lower'),'String'));
%	lower = getednbr(findedit(gf,'lower'),'Range',range,...
%		'Integer','off','Variable','Lower');

	% move cursor
	crsrmove(ga,'freq1',lower);

	% draw transfer function
	sigdecal('drawtrans');

elseif strcmp(action,'upper'),

	% check value
	ga = findaxes(gf,'freq');
	fs = getpopvl(gf,'FS');
	vf_fft = getpopvl(gf,'FFT');
	if ~ednbrchk(findedit(gf,'upper'),'Range',[crsrloc(ga,'freq1') ...
			fs/2-fs/vf_fft],...
		'Integer','off','Variable','Lower'), return; end;

 	% make sure we have focus
 	figure(gf);

	% get upper cutoff frequency from user
	upper = eval(get(findedit(gf,'upper'),'String'));

	% move cursor
	crsrmove(ga,'freq2',upper);

	% draw transfer function
	sigdecal('drawtrans');

elseif strcmp(action,'init'),

	% delete old lines
	ga = findaxes(gf,'freq');
	h = findline(ga,'spectrum');
	if ~isempty(h), delete(h); end;
	h = findline(ga,'old');
	if ~isempty(h), delete(h); end;

	% reset nomalization factor
	set(findmenu(gf,'Filter','FIR'),'UserData',[]);

	% redo plots
        sigdecal('plotfreq');

	if ischeckd(gf,'Filter','Display Signal'),

		% update signal window
		signal = get(findmenu(gf,'Apply'),'UserData');
		fs = getpopvl(gf,'FS');
		tscale = (0:length(signal)-1)/fs;

		% git rid of old one first
		h = get(findmenu(gf,'Apply','Filter'),'UserData');
		if find(get(0,'Children') == h); close(h); end;

		% now with the new
		h = figure('Name','Time-Domain Signal');
		plot(tscale,signal);
		xlabel('Amplitude');
		ylabel('Time (s)');
		title('Time-Domain Signal');

		% add zoomtool
		zoomtool;
		zoomplay(h,fs);
		zoomprog(h);

		% store handle to signal window
		set(findmenu(gf,'Apply','Filter'),'UserData',h);

		if (strcmp(computer,'PCWIN')),
			set(h,'MenuBar','none');
		end;

	end;


elseif strcmp(action,'use'),

	h = get(findmenu(gf,'Apply','Filter'),'UserData');
	if ~isempty(find(get(0,'Children') == h)),
		close(h);
	end;
	close(gf);
	return;

elseif strcmp(action,'restore')

	signal = get(findmenu(gf,'Workspace','Restore'),'UserData');

	% is it a file?
	if isstr(signal),

		ind = find(signal == '#');
		if isempty(ind),
			[signal,fs] = readsig(signal);
		else,
			bits = str2num(signal(ind(1)+1:length(signal)));
			signal = signal(1:ind-1);
			[signal,fs] = readsig(signal,bits);
		end;

		% set sampling freq popup menu
		h = findpopu(gf,'FS');
		max = get(h,'Max');

		% get current values
		items = zeros(max-1,1);
		str = get(h,'String');
		for i = 1:max-1,
			items(i) = str2num(str(i,:));
		end;

		if find(fs == items),

			% sampling freq already in popup menu
			set(h,'Value',find(fs == items));

		else,
			% add new sampliing freq
			popstr = [];
			for i = 1:max-1,
				popstr = [popstr int2str(items(i)) '|'];
			end;
			popstr = [popstr int2str(fs) '|User'];

			% reset popup menu
			set(h,'String',popstr,'Value',max);
		end;
	end;

	set(findmenu(gf,'Apply'),'UserData',signal);

	sigdecal('init');

elseif strcmp(action,'killtime')

	gf = gcf;

	if ischeckd(gf,'Filter','Display Signal'),
		set(findmenu(gf,'Filter','Display Signal'),'Checked','off');
	else,
		set(findmenu(gf,'Filter','Display Signal'),'Checked','on');
	end;

	if ischeckd(gf,'Filter','Display Signal'),

		% update signal window
		signal = get(findmenu(gf,'Apply'),'UserData');
		fs = getpopvl(gf,'FS');
		tscale = (0:length(signal)-1)/fs;

		% git rid of old one first
		h = get(findmenu(gf,'Apply','Filter'),'UserData');
		if find(get(0,'Children') == h); close(h); end;

		% now with the new
		h = figure('Name','Time-Domain Signal');
		plot(tscale,signal);
		xlabel('Amplitude');
		ylabel('Time (s)');
		title('Time-Domain Signal');

		% add zoomtool
		zoomtool;
		zoomplay(h,fs);
		zoomprog(h);

		% store handle to signal window
		set(findmenu(gf,'Apply','Filter'),'UserData',h);
	else,

		% git rid of time-domain display
		h = get(findmenu(gf,'Apply','Filter'),'UserData');
		if find(get(0,'Children') == h); close(h); end;
		set(findmenu(gf,'Apply','Filter'),'UserData',[]);
	end;
else
	error(['sigdecal: Invalid action "' action '" requested.']);
end

set(gf,'Pointer','arrow');
