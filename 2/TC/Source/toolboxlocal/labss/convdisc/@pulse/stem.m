function h = stem(Signal)
%STEM Overloaded STEM command for a PULSE object
%   h = STEM(Signal) creates a STEM plot for the PULSE object Signal.
%   The XLABEL of the plot is set to the Signal's Name property and the
%   plots TITLE is set to the output of FORMULASTRING(Signal).
%
%   See also PULSE, FORMULASTRING

% Jordan Rosenthal, 12/16/97

h = stem(Signal.XData,Signal.YData);
title(formulastring(Signal), 'Color', 'b', 'FontUnits', 'normalized', ...
   'FontSize',0.07);
xlabel(Signal.Name, 'FontWeight', 'bold', 'FontUnits', 'normalized');