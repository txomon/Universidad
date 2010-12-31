function gff = voicedit(signal,fs)
%VOICEDIT	Signal editor.
%	[H]=VOICEDIT(X) opens the Signal Edit Tool providing a
%	graphical cut and paste editing facility for speech
%	signals.  This is a specialized version of the
%	SIGEDIT tool.  Two axes are displayed in the VOICEDIT
%	figure window.  The lower axis displays the time-domain
%	signal and operates like the axes in SIGEDIT.  The upper
%	axis contains two curves representing the short-time
%	energy and short-time zero-crossing rates of the time-
%	domain signal.  This information allows the user to
%	better discriminate between voiced and unvoiced
%	phonemes in the speech, allowing better precision in
%	editing phonemes.  Note cursor movements in the
%	lower axis are reflected in the upper axes and vica
%	versa.
%
%	[H]=VOICEDIT(X,FS) - Sets the default sampling frequency to
%	FS Hertzs.  The default sampling frequency is 8192 Hz.
%	The sampling frequency can also be set using the Sampling
%	Frequency popupmenu in the VOICEDIT figure window.
%
%	VOICEDIT('FILENAME') and VOICEDIT('FILENAME',BITS) open the
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
%	VOICEDIT returns the handle to the figure window it was
%	started in.
%
%	See also SIGEDIT, SIGFILT, SIGMODEL, SPECT2D, SPECT3D

%       Dennis W. Brown 2-3-93, DWB 6-7-94
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
		error(['voicedit: Filename must have an extension' ...
			' or bits must be specified.']);
	end;
elseif nargin == 1,
	fs = 8192;
end;

% figure out if we have a vector
if min(size(signal)) ~= 1,
	error('voicedit: Input arg "signal" must be a 1xN or Nx1 vector.');
end;

% work with Nx1 vectors
signal = signal(:);

% -----------------------------------------------------------------------------
% local constants
nbrcols = 5; nbrrows = 2;
b_hite = .05; 	b_int = .015;	b_frame = .005; b_end = .05;
b_width = (1 - (nbrcols-1)*b_int - 2*b_end)/nbrcols;
columns = (0:nbrcols-1) .* (b_width + b_int) + b_end;
rows = (0:nbrrows-1) .* (b_hite + b_int) + b_end;

% -----------------------------------------------------------------------------
spcolors;
global SPC_WINDOW SPC_TEXT_FORE SPC_TEXT_BACK SPC_AXIS SPC_MARKS SPC_VE_POS
s = get(0,'ScreenSize');
if exist('SPC_VE_POS'),
    ve_pos = SPC_VE_POS;
elseif s(3) < 800,
    ve_pos = [0 0 .9 .9];
elseif s(3) >= 800 & s(3) < 1024,
    ve_pos = [0 .0 .8 .8];
elseif s(3) == 1024,
    ve_pos = [0 0 .7 .7];
else
    ve_pos = [0 0 .7 .7];
end;

gf = figure('Units','normal','Position',ve_pos,'color',SPC_WINDOW,...
        'Name','Voice Edit Tool by D.W. Brown',...
        'NumberTitle','off');

% following line is bug workaround for version 4.1 and below
set(gcf,'BackingStore','off','BackingStore','on');

% -----------------------------------------------------------------------------

savecall = [...
	'eval([get(finduitx(gcf,''Answer''),''UserData'') '...
	' ''= get(zoomed(gcf),''''YData'''');'']);'];

if isempty(sigfile),
	workmenu(gf,signal,'voiccall(''restore'');','voiccall(''common'');', ...
		'voicload;voiccall(''redo'');',savecall);
else,
	workmenu(gf,sigfile,'voiccall(''restore'');','voiccall(''common'');',...
		'voicload;voiccall(''redo'');',savecall);
end;

% add short-time method  menu
items = str2mat('Energy','Magnitude');
togmenu(gf,'Short-Time',items,1,'voiccall(''redo'');');
togmenu(gf,'Short-Time','Zero-Crossings',1,'voiccall(''redo'');');
togzcr = ['dog_h = get(gcf,''CurrentMenu'');'...
	  'if strcmp(get(dog_h,''Checked''),''on''),'...
		'set(dog_h,''Checked'',''off'');'...
	  'else,'...
		'set(dog_h,''Checked'',''on'');'...
	  'end;'];
set(findmenu(gf,'Short-Time','Zero-Crossings'),'Enable','on',...
	'Callback',[togzcr 'voiccall(''redo'');']);

% accelerator keys for short-time menu
set(findmenu(gf,'Short-Time','Energy'),'Accelerator','E');
set(findmenu(gf,'Short-Time','Magnitude'),'Accelerator','M');
set(findmenu(gf,'Short-Time','Zero-Crossings'),'Accelerator','F');

% add frame length menu
items = str2mat('2','5','10','15','20','25','30','40','50','60');
togmenu(gf,'Frame',items,4,'voiccall(''redo'');');

% add overlap length menu
items = str2mat('0','10','20','30','40','50','60','70','80','90');
togmenu(gf,'Overlap',items,3,'voiccall(''redo'');');

