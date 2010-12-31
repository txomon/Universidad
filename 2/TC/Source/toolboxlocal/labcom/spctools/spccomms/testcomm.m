%TESTCOMMS Test communication functions.

%       LT Dennis W. Brown 1-23-94, DWB 1-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

echo on
format compact

pause % press key to test STR2MASC and MASC2STR

textmsg = 'A boy and his rats';
binmsg = str2masc(textmsg);
t = masc2str(binmsg)

echo on
pause % press key to continue

binmsg = str2masc(textmsg,7,'o',2);
t = masc2str(binmsg,7,'o',2)

echo on
pause % press key to continue

binmsg = str2masc(textmsg,8,'n',1);
t = masc2str(binmsg,8,'n',1)

% ------------------------------------------------------------
echo on
pause % press key to test LRS functions.

y = lrs(5,12,[1 1 1 1 1],4)'
y = lrs(5,12,[1 1 1 1 1],[1 0 0 1 0])'
y = lrs(5,12,[1 2 3 4 5],[1 4])'


% ------------------------------------------------------------
echo on
dur = .04;
pause % press key to test DSBLC functions.

x = triwave(60);
y = dsblc(x,0.3,1024);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

% ------------------------------------------------------------
echo on
pause % press key to test envelope functions.

[z,m] = envelope(y);
subplot(2,1,1); plottime(z,dur); subplot(2,1,2); lperigrm(z);

m

% m should be 0.3

% ------------------------------------------------------------
echo on
pause % press key to test MODINDEX functions.

m = modindex(y)

% m should be 0.3

% ------------------------------------------------------------
echo on
pause % press key to test SQWAVE functions.
dur = .01;
Rb = 512;

y = sqwave(Rb);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 8192, error, end;

pause % press key to continue

y = sqwave(Rb,'antipodal');
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 8192, error, end;

pause % press key to continue

% generate only 1/2 second
y = sqwave(Rb,0.5);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 4096, error, end;

pause % press key to continue

% generate only 1/2 second
y = sqwave(Rb,0.5,'antipodal');
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 4096, error, end;

pause % press key continue

y = sqwave(Rb,0.5,4096);
subplot(2,1,1); plottime(y,dur/2); subplot(2,1,2); lperigrm(y,4096);

if length(y) ~= 2048, error, end;

pause % press key continue

y = sqwave(Rb,0.5,4096,'antipodal');
subplot(2,1,1); plottime(y,dur/2); subplot(2,1,2); lperigrm(y,4096);

if length(y) ~= 2048, error, end;

% ------------------------------------------------------------
pause % press key to test TRIWAVE functions.
dur = .01;
Rb = 512;

y = triwave(Rb);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 8192, error, end;

pause % press key to continue

y = triwave(Rb,'antipodal');
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 8192, error, end;

pause % press key to continue

% generate only 1/2 second
y = triwave(Rb,0.5);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 4096, error, end;

pause % press key to continue

% generate only 1/2 second
y = triwave(Rb,0.5,'antipodal');
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 4096, error, end;

pause % press key continue

y = triwave(Rb,0.5,4096);
subplot(2,1,1); plottime(y,dur/2); subplot(2,1,2); lperigrm(y,4096);

if length(y) ~= 2048, error, end;

pause % press key continue

y = triwave(Rb,0.5,4096,'antipodal');
subplot(2,1,1); plottime(y,dur/2); subplot(2,1,2); lperigrm(y,4096);

if length(y) ~= 2048, error, end;

% ------------------------------------------------------------
pause % press key to test SAWWAVE functions.
dur = .01;
Rb = 512;

y = sawwave(Rb);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 8192, error, end;

pause % press key to continue

y = sawwave(Rb,'antipodal');
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 8192, error, end;

pause % press key to continue

% generate only 1/2 second
y = sawwave(Rb,0.5);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 4096, error, end;

pause % press key to continue

% generate only 1/2 second
y = sawwave(Rb,0.5,'antipodal');
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 4096, error, end;

pause % press key continue

y = sawwave(Rb,0.5,4096);
subplot(2,1,1); plottime(y,dur/2); subplot(2,1,2); lperigrm(y,4096);

if length(y) ~= 2048, error, end;

pause % press key continue

y = sawwave(Rb,0.5,4096,'antipodal');
subplot(2,1,1); plottime(y,dur/2); subplot(2,1,2); lperigrm(y,4096);

if length(y) ~= 2048, error, end;


% ------------------------------------------------------------
pause % press key to test COSWAVE functions.
dur = .01;

y = coswave(512);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 8192, error, end;

pause % press key to continue

% generate only 1/2 second
y = coswave(512,0.5);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 4096, error, end;

pause % press key continue

y = coswave(512,0.5,4096);
subplot(2,1,1); plottime(y,dur/2); subplot(2,1,2); lperigrm(y,4096);

if length(y) ~= 2048, error, end;

pause % press key to continue

