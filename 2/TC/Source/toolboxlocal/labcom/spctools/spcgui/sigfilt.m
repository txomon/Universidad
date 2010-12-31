function hand = sigfilt(signal,fs,callback,pf)
%SIGFILT  Interactive filter design and filtering.
%	SIGFILT(SIGNAL) opens a signal filtering tool with
%	the default sampling rate set to 8192 Hz.
%
%	SIGFILT(SIGNAL,FS) sets the sampling frequency
%	to FS.  FS must be specified in Hz.
%
%	SIGFILT('FILENAME') and SIGFILT('FILENAME',BITS) open the
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
%	See also SIGEDIT, VOICEDIT, SPECT2D, SPECT3D

%       Dennis W. Brown 3-93, DWB 6-11-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% must have at least 1 args or variable SPC_COMMON in workspace
sigfile = '';
if nargin < 1
        signal = randn(512,1);
	fs = 8192;
elseif isstr(signal),
	sigfile = signal;
	if nargin == 2,
		bits = fs;
		[signal,fs] = readsig(sigfile,bits);
		sigfile = [sigfile '#' int2str(bits)];
	elseif ~isempty(find(sigfile == '.')),
		[signal,fs] = readsig(sigfile);
	else,
		error(['sigfilt: Filename must have an extension' ...
			' or bits must be specified.']);
	end;
elseif nargin == 1,
	fs = 8192;
end;

if nargin ~= 4,
	pf = [];
end;

