function execsxaf(gf)
%EXECSXAF Executes the SSPI 'sxaf' program.
%       EXECSXAF(H) executes the SSPI software package 'sxaf'
%       program.  H is a handle to the figure window created by
%       the SSPISXAF.
%
%       Note: Not for used from the command line.  This
%             function is called by SSPISXAF.
%
%       See also SSPISXAF, SAVESXAF, LOADSXAF

%       Dennis W. Brown 1-16-94, DWB 1-21-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

if nargin ~= 1,
	gf = gcf;
end;

% save the file
savesxaf(gcf);

% get case id
case = get(findedit(gf,'Case-ID'),'String');

% build the command
cmd = '!sxaf ';

% commandline args
of  = get(findedit(gcf,'Output-File'),'String');
if isempty(of),
    of = ['pam_' case '.surf'];
end;
cmd = [cmd ' -o ' of];

ofor = get(findpopu(gcf,'Output-Format'),'Value');
if ofor == 1,
    cmd = [cmd ' -f a'];
else
    cmd = [cmd ' -f b'];
end;

af  = get(findedit(gcf,'Alphas-File'),'String');
if isempty(af),
    af = 'alphas';
end;
cmd = [cmd ' -a ' af];

ip  = fix(str2num(get(findedit(gcf,'Input-Points'),'String')));
if ip < 0,
	error('savesxaf: Input-Points (-m) must be >= 0 (0=All)');
end;
if ip ~= 0,
    cmd = [cmd ' -m ' int2str(ip)];
end;

mc  = get(findchkb(gcf,'Max-Cuts'),'Value');
if mc,
    cmd = [cmd ' -M'];
end;

con = get(findchkb(gcf,'Conjugate'),'Value');
if con,
    cmd = [cmd ' -C'];
end;

cc  = fix(str2num(get(findedit(gcf,'Cyclic-Corr'),'String')));
if cc > 0,
    cmd = [cmd ' -t ' int2str(cc)];
end;

st  = get(findpopu(gcf,'Surface-Type'),'Value');
if st == 1,
    cmd = [cmd ' -r c'];
elseif st == 2,
    cmd = [cmd ' -r m'];
else
    cmd = [cmd ' -r p'];
end;

ss  = fix(str2num(get(findedit(gcf,'Sub-Sample'),'String')));
if ss < 0,
	error('savesxaf: Sub-Sample (-s) must be >= 0 (0=All)');
end;
if ss > 0,
    cmd = [cmd ' -s ' int2str(ss)];
end;

sw  = str2num(get(findedit(gcf,'Smooth-Window'),'String'));
if sw <= 0,
	error('savesxaf: Smooth-Window (-w) must be > 0');
end;
cmd = [cmd ' -w ' num2str(sw)];

% add the input file
if isempty(case),
	case = 'temp';
	set(findedit(gf,'Case-ID'),'String',case);
end;
cmd = [cmd ' pam_' case '.tim'];

xcf = get(findedit(gcf,'X-Correlation-File'),'String');
if ~isempty(xcf) & ~strcmp(xcf,'none'),
    cmd = [cmd ' ' xcf ' '];
end;

% append output of sxaf to .sxaf file
file = ['pam_' case '.sxaf'];
cmd = [cmd ' >!  sspi_junk'];

% show the command
disp(cmd);

% run sxaf
eval(cmd)
eval('!cat sspi_junk');
eval(['!cat sspi_junk | grep Resolution >> ' file]);

% load and show surface
of = get(findedit(gf,'Output-File'),'String');
cmd = ['[' case '_surf,' case '_a,' case '_f] = loadsurf(''' of ''''];
if ofor == 2,
    cmd = [cmd ',''binary'');'];
else
    cmd = [cmd ');'];
end;

% disp(cmd);
eval(cmd);
figure('Units','normal','Position',[.5 0 .5 .5], ...
       'Name',of);
eval(['waterfall(' case '_f,' case '_a,abs(' case '_surf));']);
xlabel('Freq');
ylabel('Alpha');
zlabel('(W)');
title('SXAF Surface');
v3dtool

