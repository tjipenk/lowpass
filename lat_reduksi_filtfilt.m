Fs = 23;
T = 1/Fs;
L = 23*6;
t = (0:L-1)*T;
x = 8000*sin(2*pi*3*t)+8000*sin(2*pi*2*t);
y = x + 1000*randn(size(t))+1500*sin(2*pi*100*t)+2000*sin(2*pi*200*t);

h=fdesign.lowpass('Fp,Fst,Ap,Ast',4,6,6000,120,23);
d=design(h,'equiripple');
y1=filtfilt(d.Numerator,1,y);
y2=filter(d.Numerator,1,y);
%plot(y);
plot(x,'--');
hold on
plot(y1/2,'r');
plot(y2,'g');

hold off