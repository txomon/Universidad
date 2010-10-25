function spcolors
%SPCOLORS Default colors for SPC Toolkit tools.
%       This file sets up the colors scheme for the SPC toolkit 
%       tools. 
%
%       Two versions of this file are provided.  If you monitor
%       is black and white, rename the SPCOLORS.M file to
%       SPCOLORS.OLD and then rename the SPBANDW.M file to 
%       SPCOLORS.M.
%
%       On multiuser systems, copy this file to your working
%       directory and edit as desired.  For custom color changes
%       to take affect, a user's version of SPCOLORS.M must be 
%       in their MATLABPATH before the spcolors.m file in the 
%       SPCTOOLS directory.
%

%       LT Dennis W. Brown 9-28-93, DWB 5-8-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

global SPC_WINDOW		% main window color
SPC_WINDOW = 'blue';

global SPC_TEXT_FORE		% foregound text color
SPC_TEXT_FORE = 'white';

global SPC_COOL_WINDOW		% COOL window display
SPC_COOL_WINDOW = 0;

global SPC_TEXT_BACK		% background text color
SPC_TEXT_BACK = SPC_WINDOW;

global SPC_AXIS			% axis, including labels
SPC_AXIS = [1 1 1]*1;

global SPC_UI_TEXT		% text in popupmenus, etc
SPC_UI_TEXT = 'black';

global SPC_FONTNAME		% for axis, title, ylabel, xlabel, text
SPC_FONTNAME = 'times';

global SPC_LINE			% lines objects
SPC_LINE = 'r';

global SPC_COLOR_ORDER		% color order of lines
SPC_COLOR_ORDER = [...
     1     0     0
     1     0     1
     0     .5     1
     0     0     0];

global SPC_MARKS		% in vectarma
SPC_MARKS = 'cyan';

global SPC_MODEL_MARKS		% in vectarma, 
SPC_MODEL_MARKS = 'red';

global SPC_PERIOD_MARKS		% in vectarma, 
SPC_PERIOD_MARKS = 'green';

global SPC_DESIRED		% desire signal in vectarma, sigmodel overlay
SPC_DESIRED = ':';

global SPC_MODEL		% model signal in vectarma, sigmodel overlay
SPC_MODEL = 'magenta';

global SPC_POLES		% poles on polar plots (x's)
SPC_POLES = 'white';

global SPC_ZEROS		% zeros on polar plots (o's)
SPC_ZEROS = 'green';

global SPC_TRANSFER		% transfer functions
SPC_TRANSFER = 'blue';

global SPC_HIGHLIGHT		% highlighted background for text in sanalyzr
SPC_HIGHLIGHT = 'magenta';

global SPC_ST_ENG		% short-time energy curve in voicedit
SPC_ST_ENG = 'red';

global SPC_ST_MAG		% short-time magnitude curve in voicedit
SPC_ST_MAG = 'green';

global SPC_ST_ZCR		% short-time magnitude curve in voicedit
SPC_ST_ZCR = 'blue';

global SPC_UNIT_CIRCLE		% unit circle in polargrf
SPC_UNIT_CIRCLE = 'magenta';

global SPC_POLAR_AXIS		% polar axis in polargrf
SPC_POLAR_AXIS = 'cyan';

global SPC_GFILT_AXIS		% response curve axis in gfilterd
SPC_GFILT_AXIS = [1 1 1] * .7;

global SPC_GFILT_LIMIT		% limit beyond which poles/zeros are not
SPC_GFILT_LIMIT = 5;		%    shown (magnitude)


% the following should be off if you're working with large vectors
% and are having out-of-memory problems
global SPC_RESTORE
SPC_RESTORE = 'on';

% -----------------------------------------------------------------------------
% The next variables allow the user to change the default location
% the tool open up.  To enable, unmark the lines for the doad you want
% to enable your own location.  Specify the position rectangle with a four
% element vector of the form:
%
%   [left, bottom, width, height]
%
% where left and bottom define the distance from the lower-left corner of the
% screen to the lower-left corner of the tool window.  The units are
% normalized in the range of 0.0 to 1.0.  A full-screen window would be
%
%   [0 0 1 1]
%
% The sums of left+width and bottom+height should not exceed 1.0.

% the vectfilt tool
%global SPC_VF_POS
%SPC_VF_POS = [0 .3 .7 .7];

% the vectedit tool
%global SPC_VE_POS
%SPC_VE_POS = [0 0 .7 .7];

% the vectarma tool
%global SPC_AR_POS
%SPC_AR_POS = [0 .3 .7 .7];

% the vecttime tool
%global SPC_ST_POS
%SPC_ST_POS = [0 .3 .7 .7];

% the signal model tool
%global SPC_SM_POS
%SPC_SM_POS = [0 .3 .7 .7];

% the signal edit tool
%global SPC_SE_POS
%SPC_SE_POS = [0 .3 .7 .7];

% the 2d spectrum estimation tool
global SPC_2D_POS
SPC_2D_POS = [0 .3 .7 .7];

% the 3d spectrum estimation tool
global SPC_3D_POS
SPC_3D_POS = [0 0 .7 .7];

% the signal filter tool
%global SPC_SF_POS
%SPC_SF_POS = [.3 .3 .7 .7];


% -----------------------------------------------------------------------------


