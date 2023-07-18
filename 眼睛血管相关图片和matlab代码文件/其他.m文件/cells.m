Image = imread('spots.tif');
figure,imshow(Image);
title('ԭͼ');
Theshold = graythresh(Image);%ȡ��ͼ���ȫ����ֵ
Image_BW = im2bw(Image,Theshold);%��ֵ��ͼ��
figure,imshow(Image_BW);
title('���ζ�ֵ��ͼ��');
%��������ֵ��ͼ�����
Image_BW_medfilt= medfilt2(Image_BW,[13 13]);
figure,imshow(Image_BW_medfilt);
title('��ֵ�˲���Ķ�ֵ��ͼ��');
%���Ĳ���ͨ�������ζ�ֵ��ͼ���롰��ֵ�˲���Ķ�ֵ��ͼ�񡱽��С��������Ż�ͼ��Ч��
Optimized_Image_BW = Image_BW_medfilt|Image_BW;
figure,imshow(Optimized_Image_BW);
title('���С��������Ż�ͼ��Ч��');
%���岽���Ż����ֵ��ͼ��ȡ������֤����1��-������ɫ������0��-������ɫ��
%��������Ĳ���
Reverse_Image_BW = ~Optimized_Image_BW;
figure,imshow(Reverse_Image_BW);
title('�Ż����ֵ��ͼ��ȡ��');
%����������������ͼ��ı���ɫ��ȥ��ϸ���ڵĺ�ɫ��϶
Filled_Image_BW = bwfill(Reverse_Image_BW,'holes');
figure, imshow(Filled_Image_BW);
title('����䱳��ɫ�Ķ�����ͼ��');
%���߲�����ͼ����п����㣬ȥ��ϸ����ϸ��֮����ճ���Ĳ���
SE = strel('disk',4);
Open_Image_BW = imopen(Filled_Image_BW,SE);
figure, imshow(Open_Image_BW);
title('��������ͼ��');
%-----------------------------------------------
%-------------��ʼ����ϸ����--------------------
%-----------------------------------------------
[Label,Number]=bwlabel(Open_Image_BW,8)%����ȡ��ϸ������
Array = bwlabel(Open_Image_BW,8);%ȡ������ǩ������ͼ��
Sum = [];
%����ͳ������ǩ������
for i=1:Number
[r,c] = find(Array==i);%��ȡ��ͬ��ǩ�ŵ�λ�ã���λ����Ϣ����[r,c]
rc = [r c];
Num = length(rc);%ȡ��vc�����Ԫ�صĸ���
Sum([i])=Num;%��Ԫ�ظ�������Sum����
end
Sum
N = 0;
%����Sum�����е�Ԫ�ش�����1500����ʾ������ϸ�����������ص�϶࣬����Ϊ����ϸ����
for i=1:length(Sum)
if(Sum([i])) > 500
N = N+1;
end
end
%-------------------------------------------
%------------------ͳ������ϸ����-----------
%-------------------------------------------
Number = Number+N
