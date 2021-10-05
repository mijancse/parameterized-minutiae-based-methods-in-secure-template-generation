clear all;
load('FVC_2002_DB1_B_Fuzzy_Ultimate_v17_Ter&Bif.mat'); 
path = 'E:\DocuPlanet\Education\Thesis\FVC 2002\DB1_B\Query8';
% path = pwd;
% display(pwd);
files = dir(fullfile(path, '*.bmp'));
%%
Match_Score=zeros(10,50);
Mapping=zeros(10,50);
%% GET FILE
for z=1:10
    file=fullfile(path, files(z).name);
    I = imread(file);
    m = size(I,1); 
    n = size(I,2);
    % Mixed Code [Segmentation , Normalization]
    Img = before_enhancement(I); %manually cut 4 sides of the picture
    EnhancedImg =  fft_enhance_cubs(Img,-1); % if -1, 12x12
    blksze = 5;   thresh = 0.085;   % FVC2002 DB1
    [I_Normalized, Mask, maskind] = segment_normalize_by_NA(EnhancedImg, blksze, thresh);
                %Mask = after_mask(Mask); %manually cut 4 sides of the picture
    % Orientation Est
    I_Oriented=ridgeorient(I_Normalized, 1, 3, 3);
    % Ridge Frequency
    [I_Ridge_Freq, MedianFreq] = ridgefreq_by_NA(I_Normalized, Mask, I_Oriented, 32, 5, 5, 15);
    % BINARIZATION
    ModifiedMask=Mask.*MedianFreq;
    I_Binarized = ridgefilter_by_NA(I_Normalized, I_Oriented, ModifiedMask, 0.5, 0.5, 1) > 0;
    % THINNING
    I_Thinned =  bwmorph(~I_Binarized, 'thin',Inf); 
    % EXTRACT MINUTIAES 
    [Minutiae, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);

    
% % %         %% ADD CHAFF MINUTIAES
% % %         ChaffIndex=1;
% % %         ChaffMinutiae = [];
% % %         for i=1:size(Minutiae(:,1),1)
% % %            % drawing main minutiae circle
% % %            % bla bla blahhh....
% % % 
% % %            % drawing the angle line for main minutiae
% % %            % bla bla blahhh....
% % % 
% % %            % DO THE VAULT THINK for what? [BIF or TER]
% % %            if(Minutiae(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
% % %                continue;
% % %            end
% % % 
% % %            % Drwaing Fuzzy Vault Circles for the minutiae
% % %            StatingAngle = Minutiae(i,4);
% % %            r=15;     % <----------- Circle Varied {{{VARIABLE}}}
% % %            xc=Minutiae(i,1);
% % %            yc=Minutiae(i,2);
% % %            
% % %            % detecting 7 points   <----------- Points Varied {{{VARIABLE}}}
% % %            angForPoints=(StatingAngle+pi/4):pi/4:(StatingAngle+(2*pi)-(pi/4)); 
% % %            xp=r*cos(angForPoints);
% % %            yp=r*sin(angForPoints);
% % % 
% % %            % Getting 7 circles Centers
% % %            for m=1:7
% % %               Center_x(m) = xc+xp(m); 
% % %               Center_y(m) = yc+yp(m); 
% % %            end
% % % 
% % %            %drawing 7 circle
% % %            for m=1:7
% % %                xc=Center_x(m);
% % %                yc=Center_y(m);
% % %                if(m==5)
% % %                    ChaffMinutiae(ChaffIndex,1) = xc;
% % %                    ChaffMinutiae(ChaffIndex,2) = yc;
% % %                    ChaffMinutiae(ChaffIndex,3) = 3;
% % %                    ChaffMinutiae(ChaffIndex,5) = Minutiae(i,5);
% % %                    ChaffMinutiae(ChaffIndex,6) = Minutiae(i,6);
% % %                    if(Minutiae(i,4)>=3.7832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
% % %                        ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + 2.5) - 6.2832;
% % %                    else
% % %                        ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + 2.5);
% % %                    end
% % %                    ChaffIndex = ChaffIndex+1;
% % %                end
% % %            end
% % %         end
% % %     ttemp = Minutiae;
% % %     Minutiae = [Minutiae; ChaffMinutiae];
% % %     
% % %     % //CHAFF MINUTIAE GENERATION COMPLETED
    
    
    
    %% OPERATION
%     filename=files(z).name;
%     FINGER_IDX=filename(5:5);
%     Max_Match_Score=0;
%     ChoosenTemplateIndex=zeros(1,5,'uint16');
%     k=1;
%     for i=1:size(Templates,1)
%         student_id = Templates{i,2}; 
%         if strcmp(Templates{i,3},num2str(FINGER_IDX))==1 
%             ChoosenTemplateIndex(k)=i;
%             k=k+1;
%         end
%     end

    for i=1:size(Templates,1)
		[ChaffRemovedTemplate, Chaffs] = RemoveChaff_Ultimate_TER_BIF(Templates{i,1});
        Match_Score(z,i)=match(Minutiae,ChaffRemovedTemplate);
        if strcmp(Templates{i,3},(files(z).name(1:3)))==1 
            Mapping(z,i) = 1;
        end
        display(['Finger : ' num2str(z) ' --- Template : ' num2str(i) ' --- Minutiae Imbalance : ' num2str(Templates{i,6} - size(Chaffs,1)) ' || Chaff In Tmp : ' num2str(Templates{i,6}) ' || Chaff Removed : ' num2str(size(Chaffs,1)) ])
        
        % only for calculation
        if z==1
            FP_ChaffRemoved(i) = size(Chaffs(:,1),1);
        end
        % .....................

    end
    drawnow

end