%%
close all; clear; clc;

a = imread('cameraman.tif');
a=double(a)/255; %matlab nie potrafi podniesc int do niecalkowitej
%double na 0 - 1 a z int 0-255 po pierwiastku 0 - 16
coef = [0.1, 0.25, 0.5, 1, 2, 4];

for k=1:6
    b = a.^coef(k);
    subplot(2,3,k);
    imshow(b);
    title(['\gamma = ', num2str(coef(k))]);
end

%%
%normalizacja - rozciagniecie histogramu

close all; clear; clc;
a = imread('pout.tif');
subplot(221), imshow(a);
subplot(222), imhist(a, 256);

b = imadjust(a); %rozciagnelismy histogram - tylko na koncowkach wyglada inaczej
subplot(223), imshow(b);
subplot(224), imhist(b, 256);

%% wyrownanie histogramu
close all; clear; clc;
a = imread('pout.tif');
subplot(221), imshow(a);
subplot(222), imhist(a, 256);

b = histeq(a, 16); %wyrownanie dla 256 odcieni
subplot(223), imshow(b);
subplot(224), imhist(a, 16);

%%
close all; clear; clc;
a = rgb2gray(imread('saturn.png'));
subplot(221), imshow(a);
subplot(222), imhist(a, 256);

b = histeq(a, 256); %wyrownanie dla 256 odcieni
subplot(223), imshow(b);
subplot(224), imhist(b);

%%
close all; clear; clc;
a = rgb2gray(imread('saturn.png'));
subplot(221), imshow(a);
subplot(222), imhist(a, 256);

b = adapthisteq(a, 'Distribution', 'rayleigh'); %wyrownanie dla 256 odcieni
subplot(223), imshow(b);
subplot(224), imhist(b);
%% binaryzacja

close all; clear; clc;

a = imread('coins.png');
subplot(121), imshow(a); %sprawdzamy wartosci jakie oddzielaja monety od tla
bin = (a > 90);
bin = medfilt2(bin, [3 3]); %odszumianie filtracja medianowa
subplot(122), imshow(bin);

%%
close all; clear; clc;
a = imread('wykres.png'); %obrazek ze strony 
subplot(121), imshow(a);
bin = (a(:, :, 1) == 126 & a(:, :, 2) == 47 & a(:,:, 3) == 142);
subplot(122), imshow(bin);

%poczatek to X k = 344, Y w = 114 (lewy gorny rog), (prawy dolny rog) X k =
%2374 w = 1313

bb = bin(114:1313, 344:2374);
imshow(bb);
[N, M] = size(bb);
czas = zeros(M, 1);
cisn = zeros(M, 1);

%po kazdej kolumnie obrazka
for k = 1:M
    czas(k, 1) = k;
    %ile mamy pixeli w danej kolumnie
    ile = sum(bb(:,k));
    if(ile > 0)
       for w = 1:N
           if bb(w, k) == true
               cisn(k, 1) = cisn(k, 1) + w;
           end
       end
       cisn(k, 1) = cisn(k, 1) / ile;
    end
end

czas = 350 * (czas - 1) / (M-1);
cisn = 35000 * (N-cisn) / (N - 1);

czas_5h = 0:5:333;
cisn_5h = interp1(czas, cisn, czas_5h);
plot(czas, cisn, 'r', czas_5h, cisn_5h, '*k');
xlim([0, 333]);

%% przeksztalcenia geometryczne
close all; clear; clc;
a = imread('cameraman.tif');
%b = circshift(a, [100, -50]); %przesuniecie okreslonej ilosci wierszy
%b = imrotate(a, 30, 'crop', 'bicubic'); %zeby pixel odpowiadal pixelowi po rotacji
%b = flipud(a); %fliplr
%b = padarray(a, [300, 300], 'symmetric', 'both');
%subplot(121), imshow(a);
%subplot(122), imshow(b); %uzyteczne w korelacji dwuwymiarowej
%przeksztalcenie afiniczne 
mask = affine2d([1 1 0; 0 1 0; 0 0 1]); %macierz przeksz afi
%projective2d
b = imwarp(a, mask);
subplot(121), imshow(a); axis on;
subplot(122), imshow(b); axis on;

%%
%close all; clear; clc;
a = imread('cameraman.tif');
b = imrotate(a, 30);
cpselect(a, b); %zaznaczamy jakies punkty, zeby ich nie usunelo to komentarz clear close
%fitgeotrans(a, b);
mac = fitgeotrans(movingPoints, fixedPoints, 'affine');

