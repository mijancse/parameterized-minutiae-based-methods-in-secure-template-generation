%% Fingerprint Image Processing and Minutiae Extraction
%% Created By: 
% Prof. Dr. Md. Mijanur Rahman, Department of Computer Science and Engineering, 
% Jatiya Kabi Kazi Nazrul Islam University, Trishal, Mymensingh, Bangladesh. 
% Email: mijan@jkkniu.edu.bd
clear all, close all, clc
%%

%%
%FileName = 'fp2.bmp';
FileName='101_1.bmp';
I=imread(FileName);
[m,n]=size(I);
imshow(I) ; figure;
FigTitles={'Original', 'Enhanced', 'Mask', 'Complete Segmented', 'Normalized', 'Oriented', 'Oriented Masked','Ridge Freq', 'Modified Masked', 'Binary Img'};
%% Segmentation [mine]
% [I_Segmented,I_Foreground_Pixels, IMG_MEAN, IMG_VAR]=segment_by_Mehtre(I,5);


%% Segmentation Closing [morphological closing]
% se = strel('square',25);
% I_Foreground_Pixels_After_Closing = imclose(I_Foreground_Pixels,se);


%% Complete Segmented Image Creation (Show the Foreground Img Pixels, Background as 'Pure White')
% I_Seg_Completed = zeros(m,n,'uint8');
% for i=1:1:m
%    for j=1:1:n
%        if(I_Foreground_Pixels_After_Closing(i,j)==true)
%            I_Seg_Completed(i,j) = I(i,j);
%        else
%            I_Seg_Completed(i,j) = 255;
%        end
%            
%    end
% end


%% Normalization
% I_Normalized=normalize_by_Hong(I_Seg_Completed, 4, 1);



%% Mixed Code [Segmentation , Normalization]
Img = before_enhancement(I); %manually cut 4 sides of the picture
            % % % % % EnhancedImg =  fft_enhance_cubs(Img,6);             % Enhance with Blocks 6x6
            % % % % % EnhancedImg =  fft_enhance_cubs(EnhancedImg,12);         % Enhance with Blocks 12x12
            % % % % % EnhancedImg =  fft_enhance_cubs(EnhancedImg,24); % Enhance with Blocks 24x24
           
imshow(Img) ;figure;

EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
blksze = 5;   thresh = 0.085;   % FVC2002 DB1

imshow(EnhancedImg) ;figure;

[I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);
            %Mask = after_mask(Mask); %manually cut 4 sides of the picture
imshow(I_Normalized) ;figure;
imshow(Mask) ;figure;
%%

%% Masked Image
I_Masked = zeros(m,n);
for i=1:1:m
   for j=1:1:n
       if(Mask(i,j)==0)
           I_Masked(i,j) = 255;
       else
           I_Masked(i,j) = EnhancedImg(i,j);
       end
           
   end
end
imshow(I_Masked);figure;imshow(I_Masked);
%% Orientation Est
I_Oriented=ridgeorient(I_Normalized, 1, 3, 3);
I_Oriented_Masked = zeros(m,n);
for i=1:1:m
   for j=1:1:n
       if(Mask(i,j)==true)
           I_Oriented_Masked(i,j) = I_Oriented(i,j);
       else
           I_Oriented_Masked(i,j) = 255;
       end
           
   end
end


%% Ridge Frequency
[I_Ridge_Freq, MedianFreq] = ridgefreq_by_NA(I_Normalized, Mask, I_Oriented, 32, 5, 5, 15);
    
%% BINARIZATION
ModifiedMask=Mask.*MedianFreq;
I_Binarized = ridgefilter_by_NA(I_Normalized, I_Oriented, ModifiedMask, 0.5, 0.5, 1) > 0;
imshow(I_Binarized);figure;

%% THINNING
I_Thinned =  bwmorph(~I_Binarized, 'thin',Inf);
I_Thinned_Masked = I_Thinned;
for i=1:1:m
   for j=1:1:n
       if(Mask(i,j)==true)
           I_Thinned_Masked(i,j) = I_Thinned(i,j);
       else
           I_Thinned_Masked(i,j) = 0;
       end
           
   end
end

imshow(I_Thinned_Masked);figure;
imshow(~I_Thinned_Masked);figure;
%% EXTRACT MINUTIAES
[Minutiae, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);

Real_Minutiae = Minutiae;

imshow(Real_Minutiae);figure;
%% Display Loop

