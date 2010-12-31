function [h] = findaxes(fig,value)
%FINDAXES Find axes object.
%       [H]=FINDAXES(FIGURE,'IDENTIFIER') find the axes graphic
%       object with the axes identifier string equal to
%       'IDENTIFIER'.
%
%       [H]=FINDAXES(FIGURE,IDENTIFIER) find the axes graphic
%       object with the axes identifier number equal to
%       IDENTIFIER.
%
%       The Userdata property of the axis title is used to
%       store the identifier.
%
%       See also IDAXES, FINDCHKB, FINDEDIT, FINDMENU, FINDPUSH,
%           FINDPOPU, FINDRDIO, FINDSLID, FINDUITX

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if str2num(version) >= 4.2,
	h = findobj(fig,'Type','axes','UserData',value);
else,

% output variables
h = [];

% find axes objects
c = get(fig,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'axes'),
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

