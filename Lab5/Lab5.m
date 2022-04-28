close all; clear; clc;
%transformata falkowa
Fs = 100;
t = 0:(1/Fs):10;
x = sin(2*pi*(2+t/2).*t);
plot(t,x);
[C, L] = wavedec(x, 3, 'db3'); %dekompozycja, db3 to falka 3 rodzaju
L

A3 = C(1: L(1));
D3 = C(1 + L(1) + L(2));
D2 = C(1 + L(1) + L(2) : L(1) + L(2) + L(3));
D1 = C(1 + L(1) + L(2) + L(3) : L(1) + L(2) + L(3) + L(4));

%kopiuje wektor C do zmiennej pomocniczej
C1 = C;
C1(1:L(1)) = 0; %C1 na wspolrzednej A3 = 0
A3 = waverec(C1, L, 'db3'); %i robimy rekonstrukcje, dla kazdego tak samo mozemy zrobic, tzn
%zerujemy czesc D3 i znowu, D2 itd


subplot(411), plot(A3);
subplot(412), plot(D3);
subplot(413), plot(D2);
subplot(414), plot(D1);

%%
close all; clear; clc;

Fs = 100;
t = 0:(1/Fs):10;
x = sin(2*pi*4*t);
x(357) = []; t(357) = []; %mamy ciagla rejestracje, ale jedna randomowa probka sie nie zapisala
plot(t, x); %transformata falkowa pozwala nam wykryc takie elementy, sygnal nie msui byc ciagly!
%%
close all; clear; clc;
a = imread('cameraman.tif');
[C, L] = wavedec2(a, 2, 'sym4');
L % w pierwszym wierszu A2, drugi H2 V2 D2, trzeci H1 V1 D1

L2 = L(:, 1) .* L(:,2); %ilosc pixeli wysokosc razy szerokosci
A2 = C(1:L2(1));
AA2 = reshape(A2, [L(1,1) L(1,2)]);
imagesc(AA2), axis image

C1 = C; %odfiltrowujemy wszystkie skladowe detali
C1(1 + L2(1) : end) = 0;
anew = waverec2(V1, L, 'sym4');
imshow(uint8(anew));

%zerujemy V1 i V2
C1(1 + L2(1) + L2(2):L2(1) + 2*L2(2)) = 0; %V2
C1(1 + L2(1) + 3*L2(2) + L2(3) : L2(1) + 3*L2(2) + 2*L2(3)) = 0; %V1
anew = waverec2(C1, L, 'sym4');
imshow(uint8(anew));

%predykcyjna transformata 2D do JPEG2000

%%
close all; clear; clc; %TRANSFORMATA cosiunusowa - zostajemy w liczbach rzeczywistych

a = imread('cameraman.tif');
a = double(a)/255;
A = dct2(a);
imagesc(log(abs(A) + 0.01)); axis image %w zerowym indeksie mamy sume wszystkich wartosci obrazu, dlatego potrzebujemy wyswietlic z log

r = [5, 10, 25, 50, 100].^2;
%filtracja dolnoprzepustowa
[Nz, Nx] =  size(a);
odl = zeros(Nz, Nx);
%petla po wszystkich wierszach, kolumnach
for kz = 1:Nz
    for kx = 1:Nx
        odl(kz, kx) = kz^2 + kx^2; %nie liczymy pierwiastka aby zoptymalizowac obliczenia i ich ilosc
    end
end

for k = 1:5
    LP = (odl <= r(k));
    anew = idct2(LP.*A);
    subplot(2, 3, k+1), imshow(anew);
end
subplot(231), imshow(a);
%%
close all; clear; clc;
a = imread('cameraman.tif');
%filtracja po wartosciach bezwzglednych transformaty
A = double(a)/255;
A = dct2(a);
th = [0.01, 0.05, 0.1, 0.5, 1];
[Nz, Nx] = size(a);

for kz = 1:Nz
    for kx = 1:Nx
        odl(kz, kx) = kz^2 + kx^2; %nie liczymy pierwiastka aby zoptymalizowac obliczenia i ich ilosc
    end
end

for k = 1:5
    HP = (abs(A) >= th(k));
    ile_zer = 100*sum(HP(:) == 0) / (Nz*Nx);
    anew = idct2(HP.*A);
    subplot(2, 3, k+1), imshow(anew);
    title(num2str(ile_zer));
end
subplot(231), imshow(a);

%%JPEG92 DZIALANIE
%1. RGB -> YCbCr (intensywnosc, dopelnienie do niebieskiego, do czerwonego)
%zakladamy, ze srednia to 0, odejmujemy na sztywno - 128
%3. downsampling - usuwamy co drugi wiersz/kolumne - nie bedziemy z tego
%korzystac
%4. Dzielimy na bloki na 8x8x1 liczymy:
%a) transforata cosiunusowa dwuwymiarowa
%b) palete dzielimy 
%c) zaokraglamy do calkowitch
%d) zigzag
%e) kodujemy i zapisujemy
close all; clear; clc;
Qy = [16 11 10 16 24 40 51 61
12 12 14 19 26 58 60 55
14 13 16 24 40 57 69 56
14 17 22 29 51 87 80 62
18 22 37 56 68 109 103 77
24 35 55 64 81 104 113 92
49 64 78 87 103 121 120 101
72 92 95 98 112 100 103 99];

Qc = [17 18 24 47 99 99 99 99
18 21 26 66 99 99 99 99
24 26 56 99 99 99 99 99
47 69 99 99 99 99 99 99
99 99 99 99 99 99 99 99
99 99 99 99 99 99 99 99
99 99 99 99 99 99 99 99
99 99 99 99 99 99 99 99];

a = imread('peppers.png');
b = rgb2ycbcr(a);

b = double(b);

b = b - 128;

[Nx, Ny, Nc] = size(a);

for i = 1:8:Nx
    for j = 1:8:Ny
        for z = 1: Nc
            temp = b(i:i+7, j:j+7, z);
            T = dct2(temp);
            if(z == 1)
                T = T./Qy;
            else
                T=T./Qc;
            end
            T = round(T);
            %dekompresja
            if (z == 1)
                T = T.*Qy;
            else
                T = T.* Qc;
            end
            temp = idct2(T);
            b(i:i+7, j:j+7, z) = temp; 
        end
    end
end
b= uint8(b+128);
b = ycbcr2rgb(b);
subplot(121), imshow(a);
subplot(122), imshow(b);


