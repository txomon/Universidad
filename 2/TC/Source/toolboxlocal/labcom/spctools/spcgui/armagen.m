function [b,a,modsig,errsig,desired,g] = armagen(gf,pf)
%ARMAGEN Generates AR/MA/ARMA model for ARMADSGN
%	ARMAGEN(H,X) models the signal X according to
%	the setting of the controls in the ARMADSGN
%	figure pointed to by the handle H.


if ~isempty(pf),

	set(gf,'Pointer','watch');

	pa = get(pf,'CurrentAxes');

	toolname = get(pf,'Name');

else,
	set(gcf,'Pointer','watch');

	gf = gcf;

	toolname = 'command';

end;

set(gf,'Pointer','watch');

% default for everything but Burg
g=1;

if strcmp(toolname,'Signal Modeling Tool by D.W. Brown'),

	toolname = 'signal';

	% get some data about the current axes state
	zoom = get(finduitx(pf,'zoomtool'),'UserData');
	xfactor = zoom(28);
	xmin = zoom(29);

	% current index
	mstart = round((crsrloc(pa,'modstart') - xmin) / xfactor) + 1;
	mend   = round((crsrloc(pa,'modend')   - xmin) / xfactor) + 1;
	pstart = round((crsrloc(pa,'perstart') - xmin) / xfactor) + 1;
	pend   = round((crsrloc(pa,'perend')   - xmin) / xfactor) + 1;

	% get the data
	x = get(findpush(gf,'Apply'),'UserData');
	x = x(:);

	% make sure they're not past the data
	if mstart < 1, mstart = 1; end;
	if mend > length(x); mend = length(x); end;

	% determine model length
	model = x(mstart:mend,1);

elseif strcmp(toolname,'2D Spectral Estimation Tool - by D.W. Brown'),

	toolname = '2D';

	% get the data
	model = get(findpush(gf,'Apply'),'UserData');
	mstart = 1;
	mend = length(model);
	pstart = 1;
	pend = 1;

elseif strcmp(toolname,'command'),

	% get the data
	model = get(findpush(gf,'Apply'),'UserData');
	mstart = 1;
	mend = length(model);
	pstart = mstart;
	pend = mend;

end;

if nargin ~= 2,
	error('armagen: Invalid number of input arguments.');
end;

% determine AR method
if get(findrdio(gf,'Correlation'),'Value'),
	ar_type = 1;
	arcmd = 'ar_corr';
elseif get(findrdio(gf,'Covariance'),'Value'),
	ar_type = 2;
	arcmd = 'ar_covar';
elseif get(findrdio(gf,'Mod Covar'),'Value'),
	ar_type = 3;
	arcmd = 'ar_mdcov';
elseif get(findrdio(gf,'Burg'),'Value'),
	ar_type = 4;
	arcmd = 'ar_burg';
end;

% determine MA method
if get(findrdio(gf,'Prony'),'Value'),
	ma_type = 5;
elseif get(findrdio(gf,'Shank'),'Value'),
	ma_type = 6;
elseif get(findrdio(gf,'Durbin'),'Value'),
	ma_type = 7;
end;

% get orders
order_p = getpopvl(gf,'AR Order');
order_q = getpopvl(gf,'MA Order');

% be verbose if requested
verbose = get(findchkb(gf,'Verbose'),'Value');
if verbose,
	disp(' ');
	disp('------------------------------------------');
end;


% generate coefficients
if get(findrdio(gf,'AR'),'Value'),

	if verbose, disp('AR Model'); end;
	mtype = 1;
	if ar_type == 1,
		[a,b,S] = ar_corr(model,order_p);
		if verbose, disp('AR Method - Autocorrelation'); end;
	elseif ar_type == 2,
		[a,b,S] = ar_covar(model,order_p);
		if verbose, disp('AR Method - Covariance'); end;
	elseif ar_type == 3,
		[a,b,S] = ar_mdcov(model,order_p);
		if verbose, disp('AR Method - Modified Covariance'); end;
	elseif ar_type == 4,
		[a,b,S,g] = ar_burg(model,order_p);
		if verbose, disp('AR Method - Burg Algorithm'); end;
	end;
