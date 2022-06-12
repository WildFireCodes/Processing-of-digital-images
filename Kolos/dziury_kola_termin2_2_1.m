%%
close all; clear; clc;

a = zeros(100, 100);
a(10:20, 25:35) = 1;

imshow(a);


%%


close all; clear; clc;

a = imread('figury_02.png');

a_hsv = rgb2hsv(a);

bin = a_hsv(:, :, 2) > 0.01;
bin2 = ~a_hsv(:, :, 3) > 0.01;

bin = bin + bin2;
bin = medfilt2(bin, [3 3]);
bin = ordfilt2(bin, 5, ones(5));


% subplot(121),imshow(a);
% subplot(122),imshow(bin);

[aseq, N] = bwlabel(bin);

prop = regionprops(uint8(aseq), 'all');
wynik = false(size(bin));

for k = 1:N
%     if k == 2
%         continue
%     end

    mask = aseq == k;
    %obiekty, gdzie przynajmniej jedna dziura ma ksztalt kola

    %obiekty z dziurami
    if prop(k).EulerNumber <= 0
    %teraz musimy sprawdzic, co to za dziury - szukamy kol
        img_temp = ~mask;
        [aseq1, N1] = bwlabel(img_temp);

        for l = 1:N1
            mask1 = aseq1 == l;

            pole = bwarea(mask1);
            obwod = bwarea(bwperim(mask1));
            bwk = (4 * pi * pole) / (obwod^2);
        
            if abs (bwk - 1) < 0.12
                wynik = wynik + mask;
            end

        end
    end
end

subplot(131),imshow(bin);
subplot(132),imshow(wynik);
subplot(133), imshow(a_hsv);