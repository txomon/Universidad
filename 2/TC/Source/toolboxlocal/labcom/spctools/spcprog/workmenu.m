function hh = workmenu(gf,rdata,restcall,commcall,loadcall,savecall,closecall)
%WORKMENU Add 'Workspace' menu to figure window.
%       M = WORKMENU(H,RESTOREDATA,'RESTORECALL','COMMONCALL',...
%           'LOADCALL','SAVECALL','QUITCALL') creates a menu in the 
%       figure window pointed to by the figure handle H. The 'Workspace'
%       menu provides an interface between the user and ZOOMTOOL
%       for saving the current 'zoomed' vector in ZOOMTOOL and/or
%       loading a new vector into ZOOMTOOL.  Output argument M is
%	the handle to the 'Workspace' UIMENU.
%
%       The 'Workspace' menu is:
%
%       Workspace
%           Restore
%           Common
%           Load
%           Save
%           Quit
%
%       Restore - Restore the vector RESTOREDATA as the
%                 'zoomed' line.  This is presumably the
%                 'original' vector in the SPC tool under
%                 development.  RESTOREDATA is store in
%                 the UserData property of the 'Restore'
%                 menu item.
%       Common  - Retrieve the 'common' vector from the global
%                 workspace and make it the 'zoomed' vector.  The
%                 common vector serves as a mechanism to pass
%                 vectors between SPC tools without having to
%                 close and restart tools.
%       Load    - Load a vector from the Matlab workspace into
%                 ZOOMTOOL as the 'zoomed' line.
%       Save    - Save the current 'zoomed' vector in ZOOMTOOL
%                 to the Matlab workspace.
%       Quit    - Quit the tool, closing the window and
%                 deleting all but the common vector.
%
%       The programmer must supply the callbacks to Restore,
%       Common, Load and Save menu items.  The Restore and
%       Common callbacks ('RESTORECALL' and 'COMMONCALL') are
%       stored in the actual Callback property of the respective
%       menu item.  The Load and Save callbacks are store in
%       their UserData properties.  The operating premise for
%       these to functions is that when selected, the dialog
%       created by a call to REQSTR is opened prompting the
%       user for the variable name.  If the user cancels the
%       dialog, it is cleared and the Load or Save callback is
%       not executed.  If the user enters a variable name and
%       presses return or selects the OK push button, the
%       variable name is store in the UserData property of the
%       'Workspace' menu and then the Load or Save callback is
%       executed.  The first action these callbacks should
%       perform is retrieve the variable name from the Workspace
%       menu.  The callback functions must take care of the
%       interface with ZOOMTOOL (usually with a ZOOMLINE call).
%
%       See also ZOOMTOOL, LOADEDIT, SAVEEDIT, REQSTR, ZOOMLINE

%       Dennis W. Brown 1-31-94
%       Copyright (c) 1994 by Dennis W. Brown
%       May be freely distributed.
%       Not for use in commercial products.

% arg check
if nargin < 6 | nargin > 7,
    error('workmenu: Invalid number of input arguments.');
end;

if nargin ~= 7,
	closecall = 'close(gcf);';
end;

% ensure figure has focus
figure(gf)

% callback functions
loadrequestcall = [...
    'reqstr(gcf,''Enter variable name to load''); ' ...
    ];

saverequestcall = [...
    'reqstr(gcf,''Enter variable name to save''); ' ...
    ];

% draw the menu, same RESTOREDATA in Restore menu item and
%   Load and Save callback in UserData
m=uimenu('Label','Workspace');

  global SPC_RESTORE
  if strcmp(SPC_RESTORE,'on'),
	  uimenu(m,'Label','Restore','UserData',rdata,'Callback',restcall);
  end;
  uimenu(m,'Label','Common','Callback',commcall);
  uimenu(m,'Label','Load','UserData',loadcall,'Separator','on',...
    'CallBack',loadrequestcall);
  uimenu(m,'Label','Save','UserData',savecall, ...
    'CallBack',saverequestcall);

  if exist('uigetfile') == 5,
	mm = uimenu(m,'Label','File Load');
	uimenu(mm,'Label','Audio (*.au)','CallBack',...
		['reqfile(gcf,''*.au'',''Select file to load'',''' ...
			dblquote(loadcall) ''');' ]);
	uimenu(mm,'Label','Voice (*.voc)','CallBack',...
		['reqfile(gcf,''*.voc'',''Select file to load'',''' ...
			dblquote(loadcall) ''');' ]);
	uimenu(mm,'Label','Wave (*.wav)','CallBack',...
		['reqfile(gcf,''*.wav'',''Select file to load'',''' ...
			dblquote(loadcall) ''');' ]);
	uimenu(mm,'Label','SSPI (*.tim)','CallBack',...
		['reqfile(gcf,''*.tim'',''Select file to load'',''' ...
			dblquote(loadcall) ''');' ]);
	mmm = uimenu(mm,'Label','Integer');
	uimenu(mmm,'Label','8 Bit','CallBack',...
		['reqfile(gcf,''*.*'',''Select file to load'',''' ...
			dblquote(loadcall) ''');' ]);
	uimenu(mmm,'Label','16 Bit','CallBack',...
		['reqfile(gcf,''*.*'',''Select file to load'',''' ...
			dblquote(loadcall) ''');' ]);
	uimenu(mmm,'Label','32 Bit','CallBack',...
		['reqfile(gcf,''*.*'',''Select file to load'',''' ...
			dblquote(loadcall) ''');' ]);
  end;

  uimenu(m,'Label','Quit','Callback',closecall,'Accelerator','Q',...
		'Separator','on');

if nargout == 1,
	hh = m;
end;
