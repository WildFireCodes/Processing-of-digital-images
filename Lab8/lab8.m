close all; clear; clc;

%male znikaja, wystajace moga byc uciete, moga byc otwarte polaczenia na
%zewnatrz, moga byc elementy rozdzielone - otwarcie

a = imread('blobs.png');

SE1 = strel('disk', 6);
SE2 = strel('line', 11, 30);
SE3 = ones(3);

a1 = imopen(a, SE1);
a2 = imopen(a, SE2);
a3 = imopen(a, SE3);

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);

%otwarcie - rozlaczenie i generalizacja obrazu
%dla monochromu max(min(X)), generalizuje w dol, w strone ciemnych

%%
close all; clear; clc;
a = imread('cameraman.tif');

SE1 = strel('disk', 6);
SE2 = strel('line', 11, 30);
SE3 = ones(3);

a1 = imopen(a, SE1);
a2 = imopen(a, SE2);
a3 = imopen(a, SE3);

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);

%%
% zamkniecie: Erozja(Dylatacja)
% male dziury znikna, duza dziura nic, bliskie elementy moga sie polaczyc
close all; clear; clc;
a = imread('blobs.png');

SE1 = strel('disk', 6);
SE2 = strel('line', 11, 30);
SE3 = ones(3);

a1 = imclose(a, SE1);
a2 = imclose(a, SE2);
a3 = imclose(a, SE3);

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);

% Erozja <= Otwarcie <= Obraz <= Zamkniecie <= Dylatacja
%mniejsze badz rowne na rownosc: dla jednokolorowych, jesli element
%strukturalny jest delta diraca, jednopixelowy
%%
close all; clear; clc;
a = imread('cameraman.tif');

SE1 = strel('disk', 6);
SE2 = strel('line', 11, 30);
SE3 = ones(3);

a1 = imclose(a, SE1);
a2 = imclose(a, SE2);
a3 = imclose(a, SE3);

subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);
%%
%Gradient morfologiczny
%1 Sposob: Obraz - erozja
%2 Dylacja - obraz
%3 Dylacja - Erozja, czasami dzieli sie przez 2, jezeli chcemy liczyc cos z
%polem po operacji, to dzielimy przez 2
%uzywa sie minimalnego elementu strukturalnego np ones(3)
close all; clear; clc;
a = imread('circles.png');
SE1 = ones(3);

a1 = imerode(a, SE1);
a2 = imdilate(a, SE1);

a3 = a - a1; %I - E - dostaniemy pixele na brzegu np 16<20
a4 = a2 - a; %D - I - bixele brzegowe, ale na zewnatrz np 24>20
a5 = a2 - a1; %D - E - (24+16)/2 = 20 == 20, przyklad to 5x5 kwadrat pixelowy

subplot(221), imshow(a);
subplot(222), imshow(a3);
subplot(223), imshow(a4);
subplot(224), imshow(a5);

%%
%rekonstrukcja morfologiczna 
%Obraz = Dylacja & Obraz, z jednego punktu mozemy odtworzyc kontury obrazu
%- na zewnatrz sa zerowane
close all; clear; clc;

a = imread('dziury.bmp');
%geodezyjna - najmniejsza odleglosc miedzy dwoma punktami
%np dla C idzie po wewnatrz, rekonstrukcja to bedzie jakas estymata

%Start - 20, 231
%Koniec - 84, 259

SE = ones(3);

%tworzymy marker (obraz z czarnych pikseli o rozmiarze naszego obrazu) a
%nastepnie zamieniamy w punkcie A piksel na True czyli bialy piksel.
%Dokonujemy Dylacji i iloczyn logiczny naszego obrazu z poprzedniej iteracji 
% az nasz piksel B nie bedzie True. Ilosc iteracji to estymowana droga pomiedzy A i B.

b = false(size(a));
b(20,231) = true;
n = 0;
while ~b(84, 259)
    b = imdilate(b, SE) & a;
    n = n + 1;
    %SE element strukturalny
end
n %zanizona - odleglosc do sasiadujacych pixeli, jezeli chcemy znac gorne zlozenie to zmieniamy SE z ones(3) 
% na np plus 0 1 0, 111, 010, dla linii prostej beda identyczne, bez False
% po drodze, dziur itd
imshow(b);

%usuwanie elementow stycznych z brzegiem
%%
close all; clear; clc;
a = imread('blobs.png');

%potrzebujmey pierwszego i ostatniego wiersza i kolumn
marker = a;
[N, M] = size(a);
marker(2:N-1, 2:M-1) = false;
kraw = imreconstruct(marker, a);
imshow(kraw);

a=a & ~kraw;
imshow(a);

%%
%
close all; clear; clc;
a = zeros(100, 100);
a(21:80, 41:60) = 1; %krzyzyk 
a(41:60, 21:80) = 1;

SE1 = [1 1 0; 1 -1 0; 1 0 -1];
SE2 = [1 1 1; 1 -1 0; 0 -1 0];
b = false(size(a));

while ~isequal(a,b)
    b=a; %stan poczatkowy przed 8 iteracjami
    for k=1:4 %4 operacje hit miss z rotacjami, dla siatki 6 katnej byloby 6
        a = a | bwhitmiss(a, SE1);
        a = bwmorph(a, 'clean'); %zeby narozniki sie nie rozrastaly
        SE1 = rot90(SE1);
        SE2 = rot90(SE2);
    end
end

imshow(a);
%%
close all; clear; clc;
a = imread('circles.png');
a1 = bwmorph(a, 'thicken', Inf);
a2 = bwmorph(a, 'thin', inf);
subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
a3 = bwmorph(a, 'dilate', inf);
subplot(224), imshow(a3);

%%
%szkieletyzacja
close all; clear; clc;
a = imread('circles.png');
a1 = imrotate(a, 35);

a_bw = bwmorph(a, 'skel', inf); %bwmorph spur usunie niektore niepotrzebne galezie 
a_bw1 = bwmorph(a1, 'skel', inf);
subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a_bw);
subplot(224), imshow(a_bw1);

%%
%tophat - sluzy do wyrownania oswietlenia na obrazie, bothat 
