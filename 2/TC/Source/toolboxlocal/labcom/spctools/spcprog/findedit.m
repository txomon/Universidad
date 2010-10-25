function [h] = findedit(fig,value)
%FINDEDIT Find edit uicontrol.
%       [H]=FINDEDIT(FIGURE,'IDENTIFIER') finds the edit
%       uicontrol with the Userdata property equal to
%       'IDENTIFIER'. Both 'IDENTIFIER' and the Userdata
%       property must be strings.
%
%       [H]=FINDEDIT(FIGURE,IDENTIFIER) finds the edit
%       uicontrol with UserData property equal to IDENTIFIER.
%       Both IDENTIFIER and the UserData property must be scalar
%       numbers.
%
%       See also FINDAXES, FINDCHKB, FINDMENU, FINDPOPU, FINDPUSH,
%           FINDRDIO, FINDSLID, FINDUITX

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if str2num(version) >= 4.2,
	h = findobj(fig,'Style','edit','UserData',value);
else,

% output variables
h = [];

% find axes objects
c = get(fig,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'uicontrol'),
        if strcmp(get(c(i),'Style'),'edit'),
            if isstr(value),
                if strcmp(get(c(i),'Userdata'),value),
                    h = c(i);
                    return;
                end;
            else,
                if get(c(i),'UserData') == value,
                    h = c(i);
                    return;
                    end;
            end;
        end;
    end;
end;

end;

