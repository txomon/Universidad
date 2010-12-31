function newfig=snapshot(ga,na)
%SNAPSHOT Copy axis.
%       FIG = SNAPSHOT(H) opens a new figure window, recreating the
%       axes pointed to by the handle H in the new figure.  All
%       visible lines are copied along with the title and x- and
%       y-axis labels.  Returns a handle to the figure window that
%		was created.
%
%       The current axes is copied if the axes handle H is
%       ommitted.

%       Dennis W. Brown 1-31-94, DWB 3-1-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% arg check
if nargin < 1,
    ga = gca;
end;

% parent figure window
gf = get(gca,'Parent');

if nargin == 1,

	% recreate the plot in a new figure window
	newfig = figure;

	na = axes;
end;

% copy visible lines from old axis to new
h = get(ga,'Children');
for i = 1:length(h),
	if strcmp(get(h(i),'Type'),'line') & strcmp(get(h(i),'Visible'),'on'),
    
		xdata = get(h(i),'XData');
		ydata = get(h(i),'YData');
		lstyle = get(h(i),'LineStyle');

		% don't copy cursors (defined by two points)
		axes(na);
		plot(xdata,ydata,lstyle);
		set(gca,'NextPlot','add');
	end;
end;

% set properties be the same
set(na,'YLim',get(ga,'YLim'));
set(na,'XLim',get(ga,'XLim'));
set(na,'Box',get(ga,'Box'));
set(na,'Aspect',get(ga,'Aspect'));
set(na,'Visible',get(ga,'Visible'));
set(na,'XTick',get(ga,'XTick'));
set(na,'XTickLabels',get(ga,'XTickLabels'));
set(na,'XGrid',get(ga,'XGrid'));
set(na,'YTick',get(ga,'YTick'));
set(na,'YTickLabels',get(ga,'YTickLabels'));
set(na,'YGrid',get(ga,'YGrid'));
set(na,'FontName',get(ga,'FontName'));

% labels the same
h = get(ga,'Title');
title(get(h,'String'));
set(get(na,'title'),'Fontname',get(h,'Fontname'));

h = get(ga,'XLabel');
xlabel(get(get(ga,'XLabel'),'String'));
set(get(na,'XLabel'),'Fontname',get(h,'Fontname'));

h = get(ga,'YLabel');
ylabel(get(get(ga,'YLabel'),'String'));
set(get(na,'YLabel'),'Fontname',get(h,'Fontname'));

% return focus to original figure
figure(gf);


