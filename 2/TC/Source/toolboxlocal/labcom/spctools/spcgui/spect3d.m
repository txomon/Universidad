function gff = spect3d(action,arg1,arg2);
%SPECT3D Spectrum analyzer.
%	[H]=SPECT3D(X) opens a three-dimensional frequency
%	estimation tool for analyzing the time-domain
%	signal X.
%
%	[H]=SPECT3D(X,FS) sets the sampling frequency to FS.
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
%	SPECT3D('FILENAME') and SPECT3D('FILENAME',BITS) open the
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
%	See also SPECT3D, SPECT3DS, ZOOMTOOL, V3DTOOL

%       Dennis W. Brown 2-3-94, DWB 6-11-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% check args,
if nargin < 1
        signal = randn(512,1);
	fs = 8192;
	action = 'start';
elseif ~isstr(action)

	% normalize signal
	signal = action;
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
		'Name','3D Spectrum Analyzer Tool - by D.W. Brown',...
		'Position',pos,'NumberTitle','off');

	% following line is bug workaround for version 4.1 and below
	set(gf,'BackingStore','off','BackingStore','on');

	if (strcmp(computer,'PCWIN')),
		set(gf,'MenuBar','none');
	end;


	% add the basic workspace menu
	workmenu(gf,'','','spect3d(''common'');', ...
		'spect3dl','spect3ds');

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
	mufirwin(gf,'spect3d(''plot'');');

	% Scale menu
	items = str2mat('Linear','Logarithmic');
	togmenu(gf,'Scale',items,2,'spect3d(''plot'');');

	% accelerator keys for Angles menu
	set(findmenu(gf,'Scale','Linear'),'Accelerator','W');
	set(findmenu(gf,'Scale','Logarithmic'),'Accelerator','L');

	% surface menu
	items = str2mat('surf','surfl','mesh','meshz','waterfall','pcolor');
	togmenu(gf,'Surface',items,1);

	% colormap menu
	menucmap(gf,'Jet');

	% shading menu
	menushad(gf,'flat');

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
		'CallBack','spect3d(''plot'');', ...
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
		freqs,'FS','CallBack','spect3d(''plot'');', ...
		'Range',[16 Inf],'Integer','on','PowerOfTwo','on', ...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'LabelPosition',[columns(1) rows(2) b_width/2 b_hite],...
		'LabelJustify','center');
	if fs ~= 1,
		set(findpopu(gf,'FS'),'Value',ind);
	end;

	% draw frame length edit box
	uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(2)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

    uicontrol('Style','text','Units','normal','Horiz','center',...
        'Position',[columns(2) rows(2) b_width b_hite],...
	'Fore','black','Back',bcolor,...
        'String','Frame Length');
    uicontrol('Style','edit','Units','normal','Horiz','center',...
        'Position',[columns(2) rows(1) b_width b_hite],...
        'UserData','Frame Length',...
	'Fore','black','Back',beditcolor,...
	'String',num2str(512/fs),...
	'Callback',['dog_h3d = findedit(gcf,''Frame Length''); ' ...
		'dog_y3d=str2num(get(dog_h3d,''String''));if dog_y3d <= 0,' ...
		'dog_fs3d = get(findmenu(gcf,''Close''),''UserData''); ' ...
		'set(dog_h3d,''String'',num2str(512/dog_fs3d)); end; ' ...
		'clear dog_h3d dog_y3d dog_fs3d ']);

	% setup overlap popupmenu
	uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(3)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);
	popunbrs(gf,[columns(3) rows(1) b_width b_hite], ...
		[0 10 20 30 40 50 60 70 80 90],'% Overlap', ...
		'CallBack','', ...
		'Range',[0 99],'Integer','on','PowerOfTwo','off', ...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'LabelPosition',[columns(3) rows(2) b_width b_hite],...
		'LabelJustify','center');
    set(findpopu(gf,'% Overlap'),'Value',3);		% default 20%

	% draw dB floor edit box
	uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(4)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);
	uicontrol('Style','text','Units','normal','Horiz','center',...
		'Position',[columns(4) rows(2) b_width b_hite],...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'String','dB Floor');
	uicontrol('Style','edit','Units','normal','Horiz','center',...
		'Position',[columns(4) rows(1) b_width b_hite],...
		'BackGroundColor',beditcolor,'ForeGroundColor','black',...
		'UserData','dB Floor',...
		'String',num2str(-40),...
		'Callback',['dog_h3d = findedit(gcf,''dB Floor''); ' ...
			'dog_y3d=str2num(get(dog_h3d,''String''));'...
			'if isempty(dog_y3d),' ...
			'set(dog_h3d,''String'',num2str(-40)); end;'...
			'clear dog_h3d dog_y3d dog_fs3d ']);

	% draw apply pushbutton
	uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(5)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);
	uicontrol('Style','text','Units','normal','Horiz','center',...
		'Position',[columns(5) rows(2) b_width b_hite],...
		'String','Apply 3D',...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'UserData',signal);
	uicontrol('Style','pushbutton','Units','normal','Horiz','center',...
		'Position',[columns(5) rows(1) b_width/2 b_hite],...
		'String','Replace',...
		'UserData',0,...
		'CallBack','spect3d(''apply'',''replace'');');
	uicontrol('Style','pushbutton','Units','normal','Horiz','center',...
		'Position',[columns(5)+b_width/2 rows(1) b_width/2 b_hite],...
		'String','New',...
		'UserData',0,...
		'CallBack','spect3d(''apply'',''new'');');

	% create axes for time domain and frequency domain plot
	global SPC_COLOR_ORDER SPC_FONTNAME SPC_TEXT_FORE SPC_AXIS
	h=axes('Position',[axis_left axis_bottom axis_width axis_hite], ...
		'DrawMode','fast','ColorOrder',SPC_COLOR_ORDER,...
		'Color',SPC_AXIS,'FontName',SPC_FONTNAME,...
		'XColor',SPC_TEXT_FORE,'YColor',SPC_TEXT_FORE,...
		'Box','on');


	spect3d('plot');

