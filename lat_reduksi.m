clear all;
close all;

mul = 3; %replikasi
Fs = 23;
T = 1/Fs;
L = 23*1;
t = (0:L-1)*T;
x = 4000+3000*sin(2*pi*3*t)+2000*sin(2*pi*2*t);
noise = 1400*randn(size(t)) + 200*randn(size(t));
%y = x + 1400*randn(size(t))+700*sin(2*pi*100*t)+900*sin(2*pi*200*t);
y = x + noise;

%% Replication Matrix
x = repmat(x',mul,1); x = x';
y = repmat(y',mul,1); y = y';
t = (0:L*mul-1)*T;
%% plot
subplot(3,1,1);
plot(Fs*t,x,'-+');
hold on
plot(Fs*t,y,'r-*');
hold off

%%  Filter Design
h=fdesign.lowpass('N,Fc',8,4,23);
%designmethods(h);
d=design(h);

%% De-noiseing
y1=filter(d.Numerator,1,y);
y1=filter(d.Numerator,1,fliplr(y1));
y1=fliplr(y1);

subplot(3,1,2);
plot(Fs*t,y,'r-*');
hold on
plot(Fs*t,y1,'g-o');
hold off

subplot(3,1,3);
plot(Fs*t,x,'-+');
hold on
plot(Fs*t,y1,'g-o');
hold off


%% peak detection
figure;
subplot(3,1,1);
plot(t,x);
hold on
[maxtab, mintab] = peakdet(x, 0.5, t);
plot(mintab(:,1), mintab(:,2), 'g*');
plot(maxtab(:,1), maxtab(:,2), 'r*');
hold off

subplot(3,1,2);
plot(t,y,'--'); 
hold on
[maxtab, mintab] = peakdet(y, 0.5, t);
plot(mintab(:,1), mintab(:,2), 'g*');
plot(maxtab(:,1), maxtab(:,2), 'r*');
hold off


subplot(3,1,3);
plot(t,y1,'r');
hold on
[maxtab, mintab] = peakdet(y1, 0.5, t);
plot(mintab(:,1), mintab(:,2), 'g*');
plot(maxtab(:,1), maxtab(:,2), 'r*');
hold off

figure;
plot(t,x);
hold on
[maxtab, mintab] = peakdet(x, 0.5, t);
plot(mintab(:,1), mintab(:,2), 'g+');
plot(maxtab(:,1), maxtab(:,2), 'r+');

plot(t,y1,'r');
[maxtab, mintab] = peakdet(y1, 0.5, t);
plot(mintab(:,1), mintab(:,2), 'go');
plot(maxtab(:,1), maxtab(:,2), 'ro');
hold off

%% Local Minimum Detection
y11 = int16(diff(y1,1));
y12 = int16(diff(y1,2));



