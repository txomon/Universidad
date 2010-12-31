function [gf] = dandsgn(pf,signal)
%DANDSGN Daniel periodogram designer.
%	DANDSGN	is a dialog box for designing a Daniel
%	periodogram and is called by the SPECT2D program.

%       Dennis W. Brown 4-23-94, 4-3-95
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

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
 	       'Name','Daniell Periodogram Design Tool by D.W. Brown',...
 	       'NumberTitle','off','BackingStore','on',...
		'Resize','off','NextPlot','new','UserData',pf);

	% following line is bug workaround for version 4.1 and below
	set(gf,'BackingStore','off','BackingStore','on');

	% turn off PC menu
	if strcmp(computer,'PCWIN'),
		set(gf,'MenuBar','none');
	end;

	% ---------------------- Bins -------------------------------

	hh=uicontrol(gf,'Style','frame','Units','pixels',...
		'Position',[columns(1)-b_frame rows(2)-b_frame ...
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
	popunbrs(gf,[columns(1) rows(2) b_width b_hite], ...
		[3 5 7 9 11 13 15],'Bins','Units','pixels', ...
		'BackGroundColor',bcolor,'ForeGroundColor','black',...
		'Range',[3 Inf],'Integer','on','PowerOfTwo','off', ...
		'LabelPosition',[columns(1) rows(3) b_width b_hite],...
		'LabelJustify','center');

	% ---------------------- Frames -------------------------------

	items = str2mat('Averaged','Show All');
	radiogrp(gf,'Frames',items,1,[columns(2) rows(1)],...
		[b_width b_hite b_frame b_int],'Units','pixels');

	% ---------------------- apply -------------------------------

	uicontrol(gf,'Style','push','String','Apply','UserData',pf,...
		'Position',[columns(3) rows(1) b_width b_hite],...
		'Visible','on','UserData',signal,...
		'CallBack','dandsgn(''apply'');');

elseif strcmp(action,'apply'),

	gf = gcf;

	% get the number of bins to average
	k = getpopvl(gf,'Bins');

	% get the signal
	s = get(findpush(gf,'Apply'),'UserData');

	% get FFT length from parent window
	pf = get(gf,'UserData');
	nfft = getpopvl(pf,'FFT');

	% number of frames
	L = fix(length(s)/nfft);

	% is fft longer than data, zero pad if so
	if L == 0,
		s = [s ; zeros(nfft-length(s)+1,1)];
		L = 1;
	end;

	% shape data into matrix
	s = reshape(s(1:(L*nfft)),nfft,L);

	% take daniell
	S = abs(daniell(s,k,nfft));
	S = S(1:(nfft/2),:);

	% average all if requested
	if get(findrdio(gf,'Averaged'),'Value'),

		if L ~= 1,
			S = (sum(S') / L)';
			L = 1;
		end;

	else
		% make sure keep curves
		set(findchkb(pf,'Keep Curves'),'Value',1);
	end;

	% convert to power
	S = (S / nfft).^2;

	% close our window
	close(gf);

	% make parent current
	figure(pf);

	% plot it
	if L == 1
		spect2d('classic',S(:,1),['Daniell(' int2str(nfft) ...
			',' int2str(k) ')']);

	else,
		for i=1:L,
			spect2d('classic',S(:,i),['Daniell(' int2str(nfft) ...
				',' int2str(k) ',' int2str(i) ')']);
		end;
	end;
end;


set(gcf,'Pointer','arrow');
