close all; clear; clc;

a = zeros(240, 320, 3, 36, 'uint8');
SE = strel('disk', 6);
x=1; z = 1;
result = a;
for k = 1:36
    if k < 13
        x = 120 - round(120 * sqrt(3)/2/12) * (k - 1);
        z = 100 + round(60/12) * (k - 1);
    elseif k >= 13 && k < 25
        x = 120 - round(120 * sqrt(3)/2) + round(120 * sqrt(3)/2/12) * (k - 13);
        z = 160 + round(60/12) * (k - 13);
    else
        x = 120;
        z = 220 - round(120/12) * (k - 25);
    end

    a(x, z, 1, k) = round(255 - 255*(k)/36);
    a(x, z, 2, k) = round(255 - 255*(k)/36);
    a(x, z, 3, k) = 255;
    
    a(:, :, :, k) = imdilate(a(:, :, :, k), SE);
    if k>1
        a(:, :, :, k) = a(:, :, :, k) + a(:, :, :, k - 1);
    end
    
%     mask = a(:, :, 2, k) == 0;
%     result(:, :, :, k) = imoverlay(a(:, :, :, k), mask, 'magenta');

end

implay(a)

%%
close all; clear; clc;

a = zeros(320, 240, 3, 46, 'uint8');
SE = strel('disk', 3);

x0 = 160;
y0 = 120;
r = 90;

for k = 1:46

    kat = -(45 + k - 1) * round(90 / 46);
    x = x0 + round(r * cosd(kat));
    y = y0 + round(r * sind(kat));

    a(x, y, 1, k) = 255;
    a(:, :, :, k) = imdilate(a(:, :, :, k), SE);

    if k > 1
        a(:, :, :, k) = a(:, :, :, k) + a(:, :, :, k - 1);
    end
   
    if k > 3
        a(:, :, :, k) = a(:, :, :, k) - a(:, :, :, k - 3);
    end
end

implay(a)

%%
close all; clear; clc;

mask = poly2mask([70, 140, 210], [185, 95, 185], 280, 280); %y odlegosc od gory, od dolu na dwa 
mask2 = zeros(280, 280);

props = regionprops(mask);
centr = round(props.Centroid);

mask2(centr(2), centr(1)) = 1;
dist = bwdist(mask2);

mask3 = dist .* mask;

L1 = zeros(1, 20);
[N, M] = size(mask3);

krok = 1:20;

for k = krok
    kat = 0:k:179;
    [R, X] = radon(mask3, kat);
    a_new = iradon(R, kat);
    a_new = a_new(2:N+1, 2:M+1) .* mask;
    L1(1, k) = sum(sum(abs(mask3 - a_new)))/bwarea(mask);
end
plot(krok, L1);

%%
close all; clear; clc;

mask = poly2mask([50, 125, 200], [192, 62, 192], 250, 250);
imshow(mask)

mask2 = zeros(250, 250);
props = regionprops(mask, 'all');
centr = round(props.Centroid);

mask2(centr(2), centr(1)) = 1;
dist = bwdist(mask2);

mask3 = dist .* mask;

L1 = zeros(1, 15);
[N, M] = size(mask3);

krok = 1:15;

for k=krok
    kat = 0:k:179;
    [R, X] = radon(mask3, kat);
    a_new = iradon(R, kat);
    a_new = a_new(2:N+1, 2:M+1).* mask;
    L1(k) = sum(abs(mask3 - a_new), 'all')/bwarea(mask);
end
plot(krok, L1);

%%
close all; clear; clc;

a = imread('cameraman.tif');
a_double = double(a)/255;

krok = 2:2:100;

%rzad 3
[N, M] = size(a_double);

temp = zeros(N, M);
temp(N/2, M/2) = 1;
f = bwdist(temp);
N = 3;
wyniki = zeros(1, 50);

for k = 1:50
    f0 = krok(k);
    FT = fftshift(fft2(a_double));

    BS = 1 ./ (1 + (f ./ f0).^2*N);

    odszum = ifft2(ifftshift(FT .* BS));
    
    wyniki(1,k) = sqrt(sum((a_double - odszum).^2, "all"));
end

scatter(krok, wyniki, 'red', 'd', 'filled');

%%
close all; clear; clc;

a = imread('pout.tif');
a_double = double(a)/255;
a_norm = imadjust(a_double);

a_szum = imnoise(a_norm, 'gaussian', 0.0, 0.002);
a_szum = imnoise(a_szum, 'salt & pepper', 0.01);

a_szum = medfilt2(a_szum, [3 3]);

a_szum = wiener2(a_szum, [3 3]);

ocena = sqrt(sum((a_norm - a_szum).^2, "all"));
ocena

imshow(a_szum)




