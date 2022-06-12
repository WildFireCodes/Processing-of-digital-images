%% binaryzacja
close all; clear; clc;

original = imread('grosze_03.jpg');
a=rgb2hsv(original);
imshow(a);
a=a(:,:,1)<0.3;
imshow(a);

%% Watershed
b=imerode(a, ones(25));
L=bwdist(b);
L=watershed(L);
a=a & (L>0);
imshow(a);

%% etykietowanie

[aseg, N] = bwlabel(a);
region = regionprops(uint8(aseg), 'all');
pole=zeros(1,N);
%obwod=zeros(1,N);

for k=1:N
    temp=(aseg==k);
    pole(1,k)=bwarea(temp);
    %obwod(1,k)=bwarea(bwperim(temp));
end


%% Zliczenie sumy
[count,edges]=histcounts(pole,3);
suma=(count(1)+count(2)*2+count(3)*5)/100;
suma

%% Zrobioenie obdodów kolorowych
result=original;

for k=1:sum(count)
    temp=(aseg==k);

    if (pole(k) > edges(1) && pole(k)<edges(2))
        result = imoverlay(result, bwperim(temp), 'r');
    end

    if (pole(k) > edges(2) && pole(k)<edges(3))
        result = imoverlay(result, bwperim(temp), 'g');
    end

    if (pole(k) > edges(3) && pole(k)<edges(4))
        result = imoverlay(result, bwperim(temp), 'b');
    end
  
end


imshow(result)
 

