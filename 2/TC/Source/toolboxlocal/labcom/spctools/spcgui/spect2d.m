function gff = spect2d(action,arg1,arg2,arg3);
%SPECT2D Spectrum analysis tool.
%	SPECT2D(X,FS) creates a spectrum analysis tool for the
%	signal x at the sampling frequency FS.  If FS is not
%	given, the default is FS = 8192 Hz.
%
%	SPECT2D('FILENAME') and SPECT2D('FILENAME',BITS) open the
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
%	See also SPECT3D

%       Dennis W. Brown 4-27-94, DWB 3-2-95
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% check args,
if nargin < 1
        signal = randn(512,1);
	fs = 8192;
	action = 'start';
elseif ~isstr(action)

	signal = action(:) - mean(action);
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
	elseif nargin == 2,
		if ~isstr(arg1),
			if max(size(arg1)) == 1,
				[signal,fs] = readsig(action,arg1);
				action = 'start';
			else,
				set(gcf,'Pointer','watch');
			end;
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

	axis_left = .1;     axis_bottom = .2;
	axis_width = .85;   axis_hite = .9 - axis_bottom;

	% graphics initialization

	spcolors;
	global SPC_WINDOW SPC_AXIS SPC_2D_POS
	s = get(0,'ScreenSize');
	if exist('SPC_2D_POS'),
		pos = SPC_2D_POS;
	elseif s(3) < 800,
		pos = [.1 0 .9 .9];
	elseif s(3) >= 800 & s(3) < 1024,
		pos = [.1 .1 .8 .8];
	elseif s(3) == 1024,
		pos = [.3 .3 .7 .7];
	else
		pos = [.3 .3 .7 .7];
	end;

	gf = figure('Units','normalized','backingstore','off',...
		'Color',SPC_WINDOW,...
		'Name','2D Spectral Estimation Tool - by D.W. Brown',...
		'Position',pos,'NumberTitle','off');

	% following line is bug workaround for Sun version 4.1 and below
	set(gf,'BackingStore','off','BackingStore','on');

	if (strcmp(computer,'PCWIN')),
		set(gf,'MenuBar','none');
	end;

	closecall = ['close(gcf);'];

	% add the basic workspace menu
	workmenu(gf,'','','spect2d(''common'');', ...
		'spect2dl','spect2ds',closecall);

	% turn off restore menu since this tool doesn't change the signal
	delete(findmenu(gf,'Workspace','Restore'));

	% add FIR window menu
	mufirwin(gf,'spect2d(''plot'');');

	% setup for rectangular window
	set(get(findmenu(gf,'Window'),'Children'),...
					'Checked','off','Enable','on');
	set(findmenu(gf,'Window','Rectangular'),'Checked','on','Enable','off');

	% Scale menu
	items = str2mat('Linear','Logarithmic');
	togmenu(gf,'Scale',items,2,['zoomscal(gca);']);

	% accelerator keys for scale menu
	set(findmenu(gf,'Scale','Linear'),'Accelerator','W');
	set(findmenu(gf,'Scale','Logarithmic'),'Accelerator','L');

	m=uimenu(gf,'Label','Classical');
	  mm=uimenu(m,'Label','Bartlett Periodogram');
	  uimenu(mm,'Label','Average', ...
		'CallBack','spect2d(''bartlett'',''average'');');
	  uimenu(mm,'Label','Frames', ...
		'CallBack','spect2d(''bartlett'',''frames'');');
	  mm=uimenu(m,'Label','Welch Periodogram...',...
		'CallBack',['wlchdsgn(gcf,get(findchkb(gcf, '...
			' ''Keep curves''),''Userdata''));']);
	  mm=uimenu(m,'Label','Blackman-Tukey');
	  uimenu(mm,'Label','Average', ...
		'CallBack','spect2d(''blacktuk'',''average'');');
	  uimenu(mm,'Label','Frames', ...
		'CallBack','spect2d(''blacktuk'',''frames'');');
	  uimenu(m,'Label','Daniell...', ...
		'CallBack',['dandsgn(gcf,get(findchkb(gcf, '...
			' ''Keep curves''),''Userdata''));']);

	m=uimenu(gf,'Label','Parametric');
	  uimenu(m,'Label','AR/MA/ARMA','CallBack','spect2d(''arma'');');
	  uimenu(m,'Label','Linear Prediction','CallBack',...
		'spect2d(''linpred'');');

	m=uimenu(gf,'Label','Subspace');
	  uimenu(m,'Label','Min Variance','CallBack','spect2d(''minvarsp'');');
	  uimenu(m,'Label','MUSIC','CallBack','spect2d(''music'');');

	% add frame length menu
	items = str2mat('Signal','Abs Value','Squared');
	togmenu(gf,'Function',items,1,'spect2d(''function'');');

	% draw a frame for fft popupmenu
	hh = uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(2)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 1*b_hite+0*b_int+2*b_frame]);

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
	popunbrs(gf,[columns(2)+b_width/2 rows(1) b_width/2 b_hite], ...
		[16 32 64 128 256 512 1024 2048],'FFT', ...
		'CallBack',['set(findchkb(gcf,''Keep curves''),''Value'',0);'...
			'spect2d(''bartlett'',''average'');'], ...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'Range',[16 Inf],'Integer','on','PowerOfTwo','on', ...
		'LabelPosition',[columns(2) rows(1) ...
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

	% draw a frame for freq popup menu
	hh = uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(1)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 1*b_hite+0*b_int+2*b_frame]);

	% setup sampling sampling freq popupmenu
	popunbrs(gf,[columns(1)+b_width/2 rows(1) b_width/2 b_hite], ...
		freqs,'FS','CallBack','spect2d(''plot'');', ...
		'Range',[1 Inf],'Integer','on','PowerOfTwo','off', ...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'LabelPosition',[columns(1) rows(1) b_width/2 b_hite],...
		'LabelJustify','center');
	if fs ~= 1,
		set(findpopu(gf,'FS'),'Value',ind);
	end;

	% to prevent a major re-write of code, don't let user change sampling freq
	set(findpopu(gf,'FS'),'Enable','off');

	% draw keep transfer function checkbox
	uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(3)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 1*b_hite+0*b_int+2*b_frame]);
	h=uicontrol(gf,'Style','checkbox','Units','normal','Horiz','center',...
		'Position',[columns(3) rows(1) b_width b_hite],...
		'String','Keep curves','Value',1,...
		'Callback',['if ~get(findchkb(gcf,''Keep curves''),''Value''), '...
		'spect2d(''curves'');end']);

	% store signal in Keep curves UserData
	set(h,'UserData',signal);

	% draw delete pushbutton
	uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(5)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 1*b_hite+0*b_int+2*b_frame]);
	uicontrol(gf,'Style','push',...
		'Units','normal',...
		'Horiz','center',...
		'Enable','off',...
		'Position',[columns(5) rows(1) b_width b_hite],...
		'String','Delete',...
		'Callback',['zoomdel(gca,''current'');' ...
		  'if length(get(findpush(gcf,''T''),''UserData'')) <= 1,'...
		 	'set(findpush(gcf,''Delete''),''Enable'',''off'');'...
		  'end;']);

	% draw normalize checkbox
	uicontrol(gf,'Style','frame','Units','normal',...
		'Position',[columns(4)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 1*b_hite+0*b_int+2*b_frame]);
	uicontrol(gf,'Style','checkbox','Units','normal','Horiz','center',...
	'Position',[columns(4) rows(1) b_width b_hite],...
	'String','Normalize','Value',0);

	% create axes for time domain and frequency domain plot
	global SPC_COLOR_ORDER
	h=axes('Position',[axis_left axis_bottom axis_width axis_hite], ...
		'DrawMode','fast','ColorOrder',SPC_COLOR_ORDER,...
		'box','on');

	spect2d('plot');

