function zoomall

gf = gcf;
ga = gca;

h = findobj(get(gf,'Children'),'Type','axes');

ind = find(h ~= ga);

h = h(ind);

xlims = get(ga,'XLim');

set(h,'XLim',xlims);

