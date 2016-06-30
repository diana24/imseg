% Brain tumor detection method using histogram thresholding, filters and
% morphological operations.
% http://ijecscse.org/papers/apr2012/Brain-Tumour-Extraction-from-MRI-Images-Using-MATLAB.pdf
% http://www.mecs-press.net/ijigsp/ijigsp-v4-n10/IJIGSP-V4-N10-5.pdf

close all;
clc;
clear;
addpath('lib');

inputImg=input('Enter path to an image file: ','s');  % 'images/filename'
inputImg = strcat('images/',inputImg)

img = imread(inputImg);
%imshow(img);
[rows, columns, channels] = size(img);

% Step 1 - conversion to grayscale image.
if channels > 1
	grayImage = rgb2gray(img);
end

grayImage = imadjust(grayImage);
%grayImage = imfilter(double(grayImage), fspecial('log',50,10));
figure, imshow(img), title('Grayscale image');


% Step 2 - applying filters for noise reduction
PQ = paddedsize(size(grayImage));

% Low-pass
D0=0.5*PQ(1);
n=2;
Hp1 = lpfilter('gaussian', PQ(1), PQ(2), D0, n);
lpfImage = dftfilt(grayImage, Hp1)
%figure, imshow(lpfImage), title('Low-pass filter');

% High-pass
D0=0.01*PQ(1);
n=2;
Hp1 = hpfilter('btw', PQ(1), PQ(2), D0, n);
hpfImage = dftfilt(lpfImage, Hp1);
%figure, imshow(hpfImage), title('High-pass filter');
h = hpfImage;

hpfImage = imadjust(hpfImage);
hpfImage = adapthisteq(hpfImage);
%figure, imshow(hpfImage), title('High-pass filter adjusted');

% Median filter
mfImage = medfilt2(grayImage, [floor(PQ(1)/100) floor(PQ(1)/100)]);
%figure, imshow(mfImage), title('Median filter');

% Edge detection
i = tofloat(mfImage);
[g1 t1] = edge(i,'sobel');
g2 = edge(i,'prewitt');
g3 = edge(i,'roberts');
g4 = edge(i,'canny');
%figure, imshow(g1), title('Sobel edge detection');
%{
figure, subplot(2,2,1), imshow(g1);
subplot(2,2,2), imshow(g2);
subplot(2,2,3), imshow(g3);
subplot(2,2,4), imshow(g4);
%}

% Step 3 - histogram thresholding
level1 = multithresh(mfImage); % single treshold
seg1 = imquantize(mfImage,level1);
%%figure, imshow(mfImage,[]);

[pixelCount, grayLevels] = imhist(grayImage, 256);
% Split the image in two
leftHalf = grayImage(:, 1:columns/2);
[pixelCountL, grayLevelsL] = imhist(leftHalf, 256);
rightHalf = grayImage(:, columns/2+1:columns);
[pixelCountR, grayLevelsR] = imhist(rightHalf, 256);

diff = int16(pixelCountL - pixelCountR); % the difference of histograms for left and right sides
%%figure, plot(diff);

thresh = 255 * graythresh(diff); % compute Otsu threshold

aboveThresh = grayImage > thresh; % get all pixels above threshold
%figure, imshow(aboveThresh), title('Histogram thresholding');

% Step 4 - morphological operations
abval = min(rows,columns)/max(rows,columns)
srel_param = min(rows,columns)/(70*abs(abval));
%srel_param = min(rows,columns)/100;
se = strel('disk',double(int8(srel_param)));        
erodedBW = imerode(aboveThresh,se);
%figure, imshow(erodedBW), title('Erodation');
       
dilatedBW = imdilate(erodedBW,se);
%%figure, imshow(dilatedBW), title('Dilation');

% Final image
img = imfuse(img, erodedBW);
figure, imshow(img), title('Final image');