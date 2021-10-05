%%
clear all, close all, clc
%% VAULT 1
%% Parameters
    radius=30;     %<<<<<<<<<<<<<<<<<--------------Changing
    r=radius;
    ChaffPointsOnCircumference = 16;
    SelectedChaffPoint = 13;
    RealMinutiaeMovingPoint = 2;
    
	ChaffAngleOffset=4.1;
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







%%
General_Minutiae = Minutiae(:,1:4);
ChaffAngleOffset=0.1;
%%
for z=1:1:100;
    % Anglewise Line Creating + Fuzzy Vault Circle
    ChaffIndex=1;
    ChaffMinutiae=[];
    Minutiae = General_Minutiae;
    for i=1:size(Minutiae(:,1),1)
       % Drwaing Fuzzy Vault Circles for the minutiae
       StatingAngle = Minutiae(i,4);
       xc=Minutiae(i,1);
       yc=Minutiae(i,2);
       % detecting 16 points
       angForPoints=(StatingAngle+0):pi/8:(StatingAngle+(2*pi)-(pi/8)); 
       xp=r*cos(angForPoints);
       yp=r*sin(angForPoints);

       
       % Getting 16 circles Centers
       for k=1:ChaffPointsOnCircumference
          Center_x(k) = xc+xp(k); 
          Center_y(k) = yc+yp(k); 
       end

       SixteenPointsAngles=0:pi/8:(2*pi)-(pi/8); 
       %drawing 16 circle
       for k=1:ChaffPointsOnCircumference
           xc=Center_x(k);
           yc=Center_y(k);

           % Selecting Chaff
           if(k==SelectedChaffPoint)    %%%%<<<------------- 6th point chosen (clockwise)
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
       end
    end

    %% Adding Chaff Minutiae to real
    Vault_with_chaff = [Minutiae(:,1:4); ChaffMinutiae(:,1:4)];
    Vault_without_chaff = Minutiae(:,1:4);


    %% Smilarity bwtween General and Vault
    similarity_btn_real_n_secured_with_chaff(z)=match(General_Minutiae, Vault_with_chaff,0);
    
    Vault_with_chaff=[];
    display(['Chaff Angle Offset=' num2str(ChaffAngleOffset) '   Score=' num2str(similarity_btn_real_n_secured_with_chaff(z))]);
    ChaffAngleOffset=ChaffAngleOffset+0.1;
    if ChaffAngleOffset>6.2832
        break;
    end
end