elseif strcmp(action,'curves'),

	gf = gcf; ga = gca;

	% turn checkbox off in case this was called by some other than the
	%   check boxes own callback
	set(findchkb(gcf,'Keep curves'),'Value',0);

	% delete all other lines
	zoomdel(ga,'others');

	% disable delete button
	set(findpush(gf,'Delete'),'Enable','off');

elseif strcmp(action,'function'),


	gf = gcf; ga = gca;

	% if first time called, store signal in current dir
	flag = get(findmenu(gf,'Function','Signal'),'UserData');
	if isempty(flag),

		% First time, set flag
		set(findmenu(gf,'Function','Signal'),'UserData',1);

		% get signal
		signal = get(findchkb(gf,'Keep curves'),'Userdata');
		signal = signal(:);

		% store signal in temp file
		save spect2d signal

	else

		% get signal from file
		load spect2d

	end;

	if ischeckd(gf,'Function','Abs Value'),

		% Take absolute value of signal
		signal = abs(signal);

	elseif ischeckd(gf,'Function','Squared'),

		% Take square of signal
		signal = signal.^2;

	end;

	% store signal
	set(findchkb(gf,'Keep curves'),'Userdata',signal);

	% replot
	set(findchkb(gcf,'Keep curves'),'Value',0);
	spect2d('bartlett','average');
	set(findchkb(gcf,'Keep curves'),'Value',1);

