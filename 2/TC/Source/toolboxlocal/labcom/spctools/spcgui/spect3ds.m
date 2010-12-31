%SPECT3DS	Save 3D spectral surface.
%	SAVE3D retrieves the name of the surface to save
%	from an invisible uicontrol text object in the
%	current figure and saves the spectral surface to.
%	The invisible uicontrol text object is placed in
%	figure by a call to REQSTR before executing this
%	function.  Two vectors containing the time and
%	frequency scales are also save.  The variable
%	nameing convention is:
%
%		name_ss - spectral surface
%		name_f  - frequency scale
%		name_t  - time scale
%
%	The surface can be redrawn from the command line
%	with
%		>> surf(name_f,name_t,name_ss)
%
%	See also SPECT3D, REQSTR

%	Dennis W. Brown 2-18-94, 3-2-95
%	Copyright (c) 1994 by Dennis W. Brown
%	May be freely distributed.
%	Not for use in commercial products.

s3d_gf = gcf; s3d_ga = gca;

set(s3d_gf,'Pointer','watch');

% get variables
s3d_y = get(finduitx(s3d_gf,'Apply 3D'),'UserData');
s3d_fs = getpopvl(s3d_gf,'FS');
s3d_overlap = getpopvl(s3d_gf,'% Overlap');
s3d_framelen = getednbr(s3d_gf,'Frame Length');
s3d_fftlength = getpopvl(s3d_gf,'FFT');
s3d_dbfloor = getednbr(s3d_gf,'dB Floor');

% frame length in samples
if rem(s3d_framelen,1),
	% not an integer must be time
	s3d_framelength = floor(s3d_framelen * s3d_fs);
else,
	% an integer, must be points
	s3d_framelength = s3d_framelen;
end;

if s3d_framelength > s3d_fftlength,
	s3d_msg = 'spect3ds: Frame length exceeds FFT length.  Aborted.';
	spcwarn(l3d_msg,'OK');
	set(s3d_gf,'Pointer','arrow');
	clear s3d_y s3d_fs s3d_fftlength s3d_framelen s3d_framelength
	clear s3d_dbfloor s3d_msg s3d_gf s3d_ga
	return;
end;

% convert to matrix
[s3d_Y,s3d_tscale] = framdata(s3d_y,s3d_framelength,s3d_fftlength,...
	s3d_overlap,s3d_fs);

% get window 
s3d_window = gtfirwin(s3d_gf,s3d_framelength);

for s3d_k = 1:length(s3d_tscale),
	s3d_Y(1:s3d_framelength,s3d_k) = s3d_window .* ...
		s3d_Y(1:s3d_framelength,s3d_k);
end;
clear s3d_window

% apply FFT
s3d_YY = abs(fft(s3d_Y,s3d_fftlength));

s3d_i1 = zoomind(s3d_gf,1);
s3d_i2 = zoomind(s3d_gf,2);

% use freqs between cursors
s3d_YY = s3d_YY(s3d_i1:s3d_i2,:);

if ischeckd(s3d_gf,'Scale','Logarithmic'),
	s3d_YY = 20*log10(s3d_YY);
	if isempty(s3d_dbfloor),
		s3d_msg = 'spect3ds: dB Floor must be a value.  Aborted.';
		spcwarn(l3d_msg,'OK');
		set(s3d_gf,'Pointer','arrow');
		clear s3d_y s3d_fs s3d_fftlength s3d_framelen s3d_framelength
		clear s3d_dbfloor s3d_msg s3d_k s3d_Y s3d_YY s3d_tscale
		clear s3d_i1 s3d_i2 s3d_overlap s3d_gf s3d_ga
		return;
	end;
	s3d_k = find(s3d_YY < s3d_dbfloor);
	s3d_YY(s3d_k) = s3d_dbfloor * ones(length(s3d_k),1);
end;

% frequency scale
s3d_fscale = ((s3d_i1:s3d_i2)-1)/s3d_fftlength*s3d_fs;

s3d_name = get(finduitx(gcf,'Answer'),'UserData');
eval([s3d_name '_ss = s3d_YY.'';']);
eval([s3d_name '_f = s3d_fscale;']);
eval([s3d_name '_t = s3d_tscale;']);

set(s3d_gf,'Pointer','arrow');

clear s3d_y s3d_fs s3d_fftlength s3d_framelen s3d_framelength
clear s3d_dbfloor s3d_k s3d_Y s3d_YY s3d_tscale s3d_i1 s3d_i2
clear s3d_overlap s3d_fscale s3d_name s3d_gf s3d_ga
