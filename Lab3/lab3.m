close all; clear; clc;


%filtr najprostszy dolnoprzepustowy LP ones(n,m) / n*m
a = imread('cameraman.tif');

N=3;

maski = ones(N) / (N*N);
b = imfilter(a, maski);

subplot(121), imshow(a);
subplot(122), imshow(b);

%%
close all; clear; clc;

a = imread('cameraman.tif');
N = 11;
maska = fspecial('gaussian', [N, N], 3);
b = imfilter(a, maska, 'symmetric');
subplot(121), imagesc(maska);
subplot(122), imshow(b); 
%filtr gaussowski - symeteyczny, suma = 1, kazdy element > 0 

%%
%wykrywanie zmian poziomych, pionowych
%jedna maska pozioma, druga pionowa

close all; clear; clc;
a = imread('cameraman.tif');

maska = [-1, -1, -1; 0, 0, 0; 1, 1, 1]; %pozioma
maska2 = [-1, 0, 1; -1, 0, 1; -1, 0, 1]; %pionowa

b = imfilter(a, maska, 'symmetric');
b2 = imfilter(a, maska2, "symmetric");

subplot(121), imshow(b);%imagesc(maska);
subplot(122), imshow(b2);
close all; clear; clc;
a = imread('cameraman.tif');

maska = [-1, -1, -1; 0, 0, 0; 1, 1, 1]; %pozioma
maska2 = [-1, 0, 1; -1, 0, 1; -1, 0, 1]; %pionowa

b = imfilter(a, maska, 'symmetric');
b2 = imfilter(a, maska2, "symmetric");

subplot(121), imshow(b);%imagesc(maska);
subplot(122), imshow(b2);
%%
%Pracujemy na uint8, wykryslimy poziome, pionowe, teraz trzeba z lewej i
%prawej zeby nie obcinac ujemnej krawedzi
close all; clear; clc;
a = imread('cameraman.tif');
a = double(a)/255;
%dla usredniajacych nie trzeba przechodzic na double,bo nie wypadnie poza
%zakres
%tutaj moze sie zdarzyc
%operacje gornoprzepustowe na double
maska = [-1, -1, -1; 0, 0, 0; 1, 1, 1]; 
b = abs(imfilter(a, maska, 'symmetric'));
b2 = abs(imfilter(a, maska', 'symmetric'));

subplot(121), imshow(b);
subplot(122), imshow(b2);

%%
%teraz po ukosie - skladamy predkosc

close all; clear; clc;
a = imread('cameraman.tif');
a = double(a)/255;
%dla usredniajacych nie trzeba przechodzic na double,bo nie wypadnie poza
%zakres
%tutaj moze sie zdarzyc
%operacje gornoprzepustowe na double
maska = [-1, -1, -1; 0, 0, 0; 1, 1, 1]; %jezeli zmienimy srodkowe -1 i 1 po lewewj
%i prawej otrzymamy krawedz wazona -1 -> 2 i 1 -> 2 [-1 2 -1] [0, 0, 0],
%[1, 2, 1]

b = abs(imfilter(a, maska, 'symmetric')).^2;
b2 = abs(imfilter(a, maska', 'symmetric')).^2;
b3 = sqrt(b+b2);

subplot(121), imshow(a);
subplot(122), imshow(b3);

%%
close all; clear; clc;
a = zeros(100);
a(36:65, 36:65) = 1;

subplot(121), imshow(a);
%w wyniku filtracji maja zostac tylko narozniki
%kilka metod:
%filtrujemy poziomo (krawedz gorna i dolna), filtrujemy pionowo i tylko w
%naroznikach mamy mnozenie 1 * niezerowe - iloczyn dwoch filtracji i abs

%abs filtracja filtracji

%filtrujemy, elementem ones(2)/4 i wyszukujemy == 1/4

%xor (1, median(1, [3, 3]) - mediana ucina narozniki

%operacja morfologiczna 

maska = [-1, 0, 1]; %maska liniowa
b = abs(imfilter(a, maska).*imfilter(a, maska'));
c = uint8(a + b);
pal = [0 0 0; 1 1 1; 1 0 0]; %0 - tla, 1 - kwadraty, 1 0 0 dla rogow
imshow(c, pal);

%%
%Laplasian - suma drugich pochodnych czastkowych
%[[0 -1 0] [-1 4 -1] [0 -1 0]] suma elementow = 0
%albo [[-1 -1 -1] [-1 8 -1] [-1 -1 -1]]
close all; clear; clc;
a = imread('cameraman.tif');

mask = [0 -1 0; -1 4 -1; 0 -1 0];
b = imfilter(a, mask, 'symmetric');

subplot(121), imshow(a);
subplot(122), imshow(b);

%%
close all; clear; clc;
% FILTRY NIELINIOWE
%mediana - medfilt2
%wienera (adaptacyjna dwumianowa) - wiener2
a = imread('cameraman.tif');
aszum = imnoise(a, 'speckle'); %dodaje szum do obrazka - gaussian, salt & pepper,
%poisson - wartosc szumu nie zalezy od wartosci pixela
%szum, ktory uwzglednia wartosc pixela - speckle
N = 9;

b = medfilt2(aszum, [N, N], 'symmetric'); %mediana zjada narozniki
b2 = wiener2(aszum, [N, N]);
b3 = imfilter(aszum, ones(N)/(N*N), 'symmetric'); %avg
b4 = imfilter(aszum, fspecial('gaussian', [N N], N/4)); %Gaussa

subplot(221), imshow(b);
subplot(222), imshow(b2);
subplot(223), imshow(b3);
subplot(224), imshow(b4);

%filtr usredniajacy, usredniajacy Gaussa

%%
close all; clear; clc;
a = imread('cameraman.tif');
N = 5;
b1 = ordfilt2(a, 1, ones(N)); %filtr porzadku
b2 = ordfilt2(a, N*N, ones(N));

subplot(121), imshow(b1);
subplot(122), imshow(b2);

%%
%filtr entropii
close all; clear; clc;
a = imread('cameraman.tif');
N = 5;
%b1 = entropyfilt(a, ones(9)); %maska musi byc duza, minimum 9x9, mowi o niejednoronosci - 
%intensywnosci barw
%b2 = stdfilt(a, ones(5)); %odchylenie w malej masce
b1 = edge(a, 'canny');
b2 = edge(a, 'prewitt');

% subplot(121), imagesc(b1); colorbar('vertical');
% axis image;
% subplot(122), imagesc(b2); colorbar('vertical');
% axis image;
subplot(121), imshow(b1);
subplot(122), imshow(b2);

%%
close all; clear; clc;
a = imread('cameraman.tif');
maska = fspecial('motion', 11, 30);

b = imfilter(a, maska);
b%1 = deconvblind(b, maska);
%b1 = deconvlucy(b, maska);
b1 = deconvwnr(b, maska);

subplot(121), imshow(b);
subplot(122), imshow(b1);
