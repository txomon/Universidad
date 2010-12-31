function [h] = zoomcrsr(gf)
%ZOOMCRSR Get ZOOMTOOL cursor handles.
%	[H] = ZOOMCRSR(FIGURE) return a vector containing
%	handles to the four ZOOMTOOL cursor line objects
%	as shown below.  FIGURE is the handle to the figure
%	ZOOMTOOL is active in.
%
%		H = [dashX dashY dashdotX dashdotY]
%
%	See also ZOOMTOOL

%       Dennis W. Brown 6-20-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

if nargin < 1,
	gf = gcf;
elseif nargin ~= 1,
	error('zoomcrsr: Invalid number of input arguments.');
end;

% get handles to zoomtool uicontrols
handles = get(finduitx(gf,'zoomtool'),'UserData');

% handles to cursors
h = handles(24:27);
