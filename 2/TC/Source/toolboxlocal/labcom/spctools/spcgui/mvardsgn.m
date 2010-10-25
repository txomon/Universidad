function [gf] = mvardsgn(pf,signal,nfft,callstr)
%MVARDSGN Minumum variace spectrum algorithm designer.
%	MVARDSGN is a dialog box for specifying minumum variance
%	algorithm options and is called by the SPECT2D program.

%       Dennis W. Brown 4-3-95
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

if nargin ~= 1,

	action = 'start';
	pa = get(pf,'CurrentAxes');

else,
	action = pf;
end;

if strcmp(action,'apply'),

	% music figure
	mf = gcf;

	% close eigenvector window if open
	h = get(findpush(mf,'Eigen'),'UserData');
	if ~isempty(find(get(0,'Children') == h)),
		close(h);
	end;

	% parameters for music algorithm
	rxxsize = getednbr(mf,'rank');

	% determine Rxx method
	h = getradio(mf,'Rxx Matrix');
	method = get(h,'String');
	if strcmp(method,'Correlation'),
		method = 'rxxcorr';
	elseif strcmp(method,'Covariance'),
		method = 'rxxcovar';
	else
		method = 'rxxmdcov';
	end;

	% number points to calculate in xfer curve
	points = get(finduitx(mf,'Rxx Size'),'UserData');

	% the data
	signal = get(findpush(mf,'Apply'),'UserData');

	% call the algorithm
	[SPC_CURVE,a] = minvarsp(signal,rxxsize,points,method);

	% put in global workspace so calling app can find it
	global SPC_CURVE

	% save polynomial in 'Polynomial'
	set(finduitx(mf,'Polynomial'),'UserData',a);

elseif strcmp(action,'eigen'),

	% hold onto our figure handle
	mf = gcf;

	% rank of correlation matrix
	rxxsize = getednbr(mf,'rank');

	% determine Rxx method
	h = getradio(mf,'Rxx Matrix');
	method = get(h,'String');
	if strcmp(method,'Correlation'),
		method = 'rxxcorr';
	elseif strcmp(method,'Covariance'),
		method = 'rxxcovar';
	else
		method = 'rxxmdcov';
	end;

	% handle to last eigenvalue plot window
	h = get(findpush(mf,'Eigen'),'UserData');

	% close previous eigenvalue plot window if open
	if ~isempty(find(get(0,'Children') == h)),
		close(h);
	end;

	% new plot of eigenvalues
	signal = get(findpush(mf,'Apply'),'UserData');
	h = showeig(signal,rxxsize,method);

	% store away new eigenvalue figure handle
	set(findpush(mf,'Eigen'),'UserData',h);


else,

% -----------------------------------------------------------------------------
spcolors;
global SPC_WINDOW SPC_TEXT_FORE SPC_TEXT_BACK

% local constants
nbrcols = 3; nbrrows = 4;
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

% control group base rows
arb = 1;	% Corrlation matrix group;
rb = 3;		% rank
vb = 3;		% variables

gf = figure('Units','pixels','Position',pos,'color',SPC_WINDOW,...
        'Name','Min Variance Design Tool by D.W. Brown',...
        'NumberTitle','off','BackingStore','off',...
	'Resize','off','NextPlot','new','UserData',pf);

% following line is bug workaround for version 4.1 and below
set(gf,'BackingStore','off','BackingStore','on');

% turn off PC menu
if strcmp(computer,'PCWIN'),
	set(gf,'MenuBar','none');
end;

callbackstr = ['dog_h=get(gcf,''UserData''); close(gcf); figure(dog_h);'...
	'clear dog_h; ' callstr];

% ------------- CORRELATION MATRIX ESTIMATION METHODS ------------

items = str2mat('Correlation','Covariance','Mod Covar');
radiogrp(gf,'Rxx Matrix',items,1,[columns(1) rows(arb)],...
	[b_width b_hite b_frame b_int],'Units','pixels');


% ---------------------- Rank -------------------------------

hh = uicontrol(gf,'Style','frame',...
	'Units','pixels',...
	'Position',[columns(2)-b_frame rows(rb)-b_frame ...
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

% print rank label
uicontrol(gf,'Style','text',...
	'Units','pixels',...
	'Horiz','center',...
	'Position',[columns(2) rows(rb+1) b_width b_hite],...
	'String','Rxx Size','UserData',nfft);

% draw rank edit box
uicontrol(gf,'Style','edit',...
	'Units','pixels',...
	'Horiz','center',...
	'Position',[columns(2) rows(rb) b_width b_hite],...
	'String','5',...
	'UserData','rank',...
	'Back',beditcolor);

% ---------------------- save -------------------------------

uicontrol(gf,'Style','frame',...
	'Units','pixels',...
	'Position',[columns(3)-b_frame rows(vb)-b_frame ...
		b_width+2*b_frame 2*b_hite+1*b_int+2*b_frame]);

% print variable labels
uicontrol(gf,'Style','text',...
	'Units','pixels',...
	'Horiz','center',...
	'Position',[columns(3) rows(vb+1) b_width b_hite],...
	'String','Polynomial');

%  variable names
uicontrol(gf,'Style','edit',...
	'Units','pixels',...
	'Horiz','center',...
	'Position',[columns(3) rows(vb) b_width b_hite],...
	'UserData','coef',...
	'Back',beditcolor);

% save varibles if names present callback
savecall = [...
	'dog_name = get(findedit(gcf,''coef''),''String'');'...
	'dog_a = get(finduitx(gcf,''Polynomial''),''UserData'');'...
	'if ~isempty(dog_name),'...
		'eval([dog_name '' = dog_a;'']);'...
	'end;'...
	'clear dog_name dog_a;'...
];

% ---------------------- apply -------------------------------

uicontrol(gf,'Style','push',...
	'String','Apply',...
	'UserData',pf,...	% parent window (SPECT2D)
	'UserData',signal,...
	'Position',[columns(3) rows(1) b_width b_hite],...
	'CallBack',['mvardsgn(''apply'');' savecall callbackstr]);

% ---------------------- eigenvalues -------------------------------

uicontrol(gf,'Style','push',...
	'String','Eigen',...
	'UserData',0,...	% handle of eigenvalue figure
	'Position',...
		[columns(2) rows(1) b_width b_hite],...
	'CallBack','mvardsgn(''eigen'');');



end;
