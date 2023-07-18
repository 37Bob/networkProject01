    clc;
    close all;
    clear all;
    %% ��ȡͼƬ
    I=imread('1.jpg');
    %% �ж�ͼ���ʽ������ͼ��ߴ硢ֱ��ͼ���⻯
    if(ndims(I)==3)%ndims��������ά���ĺ���
        img=rgb2gray(I);
        img=double(img);%ת��Ϊ˫����
    else
        img=double(I);%ת��Ϊ˫����
    end
    if(max(size(img))>1024)
        scale=1/8;  %ͼ�����Ϊԭͼ�ߴ��1/8
        I1 = imresize(img, scale);%���Ŵ���
    else
        I1=img;
    end    
    [m,n]=size(I1);
    f_size=max(m,n);
    %% ȥ�롢��
    [Slog f2]=frequence_get(I1,f_size);
    %% �ݲ��˲� ȥ������������ 
    % % ���ݲ��˲�ģ���޸�ԭͼ����ҶƵ�ף��˳���Ƶ��������
    % % �����ݲ��˲���ģ��
    Mask=Muban(Slog,f_size);
    vex=find(Mask==0);
    I_spec=I1;
    I_spec=im2uint8(mat2gray(I_spec));%�����һ������ͼ����������ת��Ϊ�޷��ŵ�8λ����
    I_spec(f_size,f_size)=0;
    Spectrum=fft2(uint8(I_spec));%2ά��ɢ����Ҷ�任
    Spec=abs(Spectrum);   %������
    phi=angle(Spectrum);  %��λ��
    Spec=fftshift(Spec);
    Spec1=Spec;
    Spec1(vex)=0;
    Spec2=ifftshift(Spec1);
    CJ=Spec2.*exp(i*phi);  %�ؽ�����ҶƵ��
    Re_fft2=ifft2(CJ);     %������Ҷ�任����ԭͼ��
    Restore=uint8(real(Re_fft2));
    %% �Ի�ԭͼ��ά���˲�
% %    ά���˲�     
    K=wiener2(Restore(1:m,1:n),[3 3]);%ά���˲���wiener filtering) һ�ֻ�����С�������׼�򡢶�ƽ�ȹ��̵����Ź������������˲�����������������֮��ľ������Ϊ��С����ˣ�����һ������˲�ϵͳ������������ȡ��ƽ����������Ⱦ���źš� 
    [result,threshold1]=edge(K,'sobel',0.07);% ��ԭͼû�н��о��⻯����ֵ��0.07��sobel���ӱ�Ե����ѷ�       
    [BW,thresh1]=bwfilter(K,result);%��ֵ���˲���ȥ����
    figure,
    subplot(151);imshow(I1,[]);title('ԭʼͼ��'); 
    subplot(152);imshow(Restore(1:m,1:n),[]);title('������Ҷ�任ͼ��'); 
    subplot(153);imshow(K,[]);title('ά���˲�����');
    subplot(154);imshow(result,[]);title('���Ƽ��'); 
    subplot(155);imshow(BW);title('��ֵ���˲���ȥ����');
% %     ��̬ѧ����
    Se0=strel('line',3,0);%����һ��������������ĶԳƵ����ԽṹԪ��
    Se90=strel('line',3,90);
    bw_dialte=imdilate(BW,[Se0 Se90]);%����
    bw_fill=imfill(bw_dialte,'holes');%���  
    bw1=bwmorph(bw_fill,'thin',Inf);%ϸ��  
    bw2=bwmorph(bw1,'spur',3);  %ȥë��     
    bw3=bwareaopen(bw2,5);%�Ƴ�СĿ��  
    figure,
    subplot(151);imshow(bw_dialte);title('����');
    subplot(152);imshow(bw_fill);title('���');
    subplot(153);imshow(bw1);title('ϸ��');
    subplot(154);imshow(bw2);title('ȥë��');
    subplot(155);imshow(bw3);title('�Ƴ�СĿ��');