function [BW,thresh]=bwfilter(img,bw0)
%% �Ƚ�img����bw0��ǳ������ػҶ�ֵ����ֵ�Ĺ�ϵ���Ӷ���һ�����bw0�в����ϻҶ�����������
%% �õ�һ���µĶ�ֵͼ��BW
Image=adapthisteq(img);%����Ӧֱ��ͼ���⻯
[m,n]=size(Image);
threshold=graythresh(Image);%��ʹ�������䷽��ҵ�ͼƬ��һ�����ʵ���ֵ��threshold��
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