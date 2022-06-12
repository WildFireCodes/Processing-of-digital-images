close all; clear; clc;
image = imread('football.jpg');
% imshow(image);
image_gray = rgb2gray(image);
image_double = double(image_gray)/255;

[N, M] = size(image_double);

black = zeros(N, M);
black(N/2, M/2) = 1;

distmap = bwdist(black);

zab = 0.1 * sin(0.4 * pi * distmap);

image_zab = image_double + zab;

fx = linspace(-0.5, 0.5, M);
fz = linspace(-0.5, 0.5, N);

[FX, FZ] = meshgrid(fx, fz);
f = sqrt(FX.^2 + FZ.^2);

FT = fftshift(fft2(image_zab));
WA = abs(FT);

f0 = 0.07;
LP = 1./(1+ (f/f0).^(2*4));

image_filtered = ifft2(ifftshift(FT.*LP));

subplot(221), imshow(image_double);
subplot(222), imshow(image_zab);
subplot(223), imagesc(fx, fz, log(WA + 0.01));
subplot(224), imshow(image_filtered);