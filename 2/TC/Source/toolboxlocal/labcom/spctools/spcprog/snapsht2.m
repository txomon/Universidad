function snapshot(ga)
%SNAPSHOT Copy axis.
%       SNAPSHOT(H) opens a new figure window, recreating the
%       axes pointed to by the handle H in the new figure.  All
%       visible lines are copied along with the title and x- and
%       y-axis labels.
%
%       The current axes is copied if the axes handle H is
%       ommitted.

%       Dennis W. Brown 1-31-94, 5-31-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% arg check
if nargin < 1,
    ga = gca;
end;

% parent figure window
gf = get(gca,'Parent');

% recreate the plot in a new figure window
newfig = figure;

% copy visible lines from old axis to new
h = get(ga,'Children');
for i = 1:length(h),
    if strcmp(get(h(i),'Type'),'line') & strcmp(get(h(i),'Visible'),'on'),

	x = get(h(i),'XData');

%	if length(x) > 2,
	if length(x) > 0,

		% lines must have more than two points (this gets rid
		% of cursors

		y = get(h(i),'YData');
		s = get(h(i),'LineStyle');

		plot(x,y,s);

	        set(gca,'NextPlot','add');
	end;
    end;
end;
newax = gca;

% set the limits to be the same
set(newax,'YLim',get(ga,'YLim')); set(newax,'XLim',get(ga,'XLim'));

% labels the same
h = get(ga,'Title');
title(get(h,'String'));
set(get(newax,'title'),'Fontname',get(h,'Fontname'));

h = get(ga,'XLabel');
xlabel(get(get(ga,'XLabel'),'String'));
set(get(newax,'XLabel'),'Fontname',get(h,'Fontname'));

h = get(ga,'YLabel');
ylabel(get(get(ga,'YLabel'),'String'));
set(get(newax,'YLabel'),'Fontname',get(h,'Fontname'));

xy = axis; fsize = get(get(newax,'Title'),'Fontsize') - 2;
cursor1 = zoomloc(gf,1); cursor2 = zoomloc(gf,2);

figure(gf);


