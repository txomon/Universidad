%SPECT2DL	Used by SPECT2D to load new vector.
%	SPECT2DL retrieves the name of the vector to load
%	from an invisible uicontrol text object in the
%	current figure and loads the vector if it exists.
%	The invisible uicontrol text object is placed in
%	figure by a call to REQSTR before executing this
%	function.
%
%	See also SPECT2D, SPECT2DS, REQSTR

%	Dennis W. Brown 2-5-94, DWB 6-7-94
%	Copyright (c) 1994 by Dennis W. Brown
%	May be freely distributed.
%	Not for use in commercial products.


% get current figure since user will have plenty of opportunity
%   to change window focus
dog_gf = gcf;

dog_name = get(finduitx(dog_gf,'Answer'),'UserData');

if isempty(find(dog_name == '.')) & isempty(find(dog_name == '#')),

	if exist(dog_name) == 1,

		% not a filename, load from workspace
		eval(['dog_y = ' dog_name ';']);

	else,
		dog_msg = ['spect2dl: Variable ' dog_name ' does not exist!'];
		spcwarn(dog_msg,'OK');
		clear dog_msg dog_name
	end;

	return;
else,
	% read file
	dog_ind = find(dog_name == '#');
	if isempty(dog_ind),
		[dog_y,dog_fs] = readsig(dog_name);
	else,
		dog_bits = str2num(dog_name(dog_ind(1)+1:length(dog_name)));
		dog_name = dog_name(1:dog_ind-1);
		[dog_y,dog_fs] = readsig(dog_name,dog_bits);
	end;

	% set sampling freq popup menu
	dog_h = findpopu(dog_gf,'FS');
	dog_max = get(dog_h,'Max');

	% get current values
	dog_items = zeros(dog_max-1,1);
	dog_str = get(dog_h,'String');
	for dog_i = 1:dog_max-1,
		dog_items(dog_i) = str2num(dog_str(dog_i,:));
	end;

	if find(dog_fs == dog_items),

		% sampling freq already in popup menu
		set(dog_h,'Value',find(dog_fs == dog_items));

	else,
		% add new sampliing freq
		dog_popstr = [];
		for dog_i = 1:dog_max-1,
			dog_popstr = [dog_popstr int2str(dog_items(dog_i)) '|'];
		end;
		dog_popstr = [dog_popstr int2str(dog_fs) '|User'];

		% reset popup menu
		set(dog_h,'String',dog_popstr,'Value',dog_max);
	end;

	clear dog_fs dog_h dog_max dog_i dog_str dog_popstr dog_ind dog_bits

end;

% make sure it's a vector
if min(size(dog_y)) ~= 1,
	dog_msg = ['spect2dl: ' dog_name ' is not a vector!'];
	spcwarn(dog_msg,'OK');
	clear dog_msg
end;

% store it
set(findchkb(dog_gf,'Keep curves'),'UserData',dog_y);

% turn off Keep curves
set(findchkb(dog_gf,'Keep curves'),'Value',0);

zoomclr(dog_gf);
set(findaxes(dog_gf,'zoomtool'),'UserData',[]);

% show it, use welch
spect2d('plot');

% turn on Keep curves
set(findchkb(dog_gf,'Keep curves'),'Value',1);

clear dog_name dog_y

