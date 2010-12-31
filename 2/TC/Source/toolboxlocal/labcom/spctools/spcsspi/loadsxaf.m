function [ok] = loadsxaf(gf)
%LOADSXAF Load a '.sxaf' file.
%       FLAG = LOADSXAF(H) loads a '.sxaf' file containing
%       command line arguments for the SSPI 'sxaf' program.
%       H is a handle to the figure window created by
%       the SSPISXAF program used to set the command-line
%       arguments for the 'sxaf' program.   The filename format
%       is 'pam_caseid.sxaf'.  The file itself is not a part
%       of the SSPI software package and is only used by the
%       SSPISXAF function.  FLAG returns 0=failure, 1=success.
%
%       Note: Not for used from the command line.  This
%             function is called by SSPISXAF.
%
%       See also SSPISXAF, EXECSXAF, SAVESXAF

%       Dennis W. Brown 1-16-94, DWB 1-21-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

if nargin ~= 1,
	gf = gcf;
end;

% initial error code is bad
ok = 0;

% get caseid from window
case = get(findedit(gf,'Case-ID'),'String');
if isempty(case),
    error('loadsxaf: Case-ID is invalid...');
end;

% open file, return if can't
file = ['pam_' case '.sxaf'];
fid = fopen(file,'r');
if fid < 0,
	disp(['loadsxaf: Could not open ' file ', using default...']);
	return;
end;

% read in values
t = fscanf(fid,'%s',1);
line = 'X-Correlation-File';
if ~strcmp(t,line),
    error(['loadsxaf: Error reading ' line ' from ' file '...']);
end;
xcf = fscanf(fid,'%s',1);
if isempty(xcf),
    xcf = 'none';
end;

t = fscanf(fid,'%s',1);
line = 'Output-File';
if ~strcmp(t,line),
    error(['loadsxaf: Error reading ' line ' from ' file '...']);
end;
of = fscanf(fid,'%s',1);
if isempty(of),
    of = 'surf_out';
end;

t = fscanf(fid,'%s',1);
line = 'Output-Format';
if ~strcmp(t,line),
    error(['loadsxaf: Error reading ' line ' from ' file '...']);
end;
ofor = fscanf(fid,'%d');
if ofor < 1 | ofor > 2,
   error('loadsxaf: Output-Format must be 1 (ASCII) or 2 (binary)');
end;

t = fscanf(fid,'%s',1);
line = 'Alphas-File';
if ~strcmp(t,line),
    error(['loadsxaf: Error reading ' line ' from ' file '...']);
end;
af = fscanf(fid,'%s',1);
if isempty(of),
    af = 'alphas';
end;

t = fscanf(fid,'%s',1);
line = 'Input-Points';
if ~strcmp(t,line),
    error(['loadsxaf: Error reading ' line ' from ' file '...']);
end;
ip = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'Max-Cuts';
if ~strcmp(t,line),
    error(['loadsxaf: Error reading ' line ' from ' file '...']);
end;
mc = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'Conjugate';
if ~strcmp(t,line),
    error(['loadsxaf: Error reading ' line ' from ' file '...']);
end;
con = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'Cyclic-Corr';
if ~strcmp(t,line),
    error(['loadsxaf: Error reading ' line ' from ' file '...']);
end;
cc = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'Surface-Type';
if ~strcmp(t,line),
    error(['loadsxaf: Error reading ' line ' from ' file '...']);
end;
st = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'Sub-Sample';
if ~strcmp(t,line),
    error(['loadsxaf: Error reading ' line ' from ' file '...']);
end;
ss = fscanf(fid,'%d');

t = fscanf(fid,'%s',1);
line = 'Smooth-Window';
if ~strcmp(t,line),
    error(['loadsxaf: Error reading ' line ' from ' file '...']);
end;
sw = fscanf(fid,'%e');

% close file
fclose(fid);

% set values
set(findedit(gf,'X-Correlation-File'),'String',xcf);
set(findedit(gf,'Output-File'),'String',of);
set(findpopu(gf,'Output-Format'),'Value',ofor);
set(findedit(gf,'Alphas-File'),'String',af);
set(findedit(gf,'Input-Points'),'String',int2str(ip));
set(findchkb(gf,'Max-Cuts'),'Value',mc);
set(findchkb(gf,'Conjugate'),'Value',con);
set(findpopu(gf,'Surface-Type'),'Value',st);
set(findchkb(gf,'Cyclic-Corr'),'String',int2str(cc));
set(findedit(gf,'Sub-Sample'),'String',int2str(ss));
set(findedit(gf,'Smooth-Window'),'String',num2str(sw));

% error code ok
ok = 1;

