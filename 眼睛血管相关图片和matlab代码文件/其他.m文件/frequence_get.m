    function [ Slog,f2]=frequence_get(image,f_size)
    % %�������ܣ��Ƚ�ͼ�����0��ʹ֮��Ϊ����ͼ��Ȼ���ø���ҶƵ�׹��������������Ƶ��D0,
    % %         �����Ը��� f=D0/f_size������������Ŀռ�Ƶ�� ��Ҳ������������������ 
    % %
    % % ����˵��
    % % ���룺 image������ͼ��
    % %        f_size�����0�ķ���ͼ��ߴ�
    % % 
    % % �����
    % %       Slog������ҶƵ��
    % %       f2 :  LOG��ǿͼ��
    % % 
    %% ȥ�뼰��
    h=fspecial('gaussian',5,0.3);%����һ����˹��ͨ�˲���
    f1=imfilter(image,h,'replicate');
    Size=5; Sigma=0.5;
    h_log=fspecial('log',Size,Sigma);%������˹
    f2=imfilter(f1,h_log,'corr','replicate');%���Կռ��˲����������
    %% �ø���ҶƵ�׹��������������ǳ�ϸ���ߣ�Ƶ��
    f3=f2;
    f3(f_size,f_size)=0;    %���㣬ʹ֮��Ϊ����ͼ��
    F=fft2(f3);%��ɢ����Ҷ�任
    Fc=fftshift(F);%fftshift�����������������Ჿ�ֺ͸����Ჿ�ֵ�ͼ��ֱ���ڸ��Ե����ĶԳ�
    Slog=log(1+abs(Fc));%����ҶƵ��
    end
