function [h] = findtext(ax,string,value)
%FINDTEXT Find axes text object.
%       [H]=FINDTEXT(AXES,'TEXT') finds the text object
%       with 'TEXT' in the axes specified with the
%       handle AXES.
%
%       The above uses the String property.  Both 'TEXT' and
%       the String property must be exact matches.
%
%       [H]=FINDTEXT(AXES,'TEXT',IDENTIFIER) find the text
%       object with 'TEXT' and the Userdata property equal to
%       IDENTIFIER.  This use is convenient when an axes contains
%       two or more text objects with the same text.
%
%       See also FINDAXES, FINDCHKB, FINDEDIT, FINDMENU, FINDPOPU,
%           FINDPUSH, FINDRDIO, FINDSLID, FINDUITX

%       Dennis W. Brown 1-10-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if str2num(version) >= 4.2,
	if nargin == 2,
		h = findobj(ax,'Type','text','String',text);
	else,
		h = findobj(ax,'Type','text','String',text,'UserData',value);
	end;
else,

% defaults
if nargin ~= 3,
    value = [];
end;

% output variables
h = [];

% find axes objects
c = get(ax,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'text'),
            if strcmp(get(c(i),'String'),string),
                if isempty(value),
                    h = c(i);
                    return;
                else,
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

end;

