function [gf] = wlchdsgn(pf,signal,fs)
%WLCHSGN Welch periodogram designer.
%	WLCHDSGN is a dialog box for designing a Welch
%	periodogram and is called by the SPECT2D program.

%       Dennis W. Brown 4-23-94, 5-31-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% Storage
% signal - UserData of Apply pushbutton
% fs - UserData of 'Frames' text
% pf - UserData of figure

if ~isstr(pf),

	action = 'start';
else,
	action = pf;
	oldpoint = get(gcf,'Pointer');
	set(gcf,'Pointer','watch');
end;

if strcmp(action,'start')

	% ----------------------------------------------------------------
	spcolors;
	global SPC_WINDOW SPC_TEXT_FORE SPC_TEXT_BACK

	% local constants
	nbrcols = 3; nbrrows = 3;
	b_hite = 22; 	b_int = 10;  b_frame = 6;
	b_end = 10;	b_width = 120;
	columns = (0:nbrcols-1) .* (b_width + 2*b_int) + b_end;
	rows = (0:nbrrows-1) .* (b_hite + b_int) + b_end;
	w_hite = 2*b_end + rows(nbrrows) + b_hite;
	w_width = 2*b_end + columns(nbrcols) + b_width;
	screen = get(0,'ScreenSize');
	w_left = screen(4) - w_width - 30;
	w_bottom = 50;
	pos = [w_left w_bottom w_width w_hite];

	gf = figure('Units','pixels','Position',pos,'color',SPC_WINDOW,...
 	       'Name','Welch Periodogram Design Tool by D.W. Brown',...
 	       'NumberTitle','off','BackingStore','on',...
		'Resize','off','NextPlot','new','UserData',pf);

	% following line is bug workaround for version 4.1 and below
	set(gf,'BackingStore','off','BackingStore','on');

	% turn off PC menu
	if strcmp(computer,'PCWIN'),
		set(gf,'MenuBar','none');
	end;

	% ---------------------- Bins -------------------------------

	hh=	uicontrol(gf,'Style','frame','Units','pixels',...
		'Position',[columns(3)-b_frame rows(2)-b_frame ...
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
	popunbrs(gf,[columns(3) rows(2) b_width b_hite], ...
		[0 10 20 30 40 50 60 70 80 90],'Overlap %','Units','pixels', ...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'Range',[0 99],'Integer','on','PowerOfTwo','off', ...
		'LabelPosition',[columns(3) rows(3) b_width b_hite],...
		'LabelJustify','center');
	set(findpopu(gf,'Overlap %'),'Value',6);

	% draw frame length edit box
	uicontrol(gf,'Style','frame','Units','pixels',...
		'Position',[columns(1)-b_frame rows(2)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

	fs = getpopvl(pf,'FS');
	uicontrol('Style','text',...
		'Units','pixels',...
		'Horiz','center',...
		'Position',[columns(1) rows(3) b_width b_hite],...
		'Fore','black',...
		'Back',bcolor,...
		'String','Frame Length');
	uicontrol('Style','edit',...
		'Units','pixels',...
		'Horiz','center',...
		'Position',[columns(1) rows(2) b_width b_hite],...
		'UserData','Frame Length',...
		'Fore','black',...
		'Back',beditcolor,...
		'String',num2str(512/fs),...
		'Callback',['dog_h3d = findedit(gcf,''Frame Length''); ' ...
		'dog_y3d=str2num(get(dog_h3d,''String''));if dog_y3d <= 0,' ...
		'dog_fs3d = get(findmenu(gcf,''Close''),''UserData''); ' ...
		'set(dog_h3d,''String'',num2str(512/dog_fs3d)); end; ' ...
		'clear dog_h3d dog_y3d dog_fs3d ']);

	% ---------------------- Frames -------------------------------

	items = str2mat('Averaged','Show All');
	radiogrp(gf,'Frames',items,1,[columns(2) rows(1)],...
		[b_width b_hite b_frame b_int],'Units','pixels');

	set(finduitx(gf,'Frames'),'UserData',fs);
	% ---------------------- apply -------------------------------

	uicontrol(gf,'Style','push','String','Apply','UserData',pf,...
		'Position',[columns(3) rows(1) b_width b_hite],...
		'Visible','on','UserData',signal,...
		'CallBack','wlchdsgn(''apply'');');

elseif strcmp(action,'apply'),

	gf = gcf;

	% get FFT length from parent window
	pf = get(gf,'UserData');
	nfft = getpopvl(pf,'FFT');

	% get the signal and other variables
	s = get(findpush(gf,'Apply'),'UserData');
	overlap = getpopvl(gf,'Overlap %');
	framelen = getednbr(gf,'Frame Length');
	fs = get(finduitx(gf,'Frames'),'UserData');

	if length(s) < nfft,
		s = [s ; zeros(nfft-length(s),1)];
	end;

	% frame length in samples?
	if rem(framelen,1) ~= 0.0,

		% not an integer must be time
		framelength = floor(framelen * fs);
	else,

		% an integer, must be points
		framelength = framelen;
	end;

	if framelength > nfft,
		msg = 'wlchdsgn: Frame length exceeds FFT length.  Aborted.';
		spcwarn(msg,'OK');
		set(gf,'Pointer','arrow');
		set(findedit(gf,'Frame Length'),'String',num2str(nfft/fs));
		return;
	end;

	% get smoothing window
	window = gtfirwin(pf,framelength);

	if get(findrdio(gf,'Averaged'),'Value'),

		% take welch
		S = abs(avgpergm(s,nfft,[framelength overlap],window));

	else,
		% take welch
		S = abs(avgpergm(s,nfft,[framelength overlap],window,'frames'));
	end;

	S = S(1:(nfft/2+1),:);

	% convert to power
	S = S(1:(nfft/2),:).^2;
	[m,L] = size(S);

	% close our window
	close(gf);

	% make parent current
	figure(pf);

	% plot it
	if L == 1
		spect2d('classic',S(:,1),['Welch(' int2str(nfft) ...
				',' int2str(framelength) ')']);

	else,
		for i=1:L,

			if i > 1 & get(findchkb(pf,'Keep curves'),'value') == 0,

				set(findchkb(pf,'Keep curves'),'value',1);

			end;

			spect2d('classic',S(:,i),['Welch(' int2str(nfft) ...
				',' int2str(framelength) ',' int2str(i) ')']);
		end;
	end;
end;


set(gcf,'Pointer','arrow');
