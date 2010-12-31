function [h] = findfram(fig,value)
%FINDFRAM Find frame uicontrol.
%       [H]=FINDFRAM(FIGURE,'IDENTIFIER') finds the frame with
%       the String poperty equal to the string 'IDENTIFIER'.
%
%       See also IDAXES, FINDCHKB, FINDEDIT, FINDMENU, FINDPUSH,
%           FINDPOPU, FINDRDIO, FINDSLID, FINDUITX

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if str2num(version) >= 4.2,
	h = findobj(fig,'Style','frame','String',value);
else,

% output variables
h = [];

% find axes objects
c = get(fig,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'uicontrol'),
        if strcmp(get(c(i),'Style'),'frame'),
                if strcmp(get(c(i),'String'),value),
                    h = c(i);
                    return;
                end;
        end;
    end;
end;

end;

