close all; clear; clc
a=imread('cameraman.tif');
imshow(a);

%konwersja z int na double
b = double(a)/255;

%konwersja na int
c = uint8(b * 255); %najpierw do integera a pozniej mnozymy
imshow(c);

%%
b = a + 50;
b = b - 100;
b = b + 50;

%mamy zakres 7 - 253
%- 50 0 - 203
%+100 100 - 255
%50 - 205 ucina nam zakresy

subplot(121), imshow(a);
subplot(122), imshow(b);

%%
%obraz kolorowy - zmienna jest trojwymiarowa RGB
close all; clear; clc
a = imread('onion.png');
imshow(a);
%dekompozycja obrazka na palety
subplot(221), imshow(a);

for k=1:3
    subplot(2,2,k+1),imshow(a(:,:,k));
end
%0-3, 0-6, 0-1
b = rgb2gray(a); %przejscie na obraz monochromatyczny, operacja nieodwracalna
%%
%okreslamy gorna liczbe kolorow
%jezeli chcemy wyswietlic dwa obrazy o roznych legendach to matlab wezmie
%tylko ostatnia
%zmiana dynamiki obrazu
[map, leg] = rgb2ind(a, 10000); %10000 najmniejsza liczba kolorow
b = ind2rgb(map, leg);
subplot(121), imshow(a);
subplot(122), imshow(b);

%%
[map, leg] = rgb2ind(a, 1900); 
b = ind2rgb(map, leg);
subplot(121), imshow(a);
subplot(122), imshow(b);
%zmniejszajac dynamike mozna zaoszczedzic na rozmiarze
%%
close all; clear; clc
a = imread('cameraman.tif');
%imtool(a) w konsoli
b = imfinfo('cameraman.tif'); %info o pliku graficznym
c = regionprops(a, 'all');
d = regionprops(a, 'Area', 'Centroid');
N = length(d);
pole = zeros(N, 1);

%for n=1:N
%    pole(n, 1) = d(n).Area;
%    xc(n, 1) = d(n).Centroid(1);
%end
%mozna forem albo idiom matlaba ponizej
pole = [d(:).Area];
xc = [d(:).Centroid];
xc(2:2:end) = [];
intens = 1:N;
plot(intens, pole, 'r', intens, xc, 'b'); %czerwony to histogram
%niebieski mniej wiecej rowne rozmieszczenie

%%
close all; clear; clc
a = imread('onion.png');
%pobieramy rozmiar obrazka w 3 wymiarach wysokosc, szerokosc i 3
%jezeli potraktujemy jak dwuwymiarowy to szerokosc wzrosnie 3 krotnie
[N, M, K] = size(a);
subplot(121), imshow(a);
%profilowanie obrazka
subplot(122), improfile(a, [1, M], [1, N]);

%profilowanie "po kopercie" Lewy dolny -> prawy gorny -> wysokosc w dol ->
%przekatna do gornego lewego wierzcholka
%brak koloru czerwonego
%%
subplot(121), imshow(a);
%zeby z 3d miec 2d
b = improfile(a, [1 M M 1], [N 1 N 1]);
NN = size(b, 1);
nr = 1:NN;
subplot(122), plot(nr, b(:,1,2), 'g', nr, b(:,1,3), 'b'); 
 %%
 %rozdzielczosc obrazu: wymiary/DPI/sumaryczna ilosc pixeli/wymiar
 %pojedynczego pixela
 close all; clear; clc;
 a = checkerboard(8, 4, 4);
 %imshow(a);
 %interpolacja a aproksymacja
 %aproksymacja modelem a interpolacja punktem
 skala = 0.7;
 al = imresize(a, skala, 'nearest');
 a2 = imresize(a, skala, 'bilinear');
 a3 = imresize(a, skala, 'bicubic');
 subplot(221), imshow(a);
 subplot(222), imshow(a1);
 subplot(223), imshow(a2);
 subplot(224), imshow(a3);