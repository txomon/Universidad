function n = getednbr(gf,label)
%GETEDNBR  Get number from edit box
%	GETEDNBR(H,'IDENTIFIER') or GETEDNBR(H,IDENTIFIER)
%	return the number contained in the edit box in the
%	figure pointed to by the handle H with the edit
%	box UserData set to IDENTIFIER.
%
%	See also GETEDTXT.

%       Dennis W. Brown 2-3-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% do it
n = str2num(get(findedit(gf,label),'String'));
