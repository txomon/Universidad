function fouriergui_callbacks(action)

% This is the actual callback gui.

% Mustayeen Nayeem, Summer ,02

NO = 0; YES = 1; OFF = 0; ON = 1;
%--------------------------------------------------------------------------------
% Default Settings
%--------------------------------------------------------------------------------

if nargin == 0
   action = 'Initialize';
else
   h = getuprop(gcbf, 'Handles');
end
%GCBF Get handle to current callback figure.
%GCBO Get handle to current callback object.

switch(action)
   %---------------------------------------------------------------------------
case 'Initialize'
   %---------------------------------------------------------------------------
   try
      % All error checking moved to the DCONVDEMO function.  Keep this here as
      % well because we need the Matlab version number for some of the bug
      % workarounds.
      h.MATLABVER = versioncheck(5.2);     % Check Matlab Version
      
      %---  Set up GUI  ---%
      fouriergui;
      strVersion = '1.00';           % Version string for figure title
      set(gcf, 'Name', ['Fourier Series Demo v' strVersion]);
      h.LineWidth = 0.5;
      h.FigPos = get(gcf,'Pos');
      
      SCALE = getfontscale;          % Platform dependent code to determine SCALE parameter

      setfonts(gcf,SCALE);           % Setup fonts: override default fonts used in ltigui
      configresize(gcf);             % Change all 'units'/'font units' to normalized
      
      h = gethandles(h);             % Get GUI graphic handles
      h = defaultplots(h);           % Create default plots
      setuprop(gcf,'Handles',h);
         
      
   catch
      %---  Delete any GUI figures and remove from path if necessary  --%
      delete(findall(0,'type','figure','tag','fourierdemo'));
      
      %---  Display the error to the user and exit  ---%
      errordlg(lasterr,'Error Initializing Figure');
      return;
   end
   

   %---------------------------------------------------------------------------
case 'SetFigureSize'
   %---------------------------------------------------------------------------
   OldUnits = get(0, 'Units');
   set(0, 'Units','pixels');
   ScreenSize = get(0,'ScreenSize');
   set(0, 'Units', OldUnits);
   FigSize = [0.05*ScreenSize(3), 0.1*ScreenSize(4), 0.9*ScreenSize(3), 0.8*ScreenSize(4)];
   set(gcbf, 'Position', FigSize);

      %--------------------------------------------------------------------------
case 'Help'
   %--------------------------------------------------------------------------
     
   
   hBar = waitbar(0.25,'Opening internet browser...');
   DefPath = which(mfilename);
   DefPath = ['file:///' strrep(DefPath,filesep,'/') ];
   URL = [ DefPath(1:end-21) , 'help/','index.html'];
   if h.MATLABVER >= 6
       STAT = web(URL,'-browser')
   else
       STAT = web(URL);
   end
   waitbar(1);
   close(hBar);
   switch STAT
   case {1,2}
      s = {'Either your internet browser could not be launched or' , ...
            'it was unable to load the help page.  Please use your' , ...
            'browser to read the file:' , ...
            ' ', '     index.html', ' ', ...
            'which is located in the Fourier help directory.'};
      errordlg(s,'Error launching browser.');
   end
 
   %--------------------------------------------------------------------------
case 'Close'
   %--------------------------------------------------------------------------
   close;
   
    
   %--------------------------------------------------------------------------
case 'LineWidth'
   %--------------------------------------------------------------------------
   h.LineWidth = linewidthdlg(h.LineWidth);
	set(findobj(gcbf, 'Type', 'line'), 'LineWidth', h.LineWidth);
	setuprop(gcbf,'Handles',h);
   
   %--------------------------------------------------------------------------
case 'SignalType'
   %--------------------------------------------------------------------------
    popValue = get(h.PopUpMenu.Signal, 'Value');
    
    % square wave
    if  popValue == 1
      
     h.yval  = sqar(2*pi*h.freq.*h.timeaxis); 
         
    %triangle wave
    elseif  popValue == 2
         
     h.yval = tri(200,1,length(h.timeaxis)); 
        
    %ramp wave
    
    elseif  popValue == 3
         
     h.yval = ramp(h.timeaxis); 
     
     elseif  popValue == 4
         
     h.yval = fullwave(h.timeaxis); 
     
     elseif  popValue == 5
         
     h.yval = halfwave(h.timeaxis); 
     
    end
     changeplots(h);
   setuprop(gcbf,'Handles',h);

