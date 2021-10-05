%%
clear all, close all, clc
%% VAULT 1
%% Parameters
    radius=20;     
    ChaffPointsOnCircumference = 16;
    SelectedChaffPoint = 6;
    RealMinutiaeMovingPoint = 11;
	ChaffAngleOffset=2.5;
    MovedAngleOffset=6.2832 - ChaffAngleOffset;

%%
FileName='103_1.bmp';
I=imread(FileName);
[m,n]=size(I);
% imshow(I) ;
FigTitles={'Original', 'Enhanced', 'Mask', 'Complete Segmented', 'Normalized', 'Oriented', 'Oriented Masked','Ridge Freq', 'Modified Masked', 'Binary Img'};

%% Mixed Code [Segmentation , Normalization]
Img = before_enhancement(I); %manually cut 4 sides of the picture
EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
blksze = 5;   thresh = 0.085;   % FVC2002 DB1
[I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);

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

%% EXTRACT MINUTIAES
[Minutiae, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);

General_Minutiae = Minutiae(:,1:4);

%% Showing Only Real Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL Minutiae - Vault 1');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   r=15;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
end




%% Anglewise Line Creating + Fuzzy Vault Circle
ChaffIndex=1;
figure
imshow(~I_Thinned_Masked);
title('Adding CHAFF Minutiae - Vault 1');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=radius;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
   
   
   
   
   % DO THE VAULT THINK for what? [BIF or TER]
%    if(Minutiae(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
%        continue;
%    end
   
   
   
   % Drwaing Fuzzy Vault Circles for the minutiae
   r=radius;
   StatingAngle = Minutiae(i,4);
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'Color',[0 0 0]);
   hold on
   

   % detecting 16 points
   angForPoints=(StatingAngle+0):pi/8:(StatingAngle+(2*pi)-(pi/8)); 
   xp=r*cos(angForPoints);
   yp=r*sin(angForPoints);
%    plot(xc+xp,yc+yp,'r.');
   
   
   
   
   
   % Getting 16 circles Centers
   for k=1:ChaffPointsOnCircumference
      Center_x(k) = xc+xp(k); 
      Center_y(k) = yc+yp(k); 
   end
   
   SixteenPointsAngles=0:pi/8:(2*pi)-(pi/8); 
   %drawing 16 circle
   for k=1:ChaffPointsOnCircumference
       r=3;
       xc=Center_x(k);
       yc=Center_y(k);
       ang=0:0.01:2*pi; 
       xp=r*cos(ang);
       yp=r*sin(ang);
       plot(xc+xp,yc+yp,'r');
       
       % Selecting Chaff
       if(k==SelectedChaffPoint)    %%%%<<<------------- 6th point chosen (clockwise)
           plot(xc,yc,'r.','MarkerSize',20);
           ChaffMinutiae(ChaffIndex,1) = xc;
           ChaffMinutiae(ChaffIndex,2) = yc;
           ChaffMinutiae(ChaffIndex,3) = Minutiae(i,3);
           if( (Minutiae(i,4) + ChaffAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset) - 6.2832;
           else
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset);
           end
           ChaffIndex = ChaffIndex+1;
       end

       % Moving the real minutiae
       if(k==RealMinutiaeMovingPoint)    %%%%<<<------------- other than 6th point chosen (clockwise)
           Minutiae(i,1) = xc;
           Minutiae(i,2) = yc;
		   if((Minutiae(i,4) + MovedAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
				Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset) - 6.2832;
           else
				Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset);
           end
       end

       line([x1 x2],[y1 y2],'LineWidth',2);
       hold on
   end
end




%% Showing Real & Chaff Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL & CHAFF Minutiae - Vault 1')
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=radius;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
end


% DRAWING CHAFF MINUTIAE
hold on
for i=1:size(ChaffMinutiae(:,1),1)
   plot(ChaffMinutiae(i,1),ChaffMinutiae(i,2),'r.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=ChaffMinutiae(i,1);
   yc=ChaffMinutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'r');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=ChaffMinutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=radius;
   angle=ChaffMinutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[1 0 0]);
   hold on
end


%% Adding Chaff Minutiae to real
Vault1_with_chaff = [Minutiae(:,1:4); ChaffMinutiae(:,1:4)];
Vault1_without_chaff = Minutiae(:,1:4);







%% VAULT 2
Minutiae=[];
ChaffMinutiae=[];
%% Parameters
    radius=16;     
    ChaffPointsOnCircumference = 8;
    SelectedChaffPoint = 7;
    RealMinutiaeMovingPoint = 4;
	
	ChaffAngleOffset=4.3;
    MovedAngleOffset=6.2832 - ChaffAngleOffset;

