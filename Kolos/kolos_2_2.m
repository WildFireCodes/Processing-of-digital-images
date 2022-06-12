%% zadanie 1
close all; clear;clc;
original=imread('monety_4.jpg');


SE1=strel("disk",8);

a=rgb2hsv(original);

bin=a(:,:,1)<0.3 & a(:,:,2)<0.4 ;
bin=imopen(bin,SE1);
bin=imclose(bin,SE1);

bin(400:555,200:300)=0;
bin(880:960,430:530)=0;

%watershed
SE=strel("disk",40);
b=imerode(bin,SE);
L=bwdist(b);
L=watershed(L);

a=bin & (L>0);

%etykietowanie

[aseg, N]= bwlabel(a);
region=regionprops(aseg,'Area','Centroid','EquivDiameter');
pole=zeros(1,N);

for k=1:N
    pole(k)=region(k).Area;
end

[counts,edge]=histcounts(pole,4);
suma=counts(1)*10+counts(2)*20+counts(3)*50 + counts(4)*100;
suma/100
wynik=original;

imshow(wynik)
for k =1:N
    temp=aseg==k;

    if region(k).Area <= edge(2)
       viscircles(region(k).Centroid, region(k).EquivDiameter/2,'Color','r');
    end
    if region(k).Area > edge(2) && region(k).Area <= edge(3)
        viscircles(region(k).Centroid, region(k).EquivDiameter/2,'Color','b');
    end
    if region(k).Area > edge(3) && region(k).Area <= edge(4)
        viscircles(region(k).Centroid, region(k).EquivDiameter/2,'Color','y');
    end
    if region(k).Area > edge(4)
        viscircles(region(k).Centroid, region(k).EquivDiameter/2,'Color','b');
    end

end

%% Zadanie 2
close all; clc; clear;

a=imread('figury_01.png');
a_hsv=rgb2hsv(a);
bin=~(a_hsv(:,:,1)==0 & a_hsv(:,:,3)<1 & a_hsv(:,:,3)>0);

[aseg,N]=bwlabel(bin);
region=regionprops(aseg,'all');

wynik_gwiazdki=zeros(size(bin));
wynik_triangle=zeros(size(bin));
wynik=~zeros(size(bin));

for k=1:N
    mask=aseg==k;
    temp=(region(k).MajorAxisLength - region(k).MinorAxisLength)/region(k).MajorAxisLength;
    if temp < 0.11 && region(k).Circularity < 0.6
        wynik_gwiazdki=wynik_gwiazdki+mask;
    end
end

for k=1:N
    mask=aseg==k;
    pole_bound=region(k).BoundingBox(3)*region(k).BoundingBox(4)/2;

    if abs(pole_bound - region(k).ConvexArea)<0.05
        wynik_triangle=wynik_triangle+mask;
    end
end


pozostale= bin-wynik_gwiazdki-wynik_triangle;
wynik=imoverlay(wynik, wynik_gwiazdki,'b');
wynik=imoverlay(wynik,pozostale,'g');
wynik=imoverlay(wynik,wynik_triangle,'r');

subplot(121),imshow(wynik);
subplot(122),imshow(a);

%% ZADANIE 3
close all;clc;clear;