case 'FourCoeff'
   %--------------------------------------------------------------------------
    Tag = get(gco, 'Tag');
	MAKECHANGE = YES;
	
	if strcmp(Tag, 'FourCoeffSlider')
		h.Slider.CoeffValue = round(get(gco, 'Value'));
	else
		NewCoeffValue = str2num(get(gco, 'String'));
		if ( NewCoeffValue < get(h.Slider.NumCoeff,'Min') ) ...
            | (NewCoeffValue > get(h.Slider.NumCoeff,'Max'))
			set(gco,'String',num2str(h.Slider.CoeffValue));
			MAKECHANGE = NO;
		else
			h.Slider.CoeffValue = round(NewCoeffValue);
		end
	end
	if MAKECHANGE
		set(h.Edit.NumCoeff, 'String', num2str(h.Slider.CoeffValue));
		set(h.Slider.NumCoeff, 'Value', h.Slider.CoeffValue);      
		set(h.Text.SliderText, 'String', ['The number of Coefficient is = ' num2str(h.Slider.CoeffValue)]);
		
		setuprop(gcbf,'Handles',h);
		
	end
 
   
    changeplots(h);
    %axes(h.Axis.Magnitude);
    %stem(-index_coeff:index_coeff, abs(magVec),'r.');
 %   GRID ON;
    %axes(h.Axis.Phase);
    
    %stem(-index_coeff:index_coeff, angle(magVec),'r.');
  %  GRID ON;
   %--------------------------------------------------------------------------
otherwise
   error('Illegal Action');
end

%---------------------------------------------------------------------------
%---------------------------------------------------------------------------

function changeplots(h)
    coeffValue = get(h.Slider.NumCoeff, 'Value');
    popValue = get(h.PopUpMenu.Signal, 'Value');
   
    index_coeff = round(coeffValue);
    magVec = [];
    recFinal = zeros(1,length(h.timeaxis));
   
    switch popValue
   case 1
        for n = -index_coeff:index_coeff
            if n == 0 | mod(n,2)==0
                magSpec = 0;
            else 
                magSpec = (-2*j)/(n*pi);
                
                
            end
            recSig = magSpec * exp(j*2*pi*h.freq*n*h.timeaxis);
            magVec = [magVec;magSpec];
            recFinal = recFinal+recSig;
                
                
        end
       
    case 2
        for n = -index_coeff:index_coeff
            if n == 0 | mod(n,2)==0
                magSpec = 0;
            else     
                magSpec = 4/((n*pi)^2);
            end
            recSig = magSpec * exp(j*2*pi*h.freq*n*h.timeaxis);
            magVec = [magVec;magSpec];
            recFinal = recFinal+recSig;
        end
    case 3
        for n = -index_coeff:index_coeff
            if n == 0 
               magSpec = 0;
            else 
                magSpec = ((-1)^n)*(j)/(n*pi);
            end
            recSig = magSpec * exp(j*2*pi*h.freq*n*h.timeaxis);
            magVec = [magVec;magSpec];
            recFinal = recFinal+recSig;
        end
        %--------------------full wave------------------------
        
        case 4
        for n = -index_coeff:index_coeff
            if n == 0 
                magSpec = 2/pi;
            elseif mod(n,2)==0
                magSpec = 2/pi/(1-(n^2));
            else 
                magSpec = 0;
            end
            recSig = (magSpec * exp(j*2*pi*h.freq*n*h.timeaxis));
            magVec = [magVec;magSpec];
            recFinal = recFinal+recSig;               
        end
   
        
        %--------------------Half-----------------
        case 5
        for n = -index_coeff:index_coeff
            if n == 0 
                magSpec = 1/(pi);
            elseif n== -1 | n== 1
                magSpec = 1/4;
            else
                magSpec = ( cos(n*pi/2))/pi/(1-n^2);
            end
            
            recSig = magSpec * exp(j*2*pi*h.freq*n*h.timeaxis);
            magVec = [magVec;magSpec];
            recFinal = recFinal+recSig;
                          
        end
        
end
    h.magVec = magVec;
    h.SpectrumXval = -index_coeff:index_coeff;
    
%plot & Stem
set(h.Signal.Waveform, 'YData', h.yval);
set(h.Signal.RecWaveform, 'YData', recFinal);
stemdata(h.SpectrumXval, abs(h.magVec), h.Spectrum.Magnitude);
stemdata(h.SpectrumXval, angle(h.magVec), h.Spectrum.Phase);
setuprop(gcbf,'Handles',h);


