%% ZADANE 1
close all; clc; clear;
original = imread('monety_5.jpg');

a=rgb2hsv(original);
SE1=strel('disk',5);
SE2=strel('disk',5);

bin= a(:,:,3)>0.3 & a(:,:,2)<0.2;

bin=imclose(bin,SE2);
bin=medfilt2(bin,[10 10]);
bin=imfill(bin,'holes');
bin=imopen(bin,SE1);

bin(110:170,1450:1550)=0;
bin(704:750,740:800)=0;
bin(660:700,570:630)=0;
bin(1340:1400,250:350)=0;
bin(320:390,340:440)=0;
imshow(bin)

%watershed
SE3=strel('disk',25);
b=imerode(bin,SE3);
L=bwdist(b);
L=watershed(L);
a=bin & (L>0);

%etykietyzacja
[aseg, N]= bwlabel(a);
region=regionprops(a,'Area','Centroid','EquivDiameter');
pole=zeros(1,N);

for k=1:N
    pole(k)=region(k).Area;
end

[counts,edge]=histcounts(pole,4);

suma=counts(1)*10+counts(2)*20+counts(3)*50+counts(4)*100;
suma/100

imshow(original);

for k=1:N
    temp=(aseg==k);

    if pole(k)<=edge(2)
        viscircles(region(k).Centroid,region(k).EquivDiameter/2,'Color','y');
    end
    if pole(k)>edge(2) && pole(k)<=edge(3)
        viscircles(region(k).Centroid,region(k).EquivDiameter/2,'Color','b');
    end
    if pole(k)>edge(3) && pole(k)<=edge(4)
        viscircles(region(k).Centroid,region(k).EquivDiameter/2,'Color','r');
    end
    if pole(k)>edge(4)
        viscircles(region(k).Centroid,region(k).EquivDiameter/2,'Color','g');
    end



end
%% ZADANIE 2
close all; clc; clear;

a=imread("figury_06.png");
a_gray=rgb2gray(a);
bin=a_gray<225 | a_gray==255;
bin=imclearborder(bin);

[aseg,N]=bwlabel(bin);
region=regionprops(aseg,'all');

wynik=zeros(size(bin));
wynik_gwiazdki=zeros(size(bin));
wynik_kwadraty=zeros(size(bin));

for k=1:N
    mask=(aseg==k);
    temp=(region(k).MajorAxisLength-region(k).MinorAxisLength)/region(k).MajorAxisLength;
    if temp <0.02 && region(k).Circularity <0.4
        wynik_gwiazdki= wynik_gwiazdki | mask;
    end

    if region(k).EulerNumber <=0
        [aseg1,N1]=bwlabel(~mask);
        region1=regionprops(aseg1,'all');

        for l=1:N1
            mask1=(aseg1==l);
            pole=bwarea(mask1);
            obwod=bwarea(bwperim(mask1));
            bwk=(16*pole)/(obwod*obwod);
            
            if abs(bwk-1)<0.035
                wynik_kwadraty=wynik_kwadraty | mask;
            end
        end
    end
end


wynik_reszta=bin-wynik_gwiazdki-wynik_kwadraty;

wynik=imoverlay(wynik,~wynik,'y');
wynik=imoverlay(wynik,wynik_gwiazdki,'g');
wynik=imoverlay(wynik,wynik_reszta,'b');
wynik=imoverlay(wynik,wynik_kwadraty,'r');
imshow(wynik)