elseif strcmp(action,'plot'),


	gf = gcf; ga = gca;

	% get stored values
	fft_N = getpopvl(gf,'FFT');
	signal = get(findchkb(gf,'Keep curves'),'Userdata');
	signal = signal(:);
	fs = getpopvl(gf,'FS');

	figure(gf);

	% get window
	window = gtfirwin(gf,fft_N);

	% zero pad if needed for fft length
	if length(signal) < fft_N,
		signal = [signal ; zeros(fft_N - length(signal),1)];
	end;

	% take average periodogram, make into power
	est = avgpergm(signal,fft_N,window);
	est = (est(1:fft_N/2 )).^2;

	% normalize peak to 1 if requested
	if get(findchkb(gf,'Normalize'),'Value'),
		est = est/max(est);
	end;

	% classical methods return a very small value for the DC ..
	%  when DC is near zero so make DC equal to first neighbor
	est(1,1) = est(2,1);

	% display spectrum either in dB or Watts
	if ischeckd(gf,'Scale','Logarithmic'),
		est = 10*log10(est);
	end;

	% create frequency scale for axis
	scale = (0:fft_N/2-1) / fft_N * fs;

	if isempty(findaxes(gf,'zoomtool')),

		% first time gotta add zoomtool

		% plot the PSD
		global SPC_LINE SPC_FONTNAME SPC_TEXT_FORE SPC_AXIS
		cla
		h = line(scale,est);
		set(h,'UserData','Avg FFT');
		set(ga,'XLim',[min(scale) max(scale)]);
		if ischeckd(gf,'Scale','Logarithmic'),
			spcylabl(ga,'Power (dB)');
		else,
			spcylabl(ga,'Power (W)');
		end;
		spcaxes(ga);
		spctitle(ga,'Power Spectral Density');

		% start zoomtool
		zoomtool(ga,'QuitButton','off','ZoomXY','off',...
			'ZoomX','on','Pan','off',...
			'ToggleCallBack',...
				'xlabel(get(zoomed(gcf),''UserData''));');
		zoomcust(gf);

		set(ga,'NextPlot','new');
		set(gf,'NextPlot','new');
	end;

	set(gf,'NextPlot','new');

