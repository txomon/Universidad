function [h] = findfig(name,value)
%FINDFIG Find figure window.
%       [H]=FINDFIG('NAME') finds the figure window with
%       the title equal to the string 'NAME'. 'NAME' refers
%       to the text displayed on the window title bar as defined
%       by the Name property of the figure. Both 'NAME' and the
%       String property must be exact matches.
%
%       [H]=FINDFIG('NAME',IDENTIFIER) find the figure window
%       with title 'NAME' and with the Userdata property equal to
%       IDENTIFIER. IDENTIFIER can be a string or a scalar number.
%
%       See also FINDAXES, FINDCHKB, FINDEDIT, FINDMENU, FINDPOPU,
%           FINDRDIO, FINDSLID, FINDUITX

%       Dennis W. Brown 1-18-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if str2num(version) >= 4.2,
	if nargin == 1,
		h = findobj(0,'Type','figure','Name',name);
	else,
		h = findobj(0,'Type','figure','Name',name,'UserData',value);
	end;
else,

if nargin ~= 2,
    value = [];
end;

% output variables
h = [];

% find axes objects
c = get(0,'Children');
for i = 1:length(c),
    if strcmp(get(c(i),'Type'),'figure'),
        if strcmp(get(c(i),'Name'),name),
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

