%TESTSPEECH Test speech functions

%       LT Dennis W. Brown 1-23-94, DWB 1-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

echo on
format compact

pause % press key to test LOADVOC

[s,fs] = loadvoc('seatsit.voc');
plot(s);

fs

pause % press key to test SAVEVOC

% expand in range so clipping will occur
s = 4 * s;

% save to new file
savevoc('clipped',s,fs);

% load back in and check
[s,fs] = loadvoc('clipped');
plot(s);
fs

pause % press key to test Short-time functions

s = loadvoc('seatsit');
[e,t] = sp_steng(s,0.050,10,8192,'hamming');
[m,t] = sp_stmag(s,0.050,10,8192,'hanning');
[z,t] = sp_stzcr(s,0.050,10,8192);

sse = max(e);
ssm = max(m);
ssz = max(z);

plot(t,e/sse,'-',t,m/ssm,'--',t,z/ssz,':');
title('Normalized short-time functions');
xlabel('Time (s)');


pause % press key to test median smoother

s = loadvoc('seatsit');
[e,t] = sp_steng(s,0.020,10,8192,'hamming');
[m,t] = sp_stmag(s,0.020,10,8192,'hanning');
[z,t] = sp_stzcr(s,0.020,10,8192);

e = mdsmooth(e,5);
m = mdsmooth(m,5);
z = mdsmooth(z,5);

sse = max(e);
ssm = max(m);
ssz = max(z);

plot(t,e/sse,'-',t,m/ssm,'--',t,z/ssz,':');
title('Normalized short-time functions');
xlabel('Time (s)');


pause % press key to test average smoother

s = loadvoc('seatsit');
[e,t] = sp_steng(s,0.020,10,8192,'hamming');
[m,t] = sp_stmag(s,0.020,10,8192,'hanning');
[z,t] = sp_stzcr(s,0.020,10,8192);

e = avsmooth(e,5);
m = avsmooth(m,5);
z = avsmooth(z,5);

sse = max(e);
ssm = max(m);
ssz = max(z);

plot(t,e/sse,'-',t,m/ssm,'--',t,z/ssz,':');
title('Normalized short-time functions');
xlabel('Time (s)');


