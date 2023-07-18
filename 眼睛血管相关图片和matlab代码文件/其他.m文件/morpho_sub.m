function out_img = morpho_sub(img)
A = img;
B=[0 1 0
   1 1 1
   0 1 0];
% B=strel('disk',3);

%膨胀
for i =1:6
    A=imdilate(A,B);
end
% subplot(1,2,1),imshow(A);
% title('使用B后6次膨胀后的图像');

%腐蚀
for i =1:6
    A=imerode(A,B);
end
% subplot(1,2,2),imshow(A);
% title('使用B后6次膨胀后的图像');

se1=strel('disk',7);%这里是创建一个半径为5的平坦型圆盘结构元素
A=imerode(A,se1);

A=A-img;
A=255-A-50;
out_img = A;

% figure, imshow(out_img);
end