elseif strcmp(action,'common'),

	global SPC_COMMON;

	if min(size(SPC_COMMON)) ~= 1 | length(SPC_COMMON) < 2,
		msg = 'spect3d: Invalid common vector!';
		spcwarn(msg,'OK');
		return;
	end;

	set(finduitx(gcf,'Apply 3D'),'UserData',SPC_COMMON);

	spect3d('plot');

elseif strcmp(action,'plot'),

	gf = gcf; ga = gca;

	% get stored values
	fft_N = getpopvl(gf,'FFT');
	signal = get(finduitx(gf,'Apply 3D'),'Userdata');
	fs = getpopvl(gf,'FS');
	frame = str2num(get(findedit(gf,'Frame Length'),'String'));
	
	newframe = fft_N/fs;
	
	if newframe < frame,
		frame = newframe;
		set(findedit(gf,'Frame Length'),'String',num2str(frame));
	end;
	
	figure(gf);
	set(gf,'NextPlot','add');

	% get window
	window = gtfirwin(gf,fft_N);

	% compute power using modified Mathworks Signal toolbox spectrum
	%   routine (Welch method with no overlap)
	if length(signal) < fft_N,
		signal = [signal ; zeros(fft_N - length(signal),1)];
	end;
	est = spectrm2(signal,fft_N,window);
	est = est(:,1);                     % take just PSD data
	est = sqrt(2*est/fft_N)/2;       % same units as FFT

	% SPECTRUM returns a very small value for the DC when DC is near zero
	est(1,1) = est(2,1);

	% display spectrum either in dB or Watts
	if ischeckd(gf,'Scale','Logarithmic'),
		est = 20*log10(est);
		set(findmenu(gf,'Scale','Linear'),'Checked','off');
		set(findmenu(gf,'Scale','Logarithmic'),'Checked','on');
	else,
		set(findmenu(gf,'Scale','Linear'),'Checked','on');
		set(findmenu(gf,'Scale','Logarithmic'),'Checked','off');
	end;

	% create frequency scale for axis
	scale = (0:(fft_N/2 - 1)) / fft_N * fs;

	if isempty(findaxes(gf,'zoomtool')),

		% first time gotta add zoomtool

    		% plot the PSD
		cla
		line(scale,est);
		set(ga,'XLim',[min(scale) max(scale)]);
		if ischeckd(gf,'Scale','Logarithmic'),
			spcylabl(ga,'Power (dB)');
		else,
			spcylabl(ga,'Power (W)');
		end;
		spcaxes(ga);
		spctitle(ga,'Power Spectral Density');
		spcxlabl(ga,'Frequency');

		% start zoomtool
		zoomtool(ga,'QuitButton','off','Pan','off');

		% move cursors to include whole band
		zoomset(ga,1,0);
		zoomset(ga,2,fs/2);

	else,

		% save old cursor position
		p1 = zoomloc(gf,1); p1 = p1(1);
		p2 = zoomloc(gf,2); p2 = p2(1);

		% just replace the line
		zoomrep(ga,scale,est);

		% move cursors back
		zoomset(ga,1,p1);
		zoomset(ga,2,p2);
	end;

	set(gf,'NextPlot','new');

