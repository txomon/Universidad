% Signal Processing and Communications Toolbox
% Programming functions.
% Version 2.00, 4/30/94
% LT Dennis W. Brown
% Naval Postgraduate School
% Monterey, CA
%
% Axes Cursors.
%   CRSRDEL     Delete axes cursor.
%   CRSRLOC     Return axes cursor position.
%   CRSRMAKE    Create axes cursor.
%   CRSRMOVE    Move axes cursor.
%   CRSROFF     Turn axes cursor off.
%   CRSRON      Turn axes cursor on.
%   CRSRDOWN    Drag cursor with mouse.
%   CRSRMMOV    Move cursor with mouse.
%   CRSRUP      Move cursor on mouse button up.
%
% Object handle retrieval.
%   FINDAXES    Find axes object.
%   FINDCHKB    Find checkbox uicontrol.
%   FINDEDIT    Find edit uicontrol.
%   FINDFRAM    Find frame uicontrol.
%   FINDFIG     Find figure window.
%   FINDLINE    Find axes line object.
%   FINDMENU    Find uimenu uicontrol.
%   FINDPOPU    Find popupmenu uicontrol.
%   FINDPUSH    Find pushbutton uicontrol.
%   FINDRDIO    Find radiobutton uicontrol.
%   FINDSLID    Find radiobutton uicontrol.
%   FINDTEXT    Find axes text object.
%   FINDUITX    Find text uicontrol.
%   FINDOBJ        Find objects with specified property values.
%
% Popup menu functions.
%   POPUNBRS    Labeled number popupmenu.
%   GETPOPST    Return current string on a popup menus.
%   GETPOPVL    Return current numeric value on a popup menus.
%   POPHITE     Adjust height of popup menu for MS-Windows.
%
% Menu functions.
%   MENUCMAP	Add a "Colormap" pulldown menu to a figure.
%   MENUSHAD	Add a "Shading" pulldown menu to a figure.
%   MUFIRWIN	Add a "Window" FIR filter window menu.
%   GTFIRWIN	Return FIR window based on Window menu.
%   WORKMENU	Add a 'Workspace' menu to figure window.
%
% Dialog boxes
%   REQSTR      String request dialog.
%   EDNBRCHK    Edit box number check.
%
% Three dimensional plots.
%   V3DTOOL     View three-dimensional plots tool.
%
% Object counting.
%   CNTAXES     Count axes objects.
%   CNTLINES    Count line axes objects.
%   CNTUICTL    Count figure uicontrols objects.
%
% Misc
%   DBLQUOTE    Double single quote characters.
%   READSIG     Read AU/VOC/WAV or flat integer signal files.
%   SNAPSHOT    Copy axis object to new figure.
%
% ZOOMTOOL functions.
%   ZOOMPROG    Launch SPC Toolbox program.
%   ZOOMCLR     Remove ZOOMTOOL axes.
%   ZOOMDOWN    Button down callback.
%   ZOOMLEFT    Move ZOOMTOOL cursor one sample to the left,
%   ZOOMMOVE    Button down/move callback function.
%   ZOOMPKLF    Move cursor to next extrema on left.
%   ZOOMPKRT    Move cursor to next extrema on right.
%   ZOOMRGHT    Move cursor one sample right.
%   ZOOMSET     Move specified ZOOMTOOL cursor.
%   ZOOMTGGL    Toggle line attachment of cursors.
%   ZOOMTOOL    Axes zoom/measurement tool.
%   ZOOMUP      Button up callback function.
%   ZOOMXFUL    Zoom X-axis to full limits.
%   ZOOMXIN     Zoom in the X-axis.
%   ZOOMXOUT    Zoom out the X-axis.
%   ZOOMYFUL    Zoom full the Y-axis.
%   ZOOMYIN     Zoom in the Y-axis.
%   ZOOMYOUT	Zoom out the Y-axis.
%   ZOOMLOC     Return ZOOMTOOL cursor location.
%   ZOOMEDIT    Add Play menu or play portion of vector in ZOOMTOOL.
%   ZOOMPLAY    Play portion of vector in ZOOMTOOL.
%   ZOOMIND     Return ZOOMTOOL cursor location.
%   ZOOMLINE    Replace "zoomed" line in ZOOMTOOL.
%   ZOOMED      Get currently "zoomed" line.
%   ZOOMEDSV    Save vector between vertical cursors.
%   ZOOMFILT    Launch SPC Toolbox program.
%   ZOOMSCAL    Switch between linear and logrithmic scaling.
