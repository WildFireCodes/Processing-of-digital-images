close all; clear; clc;

a = imread('grosze_09.jpg');

a_hsv = rgb2hsv(a);

a_hsv = a_hsv(:, :, 1) < 0.3;

temp = imerode(a_hsv, ones(25));
b = bwdist(temp);
a_watershed = a_hsv & (watershed(b)>0);

[aseq, N] = bwlabel(a_watershed);

pole = zeros(1, N);

for k = 1:N
    mask = (aseq == k);
    pole(1, k) = bwarea(mask);
end

[count, edges] = histcounts(pole, 3);

result = (count(1) + count(2)*2 + count(3)*5)/100;
result

a_copy = a;
for k = 1:N
    mask = (aseq == k);

    if(pole(k) > edges(1) && pole(k) < edges(2))
        a_copy = imoverlay(a_copy, bwperim(mask), 'g');
    end

    if(pole(k) > edges(2) && pole(k) < edges(3))
        a_copy = imoverlay(a_copy, bwperim(mask), 'r');
    end

    if(pole(k) > edges(3) && pole(k) < edges(4))
        a_copy = imoverlay(a_copy, bwperim(mask), 'b');
    end
end

imshow(a_copy);


