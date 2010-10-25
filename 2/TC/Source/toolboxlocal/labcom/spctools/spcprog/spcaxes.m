function spcaxes(ga)
%SPCAXES Setup axes for SPC Tools.
%	SPCAXES(H,'STRING') setups the axis pointed to
%	by the handle H.
%
%	See also SPCTITLE, SPCXLABL, SPCYLABL

%       Dennis W. Brown 2-3-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% do it
global SPC_AXIS SPC_FONTNAME SPC_TEXT_FORE SPC_COLOR_ORDER
set(ga,'Color',SPC_AXIS,'FontName',SPC_FONTNAME,...
	'XColor',SPC_TEXT_FORE,'YColor',SPC_TEXT_FORE,...
	'Visible','on','Box','on','ColorOrder',SPC_COLOR_ORDER);
