%20:42

close all; clear; clc;

a = imread('grosze_04.jpg');
a_hsv = rgb2hsv(a);
bin = a_hsv(:, :, 1) < 0.4;
bin = medfilt2(bin, [3 3]);

SE = strel('disk', 15);
temp = imerode(bin, SE);
dist = bwdist(temp);
bin = bin & watershed(dist) > 0;

[aseq, N] = bwlabel(bin);
pole = zeros(1, N);

for k = 1:N
    mask = aseq == k;
    pole(1, k) = bwarea(mask);
end

[counts, edges] = histcounts(pole, 3);

wynik = counts(1) * 0.01 + counts(2) * 0.02 + counts(3) * 0.05;
wynik

result = bin;
for k = 1:N
    mask = aseq == k;

    if pole(k) > edges(1) && pole(k) < edges(2)
        result = imoverlay(result, bwperim(mask), 'g');
    end

    if pole(k) > edges(2) && pole(k) < edges(3)
        result = imoverlay(result, bwperim(mask), 'r');
    end

    if pole(k) > edges(3) && pole(k) < edges(4)
        result = imoverlay(result, bwperim(mask), 'b');
    end
end

% imshow(result)
subplot(121), imshow(a);
subplot(122), imshow(result);

%%
%22:10
close all; clear; clc;

a = zeros(240, 320, 3, 36, 'uint8');
SE = strel('square', 7);

fuksja = 255, 0 ,255;
result = a;

for k = 1:36
    if k < 13
        x = 120 - round(120 * sqrt(3)/2/12) * (k - 1);
        z = 220 - round(60/12) * k;

    elseif k >= 13 && k < 25
        x = 120 - round(120 * sqrt(3)/2) + round(120 * sqrt(3)/2/12) * (k - 12);
        z = 160 - round(60/12) * (k - 12);
    else
        z = 100 + round(120/12) * (k - 24);
    end

    a(x, z, 1, k) = round(255 - 255*(k)/36);
    a(x, z, 2, k) = round(255 - 255*(k)/36);
    a(x, z, 3, k) = round(255 - 255*(k)/36/16);
    
%     a(:, :, :, k) = imdilate(a(:, :, :, k), SE);

    if k > 1
        a(:, :, :, k) = a(:, :, :, k) + a(:, :, :, k - 1);
    end

    mask = a(:, :, 2, k) == 0;
    result(:, :, :, k) = imoverlay(a(:, :, :, k), mask, 'magenta');

end

implay(result)

%%
close all; clear; clc;

a = imread('figury_01.png');
bin1 = ~(a(:, :, 1) > 50 & a(:, :, 1) < 245);
bin2 = ~(a(:, :, 2) > 50 & a(:, :, 2) < 245);
bin3 = a(:, :, 1) == 188 & a(:, :, 2) == 211 & a(:, :, 3) == 95;
bin4 = a(:, :, 1) == 200 & a(:, :, 2) == 113 & a(:, :, 3) == 55;
bin = bin1 + bin2 + bin3 + bin4;

imshow(bin)
%%
close all; clear; clc;

a = imread('peppers.png');
a_gray = rgb2gray(a);

marker = zeros(size(a_gray));
[N, M] = size(a_gray);

marker(N/2, M/2) = 1;

dist = bwdist(marker);

copy = a_gray;
mask = mod(dist, 10) > 9.5 | mod(dist, 10) < 0.5;
copy(mask) = copy(mask) + 20;
copy = double(copy)/255;

fx = linspace(-0.5, 0.5, M);
fz = linspace(-0.5, 0.5, N);
[FX, FZ] = meshgrid(fx, fz);
f = sqrt(FX.^2 + FZ.^2);

FT = fftshift(fft2(copy));
WA = abs(FT);

FPZ = ~(mod(f, 0.1)> 0.095 | mod(f, 0.1) < 0.005);

result = real(ifft2(ifftshift(FT.*FPZ)));

imagesc(fx, fz, log(WA + 0.01));
% FPZ = ~(mod(abs(f),  ))

imshow(result);





