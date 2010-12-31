function [h] = findline(ax,value)
%FINDLINE Find axes line object.
%       H=FINDLINE(AXES,'IDENTIFIER') finds the AXES line object
%       with the UserData property equal to string 'IDENTIFIER'.
%
%       H=FINDLINE(AXES,IDENTIFIER) finds the AXES line object
%       with the UserData property equal to scaler number
%       IDENTIFIER.
%
%       See also IDAXES, FINDCHKB, FINDEDIT, FINDMENU, FINDPUSH,
%           FINDPOPU, FINDRDIO, FINDSLID, FINDUITX

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if str2num(version) >= 4.2,
	h = findobj(ax,'Type','line','UserData',value);
else,

% output variables
h = [];

% find axes objects
c = get(ax,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'line'),
        if isstr(value),
            if strcmp(get(c(i),'Userdata'),value),
                h = c(i);
                return;
            end;
        else,
            if get(c(i),'Userdata') == value,
                h = c(i);
                return;
            end;
        end;
    end;
end;

end;

