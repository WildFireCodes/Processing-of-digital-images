%% 1
close all;clc;clear;
a=imread('grosze_01.jpg');

a_hsv = rgb2hsv(a);

a_logical=a_hsv(:,:,1)<0.30;

% watershed
temp=imerode(a_logical, ones(30));
b=bwdist(temp);
a_watershed=a_logical & (watershed(b)>0);

a_cleaned=imopen(a_watershed, ones(25));

% etykietowanie
[aseq, N]=bwlabel(a_cleaned);

pole=zeros(N,1);

for k=1:N
    temp=(aseq==k);
    pole(k,1)=bwarea(temp);
end

[counts, boundaries]=histcounts(pole, 3);

result=(counts(1)+counts(2)*2+counts(3)*5)/100;
result

monety1=find(pole>boundaries(1) & pole<boundaries(2));
monety2=find(pole>boundaries(2) & pole<boundaries(3));
monety5=find(pole>boundaries(3) & pole<boundaries(4));

monety={monety1, monety2, monety5};
color=['g', 'b', 'r'];

img_result=a;

for k=1:3
    temp=ismember(aseq, monety{k});
    img_result=imoverlay(img_result, bwperim(temp), color(k));
end

imshow(img_result);


%% 3
close all; clc; clear;

a=imread("football.jpg");

a_gray=rgb2gray(a);

a_double=double(a_gray)/255;

% imshow(a);

[N,M]=size(a_gray);

temp=zeros(N,M);
temp(N/2, M/2)=1;

noise=0.1*sin(0.4*pi*bwdist(temp));

% imshow(noise);

a_noisy=a_double+noise;

FT=fftshift(fft2(a_noisy));
WA=abs(FT);

fx=linspace(-0.5, 0.5, M);
fz=linspace(-0.5, 0.5, N);

[FX, FZ]=meshgrid(fx, fz);

f=sqrt(FX.^2+FZ.^2);

% Butterworth
n=4;
f0=0.12;

LP=1./(1+(f/f0).^(2*n));

a_denoised=ifft2(ifftshift(FT.*LP));

subplot(221), imshow(a_gray);
subplot(222), imshow(a_noisy);
subplot(223), imagesc(WA, 'XData',fx, 'YData', fz);
subplot(224), imshow(a_denoised);

