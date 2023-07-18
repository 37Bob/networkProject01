Image = imread('spots.tif');
figure,imshow(Image);
title('原图');
Theshold = graythresh(Image);%取得图象的全局域值
Image_BW = im2bw(Image,Theshold);%二值化图象
figure,imshow(Image_BW);
title('初次二值化图像');
%第三步二值化图像进行
Image_BW_medfilt= medfilt2(Image_BW,[13 13]);
figure,imshow(Image_BW_medfilt);
title('中值滤波后的二值化图像');
%第四步：通过“初次二值化图像”与“中值滤波后的二值化图像”进行“或”运算优化图像效果
Optimized_Image_BW = Image_BW_medfilt|Image_BW;
figure,imshow(Optimized_Image_BW);
title('进行“或”运算优化图像效果');
%第五步：优化后二值化图象取反，保证：‘1’-〉‘白色’，‘0’-〉‘黑色’
%方便下面的操作
Reverse_Image_BW = ~Optimized_Image_BW;
figure,imshow(Reverse_Image_BW);
title('优化后二值化图象取反');
%第六步：填充二进制图像的背景色，去掉细胞内的黑色空隙
Filled_Image_BW = bwfill(Reverse_Image_BW,'holes');
figure, imshow(Filled_Image_BW);
title('已填充背景色的二进制图像');
%第七步：对图像进行开运算，去掉细胞与细胞之间相粘连的部分
SE = strel('disk',4);
Open_Image_BW = imopen(Filled_Image_BW,SE);
figure, imshow(Open_Image_BW);
title('开运算后的图像');
%-----------------------------------------------
%-------------开始计算细胞数--------------------
%-----------------------------------------------
[Label,Number]=bwlabel(Open_Image_BW,8)%初步取得细胞个数
Array = bwlabel(Open_Image_BW,8);%取得贴标签处理后的图像
Sum = [];
%依次统计贴标签后数组
for i=1:Number
[r,c] = find(Array==i);%获取相同标签号的位置，将位置信息存入[r,c]
rc = [r c];
Num = length(rc);%取得vc数组的元素的个数
Sum([i])=Num;%将元素个数存入Sum数组
end
Sum
N = 0;
%假如Sum数组中的元素大于了1500，表示有两个细胞相连，像素点较多，即分为两个细胞数
for i=1:length(Sum)
if(Sum([i])) > 500
N = N+1;
end
end
%-------------------------------------------
%------------------统计最终细胞数-----------
%-------------------------------------------
Number = Number+N
