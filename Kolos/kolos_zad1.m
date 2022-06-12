close all; clear; clc;

image = imread('grosze_05.jpg');
image_original = image;
image = rgb2hsv(image);
image = image(:, :, 1) < 0.20;
%imshow(image);

%% - sprawdzic, jak dziala ten schemat punktu wodnego
b = imerode(image, ones(30));
L = bwdist(b);
L = watershed(L);

image = image & (L>0);
% imshow(image);

%%
[aseg, N] = bwlabel(image);

pole = zeros(1, N);
obwod = zeros(1, N);

for k = 1:N
    temp = (aseg == k);
    pole(1, k) = bwarea(temp);
    obwod(1, k) = bwarea(bwperim(temp));
end

[count,edges]=histcounts(pole,3);
suma=(count(1)+count(2)*2+count(3)*5)/100;
suma
%%
result=image_original;

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
