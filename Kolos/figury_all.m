close all; clear; clc;

a = imread('monety_11.jpg');
a_hsv = rgb2hsv(a);

%srebrne monetki
srebrne = a_hsv(:, :, 2) < 0.2;
srebrne = bwareaopen(srebrne, 620);
srebrne = medfilt2(srebrne, [8 8]);
srebrne = imerode(srebrne, strel('disk', 18));

%wszystkie monetki
monetki = a(:, :, 2) < 210 & a(:, :, 2) < 210 & a(:, :, 3) < 170;
monetki = medfilt2(monetki, [5, 5]);
monetki = imclose(monetki, strel('disk', 5));
monetki = imopen(monetki, strel('disk', 5));

temp = imerode(monetki, strel('disk', 35));
dist = bwdist(temp);
monetki = monetki & watershed(dist) > 0;
monetki = imreconstruct(srebrne, monetki);

[aseq, N] = bwlabel(monetki);
pole = zeros(1, N);

for k = 1:N
    mask = aseq == k;
    pole(1, k) = bwarea(mask);
end

[counts, edges] = histcounts(pole, 4);

result = counts(1) * 0.1 + counts(2) * 0.2 + counts(3) * 0.5 + counts(4);
result

copy = a;

for k = 1:N
    mask = aseq == k;

    if pole(k) > edges(1) && pole(k) < edges(2)
        copy = imoverlay(copy, bwperim(mask), 'red');
    end

    if pole(k) > edges(2) && pole(k) < edges(3)
        copy = imoverlay(copy, bwperim(mask), 'blue');
    end

    if pole(k) > edges(3) && pole(k) < edges(4)
        copy = imoverlay(copy, bwperim(mask), 'green');
    end

    if pole(k) > edges(4) && pole(k) < edges(5)
        copy = imoverlay(copy, bwperim(mask), 'yellow');
    end
end

subplot(121), imshow(a)
subplot(122), imshow(copy)

%% figury
close all; clear; clc;

a = imread('figury_05.png');
a_hsv = rgb2hsv(a);
bin = a_hsv(:, :, 1) < 0.83;
bin = medfilt2(bin, [3, 3]);

%obiekty, ktorych jedna dziura jest kolem
[aseq, N] = bwlabel(bin);
props = regionprops(aseq, 'all');

%% szukanie dziur, ktore sa kolami
wynik_kola = zeros(size(bin));

for k = 1:N
    mask = aseq == k;
    
    if props(k).EulerNumber <= 0
        mask1 = ~mask;
        
        [aseq1, N1] = bwlabel(mask1);

        for l = 1:N1
            mask2 = aseq1 == l;
            pole = bwarea(mask2);
            obwod = bwarea(bwperim(mask2));

            bwk = 4 * pi * pole / obwod ^ 2;

            if abs(bwk - 1) < 0.1
                wynik_kola = wynik_kola + mask;
            end
        end
    end
end

imshow(wynik_kola);

%% szukanie kwadratow

wynik_kwadraty = zeros(size(bin));

for k = 1:N
    mask = aseq == k;
    
    if props(k).EulerNumber <= 0
        mask1 = ~mask;
        
        [aseq1, N1] = bwlabel(mask1);

        for l = 1:N1
            mask2 = aseq1 == l;
            pole = bwarea(mask2);
            obwod = bwarea(bwperim(mask2));

            bwk = 4 * pi * pole / obwod ^ 2;

            if abs(bwk - (1/4 * pi)) < 0.05 && abs(bwk - (1/4 * pi)) > 0.04
                wynik_kwadraty = wynik_kwadraty + mask;
            end
        end
    end
end

imshow(wynik_kwadraty);

%% szukanie prostokatow, ktore nie sa kwadratem

wynik_prostokaty = zeros(size(bin));

for k = 1:N
    mask = aseq == k;
    pole = bwarea(mask);
    pole2 = props(k).BoundingBox(3) * props(k).BoundingBox(4);


    if abs(pole / pole2 - 1) < 0.2
        if props(k).BoundingBox(3) ~= props(k).BoundingBox(4)
            wynik_prostokaty = wynik_prostokaty + mask;
        end
    end  
end

imshow(wynik_prostokaty);

%% Trojkaty
wynik_trojkat = zeros(size(bin));

for k = 1:N
    mask = aseq == k;
    pole = bwarea(mask);
    pole2 = 1/2 * props(k).BoundingBox(3) * props(k).BoundingBox(4);

    if abs(pole / pole2 - 1) < 0.1
        if abs(props(k).Area / props(k).ConvexArea - 1) < 0.05
            wynik_trojkat = wynik_trojkat + mask;
        end
    end
end

imshow(wynik_trojkat);

%% Gwiazdki
wynik_gwiazdki = zeros(size(bin));

for k = 1:N
    mask = aseq == k;

    if abs(props(k).MajorAxisLength / props(k).MinorAxisLength - 1) < 0.01
        if props(k).Circularity < 0.45
            if abs(props(k).Area / props(k).ConvexArea - 1) > 0.37
                wynik_gwiazdki = wynik_gwiazdki + mask;
            end
        end
    end
end

imshow(wynik_gwiazdki);

%% szesciokaty foremne
wynik_szesciokaty = zeros(size(bin));

for k = 1:N
    mask = aseq == k;

    if abs(props(k).MajorAxisLength / props(k).MinorAxisLength - 1) > 0.02
        wynik_szesciokaty = wynik_szesciokaty + mask;
    end
end

imshow(a);

%% elipsy
wynik_elipsy = zeros(size(bin));

for k=1:N
  tt = (aseq==k);
  pole = bwarea(tt);
  obwod = bwarea(bwperim(tt));
  bwk = 4*pi*pole/(obwod^2);
  if abs(bwk-1) > 0.05 %wszystko poza kolami
      pole2 = pi * props(k).MinorAxisLength * props(k).MajorAxisLength/4; %dzielimy przez 4, bo jedno przez dwa i drugie przez dwa
      if abs(pole/pole2 - 1) < 0.01
          wynik_elipsy = wynik_elipsy | tt;
      end
  end
end

imshow(wynik_elipsy)

%% Filtracje

close all; clear; clc;

a = imread('football.jpg');
a_gray = rgb2gray(a);
a_double = double(a_gray)/255;

[N M] = size(a_double);

marker = zeros(N, M);
marker(N/2, M/2) = 1;

dist = bwdist(marker);

zab = 0.1 * sin(0.4 * pi * dist);

a_double = a_double + zab;

fx = linspace(-0.5, 0.5, M);
fz = linspace(-0.5, 0.5, N);
[FX, FZ] = meshgrid(fx, fz);
f = sqrt(FX.^2 + FZ.^2);

FT = fftshift(fft2(a_double));
WA = abs(FT);

W = 0.03;
N = 4;
f0 = sqrt(0.205^2 + 0.002^2);

% FPZ = 1 ./ (1 + (f .* W ./ (f.^2 - f0.^2)).^2 * N);
BS = 1./(1+(f.*W./(f.^2-f0.^2)).^(2*N));

filtered = ifft2(ifftshift(FT .* BS));

subplot(131), imshow(filtered)
subplot(132), imshow(a_double)
subplot(133), imagesc(fx, fz, log(WA + 0.01));


% imshow(a_double)

%% Filtracja z kolosa 1_17

close all; clear; clc;

a = imread('coins.png');
a_double = double(a)/255;

gamma = 0.7;

imshow(a)

