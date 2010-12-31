function ok = ednbrchk(hedit,prop1,val1,prop2,val2,prop3,val3,...
		prop4,val4,prop5,val5,prop6,val6,prop7,val7,prop8,val8,...
		prop9,val9,prop10,val10,prop11,val11);
%EDNBRCHK Edit box number check.
%	[N] = EDNBRCHK(H,RANGE,DEFAULT,'CALLBACK') retrieves
%	the String property from the edit box pointed to by
%	the handle, converts it to a number and checks 
%	the resulting value according to the range arguments.
%	If the range criteria is not met, the default value
%	is entered and a warning messages is displayed. 
%
%	Variable		<str>
%	CallBack		<str>
%	Range			[min max]
%	Integer			'on' | off
%	PowerOfTwo		on | 'off'
%	Default			<val>
%
%	See also POPUNBRS

% error check
if ~strcmp(get(hedit,'Style'),'edit'),
	error('ednbrchk: Handle must point to an edit box.');
end;

% get parent figure
gf = get(hedit,'Parent');

% default property values
range = [-Inf Inf];
poweroftwo = 'off';
integer = 'off';
variable = 'edit box';
ok = 1;
callbackstr = '';
default = [];

% must have first arg
if nargin < 1,
	error('ednbrchk: Must call with first four arguments.');
elseif nargin > 1,
    for i = 1:(nargin-1)/2,
	prop = eval(['prop' int2str(i)]);
	val = eval(['val' int2str(i)]);
	if strcmp(lower(prop),'callback'),
		callback = val;
	elseif strcmp(lower(prop),'variable'),
		variable = val;
	elseif strcmp(lower(prop),'range'),
		if max(size(val)) == 2,
			range(1) = val(1);
			range(2) = val(2);
			if isempty(default); default = range(1); end;
		else
			error('ednbrchk: Invalid range specified.');
		end;
	elseif strcmp(lower(prop),'poweroftwo'),
		if strcmp(lower(val),'off'),
			poweroftwo = 'off';
		elseif strcmp(lower(val),'on'),
			poweroftwo = 'on';
		else,
			error('ednbrchk: Invalid PowerOfTwo property.');
		end;
        elseif strcmp(lower(prop),'integer'),
		if strcmp(lower(val),'off'),
			integer = 'off';
		elseif strcmp(lower(val),'on'),
			integer = 'on';
		else,
			error('ednbrchk: Invalid Integer property.');
		end;
	elseif strcmp(lower(prop),'default'),
		if ~isstr(val),
			default = val;
		else
			error('ednbrchk: Invalid default number');
		end;
        else
            error(['ednbrchk: Invalid property ' prop ' specified.']);
        end;
    end;
end;

% just in case it ain't set
if isempty(default),
	default = 0;
end;

% get Value from edit box
newnbr = str2num(get(hedit,'String'));
msg = [];

% error message fragment
errfrag = [' required for "' variable '"!'];

if isempty(newnbr) | isstr(newnbr),

	msg = 'Numeric value';
	newnbr = default;
	ok = 0;

elseif newnbr < range(1) | newnbr > range(2),

	msg = ['Range (' num2str(range(1)) ',' ...
			num2str(range(2)) ').'];
	newnbr = default;
	ok = 0;
end;
	
% clip for integer
if strcmp(integer,'on'),

%	if rem(newnbr,1),
%		msg = 'Integer value';
%	end;

	newnbr = fix(newnbr);
end;

% power of two
if strcmp(poweroftwo,'on'),

%	if rem(log2(newnbr),1),
%		msg = ['Power of 2'];
%	end;

	if newnbr > 0,
		newnbr = 2^ceil(log2(newnbr));
	end;
end;		
			

if ~isempty(msg),

	% change background to red
	oldb = get(hedit,'BackGroundColor');
	set(hedit,'BackGroundColor','red');


	% at this point, we gotta get tricky cause the screwy
	% way matlab does not let you make modal dialog boxes.
	% if the warning figure window opens below, we got to
	% return focus to the figure containing the edit box.
	% however, we can't do that until after the user ack's
	% the warning box because a figure(gf) will cover the
	% warning dialog, bottom line, it's a pain in the ass
	spcwarn(msg,'OK');

	% change background
	set(hedit,'BackGroundColor',oldb);
end;

% ensure proper string is displayed
set(hedit,'String',num2str(newnbr));

if ok,
	% ensure focus is on original window
	figure(gf);

	eval(callbackstr);
end;
