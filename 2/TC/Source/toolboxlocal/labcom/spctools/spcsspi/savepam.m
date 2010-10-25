function [ok] = savepam(gf)
%SAVEPAM Creates file to store SSPI 'pam' program options.
%       FLAG = SAVEPAM(H) creates a '.inp' file to store
%       input variables for the SSPI 'pam' program.
%       H is a handle to the figure window created by
%       the SSPIPAM program.  The filename format is 
%       'pam_caseid.pam'. FLAG returns 0=failure, 1=success.
%
%       Note: Not for used from the command line.  This
%             function is called by SSPIPAM.
%
%       See also SSPIPAM, EXECPAM, LOADPAM

%       Dennis W. Brown 1-16-94, DWB 1-21-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

if nargin ~= 1,
	gf = gcf;
end;

% initial error code is bad
ok = 0;

% get values from window
case = get(findedit(gcf,'Case-ID'),'String');
nos = str2num(get(findedit(gcf,'Number-of-Samples'),'String'));
nos = 2^ceil(log2(nos));
sps = fix(str2num(get(findedit(gcf,'Samples-per-Symbol'),'String')));
bps = fix(str2num(get(findedit(gcf,'Bits-per-Symbol'),'String')));
con = lower(getpopst(gcf,'Constellation'));
pt  = lower(getpopst(gcf,'Pulse-Type'));
pb  = str2num(get(findedit(gcf,'Pulse-Bandwidth'),'String'));
if pb > 1.0,
	error('savepam: Pulse-Bandwidth must be <= 1');
end;
pte = fix(str2num(get(findedit(gcf,'Pulse-Tail-Exp'),'String')));
if pte > 0,
	error('savepam: Pulse-Tail-Exp must be negative...');
end;
ds  = str2num(get(findedit(gcf,'Delay-Samples'),'String'));
rfs = fix(str2num(get(findedit(gcf,'Real-Freq-Shift'),'String')));
cf  = str2num(get(findedit(gcf,'Carrier-Frequency'),'String'));
cpd = str2num(get(findedit(gcf,'Carrier-Phase-Degree'),'String'));
os  = fix(str2num(get(findedit(gcf,'Over-Sample'),'String')));
if os < 0,
	error('savepam: Over-Sample must be a positive integer...');
end;
us  = fix(str2num(get(findedit(gcf,'Under-Sample'),'String')));
if us < 0,
	error('savepam: Under-Sample must be a positive integer...');
end;
sp  = str2num(get(findedit(gcf,'Signal-Power (dB)'),'String'));
np  = str2num(get(findedit(gcf,'Noise-Power (dB)'),'String'));
aob = getpopst(gcf,'ASCII-or-binary');
ro  = get(findchkb(gcf,'Real-Output'),'Value');
to  = get(findchkb(gcf,'Time-Output'),'Value');
fo  = get(findchkb(gcf,'Frequency-Output'),'Value');

% open file
file = ['pam_' case '.inp'];
fid = fopen(file,'w');
if fid < 0,
	error(['savepam: Could not open ' file ' ...']);
end;

% write file
fprintf(fid,['nsamples            ' int2str(nos) '\n']);
fprintf(fid,['samples_per_symbol  ' int2str(sps) '\n']);
fprintf(fid,['bits_per_symbol     ' int2str(bps) '\n']);
fprintf(fid,['constellation       ' con '\n']);
fprintf(fid,['pulse_type          ' pt '\n']);
fprintf(fid,['pulse_BW            %e\n'],pb);
fprintf(fid,['pulse_tail_exp      ' int2str(pte) '\n']);
fprintf(fid,['delay_samples       %e\n'],ds);
fprintf(fid,['real_freq_shift     ' int2str(rfs) '\n']);
fprintf(fid,['carrier_freq        %e\n'],cf);
fprintf(fid,['carrier_phase_deg   %e\n'],cpd);
fprintf(fid,['over_sample         ' int2str(os) '\n']);
fprintf(fid,['under_sample        ' int2str(us) '\n']);
fprintf(fid,['signal_power_dB     %e\n'],sp);
fprintf(fid,['noise_power_dB      %e\n'],np);
fprintf(fid,['ASCII_or_binary     ' aob '\n']);
fprintf(fid,['real_output         ' int2str(ro) '\n']);
fprintf(fid,['time_output         ' int2str(to) '\n']);
fprintf(fid,['freq_output         ' int2str(fo) '\n']);
fclose(fid);

% set error code
ok = 1;

