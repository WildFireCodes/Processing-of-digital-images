close all; clear; clc;
%przechodzimy od razu na double

a = imread('cameraman.tif');
a = double(a)/255;

%transformata Fouriera
A = fftshift(fft2(a)); %z przesunieciem Widma
WA = abs(A); %widmo amplitudowe, faza nas nie interesuje
%WA = pierwiastek z (Re^2 + Im^2)
% imagsc(log(WA + 0.01)); axis image  %logarytm zeby bylo cokolwiek widac
%mala liczba zeby nie bylo zera
%czestotliwosc probkowania najwazniejsza - dowolona, co pixel w przypadku
%wideo
%dwa podejscia: szerokosc i wysokosc obrazka / normalizacja od -0.5 do 0.5

[Nz, Nx] = size(a);
fx = linspace(-0.5, 0.5, Nx);
fz = linspace(-0.5, 0.5, Nz); %do podpisania osi, ale zeby robic obliczenia przyda sie tablica -
%meshgrid
[FX, FZ] = meshgrid(fx, fz); %albo dwie ortogonalne albo jedna wypadkowa
%jako:
f = sqrt(FX.^2 + FZ.^2);
% 
% subplot(121), imagesc(FX); colorbar('vertical');
% subplot(122), imagesc(FZ); colorbar('vertical');
%imagesc(fx, fz, log(WA + 0.01)); axis image
%filtry LP %mniejszy od jakiejsc czestotliwosci
LP = f < 0.25;
%imshow(LP);

%teraz filtr * transformata obrazu i powrot:
b = real(ifft2(ifftshift(LP.*A)));
subplot(121), imshow(a);
subplot(122), imshow(b); %orbaz jest rozmyty, elementy wokol plaszcza - efekt odciecia

f0 = 0.1;
N = 2;
filtr = 1./(1+(f./f0).^(2*N));
dolnoprzepustowy_gauss = exp(-f.^2/(2.*f0).^2);
c = real(ifft2(ifftshift(dolnoprzepustowy_gauss.*A)));
subplot(121), imshow(a);
subplot(122), imshow(c);
%%
close all; clear; clc;
a = imread("F_dzieciol.png");
imshow(a);
%odfiltrowac w domenie czestotliwosci: teraz liczymy WA dla kazdej palety
%barw
[Nz, Nx, k] = size(a);
fx = linspace(-0.5, 0.5, Nx)
fz  = linspace(-0.5, 0.5, Nz);
[FX, FZ] = meshgrid(fx, fz);

BS = (abs(FX) > 0.17 & abs(FX) < 0.24) &...
     (abs(FZ) > 0.15 & abs(FZ) < 0.25);

BS = ~BS; %czarne na bialym albo biale na czarnym
a_new = a;


subplot(221), imshow(a);

for k = 1:3
    A = fftshift(fft2(a(:,:,k)));
    WA = abs(A);
    subplot(2, 2, k+1);
    imagesc(fx, fz, log(WA + 0.01));
    a_new(:,:,k) = real(ifft2(ifftshift(A.*BS)));
end

%filtrujemy znieksztalcenia obrazka: odczytujemy zakresy fx, fz i tworzymy
%maske idealna: 55 linijka
figure;
subplot(121), imshow(a);
subplot(122), imshow(a_new);
%filtracja czestotliwosciowa sluzy do wyciec znieksztalcen

%%
close all; clear; clc;

bw = imread('text.png');
a = bw(32:45, 88:98);
subplot(121), imshow(a);
subplot(122), imshow(bw);

%szukamy literki a - korelacja (miara podobienstwa) wprost z definicji
%transfotmata fouriera
C = real(ifft2(fft2(bw).*fft2(rot90(a,2),256,256)));
imagesc(C); axis image
imshow(C > 65);

%element strukturalny
SE = ones(size(a));
bin = C > 65;
test = imdilate(bin, SE);
test = circshift(test, [-7, -6]);
test = test & bw;
imshow(test);
%%
%szukanie r = gorny prawy dolny rog, pozniej liczymy korelacje, wartosc w
%okolicy maximum (C>65), odwracamy kolejnosc i powinno byc w porzadku
close all; clear; clc;
bw = imread('text.png');
imshow(bw);
r = bw(33:45, 104:112); %macierze 

C = real(ifft2(fft2(bw).*fft2(rot90(r,2),256,256)));
C1 = real(ifft2(fft2(~bw).*fft2(rot90(~r,2),256,256)));


SE = ones(size(r));
bin = (C + C1) > 115;
test = imdilate(bin, SE);
test = circshift(test, [-7, -6]); %przesuinecie o polowe sygnatury (zmienna r)
test = test & bw;
imshow(test);

%%
close all; clear; clc;
a = imread('cameraman.tif');
%zainstalowac wavelet

