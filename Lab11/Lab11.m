close all; clear; clc;

%dwa podejscia
%1D
%4D:wys x szer x {1,3} x N_klatek

%czarny obrazek, kwadracik bedzie poruszal sie po przekatnej z predkoscia
%px/klatke, Vx=Vz=5px/klatka

a = zeros(100, 100, 1, 19, 'uint8'); %19 stad, ze tyle klatek potrzebne do przejscia

for k = 1:19
    st = 5 * (k-1) + 1; %wspolrzedna X i Z, bo poruszamy sie rownomiernie
    a(st:st+9, st:st+9, 1, k) = 255;
end

implay(a);

%%
close all; clear; clc;
%teraz od lewego dolnego do prawego gornego - antyprzekatna, ale w gore

a = zeros(100, 100, 1, 19, 'uint8');

for k = 1:19
    stx = 5 * (k-1) + 1;
    stz = 91 - (k-1) * 5;
    a(stz:stz+9, stx:stx+9, 1, k) = 255;
end

implay(a);
%%
close all; clear; clc;

% 360/15 = 24
a = zeros(200, 300, 1, 24, 'uint8');
SE = strel('disk', 5);

Rx = 100;
Rz = 70;

for k = 1:24
    kat = -(k-1) * 15;
    x = round(150 + Rx * cosd(kat));
    z = round(100 + Rz * sind(kat));
    a(z, x, 1, k) = 255;
    a(:, :, 1, k) = imdilate(a(:,:,1,k), SE);
end

implay(a);

%% Kuleczek jest tyle, co iteracji
close all; clear; clc;

% 360/15 = 24
a = zeros(200, 300, 1, 24, 'uint8');
SE = strel('disk', 5);

Rx = 100;
Rz = 70;

for k = 1:24
    kat = -(k-1) * 15;
    x = round(150 + Rx * cosd(kat));
    z = round(100 + Rz * sind(kat));
    a(z, x, 1, k) = 255;
    a(:, :, 1, k) = imdilate(a(:,:,1,k), SE);
    if k>1
        a(:, :, 1, k) = a(:, :, 1, k) + a(:, :, 1, k-1);
    end
end

implay(a);

%% plynna zmiana koloru
close all; clear; clc;

% 360/15 = 24
a = zeros(200, 300, 3, 24, 'uint8');
SE = strel('disk', 5);

Rx = 100;
Rz = 70;

for k = 1:24
    kat = -(k-1) * 15;
    x = round(150 + Rx * cosd(kat));
    z = round(100 + Rz * sind(kat));
    a(z, x, 2, k) = round(255 - 255*(k-1)/23);
    a(z, x, 3, k) = round(0 + 255*(k-1)/23);

    a(:, :, :, k) = imdilate(a(:, :, :, k), SE);

    if k>1
        a(:, :, :, k) = a(:, :, :, k) + a(:, :, :, k-1);
    end
      
end

implay(a);

%%
close all; clear; clc;
load pendulum
% implay(frames);

[Nz, Nx, k, klatka] = size(frames);
maska = false(Nz, Nx);
maska(14:84, 21:274) = true;

wsp_x = zeros(klatka, 1);
wsp_z = wsp_x;

for k = 1:klatka
    temp = frames(:, :, :, k);
    bin = (temp(:, :, 1) < 60) & (temp(:, :, 2) < 60) & (temp(:, :, 3) < 60);
    bin = bin & maska;
    bin = bwmorph(bin, 'clean');
    bin = imclose(bin, ones(3));
    bin = imopen(bin, ones(3));

    centr = regionprops(uint8(bin), 'Centroid').Centroid;
    wsp_x(k) = centr(1);
    wsp_z(k) = centr(2);
end

% plot(wsp_x, wsp_z, '.'); axis equal;
G = zeros(klatka, 3);
G(:, 3) = 1;
G(:, 1) = wsp_x;
G(:, 2) = wsp_z;

d = -wsp_x.^2 - wsp_z.^2;
m = pinv(G) * d;

x0 = -m(1)/2;
z0 = -m(2)/2;

r = sqrt(x0^2 + z0^2 -m(3));


