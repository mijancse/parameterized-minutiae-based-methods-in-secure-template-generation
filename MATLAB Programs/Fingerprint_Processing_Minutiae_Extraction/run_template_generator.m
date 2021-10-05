%%
clear all, close all, clc
%%
RightShiftedSize=210;
XAxisWindowSize=300;
YAxisWindowSize=300;
FirstLineYAxisLevel=380;
SecondLineYAxisLevel=50;
%%
FileName='103_1.bmp';
I=imread(FileName);
[m,n]=size(I);
figure;
imshow(I) ;
title('Original Image')
x=0; y=FirstLineYAxisLevel;
set(gcf,'position',[x y XAxisWindowSize YAxisWindowSize]);
%FigTitles={'Original', 'Enhanced', 'Mask', 'Complete Segmented', 'Normalized', 'Oriented', 'Oriented Masked','Ridge Freq', 'Modified Masked', 'Binary Img'};


%% Mixed Code [Segmentation , Normalization]
Img = before_enhancement(I); %manually cut 4 sides of the picture
figure;
imshow(Img) ;
title('Preprocessed')
x=x+RightShiftedSize; y=FirstLineYAxisLevel;
set(gcf,'position',[x y XAxisWindowSize YAxisWindowSize]);

EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
blksze = 5;   thresh = 0.085;   % FVC2002 DB1
figure;
imshow(EnhancedImg) 
title('Enhanced')
x=x+RightShiftedSize; y=FirstLineYAxisLevel;
set(gcf,'position',[x y XAxisWindowSize YAxisWindowSize]);

[I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);
            %Mask = after_mask(Mask); %manually cut 4 sides of the picture
            
figure;
imshow(Mask);
title('Mask')
x=x+RightShiftedSize; y=FirstLineYAxisLevel;
set(gcf,'position',[x y XAxisWindowSize YAxisWindowSize]);

figure;
imshow(I_Normalized) ;
title('Normalized')
x=x+RightShiftedSize; y=FirstLineYAxisLevel;
set(gcf,'position',[x y XAxisWindowSize YAxisWindowSize]);
%%

%% Masked Image
% I_Masked = zeros(m,n);
% for i=1:1:m
%    for j=1:1:n
%        if(Mask(i,j)==0)
%            I_Masked(i,j) = 255;
%        else
%            I_Masked(i,j) = EnhancedImg(i,j);
%        end
%            
%    end
% end

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
figure;
imshow(I_Binarized);
title('Binarized')
x=x+RightShiftedSize; y=FirstLineYAxisLevel;
set(gcf,'position',[x y XAxisWindowSize YAxisWindowSize]);
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

%figure;
%imshow(I_Thinned_Masked);
%title('Thinned')
figure;
imshow(~I_Thinned_Masked);
title('Thinned (Inverse View)')
x=0; y=SecondLineYAxisLevel;
set(gcf,'position',[x y XAxisWindowSize YAxisWindowSize]);
%% EXTRACT MINUTIAES
[Minutiae, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);

Real_Minutiae = Minutiae;



%% Showing Only Real Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('REAL Minutiae');
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


x=x+RightShiftedSize; y=SecondLineYAxisLevel;
set(gcf,'position',[x y XAxisWindowSize YAxisWindowSize]);



