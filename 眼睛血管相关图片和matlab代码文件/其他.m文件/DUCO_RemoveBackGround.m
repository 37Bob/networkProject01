function  newIm= DUCO_RemoveBackGround(im,w,isShow)
%im:原始图像;w 滤波窗体大小;isShow 是否显示中间过程
if isShow==1
  figure
  imshow(im,[])
end
bk=double(im);
%1.最小值滤波
bk=ordfilt2(bk,1,ones(w,w),'symmetric');
if isShow==1
   figure
   subplot(2,2,1)
  imshow(bk,[]),title('最小值滤波之后的结果');    %显示滤波后的图象
end
%2.均值滤波
h=ones(w,w)/(w*w);
bk=imfilter(bk,h,'replicate');
if isShow==1
   subplot(2,2,2)
   imshow(bk,[]),title('均值滤波之后的结果');    %显示滤波后的图象
end
%3.减掉亮度不均的结果
newIm=imsubtract(double(im),bk);
if isShow==1
  subplot(2,2,3)
  imshow(newIm,[]);title('去背景图');
end
%4.二值化分割出目标
th=graythresh(newIm/255);
newIm=im2bw(newIm/255,th);
if isShow==1
  subplot(2,2,4)
  imshow(newIm),title('二值化的结果');    %显示滤波后的图象
end

end