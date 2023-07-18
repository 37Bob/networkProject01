clc;
clear all;
close all;
im=imread('C:\05_test.tif');    %����ͼƬ

%% 0 ��Ĥmask                                �в�ͨѽ��С�ϵܡ�
% im=imread('C:\05_test.tif');                     %����ͼƬ
% segM=imread('C:\Users\����\Desktop\mask.png') %��ĤͼƬ��Ϊ͸����pngͼƬ
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

%% 1.��ֵ�˲�
img = rgb2gray(im);
img_midFil = median_filter(img,3);  %ģ��Ĵ�С3*3��ģ�壬m=3
figure;
subplot(121);
imshow(img_midFil);
title('step1. �ҶȻ�����ֵ�˲�');

%% 2.����⻯����
% ����histeq��������ֱ��ͼ���⻯����
J=histeq(img_midFil);  %ֱ��ͼ���⻯
subplot(122);
imshow((J));
title('step2. ��ֵ�˲������⻯');

%% 3.ƥ���˲�
sigma=1;
yLength=8;
direction_number=15;
MF = MatchFilter(J, sigma, yLength,direction_number); %����⻯�Ľ��-->ƥ���˲�
mask=[0 0 0 0 0;
    0 1 1 1 0;
    0 1 1 1 0;
    0 1 1 1 0;
    0 0 0 0 0;];
MF(mask==0) = 0;
MF = normalize(double(MF));
% Adding to features
features = MF;      %ƥ���˲���Ч��ͼ
figure;
imshow(features);
title('step3. ����⻯��ƥ���˲�1');


%%  4.ƥ���˲�֮��,������̬ѧ����
%%  ��Ϊstep3.����⻯��ƥ���˲�1��Ч���ܲ��˲�����ֱ�ӽ���ƥ���˲�������Ҫ����step4������Ϊʲô��

BW = im2bw(features,0.4);%�������ͣ�im2bwʹ����ֵ�任���ѻҶ�ͼ��ת���ɶ�ֵͼ��;level����������ֵ�ģ�ȡֵ��Χ[0, 1]��
SE=strel('disk',1);      %���ڸ�ʴ��diskԲ�Σ�R=1�ǴӽṹԪ��ԭ�㵽������Զ�ľ���

img_er=imerode(img_midFil,SE); %��ֵ�˲�֮��ֱ�Ӹ�ʴ
figure;
subplot(121);
imshow(2*img_er);               %����2��Ϊ�˵������ȣ���ʾ������ͼ�񿴵ĸ�����
title('step4.1 ��ֵ�˲���ͼ��ʴ');

closeOp = imclose(img_er,SE);  %�ղ���֮���ͼ�Ż�ÿ��㣬������Ϊʲô��
subplot(122);
imshow(closeOp);
title('step4.2 ͼ��ʴ��ղ���');


%% 5.����ƥ���˲� (�������������̬ѧ����֮���ٽ���ƥ���˲����Ա����ν��֪������ε�Ч������)
sigma=2;%�ı�Ѫ�ܴ�ϸ
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
imshow(features*2);       %����2��Ϊ�˵������ȣ���ʾ������ͼ�񿴵ĸ�����
title('step5 �ղ�����ƥ���˲�2'); %���Ч����ã�������Ȼ�����������⡪��1.���� 2.������������Ӱ���ֵ�СѪ��