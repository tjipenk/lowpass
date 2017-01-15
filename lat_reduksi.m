Fs = 23;
T = 1/Fs;
L = 23*6;
t = (0:L-1)*T;
x = 8000*sin(2*pi*3*t)+8000*sin(2*pi*2*t);
y = x + 1000*randn(size(t))+1500*sin(2*pi*100*t)+2000*sin(2*pi*200*t);
plot(Fs*t(1:50),x(1:50));
hold on
plot(Fs*t(1:50),y(1:50),'--');
hold off

figure;
plot(Fs*t,y);
hold on
plot(Fs*t,sig2.data,'r');
hold off

figure;
plot(Fs*t,x);
hold on
plot(Fs*t,sig2.data,'r');
hold off
