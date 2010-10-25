function h = getradio(gf,label,groupnbr)
%GETRADIO Get pushed radio button.
%	H = GETRADIO(FIGURE,LABEL) returns the handle of the
%	selected button in a radio button group LABEL in the figure
%	window specified with the handle FIGURE.
%
%	See also TOGRADIO, RADIOGRP

%       Dennis W. Brown 5-30-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% uimenu selected
h = findobj(get(findfram(gf,label),'UserData'),'Value',1);


