function spscocal(action,arg1,arg2)
%SPSCOCAL Callback functions for SPSCOPE
%	SICEDCAL('ACTION',ARG1,ARG2) performs the specified
%	callback 'ACTION'.  Valid actions are:
%
%
%	See also SPSCOPE

%       Dennis W. Brown 6-18-94, DWB 2-21-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% base objects
gf = gcf;
ga = findaxes(gf,'zoomtool');

set(gf,'Pointer','watch');

if strcmp(action,'start'),

	% current values
	fft_N = getpopvl(gf,'FFT');
	fs = getpopvl(gf,'FS');
	maxlen = get(finduitx(gf,'Start'),'UserData');
	framestart = get(finduitx(gf,'Frame'),'UserData');
	framelen = getednbr(gf,'Frame');

	% frame length in samples
	if rem(framelen,1),
		% not an integer must be time
		framelen = floor(framelen * fs);
	end;

	% check value
	if ~ednbrchk(findedit(gf,'Start'),...
		'Range',[0 (maxlen-framelen-1)/fs],...
		'Integer','off',...
		'Variable','Start',...
		'Default',(framestart-1)/fs),

			set(gf,'Pointer','arrow');
			return;
	end;

	% new starting point
	framestart = floor(str2num(get(findedit(gf,'Start'),'String')) * fs)+1;
	set(finduitx(gf,'Frame'),'UserData',framestart);

	% adjust for time smoothing
	timesmooth = str2num(get(getcheck(gf,'TimeSmooth'),'Label'));
	if timesmooth > 1,
		spscocal('timesmooth');
	else,
		% redo
		spscope('apply','current');
	end;
	
elseif strcmp(action,'frame'),

	% current values
	fft_N = getpopvl(gf,'FFT');
	fs = getpopvl(gf,'FS');
	framelen = getednbr(gf,'Frame');

	% frame length in samples
	if ~rem(framelen,1),

		% check value for number of samples
		ednbrchk(findedit(gf,'Frame'),...
			'Range',[0 fft_N],...
			'Integer','on',...
			'Variable','Frame',...
			'Default',fft_N);
	else,
		% check value for time
		ednbrchk(findedit(gf,'Frame'),...
			'Range',[0 (fft_N-1)/fs],...
			'Integer','off',...
			'Variable','Frame',...
			'Default',fft_N/fs);
	end;

	% adjust for time smoothing
	timesmooth = str2num(get(getcheck(gf,'TimeSmooth'),'Label'));
	if timesmooth > 1,
		spscocal('timesmooth');
	else,
		% redo
		spscope('apply','current');
	end;


elseif strcmp(action,'ceil'),

	% current values
	dbfloor = str2num(get(findedit(gf,'Floor'),'String'));
	ylim = get(ga,'YLim');

	% check value
	if ~ednbrchk(findedit(gf,'Ceil'),...
		'Range',[dbfloor+1 Inf],...
		'Integer','on',...
		'Variable','Ceil',...
		'Default',round(ylim(2)/10)*10),

			set(gf,'Pointer','arrow');
			return;
	end;

	% redo
	spscope('apply','current');
	
elseif strcmp(action,'floor'),

	% current values
	dbceil = str2num(get(findedit(gf,'Ceil'),'String'));
	ylim = get(ga,'YLim');

	% check value
	if ~ednbrchk(findedit(gf,'Floor'),...
		'Range',[-Inf dbceil-1],...
		'Integer','on',...
		'Variable','Floor',...
		'Default',round(ylim(1)/10)*10),

			set(gf,'Pointer','arrow');
			return;
	end;

	% redo
	spscope('apply','current');
	
elseif strcmp(action,'timesmooth'),

	% speed things up, keep previous frames around so only
	% on new FFT has to be performed.

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

	if framestart < 1, framestart = 1; end;
	if framestart+timesmooth*framelength-1 > length(y),
		msg = 'spscope: Last frame reached.';
		spcwarn(msg,'OK');
		set(gf,'Pointer','arrow');
		set(findedit(gf,'Frame'),'String',num2str(fftlength/fs));
		return;
	end;

	% store for time windows.
	YYY = zeros(timesmooth,fftlength/2);

	for i = 1:timesmooth,

		nextframe = y(framestart:framestart+framelength-1);

		% appply window, get it from menu and then create it
		window = gtfirwin(gf,framelength);
		nextframe = window .* nextframe;

		% apply FFT
		YY = abs(fft(nextframe,fftlength))/framelength;
		YY = YY(1:fftlength/2);
		YY = YY(:).^2;

		% put in storage
		YYY(i,:) = YY';

		framestart = framestart + framelength - overlap;
	end;

	% store in Play text
	set(finduitx(gf,'Play'),'UserData',YYY);

	% store pointers to head and tail
	set(findpush(gf,'Stop'),'UserData',[1 timesmooth]);

	% redo
	spscope('apply','current');
	
elseif strcmp(action,'window'),

	% adjust for time smoothing
	timesmooth = str2num(get(getcheck(gf,'TimeSmooth'),'Label'));
	if timesmooth > 1,
		spscocal('timesmooth');
	else,
		% redo
		spscope('apply','current');
	end;
	
elseif strcmp(action,'fft'),

	% adjust for time smoothing
	timesmooth = str2num(get(getcheck(gf,'TimeSmooth'),'Label'));
	if timesmooth > 1,
		spscocal('timesmooth');
	else,
		% redo
		spscope('apply','current');
	end;
	
elseif strcmp(action,'overlap'),

	% adjust for time smoothing
	timesmooth = str2num(get(getcheck(gf,'TimeSmooth'),'Label'));
	if timesmooth > 1,
		spscocal('timesmooth');
	end;
	
else,
	error(['spscocal: Invalid action "' action '" specified.']);
end;

set(gf,'Pointer','arrow');
