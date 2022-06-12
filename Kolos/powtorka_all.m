%% Kolos 1_25 zadanie 1 - grubosc obwodki na 3 px
close all; clear; clc;

a = imread('grosze_02.jpg');
a_hsv = rgb2hsv(a);
bin = a_hsv(:, :, 1) < 0.7;

bin = medfilt2(bin, [3 3]);

temp = imerode(bin, strel('disk', 20));
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

image = a;

for k = 1:N
    mask = aseq == k;

    if pole(k) < edges(2)
        image = imoverlay(image, bwdist(bwperim(mask)) <=1, 'blue');
    elseif pole(k) >= edges(2) && pole(k) < edges(3)
        image = imoverlay(image, bwdist(bwperim(mask)) <=1, 'green');
    else
        image = imoverlay(image, bwdist(bwperim(mask)) <=1, 'red');
    end
end

imshow(image)
%% Zadanie 2 - animacja kwadrat 

close all; clear; clc;

a = zeros(300, 300, 3, 24);

SE = strel('disk', 5);

result = a;

for k = 1:24
    if k < 7 
        x = 150 + round(120 * sqrt(2)/2/6) * k;
        z = 150 - round(120 * sqrt(2)/2) + round(120 * sqrt(2)/2/6) * k;
    elseif k >= 7 && k < 13
        x = 150 + round(120 * sqrt(2)/2) - round(120 * sqrt(2)/2/6) * (k - 6);
        z = 150 + round(120 * sqrt(2)/2/6) * (k - 6);
    elseif k >= 13 && k < 19
        x = 150 - round(120 * sqrt(2)/2/6) * (k - 12);
        z = 150 + round(120 * sqrt(2)/2) - round(120 * sqrt(2)/2/6) * (k - 12);
    else
        x = 150 - round(120 * sqrt(2)/2) + round(120 * sqrt(2)/2/6) * (k - 18);
        z = 150 - round(120 * sqrt(2)/2/6) * (k - 18);
    end

    a(x, z, 1, k) = (255 - 255 * (k - 1) / 24);
    a(x, z, 2, k) = 255;
    a(x, z, 3, k) = (255 - 255 * (k - 1) / 24);
    a(:, :, :, k) = imdilate(a(:, :, :, k), SE);

    if k > 1
        a(:, :, :, k) = a(:, :, :, k) + a(:, :, :, k - 1);
    end
    
    mask = a(:, :, 2, k) == 0;
    result(:, :, :, k) = imoverlay(a(:, :, :, k), mask, 'cyan');
end

implay(result)

%% Zadanie 3
close all; clear; clc;

a = imread('football.jpg');
a_gray = rgb2gray(a);
a_double = double(a_gray)/255;

temp = zeros(size(a_double));
[N, M] = size(a_double);

temp(1, 1) = 1;

dist = bwdist(temp);
z = 0.15 * cos(0.5 * pi * dist);

a_double = a_double + z;

fx = linspace(-0.5, 0.5, M);
fz = linspace(-0.5, 0.5, N);
[FX, FZ] = meshgrid(fx, fz);
f = sqrt(FX.^2 + FZ.^2);

FT = fftshift(fft2(a_double));
WA = abs(FT);


% f0 = sqrt(0.1176^2 + 0.2256^2);
f0 = 0.25;
N = 3;
W = 0.03;

BS = 1 ./ (1+( f.* W ./ (f.^2 - f0.^2)).^(2 * N));

result = ifft2(ifftshift(FT .* BS));

% imagesc(fx, fz, log(WA +0.01));
subplot(121), imshow(result)
subplot(122), imshow(a_double)

%% Zadanie 3 2_2 Radon
close all; clear; clc;

mask = poly2mask([100, 150, 200], [225, 75, 225], 300, 300);
mask2 = ~mask;

a = bwdist(mask2);

krok = 1:1:15;
[N, M] = size(a);
L2=zeros(1, 15);
for k = krok
    kat = 1:k:179;
    [R, X] = radon(a, kat);
    a_new = iradon(R, kat);
    a_new = a_new(2:N+1, 2:M+1).* mask;
    L2(k)=sqrt(sum(sum((a-a_new).^2)))/bwarea(mask);
end
plot(krok,L2)
xlabel('krok');
ylabel('L2');


%% Radon 2_3

close all; clear; clc;

mask = poly2mask([80, 120, 160], [180, 60, 180], 240, 240);
mask2 = ~mask;

dist = bwdist(mask2);
L1 = zeros(1, 12);
[N, M] = size(dist);

krok = 1:1:12;

for k = krok
    kat = 1:k:179;
    [R, X] = radon(dist, kat);
    a_new = iradon(R, kat);
    a_new = a_new(2:N+1, 2:M+1) .* mask;
    L1(1, k) = sum(sum(abs(dist - a_new))) / bwarea(mask);
end

plot(krok, L1);
xlabel('krok');
ylabel('L1');