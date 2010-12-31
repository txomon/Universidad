%ZOOMNOTE Notes on variable storage used in ZOOMTOOL.
%
% Handle Object			Storage
% 1	x > < button		stack of X-limits before zoom in
% 2	x < > button	
% 3	x [ ] button		X zoom full limits
% 4	y > < button		stack of Y-limits before zoom in
% 5	y < > button	
% 6	y [ ] button		Y zoom full limits
% 7	xy > < button	
% 8	xy < > button	
% 9	xy [ ] button	
% 10	<<< button		Pan 'on' or 'off'
% 11	>>> button		Pan 'on' or 'off'
% 12	=== button		Pan 'on' or 'off'
% 13	<- button		Pan 'on' or 'off'
% 14	-> button		Pan 'on' or 'off'
% 15	'Q' button	
% 16	'T' button		Toggable line handles
% 17	'S' button		'zoomed' line handle
% 18	x - - edit		'zoomed' axes handle
% 19	y - - text		'zoomed' axes handle
% 20	delta edit		'zoomed' axes handle
% 21	delta text		'zoomed' axes handle
% 22	x - . edit		'zoomed' axes handle
% 23	x - . text		'zoomed' axes handle
% 24	- - vertical cursor line (1001)	
% 25	- - horiz cursor line (1002)	
% 26	- . vertical cursor line (2001)	
% 27	- . horiz cursor line (2002)	
% 28	none			xfactor
% 29	none			xmin inside current limits
% 30	none			xmax inside current limits
% 31	none			ymin inside current limits
% 32	none			ymax inside current limits
% 33	none			min(x)
% 34	none			max(x)
% 35	none			min(y)
% 36	none			max(y)
% 37	none			length(y)
% 38	none
% 39	zoomed line
% 40	zoomtool axes handle

%       Dennis W. Brown 7-4-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

