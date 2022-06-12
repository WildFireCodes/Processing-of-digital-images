close all; clear; clc;

a = imread('monety_9.jpg');
a_hsv = rgb2hsv(a);
bin = a_hsv(:, :, 2) > 0.35;

temp = ~bin;
temp = imerode(temp, strel('disk', 10));
temp = bwareaopen(temp, 390);
imshow(temp)
%%
%rekonstrukcja
bin_all = a(:, :, 1) > 180 & a(:, :, 2) > 30 & a(:, :, 2) < 135;
bin_all = ~bin_all;
bin_all = imclearborder(bin_all);
bin_all = medfilt2(bin_all, [4 4]);

tt = imerode(bin_all, strel('disk', 28));
dist = bwdist(tt);
bin_all = bin_all & watershed(dist) > 0;

coins = imreconstruct(temp, bin_all);

[aseq, N] = bwlabel(coins);
pole = zeros(1, N);

for k = 1:N
    mask = aseq == k;
    pole(1, k) = bwarea(mask);
end

[counts, edges] = histcounts(pole, 4);

result = counts(1) * 0.1 + counts(2) * 0.2 + counts(3) * 0.5 + counts(4);
result

copy = a;

for k = 1:N
    mask = aseq == k;

    if pole(k) > edges(1) && pole(k) < edges(2)
        copy = imoverlay(copy, bwperim(mask), 'b');
    end

    if pole(k) > edges(2) && pole(k) < edges(3)
        copy = imoverlay(copy, bwperim(mask), 'y');
    end

    if pole(k) > edges(3) && pole(k) < edges(4)
        copy = imoverlay(copy, bwperim(mask), 'magenta');
    end

    if pole(k) > edges(4) && pole(k) < edges(5)
        copy = imoverlay(copy, bwperim(mask), 'black');
    end
end

subplot(121), imshow(a)
subplot(122), imshow(copy)