elseif strcmp(action,'classic'),

	% spectral curve is arg1

	gf = gcf; ga = gca;

	% get stored values
	fft_N = getpopvl(gf,'FFT');
	fs = getpopvl(gf,'FS');

	% normalize peak to 1 if requested
	if get(findchkb(gf,'Normalize'),'Value'),
		arg1 = arg1/max(arg1);
	end;

	% classical methods return a very small value for the DC ..
	%  when DC is near zero so make DC equal to first neighbor
	arg1(1,1) = arg1(2,1);

	% display spectrum either in dB or Watts
	if ischeckd(gf,'Scale','Logarithmic'),
		arg1 = 10*log10(arg1);
	end;

	% create frequency scale for axis
	scale = (0:(fft_N/2-1)) / fft_N * fs;

	if get(findchkb(gf,'Keep curves'),'Value'),

		% add a new line
		h = zoomadd(ga,scale,arg1,'current');

		% name it if it has been defined
		set(h,'UserData',arg2);

		% set color to next in color order
		lineh = get(findpush(gf,'T'),'UserData');
		cord = get(ga,'ColorOrder');
		[m,n] = size(cord);
		for i = 1:length(lineh),

			% cycle through colors
			c = rem(i-1,m) + 1;
			set(lineh(i),'Color',cord(c,:));
		end;

		% enable pushbutton
		set(findpush(gf,'Delete'),'Enable','on');

	else,
		% just replace the line
		zoomrep(ga,scale,arg1);

		% name it if it has been defined
		if nargin == 3,
			set(zoomed(gf),'UserData',arg2);
		end;

		% disable pushbutton
		set(findpush(gf,'Delete'),'Enable','off');

	end;

	% show name of estimate cursor are now attached to
	xlabel(arg2);

elseif strcmp(action,'welch'),

	gf = gcf; ga = gca;

	% get stored values
	fft_N = getpopvl(gf,'FFT');
	signal = get(findchkb(gf,'Keep curves'),'Userdata');
	signal = signal(:);
	fs = getpopvl(gf,'FS');

	figure(gf);

	% get window
	window = gtfirwin(gf,fft_N);

	% compute power spectrum using modified Mathworks Signal toolbox
	% spectrum routine (Welch method with no overlap)
	if length(signal) < fft_N,
		signal = [signal ; zeros(fft_N - length(signal),1)];
	end;
	est = spectrm2(signal,fft_N,window);
	est = est(1:fft_N/2,1);			% take just PSD data
	est = est/fft_N;			% units of FFT

	spect2d('classic',est);

elseif strcmp(action,'arma'),

	gf = gcf;

	signal = get(findchkb(gf,'Keep curves'),'Userdata');

	armadsgn(gf,'Chain','off','DrivingSource','off',...
		'MinimumPhase','off','Verbose','off',...
		'Data',signal,'CloseOnApply','on',...
		'Play','off',...
		'CallBack','spect2d(''transfer'',''ARMA'',dog_a,dog_b);');

elseif strcmp(action,'bartlett'),

	gf = gcf;

	signal = get(findchkb(gf,'Keep curves'),'Userdata');
	signal = signal(:);
	nfft = getpopvl(gf,'FFT');
	window = gtfirwin(gf,nfft);

	if length(signal) < nfft,
		signal = [signal ; zeros(nfft-length(signal),1)];
	end;

	if strcmp(arg1,'average'),
		X = avgpergm(signal,nfft,window);
		X = (X(1:(nfft/2),:)).^2;
		spect2d('classic',X,['Bartlett(' int2str(nfft) ')']);
	else,
		set(findchkb(gf,'Keep Curves'),'Value',1);
		X = avgpergm(signal,nfft,window,'frames');
		X = (X(1:(nfft/2),:)).^2;
		[m,n] = size(X);
		for i=1:n,
			spect2d('classic',X(:,i),...
				['Bartlett(' int2str(nfft) ',' int2str(i) ')']);
		end;
	end;

