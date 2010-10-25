function [child] = aledsgn(action,arg1,arg2,arg3)
%ALEDSGN Adaptive Line Enhancer (ALE) Design Tool.
%	ALEDSGN(SIGNAL,FS) provides a graphical front end to
%	the LMSALE function.  Allows the user to interactively
%	change the number of weights, number of delay samples,
%	and the maximum step size percentage (maximum step
%	size is equal to the magnitude of the signal variance).
%	User can specify which test plots (original, filtered,
%	and error signals) to display to study how effective
%	the filter is.  User can also specify variables names
%	to store the filter weights, filtered signal and
%	error signal back to the Matlab workspace.  The Test
%	push button can be used to apply the current design and
%	view and save the results.  The Use push button performs
%	the same function only closing the ALE Design Tool.
%	The test plot figure is left displayed after closing
%	the ALE Design Tool.
%
%	[FH] = ALEDSGN(H,SIGNAL,FS,'CALLBACK') allows the ALE
%	Design Tool to be called from other programs.  H is
%	the handle to the figure window containing the calling
%	application.  The return argument FH is the handle to
%	the figure window the ALE Design Tool was started in.
%	The user has the above capabilities along with the
%	capability to specify the return signal made available
%	to the callback function (as variable 'SPC_COMMON').  The
%	function of the Test and Use push buttons are the same
%	as the above except the Use push button also closes the
%	test plot figure and executes the callback function.
%
%	The sampling frequency argument, FS, if supplied, is
%	used only in generating the time axis scale on the
%	test plots.
%
%	When saved, the variable names are appended as follows:
%		"_w" for filter weights
%		"_y" for filtered signal
%		"_e" for error signal
%
%	See also ZOOMTOOL

%       Dennis W. Brown 3-5-94, DWB 5-3-95
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% variable storage
%   pf - parent figure - UserData prop of figure window
%   signal - UserData prop of 'Apply' uicontrol text object
%   callstr - UserData prop of 'Use' uicontrol push object
%   fs - UserData prop of 'Test' uicontrol push object
%   w - weights - UserData of 'Weights' uicontrol text object
%   filsig - UserData of 'Filtered Signal' uicontrol text object
%   errsig - UserData of 'Error Signal' uicontrol text object
%   closeflag - Value of 'Apply' uicontrol text object

% default variables
callstr = '';
fs = 1;

if isstr(action),
	gf = gcf;
elseif max(size(action)) == 1,
	use = 2;	% called from another program
	gf = gcf;
	pf = action;
	pa = get(pf,'CurrentAxes');
	signal = arg1;
	if nargin == 3,
		if isstr(arg2),
			callstr = arg2;
			fs = 1;
		else,
			callstr = '';
			fs = arg2;
		end;
	elseif nargin == 4,
		fs = arg2;
		callstr = arg3;
	end;
	action = 'start';
elseif max(size(action)) ~= 1,
	use = 1;	% called from command prompt
	signal = action;
	if nargin == 2, fs = arg1; end;
	action = 'start';
	pf = [];
	pa = [];
end;


% -----------------------------------------------------------------------------

