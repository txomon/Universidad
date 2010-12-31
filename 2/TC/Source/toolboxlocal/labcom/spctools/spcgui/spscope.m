function gff = spscope(action,arg1,arg2);
%SPSCOPE Spectrum analyzer.
%	[H]=SPSCOPE(X) opens a three-dimensional frequency
%	estimation tool for analyzing the time-domain
%	signal X.
%
%	[H]=SPSCOPE(X,FS) sets the sampling frequency to FS.
%	The default sampling frequency is 8192 Hz.  A sampling
%	frequency of 1 Hz will display the frequency spectrum
%	in digital frequency units and the frame length in
%	samples-per-frame vice time (see below).
%
%	The 3D Spectrum Analyzer dodad opens with a display of
%	a 512-point, 2D Welch spectral estimate.  ZOOMTOOL is
%	available on this plot and can be used for measurement
%	and/or zooming in on the 2D plot.  This operation is
%	similar to the SPECT2D dodad.
%
%	SPSCOPE('FILENAME') and SPSCOPE('FILENAME',BITS) open the
%	file specified by 'FILENAME' and loads the signal stored
%	within directly into the tool.  File formats with the
%	extensions *.au, *.voc, *.wav, and *.tim can be specified
%	by the 'FILENAME' option only (be sure to include the
%	extension).  Flat integer formatted file require the BITS
%	argument where BITS is either 8, 16, or 32.  Integer formats
%	must be stored as signed integers to be read correctly.
%	Multi-byte integers (16 and 32) are assumed to be compatible
%	with the format used by the workstation in use ("Little Endian"
%	and "Big Endian" files are not compatible).  Pathnames are
%	required when the file is not in the current directory.
%	The sampling frequency is set to that store in the file
%	for *.voc and *.wav formats.  All others default to 1 Hz.
%
%	See also SPSCOPE, SPSCOPES, ZOOMTOOL, V3DTOOL

%       Dennis W. Brown 2-3-94, DWB 6-11-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% variable storage
% signal - "Step" uitx
% FFT's  - "Play" uitx
% index of current frame - "Frame" uitx
% time window handle - "Next" push button

% check args,
if nargin < 1
        signal = randn(512,1);
	fs = 8192;
	action = 'start';
elseif ~isstr(action)

	% normalize signal
	signal = action / std(action);
	signal = signal(:);
	action = 'start';
	if nargin == 2,
		fs = arg1;
	else
		fs = 8192;
	end;
else,

	if ~isempty(find(action == '.')),
		[signal,fs] = readsig(action);
		action = 'start';
	elseif nargin > 2,
		if ~isstr(arg1),

			% flat integer files (only other thing arg2 can
			% be when action is a string is a string)
			[signal,fs] = readsig(action,arg1);
			action = 'start';
		else,
			set(gcf,'Pointer','watch');
		end;
	else,
		set(gcf,'Pointer','watch');
	end

end;

