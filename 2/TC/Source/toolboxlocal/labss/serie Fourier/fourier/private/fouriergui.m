function a = fouriergui()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.


% to create the figure

a = figure('Color',[0.8 0.8 0.8], ...
    'MenuBar','none', ...
    'CreateFcn','fouriergui_callbacks SetFigureSize', ...
    'Name','Fourier Series Demo', ...
	'NumberTitle','off', ...
    'Tag','FOURDEMO');
    
% this creates the menu bar
b = uimenu('Parent',a, ...
	'Label','&Plot &Options', ...
   'Tag','Plot Options');

c = uimenu('Parent',b, ...
    'Label','&Help', ...
    'Callback','fouriergui_callbacks Help', ...
    'Tag','Help');

c = uimenu('Parent',b, ...
   'Callback','fouriergui_callbacks LineWidth', ...
   'Enable','on', ...
   'Label','&Set Line Width ..', ...
   'Tag','LineWidth');


% creating the axes
%-----------------------------------------------

% the waveform axes
b = uicontrol('Parent',a, ...
'Units','normalized', ...
'BackgroundColor',[0.5 0.6 0.5], ...
'FontSize',5.764705882352942, ...
'FontWeight','bold', ...
'ForegroundColor',[1 1 1], ...
'ListboxTop',0, ...
'Position',[0.05 0.883 0.165 0.033], ...
'String','Waveform of the signal', ...
'Style','text', ...
'Tag','TextforWaveform');

b = axes('Parent',a, ...
    'Units','normalized', ...
    'Box','on', ...
	'CameraUpVector',[0 1 0], ...
    'CameraUpVectorMode','manual', ...
    'Color',[1 1 1], ...
    'FontSize',14, ...
    'FontWeight','bold', ...
    'XLim',[-30 30], ...
    'YLim',[-1.5 1.5], ...
    'NextPlot','replacechildren', ...
    'Position',[0.05 0.683333 0.51 0.20], ...
    'Tag','WaveformAxis', ...
    'XColor',[0 0 0], ...
    'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);

c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
    'String','Time (seconds)', ...
	'Position',[-0.152439 -0.20339 0], ...
	'Tag','WaveformAxisXLabel', ...
	'VerticalAlignment','cap');
set(get(c,'Parent'),'XLabel',c);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
    'FontWeight','bold', ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Position',[-29.4207 0.491525 0], ...
	'Rotation',90, ...
    'String','Amplitude', ...
	'Tag','WaveformAxisYLabel', ...
	'VerticalAlignment','baseline');
set(get(c,'Parent'),'YLabel',c);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','right', ...
	'Position',[-26.8293 1.08475 0], ...
	'Tag','WaveformAxisZLabel', ...
	'Visible','off');
set(get(c,'Parent'),'ZLabel',c);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.152439 1.05932 0], ...
	'Tag','WaveformAxisTitle', ...
	'VerticalAlignment','bottom');
set(get(c,'Parent'),'Title',c);

%-----------------------------------------------
% the magnitude axis

b = uicontrol('Parent',a, ...
'Units','normalized', ...
'BackgroundColor',[0.5 0.60 0.5], ...
'FontSize',5.764705882352942, ...
'FontWeight','bold', ...
'ForegroundColor',[1 1 1], ...
'ListboxTop',0, ...
'Position',[0.05 0.566 0.165 0.033], ...
'String','Magnitude spectrum', ...
'Style','text', ...
'Tag','TextforMagnitude');

b = axes('Parent',a, ...
    'Units','normalized', ...
    'Box','on', ...
    'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
    'FontSize',14, ...
    'FontWeight','bold', ...
    'XLim',[-30 30], ...
    'YLim',[0 1], ...
    'NextPlot','replacechildren', ...
	'Position',[0.05 0.36667 0.51 0.20], ...
	'Tag','MagnitudeAxis', ...
    'XColor',[0 0 0], ...
    'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);

c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.0764526 -0.205128 0], ...
    'String','Number of Fourier Coefficients', ...
	'Tag','MagnitudeAxisXLabel', ...
	'VerticalAlignment','cap');
set(get(c,'Parent'),'XLabel',c);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
    'FontWeight','bold', ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-29.4343 0.487179 0], ...
	'Rotation',90, ...
    'String','Amplitude', ...
	'Tag','MagnitudeAxisYLabel', ...
	'VerticalAlignment','baseline');
set(get(c,'Parent'),'YLabel',c);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-26.8349 2.33333 0], ...
	'Tag','MagnitudeAxisZLabel', ...
	'Visible','off');
set(get(c,'Parent'),'ZLabel',c);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.0764526 1.05983 0], ...
	'Tag','MagnitudeAxisTitle', ...
	'VerticalAlignment','bottom');
set(get(c,'Parent'),'Title',c);

%------------------------------------------------
% the phase axis

b = uicontrol('Parent',a, ...
'Units','normalized', ...
'BackgroundColor',[0.5 0.6 0.5], ...
'FontSize',5.764705882352942, ...
'FontWeight','bold', ...
'ForegroundColor',[1 1 1], ...
'ListboxTop',0, ...
'Position',[0.05 0.265 0.165 0.033], ...
'String','Phase spectrum', ...
'Style','text', ...
'Tag','TextforPhase');

