%%
clear all, close all, clc

% I=imread('fp.bmp');
I=imread('106_4.tif');
% I=imread('108_2.tif');
[m,n]=size(I);
% imshow(I) ;
FigTitles={'Original', 'Foreground Pixels', 'Foreground Pixels After Closing', 'Complete Segmented', 'Binarized', 'Skeletonned','Preprocessed'};
%% Segmentation [mine]
[I_Segmented,I_Foreground_Pixels, IMG_MEAN, IMG_VAR]=segment_by_Mehtre(I,10);


%% Segmentation Closing [morphological closing]
se = strel('square',25);
I_Foreground_Pixels_After_Closing = imclose(I_Foreground_Pixels,se);


%% Complete Segmented Image Creation (Show the Foreground Img Pixels, Background as 'Pure White')
I_Seg_Completed = zeros(m,n,'uint8');
for i=1:1:m
   for j=1:1:n
       if(I_Foreground_Pixels_After_Closing(i,j)==true)
           I_Seg_Completed(i,j) = I(i,j);
       else
           I_Seg_Completed(i,j) = 255;
       end
           
   end
end

%% Normalization
I_Normalized=normalize_by_Hong(I_Seg_Completed, 4, 1);
figure
imshow(I_Seg_Completed);
title('Segmented')
set(gcf,'position',[380 200 400 400]);
figure
imshow(I_Normalized);
title('After Normalization')
set(gcf,'position',[800 200 400 400]);