%%
FileName='103_1.bmp';
I=imread(FileName);
[m,n]=size(I);
% imshow(I) ;
FigTitles={'Original', 'Enhanced', 'Mask', 'Complete Segmented', 'Normalized', 'Oriented', 'Oriented Masked','Ridge Freq', 'Modified Masked', 'Binary Img'};

%% Mixed Code [Segmentation , Normalization]
Img = before_enhancement(I); %manually cut 4 sides of the picture
EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
blksze = 5;   thresh = 0.085;   % FVC2002 DB1
[I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);

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

%% EXTRACT MINUTIAES
[Minutiae, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);


%% Showing Only Real Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL Minutiae - Vault 2');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=15;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
end




%% Anglewise Line Creating + Fuzzy Vault Circle
ChaffIndex=1;
figure
imshow(~I_Thinned_Masked);
title('Adding CHAFF Minutiae - Vault 2');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=radius;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
   
   
   
   
   % DO THE VAULT THINK for what? [BIF or TER]
%    if(Minutiae(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
%        continue;
%    end
   
   
   
   % Drwaing Fuzzy Vault Circles for the minutiae
   r=radius;
   StatingAngle = Minutiae(i,4);
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'Color',[0 0 0]);
   hold on
   

   % detecting 16 points
   angForPoints=(StatingAngle+0):pi/4:(StatingAngle+(2*pi)-(pi/4)); 
   xp=r*cos(angForPoints);
   yp=r*sin(angForPoints);
%    plot(xc+xp,yc+yp,'r.');
   
   
   
   
   
   % Getting 16 circles Centers
   for k=1:ChaffPointsOnCircumference
      Center_x(k) = xc+xp(k); 
      Center_y(k) = yc+yp(k); 
   end
   
   SixteenPointsAngles=0:pi/4:(2*pi)-(pi/4); 
   %drawing 16 circle
   for k=1:ChaffPointsOnCircumference
       r=3;
       xc=Center_x(k);
       yc=Center_y(k);
       ang=0:0.01:2*pi; 
       xp=r*cos(ang);
       yp=r*sin(ang);
       plot(xc+xp,yc+yp,'r');
       
       % Selecting Chaff
       if(k==SelectedChaffPoint)    %%%%<<<------------- 6th point chosen (clockwise)
           plot(xc,yc,'r.','MarkerSize',20);
           ChaffMinutiae(ChaffIndex,1) = xc;
           ChaffMinutiae(ChaffIndex,2) = yc;
           ChaffMinutiae(ChaffIndex,3) = Minutiae(i,3);
           if( (Minutiae(i,4) + ChaffAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset) - 6.2832;
           else
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset);
           end
           ChaffIndex = ChaffIndex+1;
       end

       % Moving the real minutiae
       if(k==RealMinutiaeMovingPoint)    %%%%<<<------------- other than 6th point chosen (clockwise)
           Minutiae(i,1) = xc;
           Minutiae(i,2) = yc;
		   if((Minutiae(i,4) + MovedAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
				Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset) - 6.2832;
           else
				Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset);
           end
       end

       line([x1 x2],[y1 y2],'LineWidth',2);
       hold on
   end
end




%% Showing Real & Chaff Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL & CHAFF Minutiae - Vault 2')
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=15;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
end


% DRAWING CHAFF MINUTIAE
hold on
for i=1:size(ChaffMinutiae(:,1),1)
   plot(ChaffMinutiae(i,1),ChaffMinutiae(i,2),'r.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=ChaffMinutiae(i,1);
   yc=ChaffMinutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'r');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=ChaffMinutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=15;
   angle=ChaffMinutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[1 0 0]);
   hold on
end


%% Adding Chaff Minutiae to real
Vault2_with_chaff = [Minutiae(:,1:4); ChaffMinutiae(:,1:4)];
Vault2_without_chaff = Minutiae(:,1:4);




%% VAULT 3
Minutiae=[];
ChaffMinutiae=[];
%% Parameters
    radius=27;     
    ChaffPointsOnCircumference = 8;
    SelectedChaffPoint = 2;
    RealMinutiaeMovingPoint = 7;
	
	ChaffAngleOffset=5.1;
    MovedAngleOffset=6.2832 - ChaffAngleOffset;

%%
FileName='103_1.bmp';
I=imread(FileName);
[m,n]=size(I);
% imshow(I) ;
FigTitles={'Original', 'Enhanced', 'Mask', 'Complete Segmented', 'Normalized', 'Oriented', 'Oriented Masked','Ridge Freq', 'Modified Masked', 'Binary Img'};

