clear all;
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
% figure;imshow(img_out);
% title('imgOut');

new_img = imsubtract(img,img_out);
figure;
imshow(new_img);
title('去掉轮廓')