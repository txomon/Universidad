function [hh,rh] = radiogrp(gf,label,items,pushed,llcorner,button,prop1,val1,...
		prop2,val2,prop3,val3,prop4,val4,prop5,val5,...
		prop6,val6,prop7,val7,prop8,val8,prop9,val9,...
		prop10,val10,prop11,val11);
%RADIOGRP Create radio button group.
%	h = RADIOGRP(FIGURE,'LABEL','ITEMS',PUSHED,LLCORNER,BUTTON,...
%	'PROPERTY','PROPERTYVALUE,...) creates a radio group named
%	'LABEL' containing buttons named 'ITEMS' in the figure
%	specified by the handle FIGURE.  PUSHED is the number of the
%	radio button to push.  LLCORNER is a two element vector
%	[left bottom] specifying the lower left corner of the frame
%	surrounding the radio group.  BUTTON is a four-element vector
%	[width height frame interval] specifying the button size.

%	CallBack		<str>
%	Units			pixels | 'normal' | inches | ...
%					centimeters | points
%	ForeGroundColor		colorspec
%	BackGroundColor		colorspec

%       Dennis W. Brown 5-26-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% if one already there, don't overwrite
h = findfram(gf,label);
if ~isempty(h),

	% create the base menu
	error(['radiogrp: Frame group "' label '" already exists.']);

end;


% default properties
fcolor = 'black';
bcolor = 'gray';
callback = '';
units = 'normal';
b_width = button(1);
b_hite = button(2);
b_frame = button(3);
b_int = button(4);

% must have first four args
if nargin < 6,
    error('popunbrs: Must call with first four arguments.');
elseif nargin > 6,
    for i = 1:(nargin-6)/2,
        prop = eval(['prop' int2str(i)]);
        val = eval(['val' int2str(i)]);
        if strcmp(lower(prop),'callback'),
            callback = val;
        elseif strcmp(lower(prop),'units'),
		units = val;
        elseif strcmp(lower(prop),'backgroundcolor'),
		bcolor = val;
        elseif strcmp(lower(prop),'foregroundcolor'),
		fcolor = val;
        else
            error('popunbrs: Invalid property specified.');
        end;
    end;
end;


[m,n] = size(items);		% m = number of button
handles = zeros(m,1);

% frame around group
h = uicontrol(gf,...
	'Style','frame',...
	'String',label,...
	'Units',units,...
	'Position',[llcorner(1)-b_frame llcorner(2)-b_frame ...
		b_width+2*b_frame (m+1)*b_hite+2*b_frame+m*b_int]);

% print label
uicontrol(gf,...
	'Style','text',...
	'Units',units,...
	'Horiz','center',...
	'Foreground',fcolor,...
	'Position',[llcorner(1) llcorner(2)+m*b_hite+(m-1)*b_int ...
    	b_width b_hite],...
	'String',label);

% do from bottom up
items = flipud(items);

if strcmp(computer,'PCWIN'),
	kolor = [1 1 1] * 0.7;
else,
	kolor = get(h,'BackgroundColor');
end;

% draw radio buttons
for k = 1:m,

	handles(k) = uicontrol(gf,...
		'Style','radiobutton',...
		'Units',units,...
		'Foreground',fcolor,...
		'BackGround',kolor,...
		'Horiz','center',...
		'Position',[llcorner(1) llcorner(2)+(k-1)*(b_hite+b_int) ...
			b_width b_hite],...
		'String',deblank(items(k,:)),...
		'Value',0,...
		'UserData',h,...
		'CallBack',['togradio;' callback]);

end;

% store handles in frame
set(h,'UserData',handles);

% push radio button
set(handles(m-pushed+1),'Value',1);

if nargout == 1,
	hh = h;
elseif nargout == 2,
	hh = h;
	rh = handles;
end;
