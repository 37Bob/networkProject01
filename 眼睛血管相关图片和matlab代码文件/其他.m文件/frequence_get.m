    function [ Slog,f2]=frequence_get(image,f_size)
    % %函数功能：先将图像填充0，使之成为方形图像，然后用傅里叶频谱估计周期性纹理的频率D0,
    % %         还可以根据 f=D0/f_size计算周期纹理的空间频率 （也可以是周期性噪声） 
    % %
    % % 参数说明
    % % 输入： image：输入图像
    % %        f_size：填充0的方形图像尺寸
    % % 
    % % 输出：
    % %       Slog：傅里叶频谱
    % %       f2 :  LOG增强图像
    % % 
    %% 去噪及锐化
    h=fspecial('gaussian',5,0.3);%产生一个高斯低通滤波器
    f1=imfilter(image,h,'replicate');
    Size=5; Sigma=0.5;
    h_log=fspecial('log',Size,Sigma);%拉普拉斯
    f2=imfilter(f1,h_log,'corr','replicate');%线性空间滤波函数，相关
    %% 用傅里叶频谱估计周期噪声（非常细的线）频率
    f3=f2;
    f3(f_size,f_size)=0;    %补零，使之成为方形图像
    F=fft2(f3);%离散傅里叶变换
    Fc=fftshift(F);%fftshift的作用正是让正半轴部分和负半轴部分的图像分别关于各自的中心对称
    Slog=log(1+abs(Fc));%傅里叶频谱
    end