% add smoothing menu
items = str2mat('None','Average','Median');
togmenu(gf,'Smoothing',items,3,'voiccall(''redo'');');
items = str2mat('3','5','7','9','11','15');
togmenu(gf,'Smoothing',items,3,'voiccall(''redo'');');

% accelerator keys for short-time menu
set(findmenu(gf,'Smoothing','None'),'Accelerator','N');
set(findmenu(gf,'Smoothing','Average'),'Accelerator','A');
set(findmenu(gf,'Smoothing','Median'),'Accelerator','D');

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
popunbrs(gf,[columns(1) rows(1) b_width b_hite],...
	freqs,'Sampling Freq',...
	'LabelPosition',[columns(1) rows(2) b_width b_hite],...
	'BackGroundColor',bcolor,...
	'ForeGroundColor','black',...
	'Range',[1 Inf],...
	'Integer','on',...
    	'CallBack','voiccall(''fs'');');
set(findpopu(gf,'Sampling Freq'),'Value',ind);

% -------------------------------------------------------------------------

% draw zero block pushbutton
uicontrol(gf,'Style','pushbutton',...
	'Units','normal',...
	'Horiz','center',...
	'Position',[columns(3) rows(1) b_width b_hite],...
	'String','Zero Marked',...
	'CallBack','voiccall(''zero'');');

% -------------------------------------------------------------------------

uicontrol(gf,'Style','frame','Units','normal',...
	'Position',[columns(2)-b_frame rows(1)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

% draw mean text
uicontrol(gf,'Style','text',...
	'Units','normal',...
	'Horiz','center',...
	'Foreground','black',...
	'Background',bcolor,...
	'Position',[columns(2) rows(2) b_width b_hite],...
	'String','Mean');

% draw mean user edit box
uicontrol(gf,'Style','edit',...
	'Units','normal',...
	'Horiz','center',...
	'Position',[columns(2) rows(1) b_width b_hite],...
	'BackGroundColor',beditcolor,...
	'String',num2str(mean(signal)),'Visible','on',...
	'UserData','Mean',...
	'CallBack','voiccall(''mean'');');

% -------------------------------------------------------------------------

uicontrol(gf,'Style','frame',...
	'Units','normal',...
	'Position',[columns(4)-b_frame rows(1)-b_frame ...
		2*b_width+2*b_frame+b_int 2*b_hite+1*b_int+2*b_frame]);

% print volume label
uicontrol(gf,'Style','text',...
	'Units','normal',...
	'Horiz','center',...
	'Foreground','black',...
	'Background',bcolor,...
	'Position',[columns(4) rows(2) b_width b_hite],...
	'String','Amplitude');

% draw volume popup popupmenu
uicontrol(gf,'Style','popupmenu',...
	'Units','normal',...
	'Horiz','center',...
	'Foreground','black',...
	'Background',beditcolor,...
	'Position',[columns(4) rows(1) b_width b_hite],...
	'String','Full|Marked',...
	'UserData','Amplitude',...
	'CallBack','voiccall(''volume'');');

% print volume multiplier
uicontrol(gf,'Style','edit',...
	'Units','normal',...
	'Horiz','center',...
	'Foreground','black',...
	'Background',beditcolor,...
	'UserData','Amplitude',...
	'String','100',...
	'Position',[columns(5) rows(2) b_width b_hite],...
	'CallBack',[...
		'dog_v = getednbr(gcf,''Amplitude''); ' ...
		'if dog_v >= 0 & dog_v <=200, ' ...
		'set(findslid(gcf,''Amplitude''),''Value'',dog_v); '...
		'else, '...
		'set(findedit(gcf,''Amplitude''),''String'',' ...
		'  int2str(get(findslid(gcf,''Amplitude''),''Value''))); '...
		'end; clear dog_v'] ...
    );

uicontrol(gf,'Style','slider',...
	'Units','normal',...
	'Horiz','center',...
	'UserData','Amplitude',...
	'String','Amplitude',...
	'Position',[columns(5) rows(1) b_width b_hite],...
	'min',0,...
	'max',200,...
	'Value',100,...
	'CallBack',[...
		'dog_mult = get(findslid(gcf,''Amplitude''),''Value'') / 100;'...
		'set(findedit(gcf,''Amplitude''),''String'',[int2str(dog_mult*100) ''%'']);',...
		'clear dog_mult']);

% -------------------------------------------------------------------------

% make the axis
axes('Position',[.1 .85 .85 .1],'DrawMode','fast');
set(gca,'UserData','speech');
axes('Position',[.1 .28 .85 .48],'DrawMode','fast');
set(gca,'UserData','zoomtool');

% snapshot for phase axis
uicontrol(gf,'Style','push','Units','normal','Horiz','center',...
	'Position',[.90 .85 .05 .04],...
	'String','SS','CallBack',['voiccall(''snapall'');']);

% display the signal
voiccall('plottime',signal);

if nargout == 1,
	gff = gf;
end;

