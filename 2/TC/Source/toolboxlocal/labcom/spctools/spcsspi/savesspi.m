function savesspi(x,name)
%SAVESSPI Loads SSPI software generated data files.
%       SAVESSPI(X,'NAME') saves vector X to the file
%	'NAME' in SSPI binary format.
%
%	SAVESSPI(X,'NAME','ASCII') saves vector X to the
%	file 'NAME' in SSPI ASCII format.
%
%       The ASCII SSPI format is:
%           Line 1   - T N
%                      where T = type: 1 = real, 2 = complex
%                            N = Number of samples in file
%           Lines 2+ - one or two columns of ascii numeric
%                       data dependent upon type
%
%       The binary format is:
%           integer - Type (binary 1 or 2)
%           integer - Number of samples
%           remaining integers - Sample data (complex data is  
%               with real and imaginary parts in consecutive
%               integer pairs.
%
%       Note: Binary SSPI files are not compatible across 
%             platforms.
%
%       See also LOADSURF, SSPIPAM, SSPISXAF

%       Dennis W. Brown 2-10-94, DWB 2-10-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default output
y = []; bintype = 2;

if nargin < 2 | nargin > 3,
	error('savesspi: Invalid number of input arguments.');
end;
if nargin == 3,
	bintype = 1;
end;

% name must be a string
if ~isstr(name),
	error('savesspi: Filename must be a string argument!');
end;

% figure out file storage type
if bintype == 1,

    %  ASCII
    fid = fopen(name,'w');

else,

    %  binary (0 if on Sun)
    fid = fopen(name,'wb');
    
end

type = 1;
nbr = length(x);

% write number of samples
if bintype == 1,
    [count] = fprintf(fid,'%d',type);
else,
    [count] = fwrite(fid,type,'int32');
end;

% write number of samples
if bintype == 1,
    [count] = fprintf(fid,'%d',nbr);
else,
    [count] = fwrite(fid,nbr,'int32');
end;

if count ~= 1,
    error('savesspi: Error writing number of samples...');
end;

% write the samples
if bintype == 1,
    if type == 1,
        [count] = fprintf(fid,'%e',x);
    else,
        [count] = fprintf(fid,'%e %e',x);
    end;
else,
    c = computer;
    if strcmp(c(1:2),'PC'), 
        ftype = 'double'; 
    else 
        ftype = 'float';
    end;
    if type == 1,
        [count] = fwrite(fid,x,ftype);
    else,
        [count] = fwrite(fid,2*x,ftype);
    end;
end;

% go ahead and close the file
fclose(fid);

