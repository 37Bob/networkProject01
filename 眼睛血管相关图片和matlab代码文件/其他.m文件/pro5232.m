clc;
clear all;
close all;
im=imread('C:\test_DRIVE\05_test.tif');    %导入图片
%% 中值滤波
img = rgb2gray(im);
img_midFil = median_filter(img,3);  %模板的大小3*3的模板，m=3
figure;
imshow(img_midFil);
title('step1. 灰度化后中值滤波');

%% 光均衡化处理
% 函数histeq（）进行直方图均衡化处理
balance=histeq(img_midFil);  %直方图均衡化
figure;
imshow(balance);
title('光均衡化');

%% 匹配滤波:视网膜血管增强
sigma=3;%改变血管粗细
yLength=9;
direction_number=12;
MF = MatchFilter(img_midFil, sigma, yLength,direction_number);
mask=[0 0 0 0 0;
    0 1 1 1 0;
    0 1 1 1 0;
    0 1 1 1 0;
    0 0 0 0 0;];
MF(mask==0) = 0;
MF = normalize(double(MF));
features = MF;
figure;
imshow(features*2);       %乘以2是为了调整亮度，显示出来的图像看的更亮。
title('后匹配滤波'); %有问题：1.轮廓 2.眼球里面有若影若现的小血管
imwrite(features,'04_test.jpg');


%% 去轮廓操作
img = imread('C:\05_test.tif');
img = rgb2gray(img);
figure;imshow(img, [])
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
new_img = imsubtract(features,double(img_out));
figure;
imshow(new_img);
title('眼睛轮廓');

threshold = graythresh(new_img)%自动确定二值化阈值,一点都不准确，别问为什么。相差太多了，不如手动调。
binary_data1 = im2bw(new_img,threshold);%对图像进行二值化
threshold2 = graythresh(features)%自动确定二值化阈值,一点都不准确，别问为什么。相差太多了，不如手动调。
binary_data2 = im2bw(features,threshold2);%对图像进行二值化

%binary_data2:有轮廓的图片;binary_data1:眼睛的轮廓; 
result= binary_data2-binary_data1;%没有轮廓的眼睛血管二值图
figure;
imshow(result);
title('结果图：去掉轮廓的二值图');
