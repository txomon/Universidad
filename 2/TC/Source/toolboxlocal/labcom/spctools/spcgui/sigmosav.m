%SIGMOSAV	Save current vector in SIGMODEL.
%	SIGMOSAV saves the current 'zoomed' line in the
%	'zoomtool' axis of the current figure to the Matlab
%	workspace.  The user is prompted for the workspace
%	variable name by REQSTR.
%
%	See also SIGMODEL, SIGMOCAL, SIGMOLD

%	Dennis W. Brown 2-5-94, DWB 2-21-94
%	Copyright (c) 1994 by Dennis W. Brown
%	May be freely distributed.
%	Not for use in commercial products.

% the workmenu "Save" uimenu calls this function after first
%	calling REQSTR to get the name to save the vector under.
%	REQSTR creates a uicontrol text object called 'Answer'
%	and stores the entered variable name in its UserData
%	property.
dog_name = get(finduitx(gcf,'Answer'),'UserData');

% get the zoomed line from zoomtool
dog_y = get(zoomed(gcf),'YData');

% save to workspace
eval([dog_name '= dog_y;']);

% clean up after ourselves
clear dog_name dog_y


