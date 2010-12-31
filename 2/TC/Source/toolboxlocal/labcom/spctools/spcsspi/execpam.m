function execpam(gf)
%EXECPAM Executes the SSPI 'pam' program.
%       EXECPAM(H) executes the SSPI software package 'pam'
%       program.  H is a handle to the figure window created by
%       the SSPIPAM.
%
%       Note: Not for used from the command line.  This
%             function is called by SSPIPAM.
%
%       See also SSPIPAM, SAVEPAM, LOADPAM

%       Dennis W. Brown 1-16-94, DWB 1-21-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

if nargin ~= 1,
	gf = gcf;
end;

% build the command
cmd = '!pam ';

% commandline args
bits = str2num(get(findedit(gf,'Bit-seed (-bits)'),'String'));
nois = str2num(get(findedit(gf,'Noise-seed (-noise)'),'String'));
if bits, cmd = [cmd '-bits ' int2str(bits) ' ']; end;
if nois, cmd = [cmd '-noise ' int2str(nois) ' ']; end;

% insert the case ID
case = get(findedit(gf,'Case-ID'),'String');
if isempty(case),
	case = 'temp';
	set(findedit(gf,'Case-ID'),'String',case);
end;
cmd = [cmd case];

% save the file
savepam(gcf);

% show the command
disp(cmd);

% run pam
eval(cmd)

% display time-domain signal if Time-Points specified
tp = fix(str2num(get(findedit(gf,'Time-Points'),'String')));
if tp > 0

	cmd = [case ' = loadsspi(''pam_' case '.tim'');'];
	% disp(cmd);
	eval(cmd);

	figure('Units','normal','Position',[0 0 .5 .5], ...
               'Name',['pam_' case '.tim']);

        if findchkb(gf,'Real_Output'),
            % do time domain plot
	    eval(['plot(' case '(1:' int2str(tp) '));']);
        else,
            % do time domain plot
	    eval(['plot((' case '(1:' int2str(tp) ')));']);
        end;

	% add axis measure/zoom tool
	zoomtool
end;

% start sspisxaf tool
%sspisxaf(case,gf);