%% Mixed Code [Segmentation , Normalization]
Img = before_enhancement(I); %manually cut 4 sides of the picture
EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
blksze = 5;   thresh = 0.085;   % FVC2002 DB1
[I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);

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

%% EXTRACT MINUTIAES
[Minutiae, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);


%% Showing Only Real Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL Minutiae - Vault 3');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=15;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
end




%% Anglewise Line Creating + Fuzzy Vault Circle
ChaffIndex=1;
figure
imshow(~I_Thinned_Masked);
title('Adding CHAFF Minutiae - Vault 3');
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=radius;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
   
   
   
   
   % DO THE VAULT THINK for what? [BIF or TER]
%    if(Minutiae(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
%        continue;
%    end
   
   
   
   % Drwaing Fuzzy Vault Circles for the minutiae
   r=radius;
   StatingAngle = Minutiae(i,4);
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'Color',[0 0 0]);
   hold on
   

   % detecting 16 points
   angForPoints=(StatingAngle+0):pi/4:(StatingAngle+(2*pi)-(pi/4)); 
   xp=r*cos(angForPoints);
   yp=r*sin(angForPoints);
%    plot(xc+xp,yc+yp,'r.');
   
   
   
   
   
   % Getting 16 circles Centers
   for k=1:ChaffPointsOnCircumference
      Center_x(k) = xc+xp(k); 
      Center_y(k) = yc+yp(k); 
   end
   
   SixteenPointsAngles=0:pi/4:(2*pi)-(pi/4); 
   %drawing 16 circle
   for k=1:ChaffPointsOnCircumference
       r=3;
       xc=Center_x(k);
       yc=Center_y(k);
       ang=0:0.01:2*pi; 
       xp=r*cos(ang);
       yp=r*sin(ang);
       plot(xc+xp,yc+yp,'r');
       
       % Selecting Chaff
       if(k==SelectedChaffPoint)    %%%%<<<------------- 6th point chosen (clockwise)
           plot(xc,yc,'r.','MarkerSize',20);
           ChaffMinutiae(ChaffIndex,1) = xc;
           ChaffMinutiae(ChaffIndex,2) = yc;
           ChaffMinutiae(ChaffIndex,3) = Minutiae(i,3);
           if( (Minutiae(i,4) + ChaffAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset) - 6.2832;
           else
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset);
           end
           ChaffIndex = ChaffIndex+1;
       end

       % Moving the real minutiae
       if(k==RealMinutiaeMovingPoint)    %%%%<<<------------- other than 6th point chosen (clockwise)
           Minutiae(i,1) = xc;
           Minutiae(i,2) = yc;
		   if((Minutiae(i,4) + MovedAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
				Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset) - 6.2832;
           else
				Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset);
           end
       end

       line([x1 x2],[y1 y2],'LineWidth',2);
       hold on
   end
end




%% Showing Real & Chaff Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL & CHAFF Minutiae - Vault 3')
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=15;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
end


% DRAWING CHAFF MINUTIAE
hold on
for i=1:size(ChaffMinutiae(:,1),1)
   plot(ChaffMinutiae(i,1),ChaffMinutiae(i,2),'r.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=ChaffMinutiae(i,1);
   yc=ChaffMinutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'r');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=ChaffMinutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   
   r=15;
   angle=ChaffMinutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[1 0 0]);
   hold on
end


%% Adding Chaff Minutiae to real
Vault3_with_chaff = [Minutiae(:,1:4); ChaffMinutiae(:,1:4)];
Vault3_without_chaff = Minutiae(:,1:4);



%% Smilarity bwtween Vault1 and Vault2
similarity_btn_vaults_with_chaff_12=match(Vault1_with_chaff, Vault2_with_chaff,0);
similarity_btn_vaults_with_chaff_13=match(Vault1_with_chaff, Vault3_with_chaff,0);
similarity_btn_vaults_with_chaff_23=match(Vault2_with_chaff, Vault3_with_chaff,0);
% similarity_btn_vaults_without_chaff=match(Vault1_without_chaff, Vault2_without_chaff);

similarity_btn_real_n_secured_with_chaff1=match(General_Minutiae, Vault1_with_chaff,0);
similarity_btn_real_n_secured_with_chaff2=match(General_Minutiae, Vault2_with_chaff,0);
similarity_btn_real_n_secured_with_chaff3=match(General_Minutiae, Vault3_with_chaff,0);
% similarity_btn_real_n_secured_without_chaff=match(Vault1_only_real, Vault1_without_chaff);

