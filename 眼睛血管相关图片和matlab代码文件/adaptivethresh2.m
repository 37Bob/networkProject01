% img = imread('ͼƬ1.png');adaptivethresh2(img,8);
% numpartΪ���ֲ�������ʵ�����numpart=6��8Ч���Ϻ�
function img_out = adaptivethresh2(img, numpart)
% clear all;
[m n] = size(img);
part = floor(m/numpart); 
for i = 1:numpart-1
    img_temp = img((i-1)*part+1:i*part, :);
    img_out((i-1)*part+1:i*part, :) = thresh_ost(img_temp);   %ÿһ������Ostu��ֵ��
end
img_temp = img((numpart-1)*part+1:numpart*part, :);          %���������ֵ�������
img_out((numpart-1)*part+1:numpart*part, :) = thresh_ost(img_temp);
figure;imshow(img_out)

function img_out = thresh_ost(img)
[m n] = size(img);
img_hist = zeros(1,256);
for i = 1:m
    for j = 1:n
        img_hist(img(i, j)+1) = img_hist(img(i, j)+1) + 1;
    end
end
img_hist_pro = img_hist/m/n;         %�Ҷȼ������ܶȷֲ�
% plot(img_hist_pro)
% figure;imhist(img)
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
    sigma2 = w0 * (u0 - u)^2 + w1 * (u1 - u)^2;    %��ȡ�����С
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



    