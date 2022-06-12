close all; clear; clc;

Nz=256;
Nx=256;
bok = 120;

xCoords = [round(Nx/2-bok/2) round(Nx/2+bok/2) round(Nx/2)];
zCoords = [round(Nz/2+bok*sqrt(3)/6) round(Nz/2+bok*sqrt(3)/6) round(Nz/2-bok*sqrt(3)/3)];
mask = poly2mask(xCoords, zCoords, Nx,Nz);
a = bwdist(~mask);

krok = 1:15;

[N, M] = size(a);
L2 = zeros(1, 15);

for k = krok
    kat=0:k:179;
    [R,X] = radon(a,kat);
    a_new = iradon(R,kat);
    a_new = a_new(2:N+1, 2:M+1) .* mask;
    L2(k) = sqrt(sum(sum((a-a_new).^2)))/bwarea(mask);
end

plot(krok,L2)
xlabel('krok');
ylabel('L2');