elseif get(findrdio(gf,'MA'),'Value'),

	if verbose, disp('MA Model'); end;
	mtype = 2;
	if ma_type == 5,
		[a,b] = ar_prony(model,order_p,order_q,arcmd);
		if verbose, disp('MA Method - Prony Algorithm'); end;
	elseif ma_type == 6,
		[a,b] = ar_durbn(model,order_p,order_q,arcmd);
		if verbose, disp('MA Method - Shank Algorithm'); end;
	elseif ma_type == 7,
		[a,b] = ar_shank(model,order_p,order_q,arcmd);
		if verbose, disp('MA Method - Durbin Algorithm'); end;
	end;
	a = 1;
elseif get(findrdio(gf,'ARMA'),'Value'),

	if verbose, disp('ARMA Model'); end;
	if strcmp(arcmd,'ar_corr'),
		if verbose, disp('AR Method - Autocorrelation'); end;
	elseif strcmp(arcmd,'ar_covar'),
		if verbose, disp('AR Method - Covariance'); end;
	elseif strcmp(arcmd,'ar_mdcov'),
		if verbose, disp('AR Method - Modified Covariance'); end;
	else,
		if verbose, disp('AR Method - Burg Algorithm'); end;
	end;
	mtype = 3;
	if ma_type == 5,
		[a,b] = ar_prony(model,order_p,order_q,arcmd);
		if verbose, disp('MA Method - Prony Algorithm'); end;
	elseif ma_type == 6,
		[a,b] = ar_shank(model,order_p,order_q,arcmd);
		if verbose, disp('MA Method - Shank Algorithm'); end;
	elseif ma_type == 7,
		[a,b] = ar_durbn(model,order_p,order_q,arcmd);
		if verbose, disp('MA Method - Durbin Algorithm'); end;
	end;
end;

% compute roots of poles and zeros
r_z = roots(b);
r_p = roots(a);

if verbose,
	disp('------------------------------------------');

	if mtype == 1 | mtype == 3,
		disp('Poles');
		disp([r_p]);
		disp(' Magnitude  Angle(D)');
		disp([abs(r_p) (angle(r_p)*180/pi)]);
		disp(['Model coefficients (AR parameters)']);
		disp(a);
	end;

	if mtype == 2 | mtype == 3,
		disp('Zeros');
		disp([r_z]);
		disp(' Magnitude  Angle(D)');
		disp([abs(r_z) (angle(r_z)*180/pi)]);
		disp(['Model coefficients (MA parameters)']);
		disp(b);
	end;
end;

if strcmp(toolname,'2D'),

	% done enough
	modsig = 0;
	errsig = 0;

	set(gf,'Pointer','arrow','NextPlot','new');

	return;
end;

if strcmp(toolname,'command'),

	% done enough
	modsig = 0;
	errsig = 0;

	if (mend - mstart + 1) < (mend - (pend - pstart + 1)),

		% desired signal fits within model data
		desired = model((mstart:(mstart+pend-pstart)));
	else,

		% desired signal longer than model data
		desired = [model(mstart:length(model)) ; ...
			zeros((pend-pstart)-(length(model)-mstart),1)];
	end;

	% create model driving source
	if get(findrdio(gf,'Impulse'),'Value'),
		driver = [1;zeros(pend-pstart,1)];
	else,
		driver = randn(pend-pstart+1,1);
	end;

	% make zero polynomial minimum phase if desired
	if get(findchkb(gf,'Min Phase'),'Value'),
		b = minphase(b);
	end;

	modsig = filter(b,a,driver);

	errsig = desired - modsig;

	current = 1;

	% create model chain if desired
	if get(findchkb(gf,'Chain'),'Value'),
		m_length = length(modsig);
		c_length = getpopvl(gf,'chain');
		c_desired = zeros(c_length*m_length,1);
		c_model   = zeros(c_length*m_length,1);
		for k=1:c_length,
			c_desired((k-1)*m_length+1:k*m_length,1) = desired;
			c_model((k-1)*m_length+1:k*m_length,1) = modsig;
		end;
		desired = c_desired;
		modsig = c_model;
		errsig = desired - modsig;
	end;

	set(gf,'Pointer','arrow','NextPlot','new');

	return;
end;

fs = getpopvl(pf,'Sampling Freq');

