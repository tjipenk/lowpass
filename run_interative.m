%dclear = 1;
%dnoise = 1;
%r_loc_data-max = 1;
%r_loc_data-min = 1;
%r_loc_denoise = 1;
%v_loc_data = 1;
%v_loc_denoise = 1;
for a = 1:100

    close all;

    Fs = 23;
    T = 1/Fs;
    L = 23*3;
    t = (0:L-1)*T;
    x = 4000+3000*sin(2*pi*3*t)+2000*sin(2*pi*2*t);
    y = x + 1400*randn(size(t))+700*sin(2*pi*100*t)+900*sin(2*pi*200*t);
    dclear(a,:)=x;
    dnoise(a,:)=y;
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
    r_loc_datamax{a}(:,1)=maxtab(:,1);
    r_loc_datamin{a}(:,1)=mintab(:,1);
    v_loc_datamax{a}(:,1)=maxtab(:,2);
    v_loc_datamin{a}(:,1)=mintab(:,2);
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
    r_loc_denoismax{a}(:,1)=maxtab(:,1);
    r_loc_denoismin{a}(:,1)=mintab(:,1);
    v_loc_denoismax{a}(:,1)=maxtab(:,2);
    v_loc_denoismin{a}(:,1)=mintab(:,2);
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

end
%% Local Minimum Detection
y11 = int16(diff(y1,1));
y12 = int16(diff(y1,2));