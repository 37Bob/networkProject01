clc;
clear all;
close all;
im=imread('C:\test_DRIVE\05_test.tif');    %����ͼƬ
%% ��ֵ�˲�
img = rgb2gray(im);
img_midFil = median_filter(img,3);  %ģ��Ĵ�С3*3��ģ�壬m=3
figure;
imshow(img_midFil);
title('step1. �ҶȻ�����ֵ�˲�');

%% ����⻯����
% ����histeq��������ֱ��ͼ���⻯����
balance=histeq(img_midFil);  %ֱ��ͼ���⻯
figure;
imshow(balance);
title('����⻯');

%% ƥ���˲�:����ĤѪ����ǿ
sigma=3;%�ı�Ѫ�ܴ�ϸ
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
imshow(features*2);       %����2��Ϊ�˵������ȣ���ʾ������ͼ�񿴵ĸ�����
title('��ƥ���˲�'); %�����⣺1.���� 2.������������Ӱ���ֵ�СѪ��
imwrite(features,'04_test.jpg');


%% ȥ��������
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
img_hist_pro = img_hist/m/n;         %�Ҷȼ������ܶȷֲ�
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
    sigma2 = w0 * (u0 - u)^2 + w1 * (u1 - u)^2;     %��ȡ�����С
    if (sigma2 > sigma2_max)
        sigma2_max = sigma2;
        threshold = t;
    end
end
img_out = img;
for i = 1:m                                         %��ֵ��
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
title('�۾�����');

threshold = graythresh(new_img)%�Զ�ȷ����ֵ����ֵ,һ�㶼��׼ȷ������Ϊʲô�����̫���ˣ������ֶ�����
binary_data1 = im2bw(new_img,threshold);%��ͼ����ж�ֵ��
threshold2 = graythresh(features)%�Զ�ȷ����ֵ����ֵ,һ�㶼��׼ȷ������Ϊʲô�����̫���ˣ������ֶ�����
binary_data2 = im2bw(features,threshold2);%��ͼ����ж�ֵ��

%binary_data2:��������ͼƬ;binary_data1:�۾�������; 
result= binary_data2-binary_data1;%û���������۾�Ѫ�ܶ�ֵͼ
figure;
imshow(result);
title('���ͼ��ȥ�������Ķ�ֵͼ');
