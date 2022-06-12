close all; clear; clc;

a = zeros(320, 240, 3, 36, 'uint8');
% a(:, :, 1, :) = 255;
% a(:, :, 2, :) = 0;
% a(:, :, 3, :) = 255;

SE = strel('square', 7);

for k = 1:36
    if k < 13
        z = 180 - (60/12) * (k);
        x = 160 - round((120 * sqrt(3)/2/12)) * k;
    
    elseif k >= 13 && k < 25
        z = 120 - (60/12) * (k - 13);
        x = 160 - round((120 * sqrt(3)/2)) + round((120 * sqrt(3)/2/12)) * (k - 13);
    
    else
        z = 60 + (120/12) * (k-24);
    end

    a(x, z, 1, k) = round(255 - 255*(k)/36);
    a(x, z, 2, k) = round(255 - 255*(k)/36);
    a(x, z, 3, k) = round(255 - 255*(k)/36/5);
    a(:, :, :, k) = imdilate(a(:, :, :, k), SE);
 
    if k>1
        a(:, :, :, k) = a(:, :, :, k) + a(:, :, :, k-1);
    end

end

implay(a);