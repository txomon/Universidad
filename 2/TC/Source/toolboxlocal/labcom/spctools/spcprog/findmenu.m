function [h] = findmenu(fig,menu,submenu1,submenu2,submenu3)
%FINDMENU Find uimenu uicontrol.
%       [H]=FINDMENU(FIGURE,'MENU','SUBMENU','SUBMENU','SUBMENU')
%	finds the uimenu with the Label property chain equal to the
%       chained combination of 'MENU' and up to two 'SUBMENU'.
%
%       See also FINDAXES, FINDCHKB, FINDEDIT, FINDPOPU, FINDPUSH,
%           FINDRDIO, FINDSLID, FINDUITX, IDAXES

%       Dennis W. Brown 1-10-94, DWB 5-30-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if str2num(version) >= 4.2,
	h = findobj(fig,'Label',menu,'Parent',fig);
	if nargin >= 3,
		h = findobj(get(h,'Children'),'Label',submenu1,'Parent',h);
	end;
	if nargin >= 4,
		h = findobj(get(h,'Children'),'Label',submenu2,'Parent',h);
	end;
	if nargin >= 5,
		h = findobj(get(h,'Children'),'Label',submenu3,'Parent',h);
	end;
else,

% check arg count
if nargin == 2,
	submenu1 = [];
	submenu2 = [];
	submenu3 = [];
elseif nargin == 3,
	submenu2 = [];
	submenu3 = [];
elseif nargin == 4,
	submenu3 = [];
end;

% output variables
h = [];

% find axes objects
c = get(fig,'Children');
for i = 1:length(c),
 if strcmp(get(c(i),'Type'),'uimenu'),
  if strcmp(get(c(i),'Label'),menu),
   if ~isempty(submenu1),
    d = get(c(i),'Children');
    for j = 1:length(d),
     if strcmp(get(d(j),'Label'),submenu1),
      if ~isempty(submenu2),
       e = get(d(j),'Children');
       for k = 1:length(e),
        if strcmp(get(e(k),'Label'),submenu2),
         if ~isempty(submenu3),
          f = get(d(j),'Children');
          for m = 1:length(f),
           if strcmp(get(f(m),'Label'),submenu3),
            h = f(m);
            return;
           end;
          end;
         else,
          h = e(k);
          return;
         end;
        end;
       end;
      else,
      h = d(j);
      return;
      end;
     end;
    end;
   else,
    h = c(i);
    return;
   end;
  end;
 end;
end;

end;

