function [ok] = savesxaf(gf)
%SAVESXAF Creates file to store SSPI 'sxaf' program options.
%       FLAG = SAVESXAF(H) creates a '.sxaf' file to store
%       command lines arguments for the SSPI 'sxaf' program.
%       H is a handle to the figure window created by
%       the SSPISXAF program used to set the command-line
%       arguments for the 'sxaf' program.   The filename format
%       is 'pam_caseid.sxaf'.  This file itself is not a part
%       of the SSPI software package and is only used by the
%       SSPISXAF functions.  FLAG returns 0=failure, 1=success.
%
%       Note: Not for used from the command line.  This
%             function is called by SSPISXAF.
%
%       See also SSPISXAF, EXECSXAF, LOADSXAF

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
xcf = get(findedit(gcf,'X-Correlation-File'),'String');
if isempty(xcf),
    xcf = 'none';
end;
of  = get(findedit(gcf,'Output-File'),'String');
if isempty(of),
    of = 'surf_out';
end;
ofor = get(findpopu(gcf,'Output-Format'),'Value');
af  = get(findedit(gcf,'Alphas-File'),'String');
if isempty(af),
    af = 'alphas';
end;
ip  = fix(str2num(get(findedit(gcf,'Input-Points'),'String')));
if ip < 0,
	error('savesxaf: Input-Points (-m) must be >= 0 (0=All)');
end;
mc  = get(findchkb(gcf,'Max-Cuts'),'Value');
con = get(findchkb(gcf,'Conjugate'),'Value');
st  = get(findpopu(gcf,'Surface-Type'),'Value');
cc  = fix(str2num(get(findedit(gcf,'Cyclic-Corr'),'String')));
if cc < 0,
	error('savesxaf: Cyclic-Corr (-t) must be >= 0 (0=Cyclic-Spectrum)');
end;
ss  = fix(str2num(get(findedit(gcf,'Sub-Sample'),'String')));
if ss < 0,
	error('savesxaf: Sub-Sample (-s) must be >= 0 (0=All)');
end;
sw  = str2num(get(findedit(gcf,'Smooth-Window'),'String'));
if sw <= 0,
	error('savesxaf: Smooth-Window (-w) must be > 0');
end;

% open file
file = ['pam_' case '.sxaf'];
fid = fopen(file,'w');
if fid < 0,
	error(['savesxaf: Could not open ' file ' ...']);
end;

% write file
fprintf(fid,['X-Correlation-File  ' xcf '\n']);
fprintf(fid,['Output-File         ' of '\n']);
fprintf(fid,['Output-Format       ' int2str(ofor) '\n']);
fprintf(fid,['Alphas-File         ' af '\n']);
fprintf(fid,['Input-Points        ' int2str(ip) '\n']);
fprintf(fid,['Max-Cuts            ' int2str(mc) '\n']);
fprintf(fid,['Conjugate           ' int2str(con) '\n']);
fprintf(fid,['Cyclic-Corr         ' int2str(cc) '\n']);
fprintf(fid,['Surface-Type        ' int2str(st) '\n']);
fprintf(fid,['Sub-Sample          ' int2str(ss) '\n']);
fprintf(fid,['Smooth-Window       %e\n'],sw);

fclose(fid);

% set error code
ok = 1;

