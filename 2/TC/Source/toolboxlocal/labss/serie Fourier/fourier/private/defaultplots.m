function h = defaultplots(h)
% DEFAULTPLOTS Create the default plots drawn when GUI loads
%    h = DEFAULTPLOTS(h) creates the initial plots drawn in the GUI
%    from data given in structure h.  Returns the structure with new
%    fields set.

% Mustayeen Nayeem, July 15, 2002

NO = 0; YES = 1; OFF = 0; ON = 1;
%--------------------------------------------------------------------------------
% Default Settings
%--------------------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not change code below this point.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h.NumCoeff = 0;
h.SignalVal = 1;
h.timeaxis = -30:0.1:30;
h.freq = 0.05;
h.yval = sqar(2*pi*h.freq*h.timeaxis);

set(h.Edit.NumCoeff, 'Value', h.NumCoeff);      
set(h.Slider.NumCoeff,          'Value', h.NumCoeff);      
set(h.PopUpMenu.Signal,        'Value', h.SignalVal);    

axes(h.Axis.Waveform);
h.Signal.Waveform = plot(h.timeaxis, h.yval,'k');
hold on;
h.Signal.RecWaveform = plot(h.timeaxis,zeros(1,length(h.timeaxis)),'r');
hold off;

axes(h.Axis.Magnitude);
h.Spectrum.Magnitude = stem(0,0,'b.');

axes(h.Axis.Phase);
h.Spectrum.Phase = stem(0,0,'b.');