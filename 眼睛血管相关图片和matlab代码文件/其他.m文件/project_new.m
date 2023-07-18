clc;
clear all;
close all;
image=imread('D:\test_DRIVE\06_test.tif');    %����ͼƬ�����˺ܶ���Ч���������ԣ����Ѿ�����õ�Ч���ˡ�
%% 1.ѡȡ��ɫͨ��
imager = image(:,:,1);%��
imageg = image(:,:,2);%��
imageb = image(:,:,3);%��

figure;
subplot(131);imshow(imager);title('��ɫͨ��');
subplot(132);imshow(imageg);title('��ɫͨ��');
subplot(133);imshow(imageb);title('��ɫͨ��');

%% 2.����Ӧֱ��ͼ����
figure;
subplot(121);  
H1=adapthisteq(imageg);  
imshow(H1); title('adapthisteq�����ͼ');  
subplot(122);  
imhist(H1);title('adapthisteq�����ֱ��ͼ');  

%% 3.ƥ���˲�
sigma=2;       %�ı�Ѫ�ܴ�ϸ��             ---->����Ӱ������Ч���ĵ�1�����ء�
yLength=14;      %LԽ��ƽ��Ч��Խ����    ---->����Ӱ������Ч���ĵ�2�����ء�
direction_number=21;
MF = MatchFilter(H1, sigma, yLength,direction_number); %����⻯�Ľ��-->ƥ���˲�
mask=[0 0 0 0 0;  %�Ҳ�֪���������ô����һ��ʼ��3x3�ģ��Ҹ���һ��
    0 1 1 1 0;
    0 1 1 1 0;
    0 1 1 1 0;
    0 0 0 0 0;];
MF(mask==0) = 0;
MF = normalize(double(MF));
features = MF;      %ƥ���˲���Ч��ͼ
figure;
subplot(221);
imshow(features*3);
title('ƥ���˲�');

% ͨ������imadjust()�����Ҷ�ͼ��Ҷȷ�Χ
im_adjust=imadjust(features,[0.15 0.5],[0 1]);  %�����Ҷȷ�Χ---->����Ӱ������Ч���ĵ�3�����ء�
subplot(222);imshow((im_adjust));
title('imadjust()�����Ҷ�ͼ��Ҷ�');

%��ֵ��
threshold2 = graythresh(im_adjust)%�Զ�ȷ����ֵ����ֵ,һ�㶼��׼ȷ������Ϊʲô�����̫���ˣ������ֶ�����
binary_data1 = im2bw(im_adjust,threshold2);%��ͼ����ж�ֵ��
subplot(223);
imshow(binary_data1);
title('��ֵͼ');

%% 4.ȥ��������:��õĲ���ƥ���˲������gabor�˲������������������ģ���ϧʵ�ֲ��ˡ�
img = imread('C:\05_test.tif');
img = rgb2gray(img);
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

figure;
subplot(221);
imshow(img_out);
title('�����Ĥ');

new_img = imsubtract(features,double(img_out));
subplot(222);
imshow(new_img);
title('�����Ҷ�ͼ');

threshold = graythresh(new_img)%�Զ�ȷ����ֵ����ֵ,һ�㶼��׼ȷ������Ϊʲô�����̫���ˣ������ֶ�����
SE=strel('disk',6);      %�������ͣ������Ҫ���ģ���ΪҪ����testͼƬ����������ֵô���ˣ������������ɾ���
new_img=imdilate(new_img,SE); %��ֵ�˲�֮��,����
subplot(223);
binary_data2 = im2bw(new_img,threshold);%��ͼ����ж�ֵ��,�ֶ�����
imshow(binary_data2);
title('������ֵͼ');

binary_data = binary_data1-binary_data2;%
subplot(224);
imshow(binary_data);
title('���յĶ�ֵͼ');

%% 5.ͼ����ȥ������;�ϵ�����;��ʴ���͵�
result = medfilt2(binary_data,[2 2]);%��ֵ�˲�
figure;
subplot(121);
imshow(result);
title('��ֵ�˲�');

% SE=strel('disk',1);      %��������
% img_out=imdilate(result,SE); %��ֵ�˲�֮��,����
% subplot(122);imshow(img_out);title('����');