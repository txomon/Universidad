%SPECT2DS	Save 3D spectral surface.
%	SAVE2D

%	Dennis W. Brown 2-18-94
%	Copyright (c) 1994 by Dennis W. Brown
%	May be freely distributed.
%	Not for use in commercial products.

s2d_gf = gcf; s2d_ga = gca;

set(s2d_gf,'Pointer','watch');

% get handles to zoomtool uicontrols
s2d_handles = get(finduitx(s2d_gf,'zoomtool'),'UserData');

% get handles to all the lines
s2d_lineh = get(s2d_handles(16),'UserData');
s2d_lineh(:);

% get x scale
s2d_x = get(s2d_lineh(1),'XData')';

% get y data (all spectral estimates)
s2d_y = zeros(length(s2d_x),length(s2d_lineh));
for s2d_i = 1:length(s2d_lineh),
	s2d_y(:,s2d_i) = get(s2d_lineh(s2d_i),'YData')';
end;

s2d_name = get(finduitx(gcf,'Answer'),'UserData');
eval([s2d_name '_x = s2d_x;']);
eval([s2d_name '_y = s2d_y;']);

set(s2d_gf,'Pointer','arrow');

clear s2d_y s2d_x s2d_i s2d_name s2d_gf s2d_ga s2d_lineh s2d_handles
