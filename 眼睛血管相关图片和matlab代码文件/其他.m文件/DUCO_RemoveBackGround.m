function  newIm= DUCO_RemoveBackGround(im,w,isShow)
%im:ԭʼͼ��;w �˲������С;isShow �Ƿ���ʾ�м����
if isShow==1
  figure
  imshow(im,[])
end
bk=double(im);
%1.��Сֵ�˲�
bk=ordfilt2(bk,1,ones(w,w),'symmetric');
if isShow==1
   figure
   subplot(2,2,1)
  imshow(bk,[]),title('��Сֵ�˲�֮��Ľ��');    %��ʾ�˲����ͼ��
end
%2.��ֵ�˲�
h=ones(w,w)/(w*w);
bk=imfilter(bk,h,'replicate');
if isShow==1
   subplot(2,2,2)
   imshow(bk,[]),title('��ֵ�˲�֮��Ľ��');    %��ʾ�˲����ͼ��
end
%3.�������Ȳ����Ľ��
newIm=imsubtract(double(im),bk);
if isShow==1
  subplot(2,2,3)
  imshow(newIm,[]);title('ȥ����ͼ');
end
%4.��ֵ���ָ��Ŀ��
th=graythresh(newIm/255);
newIm=im2bw(newIm/255,th);
if isShow==1
  subplot(2,2,4)
  imshow(newIm),title('��ֵ���Ľ��');    %��ʾ�˲����ͼ��
end

end