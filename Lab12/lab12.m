%% 1. Wymiar fraktalny szkieletu
close all; clear; clc;

a = imread('circles.png');

skel = bwmorph(a, 'skel', inf);

bok = (3:2:15)'; %pionowy wektor bedzie latwiejszy do macierzy
N = length(bok);
pole = zeros(size(bok));

for k = 1:N
    temp = imdilate(skel, ones(bok(k))) & a;
    pole(k) = sum(temp(:));
end

%Pole = a * bok^D
%log(P) = log(a * bok^D)
%log(Pole) = log(a) + D * log(bok) = log(a) + log(bok ^ D) = log(a) + D * log(bok)
%y = b + D * x

%linia trendu - regresja liniowa
G = ones(N, 2);
G(:, 1) = log(bok);
m = pinv(G) * log(pole);
D = m(1); %m(2) jest log z a, m(1) to D
pole2 = exp(G * m);

loglog(bok, pole, 'or', bok, pole2, 'b');
xlabel('bok');
ylabel('pole');

pol = log(pole);
pest = log(pole2);
mpol = mean(pol);
mpest = mean(pest);

R = sum((pol - mpol).*(pest - mpest)) / (sqrt(sum((pol - mpol).^2)) * sqrt(sum((pest - mpest).^2)));
R^2 %fraktalnosc glownie do tego, zeby sprawdzic, jak bardzo 'poszarpany' jest obiekt

%% 7. Znakowanie
close all; clear; clc;

a = imread('cameraman.tif');
b = imread('circles.png');

blok = 16;
[Nz, Nx] = size(a);
Nb =floor(Nz / blok);
Mb = floor(Nx / blok);

WM = imresize(b, [Nb, Mb], 'nearest');
WM = 2 * double(WM) - 1; %z 0-1 na -1 przechodzimy na taki przedzial

sygn = zeros(Nz, Nx);

for kz = 1:Nb
    stz = (kz - 1) * Nb + 1; %lewy golny rog, poczatkowe wspolrzedne bloku znaku wodnego
    for kx = 1:Mb
        stx = (kx - 1) * Mb + 1;
        sygn(stz:stz + blok - 1, stx: stx + blok - 1) = WM(kz, kx);
    end
end

imagesc(sygn) %powiekszony znak wodny do rozmiaru naszego obrazka

%funkcja nosna -> wzmocnienie -> wymnozyc

wzm = 2; %widzialnosc ukrytego znaku wodnego
szum = randn(size(Nb * blok, Mb * blok));
sygn = sygn * wzm .* szum;

%zaszumiamy
a_WM = a;
a_WM(1: Nb * blok, 1 : Mb * blok) = uint8(sygn) + a(1: Nb * blok, 1 : Mb * blok);

subplot(121), imshow(a);
subplot(122), imshow(a_WM);

%odkodowanie
A = double(a_WM)/255;

A = fftshift(fft2(A));
f = zeros(Nz, Nx); %tablica na czestotliwosci, mozna przez meshgrida
f(round(Nz/2), round(Nx/2)) = 1;
f = bwdist(f);

f = f./max(f(:));

%Butterwortha - f0 to przekatna - 1- LP
HP = 1 - 1 ./ 1 + (f ./ 0.5)^8;
b_new = real(ifft2(ifftshift(A .* HP)));

%Filtracja * szum
b_new = b_new .* szum;

%robimy teraz petle, tylko w odwrotna strone - nie z malej w duza, tylko z duzej tablicy w mala

WM_new = zeros(Nb, Mb);
for kz = 1:Nb
    stz = (kz - 1) * Nb + 1; %lewy golny rog, poczatkowe wspolrzedne bloku znaku wodnego
    for kx = 1:Mb
        stx = (kx - 1) * Mb + 1;
        WM_new(kz, kx) = sum(sum(b_new(stz : stz + blok - 1, stx: stx + blok - 1)));
    end
end

WM_new = sign(WM_new);

%% 4. Labirynt
%szkieletyzacja -> hit or miss odcina galezie ktore sa sciankami i pozniej

close all; clear; clc;

a = imread('labirynt.png');
skel = bwmorph(a, 'skel', inf);

skel = bwmorph(skel, 'spur', inf);

wynik = uint8(a) + uint8(skel);
pal = [0 0 0; 1 1 1; 1 0 0];
imshow(wynik, pal)