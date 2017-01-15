%% Low pass Filter
% data centroid
cent = dlmread('sawah_allyears.txt-64.cluster_centres');
cent = int32(cent');
cent = cent(2:end,:);

% data mentah
filename = 'sawah_2015.tif.txt';
data = single(dlmread(filename));
data = data(:,2:end);
cth = data(int32(rand(1,1000)*10000),:);
smpl = cth(1:10,:)';
smpl = repmat(smpl,3,1);
data = repmat(data',3,1);

%plot(smpl);

a = double(smpl(:,2:4));
b = tsmovavg(a,'s',5,1);
%plot(a)
%% 
h=fdesign.lowpass('N,Fc',8,4,23);
designmethods(h)
d=design(h);
%%
%h=fdesign.lowpass('Fp,Fst,Ap,Ast',4,5,6000,70,23);

%h=fdesign.lowpass('Fp,Fst,Ap,Ast',4,5,4000,100,23);
%d=design(h,'equiripple');

%fvtool(d)

y1=filtfilt(d.Numerator,1,a);
y2=filter(d.Numerator,1,a);
y3=filter(d.Numerator,1,flipud(y2));
y3=flipud(y3);

%%filter data mentah
z1=filter(d.Numerator,1,data);
z2=filter(d.Numerator,1,flipud(z1));
z2=flipud(z2);

z2 = int32(z2(24:46,:)');
fltdatatxt(:,1) = int32(1:size(z2,1));
fltdatatxt(:,2:size(z2,2)+1) = z2;
%plot(y);
plot(a,'-+');
hold on
%plot(b,'--');
%plot(y1/2,'r');
%plot(y2,'g');
plot(y3,'-*');

hold off

fName = ['lowpass-',filename];         %# A file name
fid = fopen(fName,'w');            %# Open the file
dlmwrite(fName,z2,'-append',...  %# Print the matrix
         'delimiter','\t',...
         'newline','pc');
    
fclose(fid);
