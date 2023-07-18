function Mask=Muban(Slog,f_size)
    % % 函数功能：根据频谱图Slog中峰值位置，构造一个自适应的陷波滤波器模板 。
    % % 参数说明
    % % 输入：    Slog：一幅图像的傅里叶频谱图
    % %          f_size：填充0的方形图像尺寸
    % % 输出：    Mask：陷波滤波器模板
    TH=0.78*max(Slog(:));    %该比例需要根据不同的处理对象作出修改
    Mask0=ones(f_size,f_size);
    for s=1:f_size
        for t=1:f_size      
            if Slog(s,t)>=TH
                Mask0(s,t)=0;%初始陷波模板
            end        
        end
    end
    Mask1= imclose(~Mask0, strel('disk', 3));%闭操作
    Mask2=imerode(Mask1,strel('disk', 3));%腐蚀
    Mask2=imdilate(Mask2,strel('disk', 10));%膨胀
    Mask=~Mask2;%陷波模板
end
