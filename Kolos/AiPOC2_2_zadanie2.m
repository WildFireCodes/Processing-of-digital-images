close all; clear; clc;




%%
close all; clear; clc;

a = imread('figury_01.png');
a_hsv = rgb2hsv(a);

bin = a_hsv(:, :, 2) > 0.2;
bin2 = a_hsv(:, :, 3) > 0.99;
bin3 = ~a_hsv(:, :, 3) > 0.01;
bin4 = a_hsv(:, :, 3) > 0.94 & a_hsv(:, :, 1) == 0 & a_hsv(:, :, 2) == 0;

% subplot(133), imshow(bin4);

[aseq, N] = bwlabel(bin);

prop = regionprops(uint8(aseq), 'all');
wynik = false(size(bin));

for k = 1:N
    mask = aseq == k;

    pole = bwarea(mask);
    obwod = bwarea(bwperim(mask));
    bwk = (4 * pi * pole) / (obwod^2);

    pole2 = prop(k).BoundingBox(3).*prop(k).BoundingBox(4)/2; %1/2 * a * h
    
    %trojkaty
    if abs (pole / pole2 - 1) < 0.02
        if abs(prop(k).Area / prop(k).ConvexArea - 1) < 0.02
            %wynik = wynik + mask;
            wynik = imoverlay(wynik, mask, 'r');
        end
    end
    
    %gwiazdki, kola, kwadraty i szesciany maja identyczne wartosci
    %MajorAxisLength i MinorAxisLength
    temp = (prop(k).MajorAxisLength - prop(k).MinorAxisLength) / prop(k).MajorAxisLength;

    if temp > 0 && temp < 0.12 && prop(k).Circularity < 0.5
            wynik = imoverlay(wynik, mask, 'r');
    end
end

subplot(131), imshow(a_hsv);
subplot(132), imshow(bin);
subplot(133), imshow(wynik);