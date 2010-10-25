function [y] = loadsspi(name)
%LOADSSPI Loads SSPI software generated data files.
%       LOADSSPI('name') - Loads SSPI software generated data 
%       from the file "name."
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

%       Dennis W. Brown 7-17-93, DWB 1-21-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

% default output
y = [];

% name must be a string
if ~isstr(name),
	error('loadsspi: Filename must be a string argument!');
end;

% open file as a binary, get first byte and close
fid = fopen(name,'rb');
if fid < 0,
    error(['loadsspi: Could not open ' name '...']);
else
    bite = fread(fid,1,'int8');
    fclose(fid);
end;

% figure out file storage type
if bite == 49 | bite == 50,

    % ASCII '1' or '2', must be ASCII
    bintype = 1;
    fid = fopen(name,'r');
    [type,count] = fscanf(fid,'%d',[1,1]);

elseif bite >= 0 & bite <= 2,

    % binary 1 or 2, muxt be binary (0 if on Sun)
    bintype = 2;
    fid = fopen(name,'rb');
    [type,count] = fread(fid,1,'int32');
    
else
	error(['loadsspi: Invalid SSPI format...']);
end

% check for correct file format once more
if type ~= 1 & type ~=2,
    fclose(fid);
    error('loadsspi: Invalid SSPI format...');
end;

% read number of samples
if bintype == 1,
    [nbr,count] = fscanf(fid,'%d',[1,1]);
else,
    [nbr,count] = fread(fid,1,'int32');
end;

if count ~= 1,
    error('loadsspi: Error reading number of samples...');
end;

% read the samples
if bintype == 1,
    if type == 1,
        [y,count] = fscanf(fid,'%e',[1 inf]);
        y = y(:);
    else,
        [y,count] = fscanf(fid,'%e %e',[2 inf]);
        y = y.';
    end;
else,
    c = computer;
    if strcmp(c(1:2),'PC'), 
        ftype = 'float'; 
    else 
        ftype = 'float';
    end;
    if type == 1,
        [y,count] = fread(fid,nbr,ftype);
        y = y(:);
    else,
        [y,count] = fread(fid,2*nbr,ftype);
        y = reshape(y,length(y)/2,2);
    end;
end;

% go ahead and close the file
fclose(fid);

% was it read correctly ?
if count ~= type * nbr,
    y = [];
    error(['loadsspi: ' int2str(type),int2str(nbr) ' Error, EOF reached...']);
end;

% if data was type 2, it is complex.  Make it so.
if type == 2,
    y = y(:,1) + j * y(:,2);
end

