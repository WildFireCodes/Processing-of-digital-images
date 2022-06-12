close all; clear; clc;

a = imread('tekst2.png');
a_hsv = rgb2hsv(a);
bin = a_hsv(:, :, 3) ~= 1;
bin = bwareaopen(bin, 40);

[aseq, N] = bwlabel(bin);
props = regionprops(aseq, 'all');

pole = zeros(1, N);

for k = 1:N
    pole(1, k) = props(k).Area;
end

min_pole = min(pole);
max_pole = max(pole);

counts = min_pole : 1 : max_pole; %generujemy wszystkie mozliwe pola

hist_pole = hist(pole, counts);

for w=1:3
    lit1=false(size(bin));
    nr = find(hist_pole == max(hist_pole), 1, 'first'); %indeks
    ile = counts(nr); %pole od danego indeksu - ile tego mam

    for k=1:N
        if pole(k) == ile
            lit1=lit1 + (aseq==k);
        end
    end
    subplot(2,2,w+1),imshow(lit1);

    hist_pole(nr)=0;
end