if strcmp(action,'start'),

	spcolors;
	global SPC_WINDOW SPC_TEXT_FORE SPC_TEXT_BACK

	% local constants
	nbrcols = 4; nbrrows = 7;
	b_hite = 22; 	b_int = 10;  b_frame = 6;
	b_end = 10;	b_width = 120;
	columns = (0:nbrcols-1) .* (b_width + 2*b_int) + b_end;
	rows = (0:nbrrows-1) .* (b_hite + b_int) + b_end;
	w_hite = 2*b_end + rows(nbrrows) + b_hite;
	w_width = 2*b_end + columns(nbrcols) + b_width;
	screen = get(0,'ScreenSize');
	w_left = 20;
	w_bottom = 40;
	pos = [w_left w_bottom w_width w_hite];

	% control group base rows
	aac = 1;	% plots
	aab = 4;
	bbc = 1;	% weights
	bbb = 1;
	ccc = 2;	% delay
	ccb = 1;
	eec = 3;	% mup
	eeb = 1;
	ddc = 3;	% variables
	ddb = 4;
	ffc = 4;	% apply
	ffb = 1;
	ggc = 2;	% return signal
	ggb = 5;

	gf = figure('Units','pixels','Position',pos,'color',SPC_WINDOW,...
		'Name','ALE Design Tool by D.W. Brown',...
		'NumberTitle','off','BackingStore','on',...
		'Resize','off','NextPlot','new','UserData',pf);

	% following line is bug workaround for version 4.1 and below
	set(gf,'BackingStore','off','BackingStore','on');

	% turn off PC menu
	if strcmp(computer,'PCWIN'),
		set(gf,'MenuBar','none');
	end;

	% ------------- plots  ------------

	hh = uicontrol(gf,'Style','frame','Units','pixels',...
		'Position',[columns(aac)-b_frame rows(aab)-b_frame ...
		b_width+2*b_frame 4*b_hite+3*b_int+2*b_frame]);

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

	% print plots label
	ee = uicontrol(gf,'Style','text',...
		'Units','pixels',...
		'Horiz','center',...
		'Position',[columns(aac) rows(aab+3) b_width b_hite],...
		'String','Test Plots',...
		'UserData',-1);

	% draw original check box
	bb = uicontrol(gf,'Style','check',...
		'Units','pixels','Horiz','center',...
		'Background',beditcolor,...
		'Foreground','black',...
		'Position',[columns(aac) rows(aab+2) b_width b_hite],...
		'String','Original',...
		'Value',0);

	% draw filtered check box
	cc = uicontrol(gf,'Style','check',...
		'Units','pixels',...
		'Horiz','center',...
		'Background',beditcolor,...
		'Foreground','black',...
		'Position',[columns(aac) rows(aab+1) b_width b_hite],...
		'String','Filtered',...
		'Value',1);

	% draw error check box
	dd = uicontrol(gf,'Style','check','Units','pixels','Horiz','center',...
		'Background',beditcolor,...
		'Foreground','black',...
		'Position',[columns(aac) rows(aab) b_width b_hite],...
		'String','Error',...
		'Value',0);

	% ---------------------- return signal -------------------------------

	items = str2mat('Filtered','Error');
	[fh,rh] = radiogrp(gf,'Return Signal',items,1,[columns(ggc) rows(ggb)],...
		[b_width b_hite b_frame b_int],'Units','pixels');

	% disable if called from command prompt
	if use == 1,
		set(rh,'Enable','off');
	end;

	% ---------------------- weights -------------------------------

	uicontrol(gf,'Style','frame','Units','pixels',...
		'Position',[columns(bbc)-b_frame rows(bbb)-b_frame ...
			b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

	% print weights label
	uicontrol(gf,'Style','text','Units','pixels','Horiz','center',...
		'Position',[columns(bbc) rows(bbb+1) b_width b_hite],...
		'String','Nbr Weights');

	% draw weights edit box
	uicontrol(gf,'Style','edit','Units','pixels','Horiz','center',...
		'Position',[columns(bbc) rows(bbb) b_width b_hite],...
		'String','4','UserData','weights','Back',beditcolor);

	% ---------------------- delay -------------------------------

	uicontrol(gf,'Style','frame','Units','pixels',...
		'Position',[columns(ccc)-b_frame rows(ccb)-b_frame ...
			b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

	% print delay label
	uicontrol(gf,'Style','text','Units','pixels','Horiz','center',...
		'Position',[columns(ccc) rows(ccb+1) b_width b_hite],...
		'String','Delay Samples');

	% draw delay edit box
	uicontrol(gf,'Style','edit','Units','pixels','Horiz','center',...
		'Position',[columns(ccc) rows(ccb) b_width b_hite],...
		'String','1','UserData','delay','Back',beditcolor);

	% ---------------------- step -------------------------------

	uicontrol(gf,'Style','frame','Units','pixels',...
		'Position',[columns(eec)-b_frame rows(eeb)-b_frame ...
			b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

	% print step size label
	uicontrol(gf,'Style','text','Units','pixels','Horiz','center',...
		'Position',[columns(eec) rows(eeb+1) b_width b_hite],...
		'String','Max Step Size %');

	% draw step size edit box
	uicontrol(gf,'Style','edit','Units','pixels','Horiz','center',...
		'Position',[columns(eec) rows(eeb) b_width b_hite],...
		'String','5','UserData','step','Back',beditcolor);

	% ---------------------- save -------------------------------

	uicontrol(gf,'Style','frame','Units','pixels',...
		'Position',[columns(ddc)-b_frame rows(ddb)-b_frame ...
		2*b_width+2*b_frame+2*b_int 4*b_hite+3*b_int+2*b_frame]);

	% print variable labels
	uicontrol(gf,'Style','text','Units','pixels','Horiz','center',...
		'Position',[columns(ddc) rows(ddb+3) 2*b_width+b_int b_hite],...
		'String','Variable Save Names');

	% print variable labels
	uicontrol(gf,'Style','text','Units','pixels','Horiz','center',...
		'Position',[columns(ddc) rows(ddb+2) b_width b_hite],...
		'String','Weights');

	% print variable labels
	uicontrol(gf,'Style','text','Units','pixels','Horiz','center',...
		'Position',[columns(ddc) rows(ddb+1) b_width b_hite],...
		'String','Filtered Signal');

	% print variable labels
	uicontrol(gf,'Style','text','Units','pixels','Horiz','center',...
		'Position',[columns(ddc) rows(ddb) b_width b_hite],...
		'String','Error Signal');

	%  variable names
	uicontrol(gf,'Style','edit','Units','pixels','Horiz','center',...
		'Position',[columns(ddc+1) rows(ddb+2) b_width b_hite],...
		'UserData','coef','Back',beditcolor,'CallBack', ...
		['dog_x = get(findedit(gcf,''coef''),''String''); '...
		'set(findedit(gcf,''filsig''),''String'',dog_x); '...
		'set(findedit(gcf,''errsig''),''String'',dog_x); ' ...
		'clear dog_x;']);

	%  variable names
	uicontrol(gf,'Style','edit','Units','pixels','Horiz','center',...
		'Position',[columns(ddc+1) rows(ddb+1) b_width b_hite],...
		'UserData','filsig','Back',beditcolor);

	%  variable names
	uicontrol(gf,'Style','edit','Units','pixels','Horiz','center',...
		'Position',[columns(ddc+1) rows(ddb) b_width b_hite],...
		'UserData','errsig','Back',beditcolor);


	% save varibles if names present callback
	% note save callback has to be executed as a callback script
	% so that variable creation in the normal workspace is allowed
	savecall = [...
		'dog_name = get(findedit(gcf,''coef''),''String'');'...
		'if ~isempty(dog_name),'...
			'dog_w = get(finduitx(gcf,''Weights''),''UserData'');'...
			'eval([dog_name ''_w = dog_w;'']);'...
		'end;'...
		'dog_name = get(findedit(gcf,''filsig''),''String'');'...
		'if ~isempty(dog_name),'...
			'dog_w = get(finduitx(gcf,'...
				' ''Filtered Signal''),''UserData'');'...
			'eval([dog_name ''_y = dog_w;'']);'...
		'end;'...
		'dog_name = get(findedit(gcf,''errsig''),''String'');'...
		'if ~isempty(dog_name), '...
			'dog_w = get(finduitx(gcf,'...
				' ''Error Signal''),''UserData'');'...
			'eval([dog_name ''_e = dog_w;'']);'...
		'end;'...
		'if get(finduitx(gcf,''Apply''),''Value''),'...
			' close(gcf);end; clear dog_name dog_w;'...
	];
	% ---------------------- apply -------------------------------

	uicontrol(gf,'Style','frame','Units','pixels',...
		'UserData','apply','value',0,...
		'Position',[columns(ffc)-b_frame rows(ffb)-b_frame ...
			b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

	% print apply label
	uicontrol(gf,'Style','text','Units','pixels','Horiz','center',...
		'Position',[columns(ffc) rows(ffb+1) b_width b_hite],...
		'String','Apply','UserData',signal);

	% create test push button
	uicontrol(gf,'Style','push','String','Test','UserData',pf,...
		'Position',[columns(ffc) rows(ffb) b_width/2 b_hite],...
		'Visible','on','UserData',fs,...
		'CallBack',['aledsgn(''apply'',''test'');' savecall;]);

	% create use pushbutton
	uicontrol(gf,'Style','push','String','Use','UserData',pf,...
		'Position',[columns(ffc)+b_width/2 ...
			 rows(ffb) b_width/2 b_hite],...
		'Visible','on','UserData',callstr,...
		'CallBack',['aledsgn(''apply'',''use'');' savecall;]);

	% output if requested
	if nargout >= 1,
		child = gf;
	end;

elseif strcmp(action,'apply'),

	if ~ednbrchk(findedit(gf,'weights'),'Range',[1 Inf],...
		'Integer','on','Variable','Nbr Weights'), return; end;
	if ~ednbrchk(findedit(gf,'delay'),'Range',[1 Inf],...
		'Integer','on','Variable','Delay Samples'), return; end;
	if ~ednbrchk(findedit(gf,'step'),'Range',[.0001 100],...
		'Integer','off','Variable','Max Step Size %'), return; end;

	% make sure we still have focus
	figure(gf);

	weights = getednbr(gf,'weights');
	delay = getednbr(gf,'delay');
	step = getednbr(gf,'step');
	signal = get(finduitx(gf,'Apply'),'UserData');
	fs = get(findpush(gf,'Test'),'UserData');
	pf = get(gf,'UserData');

	% check length of data
	if weights+delay > length(signal),

		msg = 'Number weights plus delay longer than data!';
		spcwarn(msg,'OK');
		return;
	end;

	% find out what the user wants plotted
	do_original = get(findchkb(gf,'Original'),'Value');
	do_filtered = get(findchkb(gf,'Filtered'),'Value');
	do_error = get(findchkb(gf,'Error'),'Value');
	plots = do_original + do_filtered + do_error;

	coef = get(findedit(gcf,'coef'),'String');
	filsig = get(findedit(gcf,'filsig'),'String');
	errsig = get(findedit(gcf,'errsig'),'String');
	nosavevars = isempty(coef) & isempty(filsig) & isempty(errsig);

	if isempty(pf) & plots == 0 & nosavevars == 1,

		% if called from command prompt and no plots, no save variables
		w = [];
		filsig = [];
		errsig = [];
	else,

		% filter it
		[w,filsig,errsig] = lmsale(signal,weights,step,delay);
	end;

	% gotta stuff the variable data somewhere to that the
	% save callback can find it, #&$*$%@ Mathworks!
	if ~isempty(get(findedit(gf,'coef'),'String')),
		set(finduitx(gf,'Weights'),'UserData',w);
	end;
	if ~isempty(get(findedit(gf,'filsig'),'String')),
		set(finduitx(gf,'Filtered Signal'),'UserData',filsig);
	end;
	if ~isempty(get(findedit(gf,'errsig'),'String')),
		set(finduitx(gf,'Error Signal'),'UserData',errsig);
	end;

	% get signal figure handles
	ow = get(findchkb(gf,'Original'),'UserData');
	of = get(findchkb(gf,'Filtered'),'UserData');
	oe = get(findchkb(gf,'Error'),'UserData');

	% don't do plots if this is the finale when called from
	%   another application
	if strcmp(arg1,'use') & ~isempty(pf),
		plots = 0;
		do_original = 0;
		do_filtered = 0;
		do_error = 0;

		% close old windows if they existed
		if ~isempty(find(get(0,'Children') == ow)),
			close(ow);
		end;
		if ~isempty(find(get(0,'Children') == of)),
			close(of);
		end;
		if ~isempty(find(get(0,'Children') == oe)),
			close(oe);
		end;
	end;


	if plots > 0,

		scr = get(0,'ScreenSize');
		pos = get(0,'DefaultFigurePosition');
		scale = (0:length(signal)-1)/fs;

		if do_original,

		    if isempty(find(get(0,'Children') == ow)),

			pos(1:2) = [0 scr(4)-pos(4)];

			h = figure('Position',pos,'Name','ALE Results');

			plot(scale,signal);
			title('Original Signal');
			xlabel('Time (sec)');
			ylabel('Magnitude');
			zoomtool(gca);
			zoomplay(h,fs);
			zoomprog(h);

			%  bug workaround for version 4.1 and below
			set(h,'BackingStore','off','BackingStore','on');

			% save handle
			set(findchkb(gf,'Original'),'UserData',h);

		    else,

			ax = get(ow,'CurrentAxes');
			zoomrep(ax,signal);

		    end;

		end;

		if do_filtered,

		    if isempty(find(get(0,'Children') == of)),

			pos(1:2) = [scr(3)-pos(3) scr(4)-pos(4)];

			h = figure('Position',pos,'Name','ALE Results');

			plot(scale,filsig);
			title('Filtered Signal');
			xlabel('Time (sec)');
			ylabel('Magnitude');
			zoomtool(gca);
			zoomplay(h,fs);
			zoomprog(h);

			%  bug workaround for version 4.1 and below
			set(h,'BackingStore','off','BackingStore','on');

			% save handle
			set(findchkb(gf,'Filtered'),'UserData',h);

		    else,
			ax = get(of,'CurrentAxes');
			zoomrep(ax,filsig);
		    end;

		end;

		if do_error,

		    if isempty(find(get(0,'Children') == oe)),

			pos(1:2) = [scr(3)-pos(3) 0];

			h = figure('Position',pos,'Name','ALE Results');

			plot(scale,errsig);
			title('Error Signal');
			xlabel('Time (sec)');
			ylabel('Magnitude');
			zoomtool(gca);
			zoomplay(h,fs);
			zoomprog(h);

			%  bug workaround for version 4.1 and below
			set(h,'BackingStore','off','BackingStore','on');

			% save handle
			set(findchkb(gf,'Error'),'UserData',h);

		    else,
			ax = get(oe,'CurrentAxes');
			zoomrep(ax,errsig);
		    end;

		end;

	end;

	% return focus to our window
	figure(gf);

	% if called from another app and use
	if ~isempty(pf) & strcmp(arg1,'use'),

		callstr = get(findpush(gf,'Use'),'UserData');

		global SPC_COMMON
		if get(findrdio(gf,'Filtered'),'Value'),
			SPC_COMMON = filsig;
		else,
			SPC_COMMON = errsig;
		end;

		set(finduitx(gf,'Apply'),'Value',1);

		% so the callback string can use gcf
		figure(pf);

		eval(callstr);

		% so we can use gcf
		figure(gf);
	end;

	% if called directly with signal
	if isempty(pf),
		if strcmp(arg1,'use'),
			set(finduitx(gf,'Apply'),'Value',1);
		else,
			return;
		end;
	end;

else,
	error(['aledsgn: Invalid action "' action '" specified.']);
end;
