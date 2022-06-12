close all; clear; clc;

a = zeros(300, 300, 3, 24, 'uint8'); %300 wierszy, 300 kolumn, 3 kolory, 24 klatki
% a(:, :, 1, :) = 255;
% a(:, :, 2, :) = 255;
% a(:, :, 3, :) = 0;

SE = strel('disk', 9);

for k = 1:24
    if k < 7
        z = 150 + round(120 * sqrt(2)/2) - round(120 * sqrt(2)/2/6) * (k);
        x = 150 - round(120 * sqrt(2)/2/6) * (k);

    elseif k >=7 && k < 13
        z = 150 - round(120 * sqrt(2)/2/6) * (k-7);
        x = 150 - round(120 * sqrt(2)/2) + round(120 * sqrt(2)/2/6) * (k-7);

    elseif k >= 13 && k < 19
        z = 150 - round(120 * sqrt(2)/2) + round(120 * sqrt(2)/2/6) * (k-13);
        x = 150 + round(120 * sqrt(2)/2/6) * (k-13);
    
    else
        z = 150 + round(120 * sqrt(2)/2/6) * (k-19);
        x = 150 + round(120 * sqrt(2)/2) - round(120 * sqrt(2)/2/6) * (k-19);
    end
    %czerwony 255 0 0
    %bialy 255 255 255
    
     a(z, x, 1, k) = 255;
     a(z, x, 2, k) = round(0 + 255*(k)/24);
     a(z, x, 3, k) = round(0 + 255*(k)/24);
     a(:, :, :, k) = imdilate(a(:, :, :, k), SE);
 
     if k>1
         a(:, :, :, k) = a(:, :, :, k) + a(:, :, :, k-1);
     end
end

implay(a);


%%


% %%
% for k = 1:20
% 
%     if (k>=1) && (k<5)
%         x =  150-round((100sqrt(2))/2/5)(k);
%         z = (100+round((100sqrt(2))/2)) + (-round((100sqrt(2))/2/5))k;
%     end
% 
% %%
%      a(z, x, 2, k) = round(255 - 255(k-1)/19);
%      a(z, x, 3, k) = round(0 + 255(k-1)/19);
%      a(:, :, :, k) = imdilate(a(:, :, :, k), SE);
%  
%      if k>1
%          a(:, :, :, k) = a(:, :, :, k) + a(:, :, :, k-1);
%      end