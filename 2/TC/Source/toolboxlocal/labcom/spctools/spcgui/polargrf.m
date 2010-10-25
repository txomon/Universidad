function polargrf(ga);
%POLARGRF	Polar coordinate plot for GFILTERD
%	POLARGRF creates the polar graph plot used in
%	the program GFILTERD.

%       Dennis W. Brown 4-3-95
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.


if nargin < 1,
	ga = gca;
end;

% radius variables
rmin = 0.5; rmax = 1.5; rinc = 0.5; rticks = 3;

% define a circle
th = 0:pi/16:2*pi;
xunit = cos(th)';
yunit = sin(th)';

global SPC_UNIT_CIRCLE SPC_POLAR_AXIS

% draw circles
for i=rmin:rinc:rmax
	if i ~= 1,
		h = line(xunit*i,yunit*i);
		set(h,'LineStyle',':','color',SPC_POLAR_AXIS,'linewidth',0.5);
	else,
		h = line(xunit*i,yunit*i);
		set(h,'LineStyle','-','color',SPC_UNIT_CIRCLE,'linewidth',0.5);
	end;
end;

% draw spokes
th = (1:6)*2*pi/12;
cst = cos(th); snt = sin(th);
xx = [0.5 1.5]';
x1 = exp(j*pi/6) * xx;
x2 = exp(j*pi/3) * xx;
x3 = j * xx;
x = [x1 x2];
x = [x conj(x) xx x3];
x = [x -x];

h = line(real(x),imag(x));
set(h,'LineStyle',':','color',SPC_POLAR_AXIS,'linewidth',0.5);

% annotate spokes in degrees
rt = 1.1*rmax;
for i = 3:3:max(size(th))
%	text(rt*cst(i),rt*snt(i),int2str(i*30),...
%		'horizontalalignment','center');
	if i == max(size(th))
		loc = int2str(0);
	else
		loc = int2str(180+i*30);
	end
%	text(-rt*cst(i),-rt*snt(i),loc,'horizontalalignment','center');
end

% set viewto 2-D
view(0,90);

% set axis limits
axis(1.1*rmax*[-1 1 -1.1 1.1]);
axis('equal');axis('off');

set(get(gca,'title'),'Visible','on');
set(get(gca,'ylabel'),'Visible','on');
set(get(gca,'xlabel'),'Visible','on');
