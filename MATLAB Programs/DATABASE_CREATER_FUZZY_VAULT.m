%%
% clear all
% load('CSE_FP_TMP_DB_v2.mat'); 
path = 'H:\Education\Thesis\Data Accquisition Experiment\Img Pool - Refined\Training';
path = 'H:\Education\Thesis\Data Accquisition Experiment\Img Pool - Refined\Training - Updated v2';
% path = 'H:\Education\Thesis\Data Accquisition Experiment\Img Pool - Refined\Training - Fuzzy Vault';

files = dir(fullfile(path, '*.bmp'));
cd(path);
for k=1:numel(files)
    FileName=files(k).name;
%         FileName = 'fp2.bmp';
        I=imread(FileName); 
        [m,n]=size(I);

        % Mixed Code [Segmentation , Normalization]
%         Img = before_enhancement(I); %manually cut 4 sides of the picture
%         EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
        EnhancedImg =  fft_enhance_cubs(I,-1); % if -1, 12x12
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
        % ADD CHAFF MINUTIAES
        ChaffIndex=1;
        ChaffMinutiae = [];
        for i=1:size(Minutiae(:,1),1)
           % drawing main minutiae circle
           % bla bla blahhh....

           % drawing the angle line for main minutiae
           % bla bla blahhh....

           % DO THE VAULT THINK for what? [BIF or TER]
           if(Minutiae(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
               continue;
           end

           % Drwaing Fuzzy Vault Circles for the minutiae
           StatingAngle = Minutiae(i,4);
           r=15;     % <----------- Circle Varied {{{VARIABLE}}}
           xc=Minutiae(i,1);
           yc=Minutiae(i,2);
           
           % detecting 7 points   <----------- Points Varied {{{VARIABLE}}}
           angForPoints=(StatingAngle+pi/4):pi/4:(StatingAngle+(2*pi)-(pi/4)); 
           xp=r*cos(angForPoints);
           yp=r*sin(angForPoints);

           % Getting 7 circles Centers
           for m=1:7
              Center_x(m) = xc+xp(m); 
              Center_y(m) = yc+yp(m); 
           end

           %drawing 7 circle
           for m=1:7
               xc=Center_x(m);
               yc=Center_y(m);
               if(m==5)
%                    plot(xc,yc,'r.','MarkerSize',20);
                   ChaffMinutiae(ChaffIndex,1) = round(xc);
                   ChaffMinutiae(ChaffIndex,2) = round(yc);
                   ChaffMinutiae(ChaffIndex,3) = 3;
                   ChaffMinutiae(ChaffIndex,5) = Minutiae(i,5);
                   ChaffMinutiae(ChaffIndex,6) = Minutiae(i,6);
                   if(Minutiae(i,4)>=3.7832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
                       ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + 2.5) - 6.2832;
                   else
                       ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + 2.5);
                   end
                   ChaffIndex = ChaffIndex+1;
               end
           end
        end

        % Adding Chaff Minutiae
        Minutiae = [Minutiae; ChaffMinutiae];
        
        % TEMPLATE Creation
        Templates{k,1} = Minutiae;
        Templates{k,2} = 1;
        Templates{k,2} = FileName(1:8);
        Templates{k,3} = FileName(10:10);
        Templates{k,4} = FileName(12:12);
        Templates{k,5} = FileName(1:12);
        Templates{k,6} = FileName;
        display(strcat(FileName(1:8),':  ','Template=',num2str(k),', Prg=',num2str((double(k)/1000)*100)));
end

