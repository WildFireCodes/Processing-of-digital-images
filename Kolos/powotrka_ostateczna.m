%% Ruch po okregu: https://drive.google.com/drive/folders/1O0A-HifWVaW5ioeqTLbUTJowVBDnjgm4?fbclid=IwAR3Eogn5f3JPhL0excn92OskHIMSlj1_PfxO4uGm34zi7M12zzpxJTvBONE
close all; clear; clc;

a = zeros(320, 240, 3, 46, 'uint8');

SE = strel('disk', 6);

result = a;

x0 = 160;
z0 = 120;
r = 90;

for k = 1:46
%     kat = 180 -270 * (k - 1)/46;
    kat = 270 - round(90/46) * (k-1);
    x = x0 + round(r * cosd(kat));
    z = z0 + round(r * sind(kat));

    a(x, z, 1, k) = 255;
    a(x, z, 2, k) = 255;
    a(x, z, 3, k) = 0;

    a(:, :, :, k) = imdilate(a(:, :, :, k), SE);

    if k > 1
        a(:, :, :, k) = a(:, :, :, k) + a(:, :, :, k - 1);
    end

    if k > 3
         a(:, :, :, k) = a(:, :, :, k) - a(:, :, :, k - 3);
    end

    mask = a(:, :, 2, k) == 0;
    result(:, :, :, k) = imoverlay(a(:, :, :, k), mask, 'blue');

end

implay(result);

%% https://drive.google.com/drive/folders/1ndnM051JakwLZ6_7TOQPG6sp2MQxrghg?fbclid=IwAR2l0kqIsLTmvLNCIFPrhqwwK8WllFWJ_Td1NOcgmJxvxRlOMHlIHZpFbHs Zadanie 1 prostkat
close all; clear; clc;

a = zeros(320, 240, 3, 70, 'uint8');

SE = strel('square', 4);

result = a;

for k = 1:70
    if k < 18
        x = 160 - 60;
        z = 120 + 100 - round(200/17) * (k - 1);
    elseif k >= 18 && k < 36
        x = 100 + round(120/17) * (k - 18);
        z = 20;
    elseif k >= 36 && k < 52
        x = 220;
        z = 20 + round(220/17) * (k - 36);
    else
        x = 220 - round(120/17) * (k - 52);
        z = 220;
    end
    
    a(x, z, 1, k) = 1;
    a(x, z, 2, k) = 255;
    a(x, z, 3, k) = 1;
    a(:, :, :, k) = imdilate(a(:, :, :, k), SE);

    if k > 1
         a(:, :, :, k) =  a(:, :, :, k) +  a(:, :, :, k - 1);
    end

    mask = a(:, :, 1, k) == 0;
    result(:, :, :, k) = imoverlay(a(:, :, :, k), mask, 'white');
end

implay(result)

%% Kolos 1_4 
close all; clear; clc;

a = imread('grosze_06.jpg');
a_hsv = rgb2hsv(a);
bin = a_hsv(:, :, 2) < 0.7;
bin = medfilt2(bin, [5 5]);

temp = imerode(bin, strel('disk', 25));
dist = bwdist(temp);
bin = bin & watershed(dist) > 0;

[aseq, N] = bwlabel(bin);
pole = zeros(1, N);

for k = 1:N
    mask = aseq == k;
    pole(k) = bwarea(mask);
end

[counts, edges] = histcounts(pole, 3);

result = counts(1) * 0.01 + counts(2) * 0.02 + counts(3) * 0.05;
result

%obwodka 5 px dla zabawy
image = a;

for k = 1:N
    mask = aseq == k;

    if pole(k) < edges(2)
        image = imoverlay(image, bwdist(bwperim(mask)) <= 2, 'red');
    elseif pole(k) >= edges(2) && pole(k) < edges(3)
        image = imoverlay(image, bwdist(bwperim(mask)) <= 2, 'blue');
    elseif pole(k) >= edges(3) && pole(k) < edges(4)
        image = imoverlay(image, bwdist(bwperim(mask)) <= 2, 'green');
    end
