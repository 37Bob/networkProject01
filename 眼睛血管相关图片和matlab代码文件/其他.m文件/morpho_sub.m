function out_img = morpho_sub(img)
A = img;
B=[0 1 0
   1 1 1
   0 1 0];
% B=strel('disk',3);

%����
for i =1:6
    A=imdilate(A,B);
end
% subplot(1,2,1),imshow(A);
% title('ʹ��B��6�����ͺ��ͼ��');

%��ʴ
for i =1:6
    A=imerode(A,B);
end
% subplot(1,2,2),imshow(A);
% title('ʹ��B��6�����ͺ��ͼ��');

se1=strel('disk',7);%�����Ǵ���һ���뾶Ϊ5��ƽ̹��Բ�̽ṹԪ��
A=imerode(A,se1);

A=A-img;
A=255-A-50;
out_img = A;

% figure, imshow(out_img);
end
