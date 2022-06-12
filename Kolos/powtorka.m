%% zadanie 1
close all; clear; clc;

a = imread("grosze_05.jpg");
a_hsv = rgb2hsv(a);
bin = a_hsv(:, :, 1) < 0.4;

temp = imerode(bin, strel('disk', 30));
dist = bwdist(temp);
bin = bin & watershed(dist) > 0;

[aseq, N] = bwlabel(bin);
pole = zeros(1, N);

for k = 1:N
    mask = aseq == k;
    pole(1, k) = bwarea(mask);
end

[counts, edges] = histcounts(pole, 3);

result = counts(1) * 0.01 + counts(2) * 0.02 + counts(3) * 0.05;
result

region = regionprops(aseq, 'all');

image = a;
for k = 1:N
    mask = aseq == k;

    if pole(k) >= edges(1) && pole(k) < edges(2)
        image = imoverlay(image, bwdist(bwperim(mask)) <= 2, 'blue');
    elseif pole(k) >= edges(2) && pole(k) < edges(3)
        image = imoverlay(image, bwperim(mask), 'red');
    else
        image = imoverlay(image, bwperim(mask), 'green');
    end
end

imshow(image)
%%
pp = bwperim(mask);

%% zadanie 2
close all; clear; clc;

a = zeros(200, 300, 3, 20, 'uint8');
SE = strel('disk', 4);

result = a;

for k = 1:20
    if k < 6
        x = 100 + round(100 * sqrt(2)/2) - round(100 * sqrt(2)/2/5) * (k);
        z = 150 - round(100 * sqrt(2)/2/5) * (k);
    elseif k >= 6 && k < 11
        x = 100 - round(100 * sqrt(2)/2/5) * (k - 5);
        z = 150 - round(100 * sqrt(2)/2) + round(100 * sqrt(2)/2/5) * (k - 5);
    elseif k >= 11 && k < 16
        x = 100 - round(100 * sqrt(2)/2) + round(100 * sqrt(2)/2/5) * (k - 10);
        z = 150 + round(100 * sqrt(2)/2/5) * (k - 10);
    else 
        x = 100 + round(100 * sqrt(2)/2/5) * (k - 15);
        z = 150 + round(100 * sqrt(2)/2) - round(100 * sqrt(2)/2/5) * (k - 15);
    end

    a(x, z, 1, k) = 0;
    a(x, z, 2, k) = round(0 + 255 *(k)/20);
    a(x, z, 3, k) = 0;

    a(:, :, :, k) = imdilate(a(:, :, :, k), SE);

    if k > 1
        a(:, :, :, k) = a(:, :, :, k) + a(:, :, :, k - 1);
    end
    
    mask = a(:, :, 2, k) == 0;
    result(:, :, :, k) = imoverlay(a(:, :, :, k), mask, 'yellow');

end

implay(result)

%% zadanie 3
close all; clear; clc;

a = imread('football.jpg');
a_gray = rgb2gray(a);
a_double = double(a_gray)/255;

temp = zeros(size(a_gray));
[N, M] = size(a_gray);

temp(N/2, M/2) = 1;
dist = bwdist(temp);

zab = 0.1 * sin(0.4 * pi * dist);

a_double = a_double + zab;

fx = linspace(-0.5, 0.5, M);
fz = linspace(-0.5, 0.5, N);
[FX, FZ] = meshgrid(fx, fz);
f = sqrt(FX.^2 + FZ.^2);

FT = fftshift(fft2(a_double));
WA = abs(FT);

% FPZ = 1 ./ (1 + (f * 0.2 ./ (f.^2 - 0.1)).^2*4);
% 
% result = ifft2(ifftshift(FPZ .* FT));

subplot(121), imagesc(fx, fz, log(WA + 0.01))
% subplot(122), imshow(result)