% x=0;
% y=300;
% FigNo=1;
% while(true) 
%     figure
%     if(FigNo==1)
%         imshow(I);
%     elseif(FigNo==2)
%         imshow(EnhancedImg);
%     elseif(FigNo==3)
%         imshow(Mask);
%     elseif(FigNo==4)
%         imshow(I|Mask);
%     elseif(FigNo==5)
%         imshow(I_Normalized);
%     elseif(FigNo==6)
%         imshow(I_Oriented);
%     elseif(FigNo==7)
%         imshow(I_Oriented_Masked);
%     elseif(FigNo==8)
%         imshow(I_Binarized);
%     elseif(FigNo==9)
%         imshow(I_Thinned);
%     elseif(FigNo==10)
%         imshow(I_Thinned_Masked);
%         
%     end
%     title(FigTitles(FigNo));
%     set(gcf,'position',[x y 400 400]);
%     x=x+280;
%     if(FigNo==5)
%         x=0;
%         y=50;
%     end
%     if(FigNo==10)
%         break;
%     end
%     FigNo=FigNo+1;
% end


% %% Display Loop [Subplot]
% x=0;
% y=300;
% figure;
% SubplotNo=1;
% for i=1:10
%     if(SubplotNo==1)
%         subplot(2,5,SubplotNo);
%         imshow(I);
%     elseif(SubplotNo==2)
%         subplot(2,5,SubplotNo);
%         imshow(EnhancedImg);
%     elseif(SubplotNo==3)
%         subplot(2,5,SubplotNo);
%         imshow(Mask);
%     elseif(SubplotNo==4)
%         subplot(2,5,SubplotNo);
%         imshow(I_Normalized);
%     elseif(SubplotNo==5)
%         subplot(2,5,SubplotNo);
%         imshow(I_Oriented);
%     elseif(SubplotNo==6)
%         subplot(2,5,SubplotNo);
%         imshow(I_Oriented_Masked);
%     elseif(SubplotNo==7)
%         subplot(2,5,SubplotNo);
%         imshow(I_Binarized);
%     elseif(SubplotNo==8)
%         subplot(2,5,SubplotNo);
%         imshow(I_Thinned);
%     elseif(SubplotNo==9)
%         subplot(2,5,SubplotNo);
%         imshow(I_Thinned_Masked);
%     elseif(SubplotNo==10)
%         subplot(2,5,SubplotNo);
%         imshow(ones(m,n));
%     end
%     SubplotNo=SubplotNo+1;
% end


%% Fuzzy Vault Working Section
% r=10;
% figure
% imshow(~I_Thinned_Masked);
% hold on
% for i=1:size(Minutiae(:,1),1)
%    plot(Minutiae(i,1),Minutiae(i,2),'g.');
%    hold on
%    % drawing circle
%    xc=Minutiae(i,1);
%    yc=Minutiae(i,2);
%    ang=0:0.01:2*pi; 
%    xp=r*cos(ang);
%    yp=r*sin(ang);
%    plot(xc+xp,yc+yp,'b');
%    hold on
%    angForPoints=pi/4:pi/4:(2*pi)-(pi/4); 
%    xp=r*cos(angForPoints);
%    yp=r*sin(angForPoints);
%    plot(xc+xp,yc+yp,'r.');
% end
% 



% %% Anglewise Line Creating
% figure
% imshow(~I_Thinned_Masked);
% hold on
% for i=1:size(Minutiae(:,1),1)
%    plot(Minutiae(i,1),Minutiae(i,2),'r.');
%    hold on
%    % drawing circle
%    r=4
%    xc=Minutiae(i,1);
%    yc=Minutiae(i,2);
%    ang=0:0.01:2*pi; 
%    xp=r*cos(ang);
%    yp=r*sin(ang);
%    plot(xc+xp,yc+yp,'r');
%    hold on
%    
%    % for the angle line
%    r=2;
%    angle=Minutiae(i,4); 
%    xp=r*cos(angle);
%    yp=r*sin(angle);
%    x1=xc+xp;
%    y1=yc+yp;
%    r=12
%    angle=Minutiae(i,4); 
%    xp=r*cos(angle);
%    yp=r*sin(angle);
%    x2=xc+xp;
%    y2=yc+yp;
%    
%    line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 .5 1]);
%    hold on
% end
% 
% 
% 




%% Showing Only Real Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(I);
title('REAL Minutiae');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=5;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   %plot(xc,yc,'b.');
   %plot(xc,yc,'bo-');
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   r=20;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2.2, 'Color',[0 0 1]);
   hold on
   
   if(i==4)
       %break
   end
end

%% Showing Only Real Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(ones(m,n));
title('REAL Minutiae Overlapped');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=5;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   %plot(xc,yc,'b.');
   %plot(xc,yc,'bo-');
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   r=20;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2.2, 'Color',[0 0 1]);
   hold on
   
end






%% to show a bright image to add in menuscript
% specially for 103_1.tif
I=imread(FileName);
[m,n]=size(I);
for i=1:1:m
   for j=1:1:n
       I_Temp(i,j) = I(i,j)+100;   
   end
end
figure;imshow(I_Temp);

%% Showing Only Real Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(I_Temp);
title('REAL Minutiae');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=5;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   %plot(xc,yc,'b.');
   %plot(xc,yc,'bo-');
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   r=20;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2.2, 'Color',[0 0 1]);
   hold on

end
