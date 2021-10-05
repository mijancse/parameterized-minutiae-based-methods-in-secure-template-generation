%%
clear all
load('cse_fp_db.mat'); 
        FileName='15102010_7_10.bmp';
%         FileName = 'fp2.bmp';
        I=imread(FileName);
        [m,n]=size(I);

        % Mixed Code [Segmentation , Normalization]
        Img = before_enhancement(I); %manually cut 4 sides of the picture
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
        
%% Matching
result_fp = repmat(' ',[30 50]);
result_score = zeros(300,1);
k=1;
for i=1:1:300
    display(strcat('Testing with:',Templates{i,2}, '  i=',num2str(i)));
    Score = match(Minutiae, Templates{i,1});
    if Score>.48
        display(strcat('Matched id:',Templates{i,2}));
%         result_idx(k)=i;
%         k=k+1;
    end
    result_score(i)=Score;
    display(strcat('Score=',num2str(Score)));
end
        
