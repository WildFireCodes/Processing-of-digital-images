close all; clear; clc;

% transformata Radona - jesli idziemy po wierszsach to dostajemy sume
% elementow w wierszu, po przekatnej pierwiastek np 3, 2 to bedzie 5
% pierwiastkow z 2
% tutaj odwrotna nie da tego samego

%czarny kwadrat, bialy srodek
a = zeros(100, 100);
a(31:70, 31:70) = 1;

kat = 0:1:179;

%tablica Radona, polozenie naszego odbiornika
[R,X] = radon(a, kat);
%maxima sa po przekatnej
imagesc(kat, X, R);
xlabel('kat [deg]')
ylabel('odleglosc [px]')

a_new = iradon(R, kat);
imshow(a_new);
%jak z ukladu plaskiego dojsc do ukladu medycznego? Bierzemy kazdy promien
%i grupujemy po azymutach
%%
close all; clear; clc;

a = phantom(256);
imshow(a);

kat = 0:2:179; %im wieksza rozdzielczosc tym wiecej promieni potrzeba
[R, X] = radon(a, kat);
imagesc(kat, X, R)
colorbar('vertical');

% stwierdzamy anomalie zmieniajac krok kat2
a_new = iradon(R, kat);
imshow(a_new);

%%
%%Hougha - wyszukiwanie prostych linii itp na obrazie, nie ma odwrotnej 
close all; clear; clc;

a = imread('blobs.png');

[H,T,R] = hough(a);
piki = houghpeaks(H,10); %tak jak w find znajdz np 10 maximow czy minimow
linie = houghlines(a, T, R, piki, 'FillGap', 2);
imagesc(T,R,H);
colorbar('vertical');
xlabel('kat \theta');
ylabel('promien \rho');
imshow(a);
hold on;

max = 0;
n = 0;

for k = 1:10
    line([linie(k).point1(1), linie(k).point2(1)], ...
        [linie(k).point1(2), linie(k).point2(2)], 'color', 'r')
    dlugosc = sqrt(abs(linie(k).point2(1) - linie(k).point1(1))^2 + abs(linie(k).point2(2) - linie(k).point1(2))^2);

    if dlugosc > max
        max = dlugosc;
        n = k;
    end
end
k = n;
line([linie(k).point1(1), linie(k).point2(1)], ...
        [linie(k).point1(2), linie(k).point2(2)], 'color', 'g');
hold off;

%%
%%transformata Gabora - tak jak falki
close all; clear; clc;

a = imread('cameraman.tif');
kat = 0:45:135;
dlug = 2.^(1:5);
g = gabor(dlug, kat);
magnituda = imgaborfilt(a, g);

subplot(121), imagesc(magnituda(:, :, 1));
subplot(122), imagesc(magnituda(:, :, 20));
% imagesc(real(g(1,20).SpatialKernel))

%%
close all; clear; clc;
a = imread('Gabor.png');
imshow(a);
[Nz, Nx] = size(a);
dlug = 2.^(1:7); %dlugosc 1 - 128
kat = 0:22.5:160;
g = gabor(dlug, kat);
magnituda = imgaborfilt(a,g);
%%
K = 3; %odchylenie naszego filtru
for k=1:length(g)
    odch = 0.5 * g(k).Wavelength;
    magnituda(:,:,k) = imgaussfilt(magnituda(:,:,k), K*odch);
end

xx = 1:Nx;
zz = 1:Nz;
[XX,ZZ] = meshgrid(xx, zz);
zbior = cat(3, magnituda, XX);
zbior = cat(3, zbior, ZZ);

%%
% Analiza glownych czynnikow
% z danych 3d na 2d
D = reshape(zbior, Nx*Nz, []);
D = D - mean(D);
D = D./std(D);
wspolczynniki = pca(D);
obraz = reshape(D*wspolczynniki(:,1), Nz, Nx);
imagesc(obraz);
%%
L = kmeans(D, 2, 'replicate', 5);
wynik = reshape(L, [Nz, Nx]);
an = imoverlay(a, BW, 'k');
imshow(an);
BW = (wynik == 1);

%transformaty fourier 2d, okragle anizotropowe, dct jpeg, radon medyczna,
%hough linie, okregi, gabor do niejednorodnosci w strukturze np tekst

%%
%Przeksztalcenia morfologiczne
close all; clear; clc;
SE1 = strel('disk', 6);
SE2 = strel('line', 11, 30);
SE3 = strel('arbitrary', [1 0 1; 1 0 1; 1 1 1; 1 0 1; 1 0 1]);

a = imread('circles.png');
% a1 = imerode(a, SE1);
% a2 = imerode(a, SE2);
% a3 = imerode(a, SE3);

a1 = imdilate(a, SE1);
a2 = imdilate(a, SE2);
a3 = imdilate(a, SE3);
subplot(221), imshow(a);
subplot(222), imshow(a1);
subplot(223), imshow(a2);
subplot(224), imshow(a3);

%%
close all; clear; clc;
a = zeros(100, 100);
a(31:70, 31:70) = 1;

SE1 = ones(3);
SE2 = ones(11);

a1 = imerode(a, SE2);
iter = 0;

while ~isequal(a, a1)
    a = imerode(a, SE1);
    iter = iter + 1;
end

subplot(221), imshow(a);
subplot(222), imshow(a1);



