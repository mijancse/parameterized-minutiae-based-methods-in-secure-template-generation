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


%% Display Loop
x=0;
y=300;
FigNo=1;
while(true) 
    figure
    if(FigNo==1)
        imshow(I);
    elseif(FigNo==2)
        imshow(I_Foreground_Pixels);
    elseif(FigNo==3)
        imshow(I_Foreground_Pixels_After_Closing);
    elseif(FigNo==4)
        imshow(I_Seg_Completed);
    end
    title(FigTitles(FigNo));
    set(gcf,'position',[x y 400 400]);
    x=x+410;
        if(FigNo==2)
        x=0;
        y=50;
    end
    if(FigNo==4)
        break;
    end
    FigNo=FigNo+1;
end