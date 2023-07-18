function [BW,thresh]=bwfilter(img,bw0)
%% 比较img中由bw0标记出的像素灰度值与阈值的关系，从而进一步清除bw0中不符合灰度条件的像素
%% 得到一个新的二值图像BW
Image=adapthisteq(img);%自适应直方图均衡化
[m,n]=size(Image);
threshold=graythresh(Image);%是使用最大类间方差法找到图片的一个合适的阈值（threshold）
Gamma=0.8;
T=Gamma*threshold*255;
BW=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        if(bw0(i,j)==1)
            temp=Image(i-1:i+1,j-1:j+1)<=T;
            if(Image(i,j)<=T)
                number=length(find(temp==1))-1;
            else
                number=length(find(temp==1));
            end
            if (Image(i,j)<=T&&(number>0))
                BW(i,j)=1;
            elseif((Image(i,j)>T)&&(number>2)&&(number<7))
                BW(i,j)=1;
            end
        end
    end
end
thresh=T;
end