if strcmp(action,'start'),

	% local variables
	nbrcols = 5; nbrrows = 2;
	b_hite = .05; 	b_int = .015;	b_frame = .005; b_end = .05;
	b_width = (1 - (nbrcols-1)*b_int - 2*b_end)/nbrcols;
	columns = (0:nbrcols-1) .* (b_width + b_int) + b_end;
	rows = (0:nbrrows-1) .* (b_hite + b_int) + b_end;

	axis_left = .1;     axis_bottom = .3;
	axis_width = .85;   axis_hite = .9 - axis_bottom;

	% graphics initialization

	spcolors;
	global SPC_3D_POS SPC_WINDOW SPC_AXIS
	s = get(0,'ScreenSize');
	if exist('SPC_3D_POS'),
		pos = SPC_3D_POS;
	elseif s(3) < 800,
		pos = [.1 0 .9 .9];
	elseif s(3) >= 800 & s(3) < 1024,
		pos = [.1 .1 .8 .8];
	elseif s(3) == 1024,
		pos = [.15 .15 .7 .7];
	else
		pos = [.25 .25 .5 .5];
	end;

	gf = figure('Units','normalized','backingstore','off',...
		'Color',SPC_WINDOW,...
		'Name','Spectrum Scope Tool - by D.W. Brown',...
		'Position',pos,'NumberTitle','off');

	% following line is bug workaround for version 4.1 and below
	set(gf,'BackingStore','off','BackingStore','on');

	if (strcmp(computer,'PCWIN')),
		set(gf,'MenuBar','none');
	end;

	% add the basic workspace menu
	workmenu(gf,'','','spscope(''common'');', ...
		'spscopel','spscopes');

	% turn off restore menu since this tool doesn't change the signal
	delete(findmenu(gf,'Workspace','Restore'));

	global SPC_COOL_WINDOW
	if SPC_COOL_WINDOW,
		SPC_TEXT_FORE = 'white';
		drawnow
		map = [linspace(0,.5,64)' zeros(64,1) linspace(0,1,64)'];
		pic = [1:64]';
		colormap(copper)
		image( pic )
		set( gca,'pos',[0 0 1 1], 'visible','off')
	end;

	% add FIR window menu
	mufirwin(gf,'spscocal(''window'');');

	% Scale menu
	items = str2mat('Linear','Logarithmic');
	togmenu(gf,'Scale',items,2,'spscope(''apply'',''current'');');

	% accelerator keys for Angles menu
	set(findmenu(gf,'Scale','Linear'),'Accelerator','W');
	set(findmenu(gf,'Scale','Logarithmic'),'Accelerator','L');

	% add overlap length menu
	items = str2mat('0','10','20','30','40','50','60','70','80','90');
	togmenu(gf,'Overlap',items,6,'spscocal(''overlap'');');

	% time smoothing
	items = str2mat('1','2','3','4','5','6','7','8');
	togmenu(gf,'TimeSmooth',items,1,'spscocal(''timesmooth'');');

	% frequency smoothing
	items = str2mat('1','3','5','7','9','11','15');
	togmenu(gf,'FreqSmooth',items,1,'spscope(''apply'',''current'');');

	% draw a frame first
	hh = uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(1)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

	% get the frame's color so we can set our text background the same
	bcolor = get(hh,'BackGroundColor');

	% if on a PC, set a special color for edit boxes so that they are
	% visible. otherwise, make same as frame cause that looks better on
	% Sun workstation ***Mathworks!***
	if strcmp(computer,'PCWIN'),
		beditcolor = [1 1 1] * 0.7;
	else,
		beditcolor = bcolor;
	end;

	% setup FFT length popupmenu
	popunbrs(gf,[columns(1)+b_width/2 rows(1) b_width/2 b_hite], ...
		[16 32 64 128 256 512 1024 2048],'FFT', ...
		'CallBack','spscocal(''fft'');', ...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'Range',[16 Inf],'Integer','on','PowerOfTwo','on', ...
		'LabelPosition',[columns(1)+b_width/2 rows(2) ...
			b_width/2 b_hite],...
		'LabelJustify','center');
	set(findpopu(gf,'FFT'),'Value',6);		% default 512

	% allow user to set freq from command line
	freqs = [1 2000 4000 8000 8192 11025 22050 44100];

	% user supplied fs in list already?
	ind = find(freqs == fs);

	if isempty(ind),

		% nope, add it
		freqs = sort([freqs(:) ; fs])';
		ind = find(freqs == fs);
	end;

	% setup sampling freq popupmenu
	popunbrs(gf,[columns(1) rows(1) b_width/2 b_hite], ...
		freqs,'FS','CallBack','spscope(''apply'',''current'');', ...
		'Range',[16 Inf],'Integer','on','PowerOfTwo','on', ...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'LabelPosition',[columns(1) rows(2) b_width/2 b_hite],...
		'LabelJustify','center');
	if fs ~= 1,
		set(findpopu(gf,'FS'),'Value',ind);
	end;

	% draw frame 
	uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(2)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

	uicontrol('Style','text','Units','normal','Horiz','center',...
		'Position',[columns(2) rows(2) b_width/2 b_hite],...
		'Fore','black','Back',bcolor,...
		'UserData',length(signal),...
 		'String','Start');
	uicontrol('Style','edit','Units','normal','Horiz','center',...
 		'Position',[columns(2) rows(1) b_width/2 b_hite],...
	        'UserData','Start',...
		'Fore','black','Back',beditcolor,...
		'String','0',...
		'Callback','spscocal(''start'');');
	uicontrol('Style','text','Units','normal','Horiz','center',...
		'Position',[columns(2)+b_width/2 rows(2) b_width/2 b_hite],...
		'Fore','black','Back',bcolor,...
		'UserData',1,...
		'String','Frame');
	uicontrol('Style','edit','Units','normal','Horiz','center',...
		'Position',[columns(2)+b_width/2 rows(1) b_width/2 b_hite],...
	        'UserData','Frame',...
		'Fore','black','Back',beditcolor,...
		'String',num2str(512/fs),...
		'Callback','spscocal(''frame'');');


	% draw dB floor edit box
	uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(3)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);
	uicontrol('Style','text','Units','normal','Horiz','center',...
		'Position',[columns(3) rows(2) b_width/2 b_hite],...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'String','Ceil');
	uicontrol('Style','text','Units','normal','Horiz','center',...
		'Position',[columns(3)+b_width/2 rows(2) b_width/2 b_hite],...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'String','Floor');
	uicontrol('Style','edit','Units','normal','Horiz','center',...
		'Position',[columns(3) rows(1) b_width/2 b_hite],...
		'BackGroundColor',beditcolor,'ForeGroundColor','black',...
		'UserData','Ceil',...
		'String',num2str(10),...
		'Callback','spscocal(''ceil'');');
	uicontrol('Style','edit','Units','normal','Horiz','center',...
		'Position',[columns(3)+b_width/2 rows(1) b_width/2 b_hite],...
		'BackGroundColor',beditcolor,'ForeGroundColor','black',...
		'UserData','Floor',...
		'String',num2str(-80),...
		'Callback','spscocal(''floor'');');

	% draw play pushbuttons
	uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(4)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);
	uicontrol('Style','text','Units','normal','Horiz','center',...
		'Position',[columns(4) rows(2) b_width/2 b_hite],...
		'String','Play',...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'UserData',[]);
	uicontrol('Style','pushbutton','Units','normal','Horiz','center',...
		'Position',[columns(4)+b_width/2 rows(2) b_width/2 b_hite],...
		'String','Stop',...
		'UserData',0,...
		'CallBack','global SPC_STOP_IT; SPC_STOP_IT = 1;');
	uicontrol('Style','pushbutton','Units','normal','Horiz','center',...
		'Position',[columns(4) rows(1) b_width/2 b_hite],...
		'String','Back',...
		'UserData',0,...
		'Interruptible','yes',...
		'CallBack','spscope(''apply'',''back'');');
	uicontrol('Style','pushbutton','Units','normal','Horiz','center',...
		'Position',[columns(4)+b_width/2 rows(1) b_width/2 b_hite],...
		'String','Fore',...
		'UserData',0,...
		'Interruptible','yes',...
		'CallBack','spscope(''apply'',''fore'');');

	% draw step pushbuttons
	uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(5)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);
	uicontrol('Style','text','Units','normal','Horiz','center',...
		'Position',[columns(5) rows(2) b_width b_hite],...
		'String','Step',...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'UserData',signal);
	uicontrol('Style','pushbutton','Units','normal','Horiz','center',...
		'Position',[columns(5) rows(1) b_width/2 b_hite],...
		'String','Prev',...
		'UserData',0,...
		'CallBack','spscope(''apply'',''prev'');');
	uicontrol('Style','pushbutton','Units','normal','Horiz','center',...
		'Position',[columns(5)+b_width/2 rows(1) b_width/2 b_hite],...
		'String','Next',...
		'UserData',0,...
		'CallBack','spscope(''apply'',''next'');');

	% create axes for time domain and frequency domain plot
	global SPC_COLOR_ORDER SPC_FONTNAME SPC_TEXT_FORE SPC_AXIS
	h=axes('Position',[axis_left axis_bottom axis_width axis_hite], ...
		'DrawMode','fast','ColorOrder',SPC_COLOR_ORDER,...
		'Color',SPC_AXIS,'FontName',SPC_FONTNAME,...
		'XColor',SPC_TEXT_FORE,'YColor',SPC_TEXT_FORE,...
		'Box','on');


	spscope('apply','first');

