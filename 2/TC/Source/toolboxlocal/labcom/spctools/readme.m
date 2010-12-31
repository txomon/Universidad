% README file for the SPC Toolbox
% LT Dennis W. Brown
% Naval Postgraduate School, Monterey, CA
%
% Last update: 3-9-95
%
%
% Interactive tools
% ---------------------
%
%    Command arguments:
%	x = Nx1 or 1xN vector
%	fs = sampling frequency (default is 8192 Hz)
%	a,b = filter coeffiecients
%
% sigedit(x) or sigedit(x,fs)	Signal editing (cut & paste).
% voicedit(x) or voicedit(x,fs)	Speech signal editing.
% sigfilt(x) or sigfilt(x,fs)	Signal filtering (analog
%				prototypes).
% spect2d(x) or spect2d(x,fs)	Spectral estimation (classical,
%				AR/MA/ARMA, MUSIC).
% spect3d(x) or spect3d(x,fs)	Spectral surface estimation
%				(time/freq/magnitude).
% sigmodel(x) or sigmodel(x,fs)	Signal modeling (AR/MA/ARMA).
% spscope(x) or spscope(x,fs)   Signal O-scope and spectrum
%				analyzer playback.
% gfilterd(b,a)			Graphical pole/zero filter design.
%
% Sample test data
% ----------------
% Type "spcdata" at Matlab prompt to load.
%
% seatsit.voc (see loadvoc) 	Speech signal of the phrase
%				"the seat, sit" with 60-Hz
%				line noise (fs=8192Hz).
% uuu.mat			Speech signal of /u/ phoneme
%				(fs=8192Hz).
% t0x.mat			AR/ARMA data sets t01, t02,
%				t03, t04 from Prof Therrien's
%				book.
% datax.mat			Spectrum analysis data sets
%				dataa, datab, datac, datad, datae
%				from Prof Therrien's book.
%
%
% The sspitool functions will not be useful to most people (an
% additional licensed program is required) so you can delete
% that directory and omit it from matlabrc.m if you wish.
% You may find the LOADSSPI and SAVESSPI functions useful for
% as a storage option to *.mat files.
%
% The toolbox is periodically updated.  To find the last date
% it was updated, look at the date in the Readme.m file (type
% "whatsnew spctools" from the Matlab command prompt to read
% the Readme.m file from within Matlab).
%
% If you have any troubles, email Dennis Brown at
% dwbrown@access.digex.net or Professor Monique Fargues at
% fargues@ece.nps.navy.mil.
%
% ---------------------------------------------------------------
%
% If this scrolled too fast for you to read, use the
% command "more on" before typing "whatsnew spctools".
%
%
% The End!