%% Anglewise Line Creating + Equidistant Circle
ChaffIndex=1;
figure
imshow(~I_Thinned_Masked);
title('Adding CHAFF Minutiae');
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
   
   
   
   
%    % DO THE VAULT THINK for what? [BIF or TER]
%    if(Minutiae(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
%        continue;
%    end
   
   
   
   % Drwaing Fuzzy Vault Circles for the minutiae
   StatingAngle = Minutiae(i,4);
   r=20;     % <----------- Circle Varied {{{VARIABLE}}}
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'Color',[0 0 0]);
   hold on
   
%    % detecting 7 points
%    angForPoints=(StatingAngle+pi/4):pi/4:(StatingAngle+(2*pi)-(pi/4)); 
%    xp=r*cos(angForPoints);
%    yp=r*sin(angForPoints);

   % detecting 16 points
   angForPoints=(StatingAngle+0):pi/8:(StatingAngle+(2*pi)-(pi/8)); 
   xp=r*cos(angForPoints);
   yp=r*sin(angForPoints);
%    plot(xc+xp,yc+yp,'r.');
   
   
   
   
   
   % Getting 16 circles Centers
   for k=1:16
      Center_x(k) = xc+xp(k); 
      Center_y(k) = yc+yp(k); 
   end
   
   SixteenPointsAngles=0:pi/8:(2*pi)-(pi/8); 
   %drawing 16 circle
   for k=1:16
       r=3;
       xc=Center_x(k);
       yc=Center_y(k);
       ang=0:0.01:2*pi; 
       xp=r*cos(ang);
       yp=r*sin(ang);
       plot(xc+xp,yc+yp,'r');
       
       % Selecting Chaff
       if(k==6)    %%%%<<<------------- 6th point chosen (clockwise)
           plot(xc,yc,'r.','MarkerSize',20);
           ChaffMinutiae(ChaffIndex,1) = xc;
           ChaffMinutiae(ChaffIndex,2) = yc;
           if( (Minutiae(i,4) + 2.5)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + 2.5) - 6.2832;
           else
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + 2.5);
           end
           ChaffIndex = ChaffIndex+1;
       end

       % Moving the real minutiae
       if(k==11)    %%%%<<<------------- other than 6th point chosen (clockwise)
           plot(xc,yc,'b.','MarkerSize',20);
           Minutiae(i,1) = xc;
           Minutiae(i,2) = yc;
           if((Minutiae(i,4) + (6.2832-2.5))>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
				Minutiae(i,4) = (Minutiae(i,4) + (6.2832-2.5)) - 6.2832;
           else
				Minutiae(i,4) = (Minutiae(i,4) + (6.2832-2.5));
           end
%            Minutiae(i,4) = ChaffMinutiae(ChaffIndex-1,4);
       end
       
       % drawing the angle line of each 7 circles
%        r=2;
%        angle=Minutiae(i,4) + 0; 
%        xp=r*cos(angle);
%        yp=r*sin(angle);
%        x1=xc+xp;
%        y1=yc+yp;
%        r=10
%        angle=Minutiae(i,4) + 0; 
%        xp=r*cos(angle);
%        yp=r*sin(angle);
%        x2=xc+xp;
%        y2=yc+yp;

       line([x1 x2],[y1 y2],'LineWidth',2);
       hold on
   end
end




x=x+RightShiftedSize; y=SecondLineYAxisLevel;
set(gcf,'position',[x y XAxisWindowSize YAxisWindowSize]);





%% Showing Real (not moved) & CHAFF Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('Added CHAFF Minutiae')
hold on
for i=1:size(Real_Minutiae(:,1),1)
   plot(Real_Minutiae(i,1),Real_Minutiae(i,2),'b.');
   hold on
   % drawing main Real_Minutiae circle
   r=3;
   xc=Real_Minutiae(i,1);
   yc=Real_Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main Real_Minutiae
   r=2;
   angle=Real_Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   r=15;
   angle=Real_Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
end


% DRAWING CHAFF (Moved) MINUTIAE
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


x=x+RightShiftedSize; y=SecondLineYAxisLevel;
set(gcf,'position',[x y XAxisWindowSize YAxisWindowSize]);




%% Showing Real & Moved Real Minutiae
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('Moving REAL Minutiae')
hold on
for i=1:size(Real_Minutiae(:,1),1)
   plot(Real_Minutiae(i,1),Real_Minutiae(i,2),'g.');
   hold on
   % drawing main Real_Minutiae circle
   r=3;
   xc=Real_Minutiae(i,1);
   yc=Real_Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'g');
   hold on
   
   % drawing the angle line for main Real_Minutiae
   r=2;
   angle=Real_Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   r=15;
   angle=Real_Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 1 0]);
   hold on
end


Moved_Minutiae = Minutiae;


% DRAWING CHAFF (Moved) MINUTIAE
hold on
for i=1:size(Moved_Minutiae(:,1),1)
   plot(Moved_Minutiae(i,1),Moved_Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=Moved_Minutiae(i,1);
   yc=Moved_Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Moved_Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   r=15;
   angle=Moved_Minutiae(i,4); 
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


x=x+RightShiftedSize; y=SecondLineYAxisLevel;
set(gcf,'position',[x y XAxisWindowSize YAxisWindowSize]);

%% Showing Real & Chaff Minutiae (Final Template)
% DRAWING REAL MINUTIAE
figure
imshow(~I_Thinned_Masked);
title('Final (Moved REAL & CHAFF Minutiae)')
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

Moved_Minutiae = Minutiae;

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

x=x+RightShiftedSize; y=SecondLineYAxisLevel;
set(gcf,'position',[x y XAxisWindowSize YAxisWindowSize]);