elseif strcmp(action,'common'),

	global SPC_COMMON;

	if min(size(SPC_COMMON)) ~= 1 | length(SPC_COMMON) < 2,
		msg = 'spscope: Invalid common vector!';
		spcwarn(msg,'OK');
		return;
	end;

	set(finduitx(gcf,'Step'),'UserData',SPC_COMMON);

	spscope('apply','first');

elseif strcmp(action,'apply'),

	gf = gcf; ga = gca;

	% get variables
	y = get(finduitx(gf,'Step'),'UserData');
	fs = getpopvl(gf,'FS');
	overlap = str2num(get(getcheck(gf,'Overlap'),'Label'));
	framelen = getednbr(gf,'Frame');
	framestart = get(finduitx(gf,'Frame'),'UserData');
	fftlength = getpopvl(gf,'FFT');
	dbfloor = getednbr(gf,'Floor');
	dbceil  = getednbr(gf,'Ceil');
	timesmooth = str2num(get(getcheck(gf,'TimeSmooth'),'Label'));
	freqsmooth = str2num(get(getcheck(gf,'FreqSmooth'),'Label'));

	if strcmp(arg1,'first'),
		framestart = 0;
		arg1 = 'current';
	end;

	% frame length in samples
	if rem(framelen,1),
		% not an integer must be time
		framelength = floor(framelen * fs);
	else,
		% an integer, must be points
		framelength = framelen;
	end;

	% convert to samples
	overlap = floor(framelength * overlap/100);

	if framelength > fftlength,
		msg = 'spscope: Frame length exceeds FFT length.  Aborted.';
		spcwarn(msg,'OK');
		set(gf,'Pointer','arrow');
		set(findedit(gf,'Frame'),'String',num2str(fftlength/fs));
		return;
	end;

	if framestart == 1 & strcmp(arg1,'prev'),
		msg = 'spscope: First frame already displayed.';
		spcwarn(msg,'OK');
		set(gf,'Pointer','arrow');
		set(findedit(gf,'Frame'),'String',num2str(fftlength/fs));
		return;
	end;

	% data for next frame
	if strcmp(arg1,'next'),
		framestart = framestart + framelength - overlap;
	elseif strcmp(arg1,'prev'),
		framestart = framestart - framelength + overlap;
	elseif strcmp(arg1,'first'),
		framestart = 1;
	end;
	if framestart < 1, framestart = 1; end;
	if (strcmp(arg1,'fore') | strcmp(arg1,'next')) & ...
			framestart+framelength-1 > length(y),

		msg = 'spscope: Last frame reached.';
		spcwarn(msg,'OK');
		set(gf,'Pointer','arrow');
		set(findedit(gf,'Frame'),'String',num2str(fftlength/fs));
		return;
	end;

	% get window from menu and then create it
	window = gtfirwin(gf,framelength);

	if ischeckd(gf,'Scale','Logarithmic'),

		% faster flag check for loops below
		log = 1;
	end;

	if ~strcmp(arg1,'fore') & ~strcmp(arg1,'back'),

		nextframe = y(framestart:framestart+framelength-1);

		% put away
		set(finduitx(gf,'Frame'),'UserData',framestart);

		% appply window
		nextframe = window .* nextframe;

		% apply FFT
		YY = abs(fft(nextframe,fftlength))/framelength;
		YY = YY(1:fftlength/2);
		YY = YY(:).^2;

		% perform time smoothing
		if timesmooth > 1,

			% get old FFT data
			YYY = get(finduitx(gf,'Play'),'UserData');
			ends = get(findpush(gf,'Stop'),'UserData');

			if strcmp(arg1,'next'),

				% go backwards (store new data were head is)
				ends = ends + 1;
				ind = find(ends > timesmooth);
				if any(ind),
					ends(ind) = 1;
				end;
				YYY(ends(2),:) = YY';

				set(findpush(gf,'Stop'),'UserData',ends);
				set(finduitx(gf,'Play'),'UserData',YYY);

			elseif strcmp(arg1,'prev'),

				% go forwards (store new data were tail is)
				ends = ends - 1;
				ind = find(ends < 1);
				if any(ind),
					ends(ind) = timesmooth;
				end;
				YYY(ends(1),:) = YY';

				set(findpush(gf,'Stop'),'UserData',ends);
				set(finduitx(gf,'Play'),'UserData',YYY);
			end;

			YY = sum(YYY)'/timesmooth;
		end;

		% perform frequency smoothing
		if freqsmooth > 1
			YY = avsmooth(YY,freqsmooth);
		end;

		if log,

			k = find(YY < eps);
			YY(k) = eps * ones(length(k),1);
			YY = 10*log10(YY);
			if isempty(dbfloor),
			    msg = 'spscope: Floor must be a value.  Aborted.';
				spcwarn(msg,'OK');
				set(gf,'Pointer','arrow');
				return;
			end;
		end;

	elseif timesmooth > 1,

		% get old FFT data
		YYY = get(finduitx(gf,'Play'),'UserData');
		ends = get(findpush(gf,'Stop'),'UserData');
	end;

	% frequency scale
	fscale = ((1:fftlength/2)-1)/fftlength*fs;
	fscale = fscale(:);

	if isempty(findaxes(gf,'zoomtool')),

		% first time gotta add zoomtool

    		% plot the PSD
		cla
		line(fscale,YY);
		set(ga,'XLim',[min(fscale) max(fscale)]);

		if ischeckd(gf,'Scale','Logarithmic'),
			spcylabl(ga,'Power (dB)');
		else,
			spcylabl(ga,'Power (W)');
		end;
		spcaxes(ga);
		spctitle(ga,'Power Spectral Density');
		spcxlabl(ga,'Frequency');

		% start zoomtool
		zoomtool(ga,'QuitButton','off','Pan','off',...
			'ZoomXY','off','ZoomX','on');

		% set line erasemode to 'xor'
		set(zoomed(gf),'EraseMode','xor',...
			'Color',get(gca,'color'));

		% set new y limits
		if ischeckd(gf,'Scale','Linear'),
			ymin = 0;
			ymax = 10^(dbceil/10);
		else,
			ymin = dbfloor;
			ymax = dbceil;
		end;
		delta = abs(ymax-ymin) * 0.05;
		if delta == 0, delta = 1; end;
		ylim(1) = ymin - delta;
		ylim(2) = ymax + delta;
		set(ga,'YLim',ylim);

		% reset cursor lengths
		handles = zoomcrsr(gf);
		set(handles(1),'YData',ylim);
		set(handles(3),'YData',ylim);

		hf = figure('Name','Time-Domain Signal',...
			'Units','normal',...
			'Position',[0 .8 1 .2]);
		sigdata = y(framestart:framestart+framelength-1);
		tscale = (0:length(sigdata)-1)/fs;
		hl = plot(tscale,sigdata);
		set(hl,'EraseMode','xor');
		ymax = max(max(abs(y)));
		set(gca,'YLim',[-ymax ymax]);
		xlabel('Amplitude');
		ylabel('Time (s)');
		title('Time-Domain Signal');

		% store handle to signal window
		set(findpush(gf,'Fore'),'UserData',hf);

		if (strcmp(computer,'PCWIN')),
		set(h,'MenuBar','none');
		end;

		figure(gf);
		
	elseif strcmp(arg1,'current'),

		% just replace the line
		zoomrep(ga,fscale,YY);

		% set new y limits
		if ischeckd(gf,'Scale','Linear'),
			ymin = 0;
			ymax = 10^(dbceil/20);
		else,
			ymin = dbfloor;
			ymax = dbceil;
		end;
		delta = abs(ymax-ymin) * 0.05;
		if delta == 0, delta = 1; end;
		ylim(1) = ymin - delta;
		ylim(2) = ymax + delta;
		set(ga,'YLim',ylim);

		% reset cursor lengths
		handles = zoomcrsr(gf);
		set(handles(1),'YData',ylim);
		set(handles(3),'YData',ylim);

		% updata signal window
		hh = get(findpush(gf,'Fore'),'UserData');
		sigdata = y(framestart:framestart+framelength-1);
		if isempty(find(get(0,'Children') == hh)),
			hh = figure('Name','Time-Domain Signal',...
				'Units','normal',...
				'Position',[0 .8 1 .2]);
			tscale = (0:length(sigdata)-1)/fs;
			hl = plot(sigdata);
			ymax = max(max(abs(y)));
			set(gca,'YLim',[-ymax ymax]);
			set(hl,'EraseMode','xor');
			set(findpush(gf,'Fore'),'UserData',hh);

			if (strcmp(computer,'PCWIN')),
				set(h,'MenuBar','none');
			end;
		else,
			hl = get(get(hh,'CurrentAxes'),'Children');
			set(hl(1),'YData',sigdata);
		end;

		figure(gf);
		
	elseif strcmp(arg1,'prev') | strcmp(arg1,'next'),

		% replace the line
		h = get(findpush(gf,'S'),'UserData');
		set(h,'YData',YY);

		% updata signal window
		hh = get(findpush(gf,'Fore'),'UserData');
		sigdata = y(framestart:framestart+framelength-1);
		if isempty(find(get(0,'Children') == hh)),
			hh = figure('Name','Time-Domain Signal',...
				'Units','normal',...
				'Position',[0 .8 1 .2]);
			tscale = (0:length(sigdata)-1)/fs;
			hl = plot(sigdata);
			ymax = max(max(abs(y)));
			set(gca,'YLim',[-ymax ymax]);
			set(hl,'EraseMode','xor');
			set(findpush(gf,'Fore'),'UserData',hh);

			if (strcmp(computer,'PCWIN')),
				set(h,'MenuBar','none');
			end;
		else,
			hl = get(get(hh,'CurrentAxes'),'Children');
			set(hl(1),'YData',sigdata);
		end;

		figure(gf);
		
	elseif strcmp(arg1,'fore') | strcmp(arg1,'back'),

		laststep = length(y);

		h = get(findpush(gf,'S'),'UserData');

		global SPC_STOP_IT
		SPC_STOP_IT = 0;

		% where to store framestart
		fsh = finduitx(gf,'Frame');

		hf = get(findpush(gf,'Fore'),'UserData');
		sigdata = y(framestart:framestart+framelength-1);
		if isempty(find(get(0,'Children') == hf)),
			hf = figure('Name','Time-Domain Signal',...
				'Units','normal',...
				'Position',[0 .8 1 .2]);
			tscale = (0:length(sigdata)-1)/fs;
			hl = plot(sigdata);
			ymax = max(max(abs(y)));
			set(gca,'YLim',[-ymax ymax]);
			set(hl,'EraseMode','xor');
			set(findpush(gf,'Fore'),'UserData',hf);

			if (strcmp(computer,'PCWIN')),
				set(hf,'MenuBar','none');
			end;

		else,
			hl = get(get(hf,'CurrentAxes'),'Children');
			hl = hl(1);
		end;

		% put time window on top
		figure(hf);

		% turn all controls off except stop push button
		controls = findobj(get(gf,'Children'),'Type','uicontrol');
		set(controls,'Enable','off');
		set(findpush(gf,'Stop'),'Enable','on');
