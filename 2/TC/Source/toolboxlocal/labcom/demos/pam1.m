% Demostarción señal PAM.

close;
A = 1;
f1 = 2500;
f2 = 4000;
f = 0:200:5000;

% Calculando las señales y sus espectros.
W = zeros(length(f),1);
for (i = 1:1:length(f));
  W(i) = A*w1(f(i),f1) -A*w2(f(i),f1,f2);
end;

% Creando las PAM
fprintf('Calculando los espectros de las señales\n');
fs = 10000;
tau = 50e-6;
Ts = 1/fs;
d = tau/Ts;
fn = -50000:200:50000;
Ws = zeros(length(fn),1);
W1s = zeros(length(fn),1);
for (i = 1:1:length(fn));
  Ws(i) = 0;
  W1s(i) = 0;
  for (n = -5:1:5)
  % Recreating W(f) from above
    Wtemp = A*w1(fn(i)-n*fs,f1) -A*w2(fn(i)-n*fs,f1,f2);
    Ws(i) = Ws(i) + Sa(pi*n*d)*Wtemp;
    W1s(i) = W1s(i) + Wtemp;
  end;
  Ws(i) = d*Ws(i);
end;
W1s = tau/Ts*Sa(pi*tau*fn).*W1s;


plot_inf(3);

plot(f,W);
xlabel('f');
title('Módulo del espectro de la señal original');
pause;

plot(fn,abs(Ws));
xlabel('f');
title('Módulo del espectro de la PAM de muestreo natural');
pause;

plot(fn,abs(W1s));
xlabel('f');
title('Módulo del espectro de la PAM instantánea.');
pause;
close;



