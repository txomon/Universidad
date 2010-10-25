function xpilabel(h,label)
%XPILABEL Label X-axis in units of PI.
%	XPILABEL changes the X-axis tick marks to multiples or 
%	fractions of PI and labels tick marks accordingly in the 
%	form "3pi" or "3pi/2" where pi is the Greek letter.
%	
%	XPILABEL(H) changes the X-axis tick marks in the axes 
%	pointed to by the axes handle H.
%	
%	XPILABEL('TEXT') and XPILABEL(H,'TEXT') also labels the 
%	X-axis with 'TEXT' and can be used in place of the XLABEL 
%	command.
%	
%	Because the axis label text and title text use the same 
%	font used in the axes object, the YLABEL, XLABEL, or TITLE 
%	commands must be executed before XPILABEL and YPILABEL to 
%	avoid the axis labels or title from using the Symbol font. 
%	These functions change the axes font to the Symbol font in 
%	order display the Greek pi character.
%	
%	See also YPILABEL

%       Dennis W. Brown 5-24-94, DWB 5-3-95
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if nargin < 1,
	h = gca;
	label = [];
elseif nargin == 1,
	if isstr(h),
		label = h;
		h = gca;
	else,
		label = [];
	end;
elseif nargin > 2,
	error('xpilabel: Invalid number of input arguments.');
end;

% get current ticks and limits
cticks = get(h,'XTick');
cxlim = get(h,'XLim');

% number of labels already there
cnbr = length(cticks);

% interval between their ticks
cint = abs(cticks(2) - cticks(1));

% decide lower and upper tick
lower = pi*(floor(cxlim(1)/pi));
upper = pi*(ceil(cxlim(2)/pi));

% pick interval on pi close to current
int = fix(cint/pi)*pi;
k = 1;


% if less than pi, make smaller
if int < pi,
	k = 2^ceil(log2(pi/cint));
	int = pi/k;
	lower = pi/k*(floor(k*cxlim(1)/pi));
	upper = pi/k*(ceil(k*cxlim(2)/pi));
end;

% decide how many to put in their place
nbr = fix(abs((upper-lower))/int);


% generate tick marks
ticks = lower:int:upper;

% generate labels
bigstr = [];
labels = [];
all = [];
for i = 1:length(ticks);
	if ~isempty(bigstr), bigstr = [bigstr ',']; end;
	temp = round(ticks(i)/int);
	if k == 1,
		if temp == 0,
			str = '0';
		elseif temp == 1,
			str = 'p';
		elseif temp == -1,
			str = '-p';
		else
			str = [int2str(temp) 'p'];
		end;
	else,
		if temp == 0,
			str = '0';
		else,
			temp2 = rem(temp,k);
			if temp2,
				g = gcd(temp,k);
				kstr = int2str(fix(k/g));
				temp = fix(temp/g);
				if abs(temp) ~= 1,
					str = [int2str(temp) 'p/' kstr];
				elseif temp == 1,
					str = ['p/' kstr];
				else,
					str = ['-p/' kstr];
				end;
			else,
				g = gcd(temp,k);
				kstr = int2str(fix(k/g));
				temp = fix(temp/g);
				if abs(temp) ~= 1,
					str = [int2str(temp) 'p'];
				elseif temp == 1,
					str = 'p';
				else,
					str = '-p';
				end;
			end;
		end;
	end;
	bigstr = [bigstr ' ''' str ''' '];

	if ~rem(i,9),
		eval(['tstr = str2mat(' bigstr ');']);
		if ~isempty(labels),
			labels = str2mat(labels,tstr);
		else,
			labels = tstr;
		end;
		bigstr = [];
	end;
end;
if ~isempty(bigstr),
	eval(['tstr = str2mat(' bigstr ');']);
	if ~isempty(labels),
		labels = str2mat(labels,tstr);
	else,
		labels = tstr;
	end;
end;

% set in axis
set(h,'XLim',[lower upper]);

set(h,'XTick',ticks','XTickLabels',labels);

% set fonts
old = get(get(h,'xlabel'),'FontName');
set(h,'Fontname','symbol');
if ~isempty(label),
	set(get(h,'xlabel'),'String',label,'FontName',old,'Visible','on');
end;

