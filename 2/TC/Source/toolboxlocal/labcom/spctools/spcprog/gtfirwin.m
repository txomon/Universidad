function [y] = gtfirwin(gf,N)
%GTFIRWIN	Get FIR window.
%	[Y] = GTFIRWIN(H,N) returns a N length FIR window
%	according to the current FIR window menuitem in the
%	figure pointed to by the handle H.
%
%	See also MUFIRWIN

%       Dennis W. Brown 1-27-94, DWB 5-26-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.


% design window as selected by the menu
win = get(getcheck(gf,'Window'),'Label');

if strcmp(win,'Rectangular'),
	y = ones(N,1);
elseif strcmp(win,'Hanning'),
	y = hanning(N);
elseif strcmp(win,'Hamming'),
	y = hamming(N);
elseif strcmp(win,'Blackman'),
	y = blackman(N);
elseif strcmp(win,'Bartlett'),
	y = bartlett(N);
end;

