%SIGDESAV	Save current vector in SIGDEMOD.
%	SIGDESAV saves the current demodulated signal.
%	The user is prompted for the workspace
%	variable name by REQSTR.
%
%	See also SIGDEMOD, DIGDECAL, SIGDEMLD

%	Dennis W. Brown 4-4-94, DWB 4-4-94
%	Copyright (c) 1994 by Dennis W. Brown
%	May be freely distributed.
%	Not for use in commercial products.

% the workmenu "Save" uimenu calls this function after first
%	calling REQSTR to get the name to save the vector under.
%	REQSTR creates a uicontrol text object called 'Answer'
%	and stores the entered variable name in its UserData
%	property.
dog_name = get(finduitx(gcf,'Answer'),'UserData');

% get the signal
dog_y = get(findmenu(gcf,'Apply'),'UserData');

% save to workspace
eval([dog_name '= dog_y;']);

% clean up after ourselves
clear dog_name dog_y


