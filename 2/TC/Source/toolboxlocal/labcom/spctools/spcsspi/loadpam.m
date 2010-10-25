function [ok] = loadpam(f)
%LOADPAM Load a '.inp' file.
%       FLAG = LOADPAM(H) loads a '.inp' file containing
%       input variables for the SSPI 'pam' program.
%       H is a handle to the figure window created by
%       the SSPIPAM program.  The filename format
%       is 'pam_caseid.inp'. FLAG returns 0=failure, 1=success.
%
%       Note: Not for used from the command line.  This
%             function is called by SSPIPAM.
%
%       See also SSPIPAM, EXECPAM, SAVEPAM

%       Dennis W. Brown 1-16-94, DWB 1-21-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

if nargin ~= 1,
	f = gcf;
end;

% initial error code is bad
ok = 0;

% get caseid from window
case = get(findedit(gcf,'Case-ID'),'String');
if isempty(case),
    error('loadpam: Case-ID is invalid...');
end;

% open file
file = ['pam_' case '.inp'];
fid = fopen(file,'r+');
if fid < 0,
	disp(['loadpam: Could not open ' file ' ...']);
	return;
end;

% read in values
t = fscanf(fid,'%s',1);
line = 'nsamples';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
nos = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'samples_per_symbol';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
sps = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'bits_per_symbol';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
bps = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'constellation';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
con = fscanf(fid,'%s',1);

t = fscanf(fid,'%s',1);
line = 'pulse_type';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
pt = fscanf(fid,'%s',1);

t = fscanf(fid,'%s',1);
line = 'pulse_BW';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
pb = fscanf(fid,'%e');

t = fscanf(fid,'%s',1);
line = 'pulse_tail_exp';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
pte = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'delay_samples';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
ds = fscanf(fid,'%e');

t = fscanf(fid,'%s',1);
line = 'real_freq_shift';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
rfs = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'carrier_freq';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
cf = fscanf(fid,'%e');

t = fscanf(fid,'%s',1);
line = 'carrier_phase_deg';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
cpd = fscanf(fid,'%e');

t = fscanf(fid,'%s',1);
line = 'over_sample';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
os = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'under_sample';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
us = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'signal_power_dB';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
spd = fscanf(fid,'%e');

t = fscanf(fid,'%s',1);
line = 'noise_power_dB';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
npd = fscanf(fid,'%e');

t = fscanf(fid,'%s',1);
line = 'ASCII_or_binary';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
aob = fscanf(fid,'%s',1);

t = fscanf(fid,'%s',1);
line = 'real_output';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
ro = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'time_output';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
to  = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'freq_output';
if ~strcmp(t,line),
    error(['loadpam: Error reading ' line ' from ' file '...']);
end;
fo = fscanf(fid,'%d');

% close file
fclose(fid);

% change strings to values
if strcmp(con,'psk'), con = 1;
elseif strcmp(con,'qam'), con = 2;
else error('loadpam: Invalid constellation value...');
end;

if strcmp(pt,'rect'), pt = 1;
elseif strcmp(pt,'bl_rect'), pt = 2;
elseif strcmp(pt,'halfcos'), pt = 3;
elseif strcmp(pt,'bl_halfcos'), pt = 4;
elseif strcmp(pt,'nyq'), pt = 5;
else error('loadpam: Invalid pulse_type...');
end;

if strcmp(aob,'ASCII'), aob = 1;
elseif strcmp(aob,'binary'), aob = 2;
else error('loadpam: Invalid ASCII_or_binary...');
end;

% set values
set(findedit(f,'Number-of-Samples'),'String',int2str(nos));
set(findedit(f,'Samples-per-Symbol'),'String',int2str(sps));
set(findedit(f,'Bits-per-Symbol'),'String',int2str(bps));
set(findpopu(f,'Constellation'),'Value',con);
set(findpopu(f,'Pulse-Type'),'Value',pt);
set(findedit(f,'Pulse-Bandwidth'),'String',num2str(pb));
set(findedit(f,'Pulse-Tail-Exp'),'String',int2str(pte));
set(findedit(f,'Delay-Samples'),'String',num2str(ds));
set(findedit(f,'Real-Freq-Shift'),'String',int2str(rfs));
set(findedit(f,'Carrier-Frequency'),'String',num2str(cf));
set(findedit(f,'Carrier-Phase-Degree'),'String',num2str(cpd));
set(findedit(f,'Over-Sample'),'String',int2str(os));
set(findedit(f,'Under-Sample'),'String',int2str(us));
set(findedit(f,'Signal-Power (dB)'),'String',num2str(spd));
set(findedit(f,'Noise-Power (dB)'),'String',num2str(npd));
set(findpopu(f,'ASCII-or-binary'),'Value',aob);
set(findchkb(f,'Real-Output'),'Value',ro);
set(findchkb(f,'Time-Output'),'Value',to);
set(findchkb(f,'Frequency-Output'),'Value',fo);

% error code ok
ok = 1;