% find out what the user wants plotted
do_desired = get(findchkb(pf,'Desired'),'Value');
do_model = get(findchkb(pf,'Model'),'Value');
do_error = get(findchkb(pf,'Error'),'Value');
overlay = get(findchkb(pf,'Overlay'),'Value');
pplot = get(findchkb(pf,'Polar'),'Value');
splot = get(findchkb(pf,'Spectrum'),'Value');

plots = do_desired + do_model + do_error + overlay;
anyplots = plots + pplot + splot;

if plots == 0 & pplot == 0 & splot == 0,
	return;
end;

h = findfig('Model Window');
if ~isempty(h),
	close(h);
end;

if plots > 0,

	s = get(0,'ScreenSize');
	if s(3) > 640,
		x_pos = .5;
		x_wid = .5;
	else
		x_pos = .1;
		x_wid = .9;
	end;

	if plots == 1, off = .25; else, off = 0; end;
	pos = [x_pos 1-plots*.25-off x_wid plots*.25+off];

	mf = figure('Units','normal','Position',pos,...
		'Name','Model Window');

	% following line is bug workaround for version 4.1 and below
	set(gcf,'BackingStore','off','BackingStore','on');
end;


if anyplots > 0,

	if mstart+(pend-pstart) < length(x),

		% desired signal fits within model data
		desired = x((mstart:(mstart+pend-pstart)));
	else,

		% desired signal longer than model data
		desired = [x(mstart:length(x)) ; ...
			zeros((pend-pstart)-(length(x)-mstart),1)];
	end;


	% create model driving source
	if get(findrdio(gf,'Impulse'),'Value'),
		driver = [1;zeros(pend-pstart,1)];
	else,
		driver = randn(pend-pstart+1,1);
	end;

	% make zero polynomial minimum phase if desired
	if get(findchkb(gf,'Min Phase'),'Value'),
		b = minphase(b);
	end;

	modsig = filter(b,a,driver);

	modsig = modsig(1:length(desired));

	errsig = desired(:) - modsig(:);

	ptscale = (0:length(desired)-1)/fs;
	current = 1;

	% create model chain if desired
	if get(findchkb(gf,'Chain'),'Value'),
		m_length = length(modsig);
		c_length = getpopvl(gf,'chain');

		% desired signal
		desired = model;

		% make user we model enough to compute the error, must do
		%   this for plots (desired and modsign same length).
		k = ceil(length(desired)/m_length);
		if k > c_length,
			kk = k;
		else,
			kk = c_length;
		end;

		% create model driving source
		if get(findrdio(gf,'Impulse'),'Value'),
			driver = zeros(m_length,kk);
			driver(1,:) = ones(1,kk);
			driver = driver(:);
		else,
			driver = randn(m_length*kk,1);
		end;

		modsig = filter(b,a,driver);
		modsig1 = modsig(1:length(desired));
		errsig = desired - modsig(1:length(desired));

		ptscale = (0:length(desired)-1)/fs;
	else,
		modsig1 = modsig;
	end;

end;    % if anyplots > 0


global SPC_DESIRED SPC_MODEL SPC_FONTNAME SPC_LINE
if overlay == 1,
	subplot(plots,1,current);
	global SPC_DESIRED SPC_MODEL;
	plot(ptscale,desired,SPC_DESIRED,ptscale,...
				modsig1,SPC_MODEL);
	set(gca,'FontName',SPC_FONTNAME);
	current = current+1;
	title('Desired/Modeled Signal');
	set(get(gca,'title'),'FontName',SPC_FONTNAME);
	xlabel('Time (sec)');
	set(get(gca,'xlabel'),'FontName',SPC_FONTNAME);
	ylabel('Magnitude');
	set(get(gca,'ylabel'),'FontName',SPC_FONTNAME);
end;

if do_desired == 1,
	subplot(plots,1,current);
	plot(ptscale,desired, SPC_LINE);
	set(gca,'FontName',SPC_FONTNAME);
	current = current+1;
	title('Desired Signal');
	set(get(gca,'title'),'FontName',SPC_FONTNAME);
	xlabel('Time (sec)');
	set(get(gca,'xlabel'),'FontName',SPC_FONTNAME);
	ylabel('Magnitude');
	set(get(gca,'ylabel'),'FontName',SPC_FONTNAME);
end;

