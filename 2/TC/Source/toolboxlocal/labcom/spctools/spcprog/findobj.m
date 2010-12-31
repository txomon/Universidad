function h = findobj(arg1,prop1,val1,prop2,val2)
%FINDOBJ        Find objects with specified property values.
%       H = FINDOBJ(ObjectHandles, 'P1Name', P1Value,...) restricts
%       the search to the objects listed in ObjectHandles and their
%       descendents.
%

h = [];

for k = 1:length(arg1),

	val = get(arg1(k),prop1);

	if ~isstr(val1),
		if val == val1,
			h = [h arg1(k)];
		end;
	else,
		if strcmp(val,val1),
			h = [h arg1(k)];
		end;
	end;

end;

