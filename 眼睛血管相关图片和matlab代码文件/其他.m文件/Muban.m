function Mask=Muban(Slog,f_size)
    % % �������ܣ�����Ƶ��ͼSlog�з�ֵλ�ã�����һ������Ӧ���ݲ��˲���ģ�� ��
    % % ����˵��
    % % ���룺    Slog��һ��ͼ��ĸ���ҶƵ��ͼ
    % %          f_size�����0�ķ���ͼ��ߴ�
    % % �����    Mask���ݲ��˲���ģ��
    TH=0.78*max(Slog(:));    %�ñ�����Ҫ���ݲ�ͬ�Ĵ�����������޸�
    Mask0=ones(f_size,f_size);
    for s=1:f_size
        for t=1:f_size      
            if Slog(s,t)>=TH
                Mask0(s,t)=0;%��ʼ�ݲ�ģ��
            end        
        end
    end
    Mask1= imclose(~Mask0, strel('disk', 3));%�ղ���
    Mask2=imerode(Mask1,strel('disk', 3));%��ʴ
    Mask2=imdilate(Mask2,strel('disk', 10));%����
    Mask=~Mask2;%�ݲ�ģ��
end
