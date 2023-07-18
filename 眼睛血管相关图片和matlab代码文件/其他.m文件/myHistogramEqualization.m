function [img2, func_T] = myHistogramEqualization(img)
    img1 = double(img);
    [r,c,l] = size(img1)%��ȡͼ��ĸ�r�Ϳ�c
    %ͳ��ͼ����ÿ���Ҷȼ����ֵĴ���
    count = zeros(1,256);
    for i=1:r
        for j=1:c
            count(1,img(i,j)+1) = count(1,img(i,j)+1)+1;
        end
    end
    %ͳ��ͼ����ÿ���Ҷȼ����ֵĸ���
    p = zeros(1,256);
    for i=1:256
        p(1,i) = count(1,i)/(r*c);
    end
    img2 = im2uint8(ones(r,c));%����һ��r X c��С��1����
    
    func_T = zeros(1,256);%�任����
    p_sum = 0;
    %��ֱ��ͼ���⻯�ı任����
    for k = 1:256
        p_sum = p_sum + p(k);%��ÿ���Ҷȼ��ĸ���֮��
        func_T(k) = (256-1)*p_sum;%���ݱ任�����Ĺ�ʽ���
    end
    
    func_T_z =  round(func_T);%�Ա任��������ȡ��
    %���ÿ�����ص��ӳ��
    for i = 1:256
        findi = find(func_T_z==i);%�ҵ��Ҷȼ�Ϊi�ĸ��ʺ�
        len = length(findi);
        for j=1:len
            findj = find(img==(findi(j)-1));%���ж�Ӧÿ�����ص��ӳ��
            img2(findj) = i;
        end
    end
end