elseif strcmp(action,'apply'),

	gf = gcf; ga = gca;

	% get variables
	y = get(finduitx(gf,'Apply 3D'),'UserData');
	fs = getpopvl(gf,'FS');
	overlap = getpopvl(gf,'% Overlap');
	framelen = getednbr(gf,'Frame Length');
	fftlength = getpopvl(gf,'FFT');
	dbfloor = getednbr(gf,'dB Floor');

	% frame length in samples
	if rem(framelen,1),
		% not an integer must be time
		framelength = floor(framelen * fs);
	else,
		% an integer, must be points
		framelength = framelen;
	end;

	if framelength > fftlength,
		msg = 'spect3d: Frame length exceeds FFT length.  Aborted.';
		spcwarn(msg,'OK');
		set(gf,'Pointer','arrow');
		set(findedit(gf,'Frame Length'),'String',num2str(fftlength/fs));
		return;
	end;

	% convert overlap to number of sampesl
	overlap = fix(framelength * overlap/100);

	% convert to matrix
	[Y,tscale] = framdata(y,framelength,fftlength,overlap,fs);

	% apply window, get it from menu and then create it
	window = gtfirwin(gf,framelength);

	for k = 1:length(tscale),
		Y(1:framelength,k) = window .* Y(1:framelength,k);
	end;

	% apply FFT
	YY = abs(fft(Y,fftlength))/fftlength;

	i1 = zoomind(gf,1);
	i2 = zoomind(gf,2);

	% use freqs between cursors
	YY = YY(i1:i2,:);

	if ischeckd(gf,'Scale','Logarithmic'),
		k = find(YY < eps);
		YY(k) = eps * ones(length(k),1);
		YY = 20*log10(YY);
		if isempty(dbfloor),
			msg = 'spect3d: dB Floor must be a value.  Aborted.';
			spcwarn(msg,'OK');
			set(gf,'Pointer','arrow');
			return;
		end;
		k = find(YY < dbfloor);
		YY(k) = dbfloor * ones(length(k),1);
	end;

	% frequency scale
	fscale = ((i1:i2)-1)/fftlength*fs;

	% get last 3d window position if exists
	oldwin = get(findpush(gf,'Replace'),'UserData');
	if ~isempty(find(get(0,'Children') == oldwin)),
		uni = get(oldwin,'Units');
		pos = get(oldwin,'Position');
	else,
		uni = 'normal';
		pos = [0 .5 1 .5];
	end;

	% open a window if needed
	if ~strcmp(arg1,'new'),
		if find(get(0,'Children') == oldwin),
			close(oldwin);
		end;
	end;

	% open window to plot surface in
	nwh = figure('Units',uni,'Position',pos);

	% save handle to it
	set(findpush(gf,'Replace'),'UserData',nwh);

	% this is a bug workaround for 4.1 and earlier
	set(nwh,'BackingStore','off','BackingStore','on');

	% "don't want no stinking menu"
	if (strcmp(computer,'PCWIN')), set(gf,'MenuBar','none'); end;

	% plot it
	surftype = get(getcheck(gf,'Surface'),'Label');
	if strcmp(surftype,'surf'),
		surf(fscale,tscale,YY');
	elseif strcmp(surftype,'surfl'),
		surfl(fscale,tscale,YY');
	elseif strcmp(surftype,'mesh'),
		mesh(fscale,tscale,YY');
	elseif strcmp(surftype,'meshz'),
		meshz(fscale,tscale,YY');
	elseif strcmp(surftype,'waterfall'),
		waterfall(fscale,tscale,YY');
	elseif strcmp(surftype,'pcolor'),
		pcolor(tscale,fscale,YY);
	end;

	% set default colormap
	hcmap = getcheck(gf,'Colormap',1);
	map = get(hcmap,'Label');

	% set default shading
	hshad = findobj(get(findmenu(gf,'Shading'),'Children'),'Checked','on');
	shad = lower(get(hshad,'Label'));

	if ~strcmp(surftype,'pcolor'),

		% maximize axis usage
		zmax = max(max(YY));
		zmin = min(min(YY));
		if zmax <= zmin,
			zmin = zmax - 10;
		end;
		set(gca,'ZLim',[zmin zmax]);
		set(gca,'XLim',[i1 i2]/fftlength*fs);
		ymax = max(tscale);
		ymin = min(tscale);
		set(gca,'YLim',[ymin ymax]);

		xlabel('Frequency');
		ylabel('Time (s)');
		title('Spectral surface');
		if ischeckd(gf,'Scale','Linear'),
			zlabel('W');
		else,
			zlabel('dB');
		end;

		if strcmp(surftype,'waterfall'),
			view(45,30);
		else,
			view(45,60);
		end;

		% draw close menu
		m=uimenu('Label','Figure');
		uimenu(m,'Label','Close','CallBack','close(gcf);');

		% start up 3d viewer
		if ischeckd(gf,'Colormap','Invert'),
		    v3dtool(gca,'Colormap',map,'Shading',shad,'Invert','on',...
		    	'Auto','off');
		else,
			v3dtool(gca,'Colormap',map,'Shading',shad,'Auto','off');
		end;

		% throw on a legend
		win = get(findobj(get(findmenu(gf,'Window'),'Children'), ...
			'Checked','on'),'Label');
		oldgca = gca;
		h = axes('Position',[0.05 .8 .2 .2]);
		th = text(0,1,['Window: ' win ]);
			set(th,'Vert','top','FontSize',10);
		p = get(th,'Extent');p = p(4);
		th = text(0,1-p,['FFT: ' int2str(fftlength)]);
			set(th,'Vert','top','FontSize',10);
		if framelen == framelength,
			% was in points
			frstr = ['Frame: ' int2str(framelen) ' pts'];
		else,
			% was in time
			frstr = ['Frame: ' num2str(framelen*1000) ' ms'];
		end;
		th = text(0,1-2*p,frstr);
			set(th,'Vert','top','FontSize',10);
		overlap = getpopvl(gf,'% Overlap');
		th = text(0,1-3*p,['Overlap: ' int2str(overlap) ' %']);
			set(th,'Vert','top','FontSize',10);
		th = text(0,1-4*p,['FS: ' int2str(fs) ' Hz']);
			set(th,'Vert','top','FontSize',10);
		set(h,'Visible','off');
		axes(oldgca)
	else
		% draw close menu
		m=uimenu('Label','Figure');
		uimenu(m,'Label','Close','CallBack','close(gcf);');

		% set default colormap
		hh = getcheck(gf,'Colormap',1);
		if ischeckd(gf,'Colormap','Invert'),
			set(nwh,'ColorMap',flipud(eval(lower(map))));
			menucmap(gcf,map,'invert','auto');
		else,
			colormap(lower(map));
			menucmap(gcf,map,'off','auto');
		end;

		% set default shading
		hh = getcheck(gf,'Shading');
		shad = get(hh,'Label');
		menushad(gcf,shad,'auto');
		if strcmp(shad,'flat')
			shading flat
		elseif strcmp(shad,'interp')
			shading interp
		end;


		% label it of course
		ylabel('Frequency');
		xlabel('Time (s)');
		set(gca,'YLim',[i1 i2]/fftlength*fs);
		set(gca,'XLim',[tscale(1) tscale(length(tscale))]);

		% make up title string
		titstr = ['Window: ' win ', FFT: ' int2str(fftlength)];
		if framelen == framelength,
			% was in points
			titstr = [titstr ', Frame: ' int2str(framelen) ' pts'];
		else,
			% was in time
			titstr = [titstr ', Frame: ' num2str(framelen*1000) ' ms'];
		end;
		titstr = [titstr ', Overlap: ' int2str(overlap) ' %'];
		titstr = [titstr ', FS: ' int2str(fs) ' Hz'];
		title(titstr);
	end;


	set(gf,'Pointer','arrow');
else
	error('spect3d: Undefined action requested...');
end

if nargout == 1,
	gff = gf;
end;

set(gcf,'Pointer','arrow');
