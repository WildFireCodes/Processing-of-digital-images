close all; clear; clc;

a = imread('monety_4.jpg');
a_hsv = rgb2hsv(a);
a_logic = a_hsv(:, :, 1) < 0.3; %& a_hsv(:, :, 2) < 0.2;

a_logic = imfill(a_logic, 'holes');
a_logic = imerode(a_logic, ones(15));

% SE = strel('disk', 3);
a_logic = bwmorph(a_logic, 'spur');

temp = imerode(a_logic, ones(35));
b = bwdist(temp);
a_watershed = a_logic & (watershed(b)>0);

imshow(a_watershed);
%%
[aseq, N] = bwlabel(a_watershed);
pole = zeros(1, N);

for k = 1:N
    mask = aseq == k;
    pole(1, k) = bwarea(mask);
end

[count, edge] = histcounts(pole, 4);

result = count(1)*0.10 + count(2)*0.20 + count(3)*0.50 + count(4);
result

img = a_watershed;
% for k = 1:N
%     mask = aseq == k;
%     if pole(k) > edges(1) && pole(k) < egdes(2)
%         img = imoverlay(img, bwperim(mask), 'g');
% 
%     elseif pole(k) > edges(2) && pole(k) < egdes(3)
%         img = imoverlay(img, bwperim(mask), 'r');
% 
%     elseif pole(k) > edges(3) && pole(k) < egdes(4)
%         img = imoverlay(img, bwperim(mask), 'b');
% 
%     elseif pole(k) > edges(4) && pole(k) < egdes(5)
%         img = imoverlay(img, bwperim(mask), 'y');
%     end
% end


hist(pole,4);

