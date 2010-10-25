%TESTUTILITY Test utility functions.

%       LT Dennis W. Brown 1-23-94, DWB 1-23-94
%       Naval Postgraduate School, Monterey, CA
%       May be freely distributed.
%       Not for use in commercial products.

format compact
echo on

pause % press key to test 8-bit functions

% data
x = -140:140;

% save to file
sv8bit('test.dat',x);

% read from file
y = ld8bit('test.dat');
plot(y);
max(y)
min(y)

% should be clipped above 127 and below -128

pause % press key to continue

% data
x = 1:140;

% save to file
sv8bit('test.dat',x);

% read from file
y = ld8bit('test.dat',30);
plot(y);
max(y)

% max should be 30

pause % press key to continue

% data
x = 1:140;

% save to file
sv8bit('test.dat',x);

% read from file
y = ld8bit('test.dat',30,31);
plot(y);
max(y)
min(y)

% max should be 60, min should be 31

pause % press key to continue

% data
x = 1:140;

% save to file
sv8bit('test.dat',x);

% read from file
y = ld8bit('test.dat',0,31);
plot(y);
max(y)
min(y)
length(y)

% max should be 127, min should be 31, length 110

% ------------------------------------------------------------
pause % press key to test 16-bit functions

% data
x = -140:140;

% save to file
sv16bit('test.dat',x);

% read from file
y = ld16bit('test.dat');
plot(y);
max(y)
min(y)

pause % press key to continue

% data
x = 1:140;

% save to file
sv16bit('test.dat',x);

% read from file
y = ld16bit('test.dat',30);
plot(y);
max(y)

% max should be 30

pause % press key to continue

% data
x = 1:140;

% save to file
sv16bit('test.dat',x);

% read from file
y = ld16bit('test.dat',30,31);
plot(y);
max(y)
min(y)

% max should be 60, min should be 31

pause % press key to continue

% data
x = 1:140;

% save to file
sv16bit('test.dat',x);

% read from file
y = ld16bit('test.dat',0,31);
plot(y);
max(y)
min(y)
length(y)

% max should be 140, min should be 31, length 110


% ------------------------------------------------------------
pause % press key to test 32-bit functions

% data
x = -140:140;

% save to file
sv32bit('test.dat',x);

% read from file
y = ld32bit('test.dat');
plot(y);
max(y)
min(y)

pause % press key to continue

% data
x = 1:140;

% save to file
sv32bit('test.dat',x);

% read from file
y = ld32bit('test.dat',30);
plot(y);
max(y)

% max should be 30

pause % press key to continue

% data
x = 1:140;

% save to file
sv32bit('test.dat',x);

% read from file
y = ld32bit('test.dat',30,31);
plot(y);
max(y)
min(y)

% max should be 60, min should be 31

pause % press key to continue

% data
x = 1:140;

% save to file
sv32bit('test.dat',x);

% read from file
y = ld32bit('test.dat',0,31);
plot(y);
max(y)
min(y)
length(y)

% max should be 140, min should be 31, length 110


