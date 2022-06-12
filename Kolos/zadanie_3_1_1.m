close all; clear; clc;

a = imread('peppers.png');
a = double(a)/255;
a_gray = rgb2gray(a);

x = size(a_gray);

x_center = ceil(x(1)/2);
y_center = ceil(x(2)/2);

for i = 1:x(1) %x
    for j = 1:x(2) %y
        dist = sqrt((i - x_center)^2 + (j - y_center)^2);

        if(mod(dist, 15) > 14.5 || mod(dist,15) < 0.5)
            a_gray(i,j) = a_gray(i,j) + 25;
        end
    end
end

imshow(a_gray);

% a_new = ~a_new;
%%
subplot(221), imshow(a_gray);
% subplot(222), imshow(a_new);

%siatka na znormalizowana czestotliwosc
[Nz, Nx] = size(a_gray);

fx = linspace(-0.5, 0.5, Nx);
fz  = linspace(-0.5, 0.5, Nz);
[FX, FZ] = meshgrid(fx, fz);

x_center = ceil(fx/2);
y_center = ceil(fz/2);
%%
a_new = zeros(size(a_gray));

for i = 1:FX %x
    for j = 1:FZ %y
        dist = sqrt((i - x_center)^2 + (j - y_center)^2);

        if(mod(dist, 15) > 14.5 || mod(dist,15) < 0.5)
            a_new(i,j) = 1;
        end
    end
end
subplot(222), imshow(a_new);
%%
%przejscie z domeny
A = fftshift(fft2(a_gray));
WA = abs(A);
subplot(223), imagesc(log(WA + 0.01));

BS = a_new;

result = real(ifft2(ifftshift(A.*BS)));
subplot(224), imshow(result);
