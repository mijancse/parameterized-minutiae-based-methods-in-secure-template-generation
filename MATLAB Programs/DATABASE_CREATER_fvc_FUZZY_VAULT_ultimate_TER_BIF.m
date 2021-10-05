%%
clear all
% load('CSE_FP_TMP_DB_v2.mat'); 
% path = 'H:\Education\Thesis\Data Accquisition Experiment\Img Pool - Refined\Training';
% path = 'H:\Education\Thesis\Data Accquisition Experiment\Img Pool - Refined\Training - Updated v2';
% path = 'H:\Education\Thesis\Data Accquisition Experiment\Img Pool - Refined\Training - Fuzzy Vault';
path = 'H:\Education\Thesis\FVC 2002\DB1_B\Training';


    
    r=15;     % <----------- Circle Varied {{{VARIABLE}}}
    ChaffPointsOnCircumference = 16;
    SelectedChaffPoint = 6;
    RealMinutiaeMovingPoint = 11;
    ChaffAngleOffset=2.5;
    MovedAngleOffset=6.2832 - ChaffAngleOffset;
    



files = dir(fullfile(path, '*.bmp'));
cd(path);
for k=1:numel(files)
    FileName=files(k).name;
%         FileName = 'fp2.bmp';
        I=imread(FileName); 
        [m,n]=size(I);

        % Mixed Code [Segmentation , Normalization]
        Img = before_enhancement(I); %manually cut 4 sides of the picture
%         EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
        EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12

        blksze = 5;   thresh = 0.085;   % FVC2002 DB1
        [I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);
        % Orientation Est
        I_Oriented=ridgeorient(I_Normalized, 1, 3, 3);

        % Ridge Frequency
        [I_Ridge_Freq, MedianFreq] = ridgefreq_by_NA(I_Normalized, Mask, I_Oriented, 32, 5, 5, 15);

        % BINARIZATION
        ModifiedMask=Mask.*MedianFreq;
        I_Binarized = ridgefilter_by_NA(I_Normalized, I_Oriented, ModifiedMask, 0.5, 0.5, 1) > 0;

        % THINNING
        I_Thinned =  bwmorph(~I_Binarized, 'thin',Inf);
        I_Thinned_Masked = zeros(m,n);
        for i=1:1:m
           for j=1:1:n
               if(Mask(i,j)==true)
                   I_Thinned_Masked(i,j) = I_Thinned(i,j);
               else
                   I_Thinned_Masked(i,j) = 0;
               end

           end
        end
        
        
        % EXTRACT MINUTIAES
        [Minutiae, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);
        
        Minutiae = Minutiae(:,1:4);
        
        
        % ADD CHAFF MINUTIAES
        ChaffIndex=1;
        ChaffMinutiae = [];
        for i=1:size(Minutiae(:,1),1)
           % drawing main minutiae circle
           % bla bla blahhh....

           % drawing the angle line for main minutiae
           % bla bla blahhh....

           % DO THE VAULT THINK for what? [BIF or TER]
%            if(Minutiae(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
%                continue;
%            end

           % Drwaing Fuzzy Vault Circles for the minutiae
           StatingAngle = Minutiae(i,4);
           xc=Minutiae(i,1);
           yc=Minutiae(i,2);
           
%            % detecting 7 points   <----------- Points Varied {{{VARIABLE}}}
%            angForPoints=(StatingAngle+pi/4):pi/4:(StatingAngle+(2*pi)-(pi/4)); 
%            xp=r*cos(angForPoints);
%            yp=r*sin(angForPoints);
%            
           % detecting 16 points   <----------- Points Varied {{{VARIABLE}}}
           angForPoints=(StatingAngle+0):pi/8:(StatingAngle+(2*pi)-(pi/8)); 
           xp=r*cos(angForPoints);
           yp=r*sin(angForPoints);

           % Getting 16 circles Centers
           for m=1:ChaffPointsOnCircumference
              Center_x(m) = xc+xp(m); 
              Center_y(m) = yc+yp(m); 
           end

           % Selecting Chaff      
           % drawing 16 circle
           for m=1:ChaffPointsOnCircumference
               xc=Center_x(m);
               yc=Center_y(m);         
               if(m==SelectedChaffPoint)
%                    plot(xc,yc,'r.','MarkerSize',20);
                   ChaffMinutiae(ChaffIndex,1) = round(xc);
                   ChaffMinutiae(ChaffIndex,2) = round(yc);
                   ChaffMinutiae(ChaffIndex,3) = Minutiae(i,3);
                   if((Minutiae(i,4) + ChaffAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
                       ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset) - 6.2832;
                   else
                       ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + ChaffAngleOffset);
                   end
                   ChaffIndex = ChaffIndex+1;
               end
           end
           
           display('Chaff');
           display(['Coordinate: x=' num2str(ChaffMinutiae(ChaffIndex-1,1)) '  y=' num2str(ChaffMinutiae(ChaffIndex-1,2)) ]);
           display(['Angle B4=' num2str(Minutiae(i,4)) '////  After=' num2str(ChaffMinutiae(ChaffIndex-1,4)) ]);
%            
           display('Moved');
           display(['Coordinate Bf: x=' num2str(Minutiae(i,1)) '  y=' num2str(Minutiae(i,2)) ]);
            % Moving the real minutiae
           for m=1:ChaffPointsOnCircumference
               xc=Center_x(m);
               yc=Center_y(m);
               if(m==RealMinutiaeMovingPoint)    %%%%<<<------------- other than chaff point chosen (clockwise)
                   Minutiae(i,1) = round(xc);
                   Minutiae(i,2) = round(yc);
                   if((Minutiae(i,4) + MovedAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
                       Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset) - 6.2832;
                   else
                       Minutiae(i,4) = (Minutiae(i,4) + MovedAngleOffset);
                   end
               end
               
           end
           display(['Coordinate Af: x=' num2str(Minutiae(i,1)) '  y=' num2str(Minutiae(i,2)) ]);
           display(['Angle Af:' num2str(Minutiae(i,4)) ]);
        end

        % Adding Chaff Minutiae
        Minutiae = [Minutiae; ChaffMinutiae];
             
        
        
        % TEMPLATE Creation
        Templates{k,1} = Minutiae;
        Templates{k,2} = FileName(1:5);
        Templates{k,3} = FileName(1:3);
        Templates{k,4} = FileName(5:5);
        Templates{k,5} = FileName;
        Templates{k,6} = size(ChaffMinutiae,1);
        display(strcat(FileName(1:5),':  ','Template=',num2str(k),', Prg=',num2str((double(k)/50)*100)));
        
        FP_ChaffAdded(k) = size(ChaffMinutiae(:,1),1);
end

