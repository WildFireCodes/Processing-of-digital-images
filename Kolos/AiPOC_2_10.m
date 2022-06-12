%18 37
close all; clear; clc;

a = imread('monety_4.jpg');
a_hsv = rgb2hsv(a);

all_coins = a_hsv(:, :, 1) < 0.4;
all_coins = imclearborder(all_coins);
all_coins = medfilt2(all_coins, [5 5]);
all_coins = imclose(all_coins, ones(7));
all_coins = imopen(all_coins, ones(7));

%srebrne monetki
srebrne = a(:,:,1)<0.3 & a(:,:,2)<0.4;

imshow(srebrne)
