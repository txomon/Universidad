function popupnbrs(gf,pos,nbrs,label,prop1,val1,prop2,val2,prop3,val3,...
		prop4,val4,prop5,val5,prop6,val6,prop7,val7,prop8,val8,...
		prop9,val9,prop10,val10,prop11,val11);
%POPUNBRS Labeled number popupmenu.
%       POPUNBRS(H,POS,NUMBERS,LABEL) creates a popu menu in the figure
%       specified with the handle H at the location specified
%       by the four element vector POS ([xmin ymin width height]).
%       The popup menu is labled with the values stored in
%       the vector NUMBERS.  The string 'LABEL' is display above
%       the popup menu using a uicontrol text object the same size
%       as the popupmenu.
%
%	CallBack		<str>
%	Range			[min max]
%	Integer			'on' | off
%	PowerOfTwo		on | 'off'
%	Label			'on' | off
%	LabelLocation		'top' | bottom | left | right
%	LabelJustify		'center' | left | right
%	LabelPosition		[left, bottom, width, height]
%	Units			pixels | 'normal' | inches | ...
%					centimeters | points
%	ForeGroundColor		colorspec
%	BackGroundColor		colorspec

%       Dennis W. Brown 5-17-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% must have an even number of args to set props
if rem(nargin,2),
    error('popunbrs: Invalid property pairs.');
end;

% default properties
global SPC_TEXT_FORE SPC_TEXT_BACK
fcolor = SPC_TEXT_FORE;
bcolor = SPC_TEXT_BACK;
callback = '';
% range values
%    range(1) - minimum
%    range(2) - maximum
%    range(3) - integer = 1, real = 0
%    range(4) - poweroftwo = 1, any = 0
range = [-Inf Inf 1 0];
tpos = pos;
tpos(2) = pos(2) + pos(4);
ljustify = 'center';
units = 'normal';
labelon = 'on';

% must have first four args
if nargin < 4,
    error('popunbrs: Must call with first four arguments.');
elseif nargin > 4,
    for i = 1:(nargin-4)/2,
        prop = eval(['prop' int2str(i)]);
        val = eval(['val' int2str(i)]);
        if strcmp(lower(prop),'callback'),
            callback = val;
        elseif strcmp(lower(prop),'range'),
            if max(size(val)) == 2,
                range(1) = val(1);
                range(2) = val(2);
            else
                error('popunbrs: Invalid range specified.');
            end;
        elseif strcmp(lower(prop),'integer'),
            if strcmp(lower(val),'off'),
                range(3) = 0;
            elseif strcmp(lower(val),'on'),
                range(3) = 1;
            else,
                error('popunbrs: Invalid Integer property.');
            end;
        elseif strcmp(lower(prop),'poweroftwo'),
            if strcmp(lower(val),'off'),
                range(4) = 0;
            elseif strcmp(lower(val),'on'),
                range(4) = 1;
            else,
                error('popunbrs: Invalid PowerOfTwo property.');
            end;
        elseif strcmp(lower(prop),'label'),
            if strcmp(lower(val),'off'),
                labelon = 'off';
            elseif strcmp(lower(val),'on'),
                labelon = 'on';
            else,
                error('popunbrs: Invalid Label property.');
            end;
        elseif strcmp(lower(prop),'labelposition'),
		tpos = val;
        elseif strcmp(lower(prop),'units'),
		units = val;
        elseif strcmp(lower(prop),'labellocation'),
            if strcmp(lower(val),'above'),
                tpos(2) = pos(2) + pos(4);
            elseif strcmp(lower(val),'below'),
                tpos(2) = pos(2) - pos(4);
            elseif strcmp(lower(val),'left'),
                tpos = pos;
                tpos(1) = pos(1) - pos(3) + 0.1 * pos(3);
                tpos(3) = 0.8 * pos(3);
            elseif strcmp(lower(val),'right'),
                tpos = pos;
                tpos(1) = pos(1) + pos(3) + 0.1 * pos(3);
                tpos(3) = 0.8 * pos(3);
            else,
                error('popunbrs: Invalid LabelLocation property.');
            end;
        elseif strcmp(lower(prop),'labeljustify'),
            if strcmp(lower(val),'center'),
                ljustify = 'center';
            elseif strcmp(lower(val),'left'),
                ljustify = 'left';
            elseif strcmp(lower(val),'right'),
                ljustify = 'right';
            else,
                error('popunbrs: Invalid LabelJustify property.');
            end;
        elseif strcmp(lower(prop),'backgroundcolor'),
		bcolor = val;
        elseif strcmp(lower(prop),'foregroundcolor'),
		fcolor = val;
        else
            error('popunbrs: Invalid property specified.');
        end;
    end;
end;


% print label
uicontrol(gf,'Style','text','Units',units,'Horiz',ljustify,...
        'Foreground',fcolor,'Background',bcolor,...
        'Position',tpos,'String',label,...
        'UserData',range,'CallBack',callback,...
        'Visible',labelon);
% note the callback function was storee here so we can get to it
%   at the time we want to actually use it (got to keep it somewhere)



% make popup string
popstr = [];
for i = 1:length(nbrs)
	if range(3),
    		popstr = [popstr int2str(nbrs(i)) '|'];
	else
		popstr = [popstr num2str(nbrs(i)) '|'];
	end;
end;
popstr = [popstr 'User'];

if strcmp(computer,'PCWIN'),

	% draw popupmenu
	h = uicontrol(gf,...
		'Style','popupmenu',...
		'Units',units,...
		'Horiz','center',...
		'Position',pos,...
		'BackGroundColor',[1 1 1] * 0.7,...
		'String',popstr,...
		'UserData',label,...
		'CallBack',['callnbrs(gcf,1);']);
else,
	% draw popupmenu
	h = uicontrol(gf,...
		'Style','popupmenu',...
		'Units',units,...
		'Horiz','center',...
		'Position',pos,...
		'String',popstr,...
		'UserData',label,...
		'CallBack',['callnbrs(gcf,1);']);
end;

set(h,'Value',1);
pophite(h);


% draw user edit box
h = uicontrol(gf,...
    'Style','edit',...
    'Units',units,...
    'Horiz','center',...
    'Position',pos,...
    'String','',...
    'UserData',label,...
    'Visible','off',...
    'CallBack',['callnbrs(gcf,2);']...
    );

if strcmp(computer,'PCWIN'),
	set(h,'BackGroundColor',[1 1 1] * 0.7);
end;

