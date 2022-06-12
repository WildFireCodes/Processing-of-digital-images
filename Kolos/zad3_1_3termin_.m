close all; clear; clc;
A = imread('coloredChips.png');
B = imread('szum_Chips4.png');

A = double(A)/255;
B = double(B)/255;

% subplot(121), imshow(A);
% subplot(122), imshow(B);

[N, M, k] = size(B);
fx = linspace(-0.5, 0.5, M);
fz = linspace(-0.5, 0.5, N);
[FX, FZ] = meshgrid(fx, fz);
f = sqrt(FX.^2 + FZ.^2);

%FPZ = ~(mod(f, 0.03) > 0.02 | mod(f, 0.03) < 0.01);
FPZ = ~(mod(abs(f)+0.01, 0.07) > 0.06 | mod(abs(f)+0.01, 0.07) < 0.01);
%FPZ = 1./(1 + (f/0.2).^(2*6));

b_filtered = B;

for k = 1:3
    FT = fftshift(fft2(B(:,:,k)));
    WA = abs(FT);
    subplot(1,3,k),imagesc(fx, fz, log(WA + 0.01));
    b_filtered(:,:,k) = real(ifft2(ifftshift(FT.*FPZ)));
end

L2 = sqrt(sum(sum(sum(A-b_filtered).^2)));
L2

figure
subplot(221), imshow(A);
subplot(222), imshow(B);
subplot(223), imshow(b_filtered);
subplot(224), imagesc(fx, fz, FPZ);
%%
close all; clear; clc;
A = imread('coloredChips.png');
B = imread('szum_Chips4.png');

A = double(A)/255;
B = double(B)/255;

%result = imfilter(B, ones(5,5)/25);
% result = B + 0.1 * (B - result);
result = B;
maska = [-1, -1, -1; -1, 8, -1; -1, -1, -1];
%result = imfilter(result, maska, 'symmetric');

for k = 1:3
    result(:, :, k) = medfilt2(B(:, :, k), [3 3]);
    %c = imfilter(result(:, :, k), maska, 'symmetric');
    %result(:, :, k) = result(:, :, k) + (c * 0.0009);
end
c = imfilter(result, maska, 'symmetric');
result = result + (c * 0.0009);

L2 = sqrt(sum(sum(sum(A-result).^2)));
L2

subplot(221), imshow(A);
subplot(222), imshow(B);
subplot(223), imshow(result);
%%
close all; clear; clc;
a = imread('peppers.png');
a = imnoise(a, "salt & pepper");

%b = imfilter(a, ones(5,5)/25);

maska = [0, -1, 0; -1, 5, -1; 0, -1, 0];
%b = imfilter(b, maska, 'symmetric');
b = a;
for k = 1:3
    b(:, :, k) = medfilt2(a(:, :, k), [3 3]);
    c = imfilter(b(:, :, k), maska, 'symmetric');
    b(:, :, k) = b(:, :, k) + c;
end

subplot(121), imshow(a);
subplot(122),imshow(b)

%%
x = 10.2;
round(x);

