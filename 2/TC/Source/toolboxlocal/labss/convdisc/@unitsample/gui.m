function gui(varargin)
%GUI Create and manage the graphic controls for UNITSAMPLE object
%   GUI(Signal, Pos) creates the controls in the rectangle of the current
%   figure described by Pos to let the user interactively change the UNITSAMPLE
%   object's parameters.  Pos is in normalized units.
%
%   GUI(Signal) assumes the position rectangle of [0 0 1 1]
%
%   This function assumes a figure has already been created and that its
%   UserData property holds a UNITSAMPLE object.
%
%   The function was written to be use within the SIGGENDLG function. 
%
%   Callbacks:
%     GUI('Replot') replots the Signal data with the current parameters and
%     stores the UNITSAMPLE data in the UserData property of the plot.
%
%     GUI('Rescale Plot') rescales the x and y axis of the plot to fit the data.
%
%   See also SIGGENDLG, UNITSAMPLE

% Jordan Rosenthal, 12/16/97

switch nargin
case 1
   action = 'Initialize';
   Signal = varargin{1};
   Pos = [0 0 1 1];
case 2
   Signal = varargin{1};
   if ~isstr(varargin{2})
      action = 'Initialize';
      Pos = varargin{2};
   else
      action = varargin{2};
   end
otherwise
   error('Illegal action.');
end

switch action
case 'Rescale Plot'
   Handles = getuprop(gcbf,'Handles');
   rescaleplot(Signal,Handles.PlotAxis);
case 'Replot'
   Handles = getuprop(gcbf,'Handles');
   Values = get(Handles.Controls,'Value');
   Signal = unitsample( ...
      'Name',Signal.Name, ...
      'Amplitude',Values{1}, ...
      'Delay',Values{2} );
   set(gcbf,'UserData',Signal);
   hStemMarkers = findobj(Handles.PlotLines,'Marker','o');
   hStemLines = findobj(Handles.PlotLines,'Marker','none');
   xx = zeros(3*length(Signal.XData),1);
   yy = zeros(length(xx),1);
   xx(1:3:end) = Signal.XData;
   xx(2:3:end) = Signal.XData;
   xx(3:3:end) = nan;
   yy(1:3:end) = 0;
   yy(2:3:end) = Signal.YData;
   set([hStemMarkers; hStemLines],{'XData','YData'},{Signal.XData Signal.YData; xx yy});
   set( get(Handles.PlotAxis, 'title'), 'String',formulastring(Signal));
case 'Initialize'   
   %%%  Create Plot  %%%
   Plot_Pos  = [0.06*Pos(3)+Pos(1) 0.2*Pos(4)+Pos(2) 0.5*Pos(3) 0.7*Pos(4)];
   hLines = stem(Signal);
   hAxes = gca;
   set(gca, 'Position', Plot_Pos, 'Box', 'off', ...
      'ButtonDownFcn','gui(get(gcbf,''UserData''),''Rescale Plot'')');
   set(hLines,'EraseMode','xor');
   
   %%% Create rescale text message  %%%
   Text_Pos = [0.06*Pos(3)+Pos(1) 0.05*Pos(4)+Pos(2) 0.5*Pos(3) 0.05*Pos(4)];
   uicontrol('Units','normalized', ...
      'BackgroundColor',get(0,'DefaultFigureColor'), ...
      'ForegroundColor','r', ...
      'FontUnits','normalized', ...
      'Position',Text_Pos, ...
      'String','Click inside plot area to rescale axis', ...
      'Style','text');
   
   %%%  Create Controls  %%%
   Controls_Pos = [0.6*Pos(3)+Pos(1) 0.2*Pos(4)+Pos(2) 0.38*Pos(3) 0.7*Pos(4)];
   
   nParams = 2;
   Parameters = {'Amplitude','Delay'};
   Labels = {'Amplitude:','Delay:'};
   Values = num2str( [Signal.Amplitude; Signal.Delay] );
   Min = [-Inf; -Inf];
   Max = [Inf; Inf];
   
   Width = 0.1*ones(1,nParams);
   Height = 0.05*ones(1,nParams);
   Left = ( Controls_Pos(1) + Controls_Pos(3) - Width ) - 0.1;
   Bottom = Controls_Pos(2) + Controls_Pos(4)-Controls_Pos(4)/nParams*[0:nParams-1] - Height;
   NumEditPos = [Left; Bottom; Width; Height];
   LabelWidth = 0.15*ones(1,nParams);
   LabelHeight = Height;
   LabelLeft = Left - 0.16;
   LabelBottom = Bottom - 0.005;
   LabelPos = [LabelLeft; LabelBottom; LabelWidth; LabelHeight];
   DefFigColor = get(0,'DefaultFigureColor');
   h = zeros(nParams,1);
   for i = 1:nParams
      uicontrol('Units','Normalized', ...   
         'Position',LabelPos(:,i), ...
         'BackgroundColor',DefFigColor, ...
         'FontUnits','normalized', ...
         'FontWeight','Bold', ...
         'HorizontalAlignment','right', ...   
         'String',Labels{i}, ...
         'style','text');
      h(i) = uinumedit('Units','normalized', ...
         'BackgroundColor','w', ...
         'CallBack','gui(get(gcbf,''UserData''),''Replot'')', ...
         'Min', Min(i), ...
         'Max', Max(i), ...
         'Position',NumEditPos(:,i), ...
         'String',Values(i,:));
   end
   
   % Store handles for use in callbacks
   Handles.Controls = h;
   Handles.PlotAxis = hAxes;
   Handles.PlotLines = hLines;
   setuprop(gcf, 'Handles', Handles);
   rescaleplot(Signal,Handles.PlotAxis);
otherwise
   error('Illegal action.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  rescaleplot(Signal,hPlotAxis)  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rescaleplot(Signal,hPlotAxis)
XLim = [Signal.XData - 10, Signal.XData + 10];
YLim = [ min(0,1.5*Signal.YData), max(0,1.5*Signal.YData) ];
if YLim(1) == YLim(2)
   YLim = [0, 1];
end
set(hPlotAxis,'XLim',XLim,'YLim',YLim);