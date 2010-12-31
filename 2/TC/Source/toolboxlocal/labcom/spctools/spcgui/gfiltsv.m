%GFILTSV  Save button callback script for GFILTERD.

%       Dennis W. Brown 6-6-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% get roots 
dog_aa = get(finduitx(gcf,'a'),'UserData');
dog_bb = get(finduitx(gcf,'b'),'UserData');

% get names to store under
dog_name_a = get(findedit(gcf,'a var'),'String');
dog_name_b = get(findedit(gcf,'b var'),'String');
dog_gain = get(finduitx(gcf,'Variables'),'UserData');

% are the names good ?
if ~isempty(dog_name_a) & ~isempty(dog_name_b),

	if isstr(dog_name_a) & isstr(dog_name_b),

		% adjust for current phase conditions
		dog_h = getcheck(gcf,'Phase');
		dog_st = get(dog_h,'Label');
		if strcmp(dog_st,'Move Zeros Only'),
			movemode = 1;
		elseif strcmp(dog_st,'Move Poles Only'),
			movemode = 2;
		else,
			movemode = 3;
		end;
		if get(findrdio(gcf,'Minimize'),'Value')
			if ~isempty(dog_aa) & (movemode == 2 | movemode == 3),
				[dog_aa,dog_gg] = minphase(poly(dog_aa));
				dog_aa = roots(dog_aa);
				dog_gain = dog_gain / dog_gg;
			end;
			if ~isempty(dog_bb) & (movemode == 1 | movemode == 3),
				[dog_bb,dog_gg] = minphase(poly(dog_bb));
				dog_bb = roots(dog_bb);
				dog_gain = dog_gain * dog_gg;
			end;
		elseif get(findrdio(gcf,'Maximize'),'Value'),

			if ~isempty(dog_aa),
				dog_ind = find(abs(dog_aa) < eps);
				dog_aa(dog_ind) = eps*ones(size(dog_ind));
			end;
			if ~isempty(dog_bb),
				dog_ind = find(abs(dog_bb) < eps);
				dog_bb(dog_ind) = eps*ones(size(dog_ind));
			end;

			if ~isempty(dog_aa) & (movemode == 2 | movemode == 3),
				[dog_aa,dog_gg] = maxphase(poly(dog_aa));
				dog_aa = roots(dog_aa);
				dog_gain = dog_gain / dog_gg;
			end;
			if ~isempty(dog_bb) & (movemode == 1 | movemode == 3),
				[dog_bb,dog_gg] = maxphase(poly(dog_bb));
				dog_bb = roots(dog_bb);
				dog_gain = dog_gain * dog_gg;
			end;
		end;

		% ensure system is causal for freqz
		dog_a = real(poly(dog_aa));
		dog_b = real(poly(dog_bb));
		if isempty(dog_a), dog_a = 1; end;
		if isempty(dog_b), dog_b = 1; end;
		dog_al = length(dog_a);
		dog_bl = length(dog_b);

		dog_nch = findchkb(gcf,'Non-Causal');
		if length(dog_aa) >= length(dog_bb),

			% causal system
			set(dog_nch,'Value',0,'Enable','off');

			if dog_al > dog_bl,
				dog_b = [fliplr(dog_b) zeros(1,dog_al-dog_bl)];
				dog_b = fliplr(dog_b);
			elseif dog_bl > dog_al,
				dog_a = [dog_a zeros(1,dog_bl-dog_al)];
				dog_a = fliplr(dog_a);
			end;
		else
			% non-causal system
			set(dog_nch,'Enable','on');

			if dog_al > dog_bl,
				dog_b = [fliplr(dog_b) zeros(1,dog_al-dog_bl)];
				dog_b = fliplr(dog_b);
			elseif dog_bl > dog_al,
				if get(dog_nch,'Value'),
				 dog_a = [fliplr(dog_a) zeros(1,dog_bl-dog_al)];
					dog_a = fliplr(dog_a);
				else,
					dog_a = [dog_a zeros(1,dog_bl-dog_al)];
				end;
			end;
		end;

		dog_tol = 100000;
		dog_a = round(dog_tol*dog_a)/dog_tol;
		dog_b = dog_gain * round(dog_tol*dog_b)/dog_tol;

		% finally, save to workspace
		eval([dog_name_a ' = dog_a,']);
		eval([dog_name_b ' = dog_b,']);

		clear dog_al dog_bl dog_aa dog_bb;
	else,
		spcwarn('gfilterd: Invalid variable names.','OK');
	end;
else,
	spcwarn('gfilterd: Invalid variable names.','OK');
end;

clear dog_a dog_b dog_name_a dog_name_b;
