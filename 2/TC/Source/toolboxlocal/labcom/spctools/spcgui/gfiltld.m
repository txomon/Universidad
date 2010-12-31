%GFILTLD  Load button callback function for GFILTERD.

%       Dennis W. Brown 6-6-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% get variable names
dog_name_a = get(findedit(gcf,'a var'),'String');
dog_name_b = get(findedit(gcf,'b var'),'String');

% are they good names
if ~isempty(dog_name_a) & ~isempty(dog_name_b),

	if isstr(dog_name_a) & isstr(dog_name_b),

		% do the variables exist?
		if ~exist(dog_name_a) == 1,
			spcwarn(['gfilterd: Variable ' dog_name_a ...
				' non-existent!'],'OK');
		elseif ~exist(dog_name_b) == 1,
			spcwarn(['gfilterd: Variable ' dog_name_b ...
				' non-existent!'],'OK');
		else,
			% they do exist!

			% get values from workspace
			eval(['dog_a = ' dog_name_a ';']);
			eval(['dog_b = ' dog_name_b ';']);

			% find the poly orders
			dog_al = length(dog_a);
			dog_bl = length(dog_b);

			% make same order
			if dog_al > dog_bl,
				dog_b = [dog_b zeros(1,dog_al-dog_bl)];
			elseif dog_bl > dog_al,
				dog_a = [dog_a zeros(1,dog_bl-dog_al)];
			end;

			% compute roots
			dog_aa = roots(dog_a);
			dog_bb = roots(dog_b);

			% compute any gain
			index = find(dog_b ~= 0);gain = dog_b(index(1));
			index = find(dog_a ~= 0);gain = gain/dog_a(index(1));

			% store the gain and roots
			set(finduitx(gcf,'Variables'),'UserData',gain);
			set(finduitx(gcf,'b'),'UserData',dog_bb);
			set(finduitx(gcf,'a'),'UserData',dog_aa);

			% no use keeping any previous curves
			set(findchkb(gcf,'Keep Curves'),'Value',0);

			% display em
			gfiltcal('plotall');
			clear dog_al dog_bl dog_aa dog_bb;
		end;
	else,
		spcwarn('gfilterd: Invalid variable names.','OK');
	end;
else,
	spcwarn('gfilterd: Invalid variable names.','OK');
end;
clear dog_a dog_b dog_name_a dog_name_b;