% figure out if we have a vector
if min(size(signal)) ~= 1,
	error('sigfilt: Input arg "signal" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
signal = signal(:);

% -----------------------------------------------------------------------------

% initialize varibles
vf_fft = 256;

% local constants
nbrcols = 4; nbrrows = 9;
b_hite = .05; 	b_int = .02;	b_frame = .005; b_end = .05;
b_width = (1 - (nbrcols-1)*b_int - 2*b_end)/nbrcols;
columns = (0:nbrcols-1) .* (b_width + b_int) + b_end;
rows = (0:nbrrows-1) .* (b_hite + b_int) + b_end;

if strcmp(computer,'PCWIN'), ibmpc = 1; else ibmpc = 0; end;

% -----------------------------------------------------------------------------

spcolors;
global SPC_WINDOW SPC_TEXT_FORE SPC_TEXT_BACK SPC_AXIS SPC_MARKS SPC_VF_POS
s = get(0,'ScreenSize');
if exist('SPC_VF_POS'),
    vf_pos = SPC_VF_POS;
elseif s(3) < 800,
    vf_pos = [.1 0 .9 .9];
elseif s(3) >= 800 & s(3) < 1024,
    vf_pos = [.2 0 .8 .8];
elseif s(3) == 1024,
    vf_pos = [.3 0 .7 .7];
else
    vf_pos = [.4 0 .6 .6];
end;
gf = figure('units','normal','position',vf_pos,'color',SPC_WINDOW,...
	'Name','Signal Filter Tool by D.W. Brown',...
	'backingstore','off','Visible','off',...
	'NumberTitle','off','UserData',pf);

% following line is bug workaround for version 4.1 and below
set(gcf,'BackingStore','off','BackingStore','on');

if (strcmp(computer,'PCWIN')),
	set(gf,'MenuBar','none');
end;

clear vf_pos;

commoncall = [...
	'set(findpush(gcf,''Apply''),''UserData'',SPC_COMMON);'...
	'sigfical(''init'');'...
];

% add workspace menu
if isempty(sigfile),
	m=workmenu(gf,signal,'sigfical(''restore'');',commoncall, ...
		'sigfild','sigfisav');
else,
	m=workmenu(gf,sigfile,'sigfical(''restore'');',commoncall, ...
		'sigfild','sigfisav');
end;

uimenu(m,'Label','Snapshot','Accelerator','F','Position',3,...
	'Separator','on',...
	'Callback',['snapsht2(findaxes(gcf,''freq''));']);

global SPC_COOL_WINDOW
if SPC_COOL_WINDOW,
	SPC_TEXT_FORE = 'black';
	drawnow
	pic = [1:64]';
	colormap(cool)
	brighten(0.5)
	image( pic )
	set( gca,'pos',[0 0 1 1], 'visible','off')
end;

% Filter menu
items = str2mat('FIR','Butterworth','Cheby Type 1','Cheby Type 2','Elliptical');
togmenu(gf,'Filter',items,1,'sigfical(''setfilter'');');
items = str2mat('Lowpass','Highpass','Bandpass','Stopband');
togmenu(gf,'Filter',items,1,'sigfical(''settype'');');
uimenu(findmenu(gf,'Filter'),'Label','Display Signal',...
	'Separator','on','CallBack','sigfical(''killtime'');');

% add FIR window menu
mufirwin(gf,'sigfical(''drawtrans'');');

% Scale menu
items = str2mat('Linear','Logarithmic');
m=togmenu(gf,'Scale',items,2,'sigfical(''scale'');');

% Full magnitude addition to Scale menu
uimenu(m,'Label','Full Magnitude','Separator','on',...
  	'CallBack','sigfical(''fullmag'');');

% accelerator keys for Scale menu
set(findmenu(gf,'Scale','Linear'),'Accelerator','W');
set(findmenu(gf,'Scale','Logarithmic'),'Accelerator','L');
set(findmenu(gf,'Scale','Full Magnitude'),'Accelerator','M');

% apply filter menu
m=uimenu('Label','Apply','UserData',signal);
  uimenu(m,'Label','Filter','Accelerator','A',...
		'Callback',['sigfical(''apply'');']);

if nargin >= 3,
	% execute callback after filtering
	uimenu(m,'Label','Use','Enable','off','Callback',...
		['sigfical(''use'');' callback]);
end;
drawnow;
% -----------------------------------------------------------------------------

% allow user to set freq from command line
freqs = [1 2000 4000 8000 8192 11025 22050 44100];

% user supplied fs in list already?
ind = find(freqs == fs);

if isempty(ind),

	% nope, add it
	freqs = sort([freqs(:) ; fs])';
	ind = find(freqs == fs);

end;

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

% finally, draw the popupmenu
popunbrs(gf,[columns(1) rows(1) b_width/2 b_hite],...
	freqs,'FS',...
	'LabelPosition',[columns(1) rows(2) b_width/2 b_hite],...
	'BackGroundColor',bcolor,'ForeGroundColor','black',...
	'Range',[1 Inf],'Integer','on',...
    	'CallBack','sigfical(''init'');'...
    );
set(findpopu(gf,'FS'),'Value',ind);

% setup FFT length popupmenu
popunbrs(gf,[columns(1)+b_width/2 rows(1) b_width/2 b_hite], ...
	[16 32 64 128 256 512 1024 2048],'FFT', ...
	'CallBack','sigfical(''plotfreq'');', ...
	'BackGroundColor',bcolor,'ForeGroundColor','black',...
	'Range',[16 Inf],'Integer','on','PowerOfTwo','on', ...
	'LabelPosition',[columns(1)+b_width/2 rows(2) ...
		b_width/2 b_hite],...
	'LabelJustify','center');
set(findpopu(gf,'FFT'),'Value',6);		% default 512
% -------------------------------------------------------------------------

uicontrol(gf,'Style','frame','Units','normal',...
	'Position',[columns(2)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

% fir order popupmenu
popunbrs(gf,[columns(2) rows(1) b_width/2 b_hite],...
	[10 20 30 40 50 60],'FIR',...
	'LabelPosition',[columns(2) rows(2) b_width/2 b_hite],...
	'BackGroundColor',bcolor,'ForeGroundColor','black',...
	'Range',[1 Inf],'Integer','on',...
    	'CallBack','sigfical(''f_length'');'...
    );
set(findpopu(gf,'FIR'),'Value',3);

% iir order popupmenu
popunbrs(gf,[columns(2)+b_width/2 rows(1) b_width/2 b_hite],...
	[2 4 6 8 10 12],'IIR',...
	'LabelPosition',[columns(2)+b_width/2 rows(2) b_width/2 b_hite],...
	'BackGroundColor',bcolor,'ForeGroundColor','black',...
	'Range',[1 Inf],'Integer','on',...
    	'CallBack','sigfical(''f_length'');'...
    );
set(findpopu(gf,'IIR'),'Value',3,'Visible','off');

% -------------------------------------------------------------------------

uicontrol(gf,'Style','frame','Units','normal',...
	'Position',[columns(3)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

% passband ripple popupmenu
popunbrs(gf,[columns(3) rows(1) b_width/2 b_hite],...
	[0.01 0.05 0.1 0.5 1 5],'Ripple',...
	'LabelPosition',[columns(3) rows(2) b_width/2 b_hite],...
	'BackGroundColor',bcolor,'ForeGroundColor','black',...
	'Range',[0 50],'Integer','off',...
    	'CallBack','sigfical(''drawtrans'');'...
    );
set(findpopu(gf,'Ripple'),'Value',5,'Visible','off');

% stopband attenuation popupmenu
popunbrs(gf,[columns(3)+b_width/2 rows(1) b_width/2 b_hite],...
	[10 15 20 30 40 50],'Atten',...
	'LabelPosition',[columns(3)+b_width/2 rows(2) b_width/2 b_hite],...
	'BackGroundColor',bcolor,'ForeGroundColor','black',...
	'Range',[1 Inf],'Integer','off',...
    	'CallBack','sigfical(''drawtrans'');'...
    );
set(findpopu(gf,'Atten'),'Value',2,'Visible','off');

% -------------------------------------------------------------------------

uicontrol(gf,'Style','frame','Units','normal',...
	'Position',[columns(4)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

% draw lower text
uicontrol(gf,'Style','text','Units','normal','Horiz','center',...
    'Foreground','black','Background',bcolor,...
    'Position',[columns(4) rows(2) b_width/2 b_hite],...
    'String','Lower');

% draw lower cutoff edit box
uicontrol(gf,'Style','edit','Units','normal','Horiz','center',...
    'Position',[columns(4) rows(1) b_width/2 b_hite],...
    'BackGroundColor',beditcolor,...
    'String',num2str(fs/8),'Visible','on',...
    'UserData','lower',...
    'CallBack','sigfical(''lower'');');

% draw upper text
uicontrol(gf,'Style','text','Units','normal','Horiz','center',...
    'Foreground','black','Background',bcolor,...
    'Position',[columns(4)+b_width/2 rows(2) b_width/2 b_hite],...
    'String','Upper');

if strcmp(computer,'PCWIN'),
	special = [1 1 1] * 0.8;
else,
	special = beditcolor;
end;

% draw upper cutoff edit box
uicontrol(gf,'Style','edit','Units','normal','Horiz','center',...
	'Position',[columns(4)+b_width/2 rows(1) b_width/2 b_hite],...
	'BackGroundColor',special,...
	'String',num2str(fs/2 - fs/vf_fft),...
	'Visible','off','UserData','upper',...
	'CallBack','sigfical(''upper'');');

% -------------------------------------------------------------------------

% make the axis
axes('Position',[.1 .3 .85 .6],'Color',SPC_AXIS,'UserData','freq');
%axes('Position',[.1 .3 .85 .2],'Color',SPC_AXIS,'UserData','freq');
% axes('Position',[.1 .6 .85 .35],'Color',SPC_AXIS,'UserData','time',...
%	'Visible','off');

set(gf,'Visible','on');

%sigfical('plottime');
sigfical('plotfreq');

if ischeckd(gf,'Filter','Display Signal'),

	h = figure('Name','Time-Domain Signal');
	tscale = (0:length(signal)-1)/fs;
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
else
	% store handle to no window
	set(findmenu(gf,'Apply','Filter'),'UserData',[]);
end

if nargout == 1,
	hand = gf;
end;