% generate only 1/2 second
y = coswave(512,0.5,4096,-pi/2);
subplot(2,1,1); plottime(y,dur/2); subplot(2,1,2); lperigrm(y,4096);

% should look like a sine wave

% ------------------------------------------------------------
pause % press key to test SINWAVE functions.
dur = .01;

y = sinwave(512);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 8192, error, end;

pause % press key to continue

% generate only 1/2 second
y = sinwave(512,0.5);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 4096, error, end;

pause % press key continue

y = sinwave(512,0.5,4096);
subplot(2,1,1); plottime(y,dur/2); subplot(2,1,2); lperigrm(y,4096);

if length(y) ~= 2048, error, end;

pause % press key to continue

% generate only 1/2 second
y = sinwave(512,0.5,4096,pi/2);
subplot(2,1,1); plottime(y,dur/2); subplot(2,1,2); lperigrm(y,4096);

% should look like a cosine wave

% ------------------------------------------------------------
pause % press key to test ANTPODAL functions.
dur = .1;

y = antpodal(64,6);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

% should be six bits

pause % press key to continue

y = antpodal(100,6,4000);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y,4000);

% should be six shorter bits

pause % press key continue

y = antpodal(64,[1 0 0 1 0 1]);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

% bit pattern should be [1 0 0 1 0 1]

pause % press key to continue

y = antpodal(100,[1 0 0 1 0 1],4000);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y,4000);

% bit pattern should be [1 0 0 1 0 1]

% ------------------------------------------------------------
pause % press key to test UNIPOLAR functions.
dur = .1;

y = unipolar(64,6);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

% should be six bits

pause % press key to continue

y = unipolar(100,6,4000);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y,4000);

% should be six shorter bits

pause % press key continue

y = unipolar(64,[1 0 0 1 0 1]);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

% bit pattern should be [1 0 0 1 0 1]

pause % press key to continue

y = unipolar(100,[1 0 0 1 0 1],4000);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y,4000);

% bit pattern should be [1 0 0 1 0 1]

% ------------------------------------------------------------
pause % press key to test BPSK functions.
dur = .075;

y = bpsk(128,1024);
subplot(2,1,1); plottime(y,0.05); subplot(2,1,2); lperigrm(y);

if length(y) ~= 8192, error, end;
if length(y)/8192 ~= 1.0, error, end;

pause % press key to continue

% generate only 1/2 second
y = bpsk(128,1024,0.5);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 4096, error, end;
if length(y)/8192 ~= 0.5, error, end;

pause % press key to continue

% generate only 1/2 second at 4096 Hz
y = bpsk(128,1024,0.5,4096);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y,4096);

if length(y) ~= 2048, error, end;
if length(y)/4096 ~= 0.5, error, end;

% ------------------------------------------------------------
pause % press key to test BPSKMSG functions.

y = bpskmsg(128,1024,binmsg);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

pause % press key to continue

% generate only 1/2 second
y = bpskmsg(128,1024,4096,binmsg);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y,4096);

% ------------------------------------------------------------
pause % press key to test BFSK functions.

y = bfsk(128,256,1024);
subplot(2,1,1); plottime(y,0.05); subplot(2,1,2); lperigrm(y);

if length(y) ~= 8192, error, end;
if length(y)/8192 ~= 1.0, error, end;

pause % press key to continue

% generate only 1/2 second
y = bfsk(128,256,1024,0.5);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 4096, error, end;
if length(y)/8192 ~= 0.5, error, end;

pause % press key to continue

% generate only 1/2 second at 4096 Hz
y = bfsk(128,256,1024,0.5,4096);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y,4096);

if length(y) ~= 2048, error, end;
if length(y)/4096 ~= 0.5, error, end;

% ------------------------------------------------------------
pause % press key to test BFSKMSG functions.

y = bfskmsg(128,256,1024,binmsg);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

pause % press key to continue

% generate only 1/2 second
y = bfskmsg(128,256,1024,4096,binmsg);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y,4096);

pause % press key to continue

% ------------------------------------------------------------
pause % press key to test OOK functions.
dur = .075;

y = ook(128,1024);
subplot(2,1,1); plottime(y,0.05); subplot(2,1,2); lperigrm(y);

if length(y) ~= 8192, error, end;
if length(y)/8192 ~= 1.0, error, end;

pause % press key to continue

% generate only 1/2 second
y = ook(128,1024,0.5);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

if length(y) ~= 4096, error, end;
if length(y)/8192 ~= 0.5, error, end;

pause % press key to continue

% generate only 1/2 second at 4096 Hz
y = ook(128,1024,0.5,4096);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y,4096);

if length(y) ~= 2048, error, end;
if length(y)/4096 ~= 0.5, error, end;

% ------------------------------------------------------------
pause % press key to test OOKMSG functions.

y = ookmsg(128,1024,binmsg);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y);

pause % press key to continue

% generate only 1/2 second
y = ookmsg(128,1024,4096,binmsg);
subplot(2,1,1); plottime(y,dur); subplot(2,1,2); lperigrm(y,4096);


