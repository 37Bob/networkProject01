% Retinal Blood Vessel Segmentation Test
clc; clear all; close all;
I = imread('C:\05_test.tif');
figure(1), imshow(I),title('original image');
% Resize image for easier computation
[len,wid,channel]=size(I);
B = imresize(I, [len/4 wid/4]);
% B = imresize(I, [600 600]);

% Convert RGB to Gray via PCA
lab = rgb2lab(im2double(B));
%get wlab's method1
% f = 0;
% A_F=cat(3,1-f,f/2,f/2);
% B_F=bsxfun(@times,A_F,lab);
% wlab = reshape(B_F,[],3);

%get wlab's method2,same to method1
lab(:,:,2)=0;lab(:,:,3)=0;
wlab = reshape(lab,[],3);

[C,S] = pca(wlab);
S = reshape(S,size(lab));
S = S(:,:,1);
gray = (S-min(S(:)))./(max(S(:))-min(S(:)));

%% Contrast Enhancment of gray image using CLAHE
J = adapthisteq(gray,'numTiles',[8 8],'nBins',256);

%% Background Exclusion
% Apply Average Filter
h = fspecial('average', [11 11]);
JF = imfilter(J, h);
% Take the difference between the gray image and Average Filter
Z = imsubtract(JF, J);
figure(2),
subplot(211),imshow(JF),title('CLAHE后均值滤波');
subplot(212), imshow(Z),title('CLAHE后均值滤波差值');
%% Threshold using the IsoData Method
%level=isodata(Z) ; % threshold level
level = graythresh(Z);
%% Convert to Binary
BW = im2bw(Z, level-0.008);
%% Remove small pixels
BW2 = bwareaopen(BW, 50); %删除二值图像BW中面积小于60的对象，默认情况下使用8邻域
figure(3),
subplot(211),imshow(BW),title('BW');
subplot(212),imshow(BW2),title('BW2_1');
%% Overlay
BW2 = imcomplement(BW2); %对图像数据进行取反运算（可以实现底片效果）
out = imoverlay(B, BW2, [0 0 0]); %底片整体颜色设置为黑色
figure(4), 
subplot(211),imshow(out),title('最终结果');
subplot(212),imshow(BW2),title('BW2_2');








