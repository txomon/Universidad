function spctitle(ga,label)
%SPCTITLE Axis title for SPC Tools.
%	SPCTITLE(H,'STRING') titles the axis pointed to
%	by the handle H with the STRING.
%
%	See also SPCYLABL, SPCXLABL

%       Dennis W. Brown 2-3-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% do it
global SPC_FONTNAME SPC_TEXT_FORE
set(get(ga,'title'),'String',label,'FontName',SPC_FONTNAME,...
	'Color',SPC_TEXT_FORE,'Visible','on');
