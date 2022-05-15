close all; clear; clc;

%strefa buforowa - odleglosc wszystkich punktow od wszystkich punktow
%L2 = dx - dy + sqrt(2) * dy - szybsze obliczenia niz Euklidesowa, w miare
%niezla dokladnosc

%L1 - odleglosc Manhattan = |dx| + |dy|, norma L1 jest bardziej
%niestabilna, jezeli na krancach sa duze odchylenia

%L (Czebyszewa) - max(|dx|,|dy|)

img = zeros(150, 150);

for k = 1:3
    x = ceil(150 * rand(1));
    z = ceil(150 * rand(1));
    img(z,x) = 1;
end

a1 = bwdist(img, 'Euclidean');
a2 = bwdist(img, 'quasi-euclidean');
a3 = bwdist(img, 'cityblock');
a4 = bwdist(img, 'chessboard');

subplot(221), imagesc(a1); axis image; colorbar('vertical');
subplot(222), imagesc(a2); axis image; colorbar('vertical');
subplot(223), imagesc(a3); axis image; colorbar('vertical');
subplot(224), imagesc(a4); axis image; colorbar('vertical');
%%
close all; clear; clc;
a = imread('new_map.bmp');
subplot(231),imshow(a);

%LAS
%L2(droga_glowna) > 20px
%L1(droga_boczna) < 10px
%L2(woda) > 15px

%na poczatek tworzymy cztery mapy logiczne
las = (a(:,:,1) == 185 & a(:,:,2) == 215 & a(:, :, 3) == 170);
subplot(232), imshow(las);

droga_glowna = (a(:,:,1) == 255 & a(:,:,2) == 245 & a(:, :, 3) == 120);
droga_glowna = imclose(droga_glowna, ones(1,3));

subplot(233), imshow(droga_glowna);

droga_boczna = (a(:,:,1) == 255 & a(:,:,2) == 255 & a(:, :, 3) == 255);
droga_boczna = imopen(droga_boczna, ones(3));
droga_boczna = imclose(droga_boczna, ones(1,3));

subplot(234), imshow(droga_boczna);

woda = (a(:,:,1) > 63 & a(:,:,1) < 180 & a(:,:,2) > 158 & a(:,:,2) < 232 & a(:, :, 3) > 189);

subplot(235), imshow(woda);

miejsce = las & bwdist(droga_glowna) > 20 & bwdist(droga_boczna, "cityblock") < 10 & bwdist(woda) > 15;
%subplot(236), imshow(miejsce); %nanosimy na mape
wynik = imoverlay(a, miejsce, 'r');
subplot(236), imshow(wynik);
%%
close all; clear; clc;

r = 5:5:100;
img = zeros(256,256);
img(128, 128) = 1;

img = bwdist(img);
pole_mat = pi * r.^2;
pole_px = zeros(size(pole_mat));
pole_est = zeros(size(pole_mat));

for k =  1:20
    bin = img < r(k);
    pole_px(k) = sum(bin(:));
    pole_est(k) = bwarea(bin);
end

plot(r, pole_px, 'r', r, pole_est, 'g', r, pole_mat, '.b');
%%
close all; clear; clc;
img = zeros(256,256);
img(128, 128) = 1;
img = bwdist(img);

r = 5:5:100;

obw_mat = 2 * pi * r;
obwod_grad = zeros(size(obw_mat));
obwod_edge = zeros(size(obw_mat));
obwod_perim = zeros(size(obw_mat));

for k = 1:20
    bin = img < r(k);
    obwod_grad(k) = sum(sum(imdilate(bin, ones(3)) - imerode(bin, ones(3))))/2;
    obwod_edge(k) = sum(sum(edge(bin, 'canny')));
    obwod_perim(k) = bwarea(bwperim(bin));
end

plot(r, obwod_grad, 'r', r, obwod_edge, 'g', r, obwod_perim, '.b');


%%
close all; clear; clc;
%watershed - rozlaczanie

img = zeros(200,200);
img(100, [95 205]) = 1;
a=bwdist(img) < 60;
imshow(img);
L=-bwdist(~img);
L=watershed(L);
imagesc(L);
a=a&(L>0);
imshow(a);

%%
close all; clear; clc;

img = zeros(200,300);
img(100, [95 205]) = 1;
a=bwdist(img) < 60;
subplot(111), imshow(a);
tt = imerode(a, ones(50,5));
L = bwdist(tt);
L=watershed(L);
imagesc(L);
a=a&(L>0);
imshow(a);
%% etykietownie i segmentacja
close all; clear; clc;

a = imread('coins.png');
%imshow(a);

a = a > 88;
a = medfilt2(a, [3 3]);
imshow(a);

[aseg, N]=bwlabel(a);
imagesc(aseg); axis image; colorbar('vertical');
subplot(122), imshow(a);
pole=zeros(1,N);

for k=1:N
    temp=(aseg==k);
    pole(1,k)=bwarea(temp);
end

med = median(pole);
b = 225*zeros(size(a), 'uint8');

for k=1:N
    if pole(1,k) > med
        b = b + uint8(aseg == k).*a;
    end
end
imshow(b);


