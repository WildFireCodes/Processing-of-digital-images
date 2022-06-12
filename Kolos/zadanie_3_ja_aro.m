image = imread('peppers.png');
image_gray = rgb2gray(image);

image_zeros = zeros(size(image_gray));
[N, M] = size(image_gray);
image_zeros(N/2, M/2) = 1;

distmap = bwdist(image_zeros);

copy = image_gray;
mask = mod(distmap, 15) > 14.5 | mod(distmap, 15) < 0.5;
copy(mask) = copy(mask) + 25;

copy_double = double(copy)/255;

fx = linspace(-0.5, 0.5, M);
fz = linspace(-0.5, 0.5, N);

[FX, FZ] = meshgrid(fx, fz);

f = sqrt(FX.^2 + FZ.^2);

FT = fftshift(fft2(copy_double));
WA = abs(FT);

FPZ = ~(mod(abs(f)+0.01, 0.07) > 0.06 | mod(abs(f)+0.01, 0.07) < 0.01);

result = ifft2(ifftshift(FT.*FPZ));

imagesc(fx, fz, log(WA + 0.01))
%imshow(result)