if do_model == 1,
	subplot(plots,1,current);
	plot(ptscale,modsig,SPC_LINE);
	set(gca,'FontName',SPC_FONTNAME);
	title('Modeled Signal');
	set(get(gca,'title'),'FontName',SPC_FONTNAME);
	xlabel('Time (sec)');
	set(get(gca,'xlabel'),'FontName',SPC_FONTNAME);
	ylabel('Magnitude');
	set(get(gca,'ylabel'),'FontName',SPC_FONTNAME);
	current = current+1;
end;

if do_error == 1,
	subplot(plots,1,current);
	plot(ptscale,errsig,SPC_LINE);
	set(gca,'FontName',SPC_FONTNAME);
	title('Error Signal');
	set(get(gca,'title'),'FontName',SPC_FONTNAME);
	xlabel('Time (sec)');
	set(get(gca,'xlabel'),'FontName',SPC_FONTNAME);
	ylabel('Magnitude');
	set(get(gca,'ylabel'),'FontName',SPC_FONTNAME);
	current = current+1;
end;

h = findfig('Poles and Zeros');
if ~isempty(h),
	close(h);
end;

if pplot,

	s = get(0,'ScreenSize');
	if s(3) > 640,
		x_pos = 0;
		x_wid = .5;
	else
		x_pos = .0;
		x_wid = .9;
	end;

	pos = [x_pos 0 x_wid x_wid];    % square window

	figure('units','normal','position',pos,...
		'Name','Poles and Zeros');

	% following line is bug workaround for version 4.1 and below
	set(gcf,'BackingStore','off','BackingStore','on');

	global SPC_POLES SPC_ZEROS
	if max(abs(r_p)) > max(abs(r_z)),
		polar(angle(r_p),abs(r_p),[SPC_POLES 'x']); hold on;
		k=0:pi/32:2*pi;
		polar(k,ones(1,length(k)),'m');
		polar(angle(r_z),abs(r_z),[SPC_ZEROS 'o']); hold off;
	else,
		polar(angle(r_z),abs(r_z),[SPC_ZEROS 'o']); hold on;
		k=0:pi/32:2*pi;
		polar(k,ones(1,length(k)),'m');
		polar(angle(r_p),abs(r_p),[SPC_POLES 'x']); hold off;
	end;
	set(gca,'FontName',SPC_FONTNAME);
	title('Pole and Zero locations');
	set(get(gca,'title'),'FontName',SPC_FONTNAME);
end;

h = findfig('Spectral Estimate');
if ~isempty(h),
	close(h);
end;

if splot,

	s = get(0,'ScreenSize');
	if s(3) > 640,
		x_pos = .5;
		x_wid = .5;
	else
		x_pos = .1;
		x_wid = .9;
	end;

	pos = [x_pos 0 x_wid .5];

	figure('units','normal','position',pos,...
		'Name','Spectral Estimate');

	% following line is bug workaround for version 4.1 and below
	set(gcf,'BackingStore','off','BackingStore','on');

	N = 2^ceil(log2(length(desired)));
	X = abs(fft(desired,N));
	X = X(:);
	X = X(1:N/2);
	X(1) = X(2);	% don't plot DC

	N = 512;
	mdata = modsig;
	if length(mdata) < N,
		mdata = [mdata ; zeros(N-length(mdata),1)];
	end;

	est = abs(freqz(b,a,N/2));

	fscale = (0:N/2 - 1)/N*fs;
	fscale = fscale(:);
	h = plot((0:length(X)'-1)/length(X)*fs/2,20*log10(X),['y.']);
	set(gca,'FontName',SPC_FONTNAME);
	set(h,'MarkerSize',2);

	% set axes up to add transfer function to it
	set(gca,'NextPlot','add');
	global SPC_LINE SPC_TRANSFER;
	plot(fscale,20*log10(est),SPC_TRANSFER);
	set(gca,'FontName',SPC_FONTNAME);
	title('Power Spectral Density Estimate');
	set(get(gca,'title'),'FontName',SPC_FONTNAME);
	ylabel('Magnitude (dB)');
	set(get(gca,'ylabel'),'FontName',SPC_FONTNAME);
	xlabel('Frequency (Hz)');
	set(get(gca,'xlabel'),'FontName',SPC_FONTNAME);

	zoomtool(gca);

	% set axes up to add transfer function to it
	set(gca,'NextPlot','replace');
end;

figure(gf);
set(gf,'Pointer','arrow','NextPlot','new');

