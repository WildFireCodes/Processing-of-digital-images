%%
%Analiza obrazow
%1. Akwizacja
%2. Preprocessing (przetwarzanie wstepne)
%3. Segmentacja (binaryzacja)
%4. Analiza obrazu
%Wizualizacja

close all; clear; clc;
%analiza pol i obwodow ziaren (histogram)

%akwizacja
a = imread('rice.png');
subplot(231), imshow(a);

se = strel('disk',12);
b = imtophat(a,se); %wygladzenie tla
b = imadjust(b);
subplot(232), imshow(a);

bin = b > 100;
bin = bwmorph(bin, 'clean');

D = imerode(bin, ones(4)); %zweza
D = bwdist(D);
%D = -bwdist(~bin); %bo liczymy do srodka a nie na zewnatrz
L = watershed(D);
bin = bin & (L>0); %automatyczna nie dziala, trzeba recznie przez erozje i liczyc na zewnatrz  a nie w ziarnach

bin = imclearborder(bin); %wyrzucamy brzegowe

[aseq, N] = bwlabel(bin);
pole = zeros(N,1);
obwod=zeros(N,1);

for k=1:N
    tt=(aseq==k);
    pole(k,1)=bwarea(tt);
    obwod(k,1)=bwarea(bwperim(tt));
end

subplot(121), hist(pole,20);
subplot(122), hist(obwod,20);



obwod=zeros(N,1);



jk = uint8(bin).*a;
kj = uint8(~bin).*a;

subplot(233), imshow(jk);
subplot(234), imshow(kj);

%%
close all; clear; clc;
[map, pal] = imread('w_shape.png');
imshow(map, pal);

bin=(map~=11);

subplot(121), imshow(map,pal);
subplot(122), imshow(bin);


[aseq, N] = bwlabel(bin); %etykietowanie
wynik = false(size(bin));

for k=1:N
  tt = (aseg==k);
  pole = bwarea(tt);
  obwod = bwarea(bwperim(tt));
  bwk = 4*pi*pole/(obwod^2);
  if abs(bwk-1)<0.15
      wynik = wynik | tt;
  end
end


subplot(121), imshow(map,pal);
subplot(122), imshow(wynik);



%%

%%
close all; clear; clc;
[map, pal] = imread('w_shape.png');
imshow(map, pal);

bin=(map~=11);

%subplot(121), imshow(map,pal);
%subplot(122), imshow(bin);


[aseq, N] = bwlabel(bin); %etykietowanie
wynik = false(size(bin));

for k=1:N
  tt = (aseq==k);
  pole = bwarea(tt);
  obwod = bwarea(bwperim(tt));
  bwk = 4*pi*pole/(obwod^2);
  if abs(bwk-pi/4)<0.10 %BWK = 4 pi pole / obw^2
      wynik = wynik | tt; %dodawanie obrazow logicznych
  end
end

subplot(121), imshow(map,pal);
subplot(122), imshow(wynik);

obwod=zeros(N,1);

%% szukanie elips, nie kola

close all; clear; clc;
[map, pal] = imread('w_shape.png');
imshow(map, pal);

bin=(map~=11); %usuniecie index tla

[aseq, N] = bwlabel(bin); %etykietowanie
prop = regionprops(uint8(aseq), 'all');
wynik = false(size(bin));

%elipsy 
for k=1:N
  tt = (aseq==k);
  pole = bwarea(tt);
  obwod = bwarea(bwperim(tt));
  bwk = 4*pi*pole/(obwod^2);
  if abs(bwk-1)>0.05 %wszystko poza kolami
      pole2 = pi*prop(k).MinorAxisLength * prop(k).MajorAxisLength/4; %dzielimy przez 4, bo jedno przez dwa i drugie przez dwa
      if abs(pole/pole2 - 1) < 0.01
          wynik = wynik | tt;
      end
  end
end

subplot(121), imshow(map,pal);
subplot(122), imshow(wynik);

obwod=zeros(N,1);


%szukajac jakis dziwnych nieregularnych ksztaltow balansujemy pomiedzy
%FERET a BWK
%%
%% szukanie elips, nie kola

close all; clear; clc;
[map, pal] = imread('w_shape.png');
imshow(map, pal);

bin=(map~=11); %usuniecie index tla

[aseq, N] = bwlabel(bin); %etykietowanie
prop = regionprops(uint8(aseq), 'all');
wynik = false(size(bin));

%trojkaty, mozna uzyc Hoffa do krawedziowki, my uzyjemy pola
%trzeba wypelnic dziury, zeby nie zaburzaly figur

for k=1:N
  tt = (aseq==k);
  pole = bwarea(tt);
  obwod = bwarea(bwperim(tt));
  bwk = 4*pi*pole/(obwod^2);
  if abs(bwk-1)>0.05 %wszystko poza kolami
      pole2 = pi*prop(k).MinorAxisLength * prop(k).MajorAxisLength/4; %dzielimy przez 4, bo jedno przez dwa i drugie przez dwa
      if abs(pole/pole2 - 1) < 0.01
          wynik = wynik | tt;
      end
  end
  if prop(k).EulerNumber == 0
      wynik = wynik | tt; %obiekty z dziurami
  end
   
  pole2=prop(k).BoundingBox(3).*prop(k).BoundingBox(4)/2;
  
  if abs(pole/pole2-1)<0.02
      if abs(prop(k).Area/prop(k).ConvexArea-1) < 0.02
          wynik = wynik | tt;
      end
  end
end

subplot(121), imshow(map,pal);
subplot(122), imshow(wynik);