end

% subplot(121), imshow(a_hsv(:, :, 2))
imshow(image)

%% monety_2

close all; clear; clc;
a = imread('monety_2.jpg');




%%
a = double(a)/255;
a_hsv = rgb2hsv(a);

srebrne = a_hsv(:, :, 2) < 0.1;
srebrne = medfilt2(srebrne, [8 8]);
srebrne = bwareaopen(srebrne, 200);

a_hsv2 = rgb2hsv((rgb2hsv(a) + a)/2);

monetki = a_hsv2(:, :, 3) < 0.53;

monetki = imclose(monetki, strel('disk', 6));
monetki = imopen(monetki, strel('disk', 6));
monetki = medfilt2(monetki, [8, 8]);
monetki(375:392, 754:782) = 1;

temp = imerode(monetki, strel('disk', 47));
dist = bwdist(temp);
monetki = monetki & watershed(dist) > 0;
monetki = imreconstruct(srebrne, monetki);
imshow(monetki)

%% dziury
close all; clear; clc;

a = imread('figury_06.png');
a = rgb2hsv(a);

channel1Min = 0.043;
channel1Max = 0.187;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.003;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.751;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
bin = (a(:,:,1) >= channel1Min ) & (a(:,:,1) <= channel1Max) & ...
    (a(:,:,2) >= channel2Min ) & (a(:,:,2) <= channel2Max) & ...
    (a(:,:,3) >= channel3Min ) & (a(:,:,3) <= channel3Max);
imshow(bin)
%%
a_hsv = rgb2hsv(a);

channel1Min = 0.013;
channel1Max = 0.243;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.005;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.886;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
bin = (a_hsv(:,:,1) >= channel1Min ) & (a_hsv(:,:,1) <= channel1Max) & ...
    (a_hsv(:,:,2) >= channel2Min ) & (a_hsv(:,:,2) <= channel2Max) & ...
    (a_hsv(:,:,3) >= channel3Min ) & (a_hsv(:,:,3) <= channel3Max);

bin = bwareaopen(~bin, 350);

[aseq, N] = bwlabel(bin);
props = regionprops(bin, 'all');

[N1, M] = size(bin);

result = zeros(N1, M, 3);
wynik_gwiazdki = zeros(size(bin));
wynik_kwadraty = zeros(size(bin));

for k = 1:N
    mask = aseq == k;
    %gwiazdki z dziurami i bez
    if abs(props(k).MajorAxisLength / props(k).MinorAxisLength - 1) < 0.01
        if props(k).Circularity < 0.4
            wynik_gwiazdki = wynik_gwiazdki + mask;
        end
    end

    %obiekty, ktorych chociaz jedna dziura jest kwadratem

    if props(k).EulerNumber <= 0
        mask1 = ~mask;
        [aseq1, N2] = bwlabel(mask1);

        for l = 1:N2
            mask2 = aseq1 == l;
            pole = bwarea(mask2);
            obwod = bwarea(bwperim(mask2));
            bwk = 4 * pi * pole / obwod^2;
            props2 = regionprops(mask1, 'BoundingBox');

            if abs(bwk - (1/4 * pi)) < 0.07 && abs(bwk - (1/4 * pi)) > 0.01
                if props2(l).BoundingBox(3) == props2(l).BoundingBox(4)
                    wynik_kwadraty = wynik_kwadraty + mask;
                end
            end
        end
    end
end

result(:, :, 1) = 255;
result(:, :, 2) = 255;

rest = bin - (wynik_gwiazdki - wynik_kwadraty);
result = imoverlay(result, rest, 'black');
result = imoverlay(result, wynik_gwiazdki, 'red');
result = imoverlay(result, wynik_kwadraty, 'blue');

subplot(121), imshow(wynik_gwiazdki)
subplot(122), imshow(result)