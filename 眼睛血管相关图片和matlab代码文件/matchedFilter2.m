function [g,bg]=matchedFilter2(f)
 
f=double(f);
% mean filter
f=medfilt2(f,[5,5]);
f=medfilt2(f,[21 1]);
f=medfilt2(f,[1,7]);
 
% 参数
os=24;  % 角度的个数
sigma=2;
tim=6;
L=18;
t=21; % threshhold
 
thetas=0:(os-1);
thetas=thetas.*(180/os);
N1=-tim*sigma:tim*sigma;
N1=-exp(-(N1.^2)/(2*sigma*sigma));
N=repmat(N1,[2*floor(L/2)+1,1]);
r2=floor(L/2);
c2=floor(tim*sigma);
[m,n]=size(f);
RNs=cell(1,os);  % rotated kernals
MFRs=cell(1,os); % filtered images
g1=f;
 
% matched filter
for i=1:os
    theta=thetas(i);
    RN=imrotate(N,theta);
    %去掉多余的0行和零列
    RN=RN(:,any(RN));
    RN=RN(any(RN'),:);
    meanN=mean2(RN);
    RN=RN-meanN;
    RNs{1,i}=RN;
    MFRs{1,i}=imfilter(f,RN,'conv','symmetric');
end
 
% get the max response
g=MFRs{1,1};
for j=2:os
    g=max(g,MFRs{1,j});
end
bg=g<t;
 
end