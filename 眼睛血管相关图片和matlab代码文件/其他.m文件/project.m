clc;
clear all;
close all;
im=imread('C:\05_test.tif');    %导入图片

%% 0 掩膜mask                                行不通呀，小老弟。
% im=imread('C:\05_test.tif');                     %导入图片
% segM=imread('C:\Users\余晖\Desktop\mask.png') %掩膜图片，为透明的png图片
% s_img=size(im);
% %%change the interested area to 1
% for i=1:s_img(1)
%     for j=1:s_img(2)
%         if segM(i,j)==255
%             segM(i,j)=1;
%         end
%     end
% end
% %%deal with the R, G, B channels
% R=im(:,:,1);
% G=im(:,:,2);
% B=im(:,:,3);
% result(:,:,1)=R.*uint8(segM);
% result(:,:,2)=G.*uint8(segM);
% result(:,:,3)=B.*uint8(segM);
% %%output the result
% imwrite([output path]);
% figure;
% imshow(result);

%% 1.中值滤波
img = rgb2gray(im);
img_midFil = median_filter(img,3);  %模板的大小3*3的模板，m=3
figure;
subplot(121);
imshow(img_midFil);
title('step1. 灰度化后中值滤波');

%% 2.光均衡化处理
% 函数histeq（）进行直方图均衡化处理
J=histeq(img_midFil);  %直方图均衡化
subplot(122);
imshow((J));
title('step2. 中值滤波后光均衡化');

%% 3.匹配滤波
sigma=1;
yLength=8;
direction_number=15;
MF = MatchFilter(J, sigma, yLength,direction_number); %光均衡化的结果-->匹配滤波
mask=[0 0 0 0 0;
    0 1 1 1 0;
    0 1 1 1 0;
    0 1 1 1 0;
    0 0 0 0 0;];
MF(mask==0) = 0;
MF = normalize(double(MF));
% Adding to features
features = MF;      %匹配滤波的效果图
figure;
imshow(features);
title('step3. 光均衡化后匹配滤波1');


%%  4.匹配滤波之后,进行形态学操作
%%  因为step3.光均衡化后匹配滤波1的效果很差，因此不可以直接进行匹配滤波，所以要进行step4。别问为什么！

BW = im2bw(features,0.4);%用于膨胀：im2bw使用阈值变换法把灰度图像转换成二值图像;level就是设置阈值的，取值范围[0, 1]。
SE=strel('disk',1);      %用于腐蚀：disk圆形，R=1是从结构元素原点到菱形最远的距离

img_er=imerode(img_midFil,SE); %中值滤波之后，直接腐蚀
figure;
subplot(121);
imshow(2*img_er);               %乘以2是为了调整亮度，显示出来的图像看的更亮。
title('step4.1 中值滤波后图像腐蚀');

closeOp = imclose(img_er,SE);  %闭操作之后的图才会好看点，别问我为什么！
subplot(122);
imshow(closeOp);
title('step4.2 图像腐蚀后闭操作');


%% 5.二次匹配滤波 (进行了上面的形态学操作之后，再进行匹配滤波，对比两次结果知道，这次的效果更好)
sigma=2;%改变血管粗细
yLength=15;
direction_number=40;
MF = MatchFilter(closeOp, sigma, yLength,direction_number);
mask=[0 0 0 0 0;
    0 1 1 1 0;
    0 1 1 1 0;
    0 1 1 1 0;
    0 0 0 0 0;];
MF(mask==0) = 0;
MF = normalize(double(MF));
% Adding to features
features = MF;
figure;
imshow(features*2);       %乘以2是为了调整亮度，显示出来的图像看的更亮。
title('step5 闭操作后匹配滤波2'); %这个效果最好，但是仍然存在两个问题——1.轮廓 2.眼球里面有若影若现的小血管