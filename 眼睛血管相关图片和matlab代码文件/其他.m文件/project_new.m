clc;
clear all;
close all;
image=imread('D:\test_DRIVE\06_test.tif');    %导入图片，试了很多张效果都还可以，这已经是最好的效果了。
%% 1.选取绿色通道
imager = image(:,:,1);%红
imageg = image(:,:,2);%绿
imageb = image(:,:,3);%蓝

figure;
subplot(131);imshow(imager);title('红色通道');
subplot(132);imshow(imageg);title('绿色通道');
subplot(133);imshow(imageb);title('蓝色通道');

%% 2.自适应直方图均衡
figure;
subplot(121);  
H1=adapthisteq(imageg);  
imshow(H1); title('adapthisteq均衡后图');  
subplot(122);  
imhist(H1);title('adapthisteq均衡后直方图');  

%% 3.匹配滤波
sigma=2;       %改变血管粗细。             ---->这是影响最终效果的第1个因素。
yLength=14;      %L越大，平滑效果越明显    ---->这是影响最终效果的第2个因素。
direction_number=21;
MF = MatchFilter(H1, sigma, yLength,direction_number); %光均衡化的结果-->匹配滤波
mask=[0 0 0 0 0;  %我不知道这个是怎么调的一开始是3x3的，我改了一下
    0 1 1 1 0;
    0 1 1 1 0;
    0 1 1 1 0;
    0 0 0 0 0;];
MF(mask==0) = 0;
MF = normalize(double(MF));
features = MF;      %匹配滤波的效果图
figure;
subplot(221);
imshow(features*3);
title('匹配滤波');

% 通过函数imadjust()调整灰度图像灰度范围
im_adjust=imadjust(features,[0.15 0.5],[0 1]);  %调整灰度范围---->这是影响最终效果的第3个因素。
subplot(222);imshow((im_adjust));
title('imadjust()调整灰度图像灰度');

%二值化
threshold2 = graythresh(im_adjust)%自动确定二值化阈值,一点都不准确，别问为什么。相差太多了，不如手动调。
binary_data1 = im2bw(im_adjust,threshold2);%对图像进行二值化
subplot(223);
imshow(binary_data1);
title('二值图');

%% 4.去轮廓操作:最好的操作匹配滤波后加上gabor滤波，那样才是最完美的，可惜实现不了。
img = imread('C:\05_test.tif');
img = rgb2gray(img);
[m n] = size(img);
img_hist = zeros(1,256);
for i = 1:m
    for j = 1:n
        img_hist(img(i, j)+1) = img_hist(img(i, j)+1) + 1;
    end
end
img_hist_pro = img_hist/m/n;         %灰度级概率密度分布
sigma2_max = 0;threshold = 0;
for t = 0:255
    w0 = 0;w1 = 0; u0 = 0; u1 = 0; u = 0;
    for q = 0:255
        if q <= t
            w0 = w0 + img_hist_pro(q+1);
            u0 = u0 + (q)*img_hist_pro(q+1);
        else
            w1 = w1 + img_hist_pro(q+1);
            u1 = u1 + (q)*img_hist_pro(q+1);
        end
    end
    u = u0 + u1;
    u0 = u0 / (w0+eps);
    u1 = u1 / (w1+eps);
    sigma2 = w0 * (u0 - u)^2 + w1 * (u1 - u)^2;     %求取类间最小
    if (sigma2 > sigma2_max)
        sigma2_max = sigma2;
        threshold = t;
    end
end
img_out = img;
for i = 1:m                                         %阈值化
    for j = 1:n
        if img(i, j) >= threshold;
            img_out(i, j) = 255;
        else 
            img_out(i, j) = 0;
        end
    end
end

figure;
subplot(221);
imshow(img_out);
title('获得掩膜');

new_img = imsubtract(features,double(img_out));
subplot(222);
imshow(new_img);
title('轮廓灰度图');

threshold = graythresh(new_img)%自动确定二值化阈值,一点都不准确，别问为什么。相差太多了，不如手动调。
SE=strel('disk',6);      %用于膨胀，这个不要随便改，因为要消除test图片的轮廓智能值么大了，否则消除不干净。
new_img=imdilate(new_img,SE); %中值滤波之后,膨胀
subplot(223);
binary_data2 = im2bw(new_img,threshold);%对图像进行二值化,手动调参
imshow(binary_data2);
title('轮廓二值图');

binary_data = binary_data1-binary_data2;%
subplot(224);
imshow(binary_data);
title('最终的二值图');

%% 5.图像处理：去噪声点;断点连续;腐蚀膨胀等
result = medfilt2(binary_data,[2 2]);%中值滤波
figure;
subplot(121);
imshow(result);
title('中值滤波');

% SE=strel('disk',1);      %用于膨胀
% img_out=imdilate(result,SE); %中值滤波之后,膨胀
% subplot(122);imshow(img_out);title('膨胀');