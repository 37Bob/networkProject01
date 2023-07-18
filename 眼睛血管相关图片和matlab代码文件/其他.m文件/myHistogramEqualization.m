function [img2, func_T] = myHistogramEqualization(img)
    img1 = double(img);
    [r,c,l] = size(img1)%获取图像的高r和宽c
    %统计图像中每个灰度级出现的次数
    count = zeros(1,256);
    for i=1:r
        for j=1:c
            count(1,img(i,j)+1) = count(1,img(i,j)+1)+1;
        end
    end
    %统计图像中每个灰度级出现的概率
    p = zeros(1,256);
    for i=1:256
        p(1,i) = count(1,i)/(r*c);
    end
    img2 = im2uint8(ones(r,c));%创建一个r X c大小的1矩阵
    
    func_T = zeros(1,256);%变换函数
    p_sum = 0;
    %求直方图均衡化的变换函数
    for k = 1:256
        p_sum = p_sum + p(k);%求每个灰度级的概率之和
        func_T(k) = (256-1)*p_sum;%根据变换函数的公式求和
    end
    
    func_T_z =  round(func_T);%对变换函数进行取整
    %完成每个像素点的映射
    for i = 1:256
        findi = find(func_T_z==i);%找到灰度级为i的概率和
        len = length(findi);
        for j=1:len
            findj = find(img==(findi(j)-1));%进行对应每个像素点的映射
            img2(findj) = i;
        end
    end
end