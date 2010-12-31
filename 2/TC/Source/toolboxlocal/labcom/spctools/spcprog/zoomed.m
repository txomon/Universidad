function [h] = zoomed(gf)
%ZOOMED	Get currently "zoomed" line.
%	[H] = ZOOMED(FIGURE) returns a handle to the currently "zoomed"
%	line.  The currently zoomed line is the one the cursors
%	are attached to.
%
%       See also ZOOMCLR ZOOMDOWN ZOOMLEFT ZOOMMENU ZOOMMOVE
%           ZOOMPKLF ZOOMPKRT ZOOMRGHT ZOOMSET ZOOMTGGL ZOOMTOOL
%           ZOOMUP ZOOMXFUL ZOOMXIN ZOOMXOUT ZOOMYFUL ZOOMYIN
%           ZOOMYOUT

%       Dennis W. Brown 3-1-94, DWB 3-1-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% it's handle is store in the UserData property of the "S"napshot
%    pushbutton

h = get(findpush(gf,'S'),'UserData');