%		set(findpush(gf,'Back'),'Enable','off');
%		set(findpush(gf,'Fore'),'Enable','off');

	   if strcmp(arg1,'fore'),

		while ~SPC_STOP_IT & ...
			framestart+framelength+overlap-1 < laststep,

			framestart = framestart + framelength - overlap;

			% appply window
			nextframe = window .* ...
				y(framestart:framestart+framelength-1);

			set(hl,'YData',y(framestart:framestart+framelength-1));
			
			% apply FFT
			YY = abs(fft(nextframe,fftlength))/framelength;
			YY = YY(1:fftlength/2);
			YY = YY(:).^2;

			% perform time smoothing
			if timesmooth > 1,

			% go backwards (store new data were head is)
			ends = ends + 1;
			ind = find(ends > timesmooth);
			if any(ind),
				ends(ind) = 1;
			end;
			YYY(ends(2),:) = YY';

			set(findpush(gf,'Stop'),'UserData',ends);
			set(finduitx(gf,'Play'),'UserData',YYY);

				% go backwards (store new data were tail is)
				ends = ends + 1;
				ind = find(ends > timesmooth);
				if any(ind),
					ends(ind) = 1;
				end;
				YYY(ends(2),:) = YY';
				YY = sum(YYY)'/timesmooth;
			end;

			% perform freq smoothing
			if freqsmooth > 1
				YY = avsmooth(YY,freqsmooth);
			end;

			if log,

				k = find(YY < eps);
				YY(k) = eps * ones(length(k),1);

				YY = 10*log10(YY);
			end;

			% replace the line
			set(h,'YData',YY);
			set(findedit(gf,'Start'),'String',...
						num2str(framestart/fs));
			set(fsh,'UserData',framestart);
			drawnow;
		end;

	    else,

		while ~SPC_STOP_IT & framestart > 1,

			framestart = framestart - framelength + overlap;

			if framestart < 0, framestart = 1; end;

			% appply window
			nextframe = window .* ...
				y(framestart:framestart+framelength-1);

			set(hl,'YData',y(framestart:framestart+framelength-1));

			% apply FFT
			YY = abs(fft(nextframe,fftlength))/framelength;
			YY = YY(1:fftlength/2);
			YY = YY(:).^2;

			% perform time smoothing
			if timesmooth > 1,

				% go backwards (store new data were head is)
				ends = ends - 1;
				ind = find(ends < 1);
				if any(ind),
					ends(ind) = timesmooth;
				end;

				YYY(ends(1),:) = YY';
				YY = sum(YYY)'/timesmooth;
			end;

			% perform freq smoothing
			if freqsmooth > 1
				YY = avsmooth(YY,freqsmooth);
			end;

			if log,

				k = find(YY < eps);
				YY(k) = eps * ones(length(k),1);

				YY = 10*log10(YY);
			end;

			% replace the line
			set(h,'YData',YY);
			set(findedit(gf,'Start'),'String',...
						num2str(framestart/fs));
			set(fsh,'UserData',framestart);
			drawnow;
		end;


	    end;

		% turn other controls back on
		set(controls,'Enable','on');
%		set(findpush(gf,'Back'),'Enable','on');
%		set(findpush(gf,'Fore'),'Enable','on');

		if timesmooth > 1,
			set(findpush(ga,'Stop'),'UserData',ends);
			set(finduitx(gf,'Play'),'UserData',YYY);
		end;

		% put away
		set(finduitx(gf,'Frame'),'UserData',framestart);

		SPC_STOP_IT = [];
	end;

	set(findedit(gf,'Start'),'String',num2str(framestart/fs));

	% get handles to zoomtool uicontrols
	handles = get(finduitx(gf,'zoomtool'),'UserData');
	xfactor = handles(28);
	xmin = handles(33);

	% cursor locations
	cv1 = get(handles(24),'XData'); cv1 = cv1(1);
	cv2 = get(handles(26),'XData'); cv2 = cv2(1);
	i1 = round((cv1 - xmin) / xfactor) + 1;
	i2 = round((cv2 - xmin) / xfactor) + 1;

	% adjust readouts and move cursors
	ch1 = YY(i1);
	ch2 = YY(i2);
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

else
	error('spscope: Undefined action requested...');
end

if nargout == 1,
	gff = gf;
end;

set(gf,'Pointer','arrow');
