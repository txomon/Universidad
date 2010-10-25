function mufirwin(gf,callback)
%MUFIRWIN	FIR filter window menu.
%	MUFIRWIN(H,CALLBACK) adds a menu to the figure window pointed to
%	by the handle H which allows the user to select a pre-defined
%	FIR window type.  The menu can be accessed using the FINDMENU
%	function.  The function GTFIRWIN returns a vector containing
%	the current window from the menu.  CALLBACK is an optional
%	string which defines the 'Callback' property for all the submenu
%	'CallBack' properties.
%
%	The FIR window menu is
%
%	Window
%		Rectangular
%		Triangular
%		Hanning
%		Hamming
%		Blackman
%		Bartlett
%
%	The Hanning window is the default window.  The current window
%	is always the one containing the checkmark in the menu.  The
%	Signal Processing Toolbox is required for this function.
%
%	See also FINDMENU, GTFIRWIN

%       Dennis W. Brown 1-27-94, DWB 5-25-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% arg check
if nargin < 1 | nargin > 2,
	error('mufirwin: Invalid number of input arguments.');
end
if nargin ~= 2,
	callback = '';
end


% Angle menu
items = str2mat('Rectangular','Bartlett','Blackman','Hanning','Hamming');
togmenu(gf,'Window',items,4,callback);

