function n = getedtxt(gf,label)
%GETEDTXT  Get text from edit box
%	GETEDTXT(H,'IDENTIFIER') or GETEDTXT(H,IDENTIFIER)
%	return the text contained in the edit box in the
%	figure pointed to by the handle H with the edit
%	box UserData set to IDENTIFIER.
%
%	See also GETEDNBR.

%       Dennis W. Brown 2-3-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% do it
n = get(findedit(gf,label),'String');
