%% ZADANIE 1
close all; clc; clear;
original = imread('monety_12.jpg');

a=rgb2hsv(original);

bin= a(:,:,1)<0.2 & a(:,:,2)<0.2;
bin=medfilt2(bin,[9 9]);
SE=strel('disk',10);
bin=imclose(bin,SE);
bin(580:620,1030:1070)=0;
bin(390:420,1710:1760)=0;

%watershed
SE=strel('disk',30);
b=imerode(bin,SE);
L=bwdist(b);
L=watershed(L);
a=bin & (L>0);

[aseg,N]=bwlabel(a);
region=regionprops(aseg);
pole=zeros(1,N);

for k=1:N
    pole(k)=region(k).Area;
end

[counts,edge]=histcounts(pole,4);

suma=(counts(1)*10+counts(2)*20+counts(3)*50+counts(4)*100)/100;
suma

result=original;
for k=1:c
    temp=(aseg==k);

    if  pole(k)<edge(2) 
        result=imoverlay(result,imdilate(bwperim(temp),ones(3)),'b');
    end
    if pole(k)>edge(2) && pole(k) <= edge(3)
        result=imoverlay(result,imdilate(bwperim(temp),ones(3)),'g');
    end
    if pole(k) > edge(3) && pole(k) <= edge(4)
        result=imoverlay(result,imdilate(bwperim(temp),ones(3)),'r');
    end
    if pole(k) > edge(4)
        result=imoverlay(result,imdilate(bwperim(temp),ones(3)),'y');
    end

end

imshow(result);

%% ZADANIE 2
close all; clc; clear;
a=imread('figury_02.png');
a_hsv=rgb2hsv(a);
bin=~(a_hsv(:,:,1)==0 & a_hsv(:,:,2)==0 & a_hsv(:,:,3)>0);
imshow(bin);
%%
wynik_dziury=false(size(bin));
wynik_gwiazdki=false(size(bin));

[aseg, N]=bwlabel(bin);
prop=regionprops(uint8(aseg),'EulerNumber','MajorAxisLength','MinorAxisLength','Circularity');

for k = 1:N
    mask = (aseg == k);
    
    %Znajduję wszystkie elementy z dziurami
    if prop(k).EulerNumber <= 0
        %negacja obrazu, analizujemy dziury
        [aseg1, N1] = bwlabel(~mask);
        prop1=regionprops(uint8(aseg1),'Circularity');

        %Jeżeli dziura ma circularity bliskie 1, to znaczy że jest kołem
        for l = 1:N1
            if abs (prop1(l).Circularity - 1) < 0.12
                wynik_dziury = wynik_dziury | mask;
            end
        end
    end
end

for k = 1:N
    mask = (aseg == k);
    temp=(prop(k).MajorAxisLength - prop(k).MinorAxisLength)/prop(k).MajorAxisLength;
    if temp > 0 && temp< 0.01 && prop(k).Circularity < 0.5
        wynik_gwiazdki = wynik_gwiazdki | mask;
    end
end

wynik_reszta=bin-wynik_dziury-wynik_gwiazdki;

wynik=imoverlay(a,~zeros(size(bin)),'y');
wynik=imoverlay(wynik,wynik_reszta,'g');
wynik=imoverlay(wynik,wynik_gwiazdki,'r');
wynik=imoverlay(wynik,wynik_dziury,'b');

imshow(wynik);