b = axes('Parent',a, ...
    'Units','normalized', ...
   'Box','on', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
    'FontSize',14, ...
    'FontWeight','bold', ...
    'XLim',[-30 30], ...
    'YLim',[-4 4], ...
    'NextPlot','replacechildren', ...
	'Position',[0.05 0.065 0.51 0.20], ...
	'Tag','PhaseAxis', ...
	'XColor',[0 0 0], ...
   	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);

c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.0764526 -0.205128 0], ...
    'String','Number of Fourier Coefficients', ...
	'Tag','PhaseAxisXLabel', ...
	'VerticalAlignment','cap');
set(get(c,'Parent'),'XLabel',c);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
    'FontWeight','bold', ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-29.4343 0.487179 0], ...
	'Rotation',90, ...
	'Tag','PhaseAxisYLabel', ...
    'String','Amplitude', ...
	'VerticalAlignment','baseline');
set(get(c,'Parent'),'YLabel',c);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-27.2936 3.57265 0], ...
	'Tag','PhaseAxisZLabel', ...
	'Visible','off');
set(get(c,'Parent'),'ZLabel',c);
c = text('Parent',b, ...
	'Color',[0 0 0], ...
	'HandleVisibility','callback', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.0764526 1.05983 0], ...
	'Tag','PhaseAxisTitle', ...
	'VerticalAlignment','bottom');
set(get(c,'Parent'),'Title',c);


%%--------------POP UP MENU----------------
% This is for the popup menu title text
b = uicontrol('Parent',a, ...
'Units','normalized', ...
'BackgroundColor',[0.5 0.6 0.5], ...
'FontSize',5.764705882352942, ...
'FontWeight','bold', ...
'ForegroundColor',[1 1 1], ...
'ListboxTop',0, ...
'Position',[0.65 0.88 0.3 0.025], ...
'String','Choose the signal type: ', ...
'Style','text', ...
'Tag','TextforSignal');

% This is for the popup menu
b = uicontrol('Parent',a, ...
'Units','normalized', ...
'BackgroundColor',[1 1 1], ...
'Callback','fouriergui_callbacks SignalType', ...
'FontSize',5.7375, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[.65 .80 .2 .028], ...
'Style','popupmenu', ...
'String','Square|Triangle|Ramp or Sawtooth|Full Wave|Half Wave',...
'Tag','SignalPopUp', ...
'Value',1);

%%--------------SLIDER----------------
% This is for the slider title text
b = uicontrol('Parent',a, ...
'Units','normalized', ...
'BackgroundColor',[0.5 0.6 0.5], ...
'FontSize',5.764705882352942, ...
'FontWeight','bold', ...
'ForegroundColor',[1 1 1], ...
'ListboxTop',0, ...
'Position',[0.65 0.55 0.3 0.08], ...
'String','Choose the number of fourier coefficients by entering a number  between 0 and 30 in the edit box or use the slider.', ...
'Style','text', ...
'Tag','TextforCoeff');

b = uicontrol('Parent',a, ...
'Units','normalized', ...
'BackgroundColor',[0.5 0.6 0.5], ...
'FontSize',5.764705882352942, ...
'FontWeight','bold', ...
'ForegroundColor',[1 1 1], ...
'ListboxTop',0, ...
'Position',[0.65 0.45 0.3 0.025], ...
'String','The number of Coefficient is = 0', ...
'Style','text', ...
'Tag','TextforSlider');

% This is for the slider, capable of 30 steps.

b = uicontrol('Parent',a, ...
'Units','normalized', ...
'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
'Callback','fouriergui_callbacks FourCoeff', ...
'ListboxTop',0, ...
'Min',0, ...
'Max',30.0, ...
'Position',[0.65 0.35 0.2 0.028], ...
'SliderStep',[0.033333333333333 0.066666666666666667], ...
'Style','slider', ...
'Tag','FourCoeffSlider', ...
'Value',0);

% This is for the edit box to put numnber of fourier coefficients.
b = uicontrol('Parent',a, ...
'Units','normalized', ...
'BackgroundColor',[1 1 1], ...
'Callback','fouriergui_callbacks FourCoeff', ...
'FontSize',4.207500000000001, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[0.90 0.35 0.05 0.028], ...
'String','0', ...
'Style','edit', ...
'Tag','FourCoeffEdit');
%-----------------

% to create the close and help button.
b = uicontrol('Parent',a, ...
   'Units','normalized', ...
   'Callback','fouriergui_callbacks Close', ...
   'FontWeight','bold', ...
   'Position',[0.65 0.05 0.145 0.08], ...
   'String','Close', ...
   'Style','pushbutton', ...
   'Tag','CloseButton');
b = uicontrol('Parent',a, ...
   'Units','normalized', ...
   'Callback','fouriergui_callbacks Help', ...
   'FontWeight','bold', ...
   'Position',[0.815 0.05 0.145 0.08], ...
   'String','Help', ...
   'Style','pushbutton', ...
   'Tag','HelpButton');