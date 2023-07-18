function [image,Iobr] = morpho_tophat(I,struc)
I = 255-I;
for i = 1:length(struc)
    se = strel('disk',struc(i));
    Itp(:,:,i) = TopHat(I,se);
end
Itpm = max(Itp,[],3);

for i = 1:length(struc)
    se = strel('disk',struc(i));
    Iobr(:,:,i) = OBR(Itpm,se);
end
image = max(Iobr,[],3);
end
    
    
function Itp = TopHat(I,se)
Ic = imclose(I,se);
Ico = imopen(I,se);
Imin = min(I,Ico);
Itp = imsubtract(I,Imin);
end

function Fobr = OBR(F,se)
Fe = imerode(F,se);
Fobr = imreconstruct(Fe,F);
end