elseif strcmp(action,'blacktuk'),

	gf = gcf;

	signal = get(findchkb(gf,'Keep curves'),'Userdata');
	nfft = getpopvl(gf,'FFT');
	window = gtfirwin(gf,fft_N);

	if strcmp(arg1,'average'),
		X = blacktuk(signal,nfft);
		X = (X(1:(nfft/2),:));
		spect2d('classic',X,['BlackTuk(' int2str(nfft/2) ')']);
	else,
		set(findchkb(gf,'Keep Curves'),'Value',1);
		X = blacktuk(signal,nfft,'frames');
		X = (X(1:nfft/2,:));
		[m,n] = size(X);
		for i=1:n,
			spect2d('classic',X(:,i),...
				['BlackTuk(' int2str(nfft) ',' int2str(i) ')']);
		end;
	end;

elseif strcmp(action,'linpred'),

	gf = gcf;

	signal = get(findchkb(gf,'Keep curves'),'Userdata');
	fs = getpopvl(gf,'FS');

	aledsgn(gf,signal,fs,...
		'spect2d(''transfer'',''LinePred'',w);');

elseif strcmp(action,'music'),

	gf = gcf;


	signal = get(findchkb(gf,'Keep curves'),'Userdata');
	N = getpopvl(gf,'FFT');
	musicdsg(gf,signal,N/2,'spect2d(''transfer'',''MUSIC'');');


elseif strcmp(action,'minvarsp'),

	gf = gcf;


	signal = get(findchkb(gf,'Keep curves'),'Userdata');
	N = getpopvl(gf,'FFT');
	mvardsgn(gf,signal,N/2,'spect2d(''transfer'',''MinVar'');');

elseif strcmp(action,'transfer'),

	gf = gcf; ga = gca;

	% compute transfer functions
	N = getpopvl(gf,'FFT');

	if strcmp(arg1,'MUSIC'),

		global SPC_CURVE
		est = SPC_CURVE(:);

		% adjust power for routine below
		est = (est/N).^2;

		clear global SPC_CURVE

	elseif strcmp(arg1,'MinVar'),

		global SPC_CURVE
		est = SPC_CURVE(:);

		% adjust power for routine below
		est = (est/N) .^ 2;


		clear global SPC_CURVE
	elseif strcmp(arg1,'ARMA'),

		est = abs(fft(arg3,N) ./ fft(arg2,N)) / N;
		est = est(1:N/2) .^ 2;

	elseif strcmp(arg1,'MA'),

		est = abs(fft(arg2,N) ./ ones(N,1)) / N;
		est = est(1:N/2);

	elseif strcmp(arg1,'LinePred'),

		est = abs(fft(arg2,N) ./ ones(N,1));
		est = est(1:N/2) .^ 2;

	end;

	est = est(:);

	scale = (0:length(est)-1)/length(est) * getpopvl(gf,'FS')/2;

	% normalize peak to 1 if requested
	if get(findchkb(gf,'Normalize'),'Value'),
		est = est/max(est);
	end;

	% scale properly
	if findmenu(gf,'Scale','Logarithmic'),
		est = 10 * log10(est);
	end;

	% add to axes
	if get(findchkb(gf,'Keep curves'),'Value'),

		% add a new line
		h = zoomadd(ga,scale,est,'current');

		% name it
		set(h,'UserData',arg1);

		% set color to next in color order
		lineh = get(findpush(gf,'T'),'UserData');
		cord = get(ga,'ColorOrder');
		[m,n] = size(cord);
		for i = 1:length(lineh),

			% cycle through colors
			c = rem(i-1,m) + 1;
			set(lineh(i),'Color',cord(c,:));
		end;

		% enable pushbutton
		set(findpush(gf,'Delete'),'Enable','on');

	else,

		% just replace the line
		zoomrep(ga,scale,est);

		% name it if it has been defined
		if nargin == 3,
			set(zoomed(ga),'UserData',arg2);
		end;

		% disable pushbutton
		set(findpush(gf,'Delete'),'Enable','off');

	end;

	% show name of estimate cursor are now attached to
	xlabel(arg1);

else
	error('spect2d: Undefined action requested...');
end

set(gf,'Pointer','arrow');

if nargout == 1,
	gff = gf;
end;

