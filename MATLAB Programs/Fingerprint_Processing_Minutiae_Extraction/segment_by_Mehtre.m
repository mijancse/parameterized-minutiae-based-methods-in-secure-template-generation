% Coded by tanjarul26@gmail.com

% Code based on [(Mehtre, 1993) Mehtre, M. (1993), Fingerprint image analysis for automatic identification,
% Machine Vision and Applications, 124-139.]

% This function takes gray image 
% and returns segmented image with background marked as 'black'

% The inputs : I_in             - the input image (grayscale)
%       `      block_size       - the block of BxB
%              Width    - the scaning width
%              treshold - the treshold size 
%              ScaleX   - scaling rows
%              ScaleY   - scaling column
%
% The output is: 
%       `      I_out                  - the segmented output
%              I_Foreground_Pixels    - the pixel decided as foreground
%                                       marked as 1, background as 0
%              IMG_MEAN               - mean of Image
%              IMG_VAR                - variance of Image
%**************************************************************
function [I_out, I_Foreground_Pixels, IMG_MEAN, IMG_VAR] = segment_by_Mehtre (I_in,block_size)
%% Load
I=I_in;
B=block_size;
[m,n]=size(I);
I_out = uint8(zeros(m,n));
I_Foreground_Pixels = false(m,n);

%% Global Variance of Image
IMG_MEAN=sum(I(:))/(m*n);
% display(ImgMean);
TotalDiff=(I-IMG_MEAN).^2;
TotalSum=sum(TotalDiff(:));
nele=(m*n)-1;
IMG_VAR=TotalSum/nele;

%% THRESHOLD
THRESHOLD = IMG_VAR
THRESHOLD = 50


%% Local Variance of block NxN
% block Mean
BlockMean = zeros(int64(m/B), int64(n/B));
BlockVar = zeros(int64(m/B), int64(n/B));

rowResidue=mod(m,B);
gap_to_forward_row = rowResidue;
colResidue=mod(n,B);
gap_to_forward_col = colResidue;
a=1;
for i=1:B:m-B+1  % 1, 11, 21, ....., 471
    b=1;
    for j=1:B:n-B+1
        block_NxN = I(i:i+B-1,j:j+B-1);
%         fprintf('[%d - %d] ------[%d - %d]\n', i,(i+B-1),j,(j+B-1))
        BlockMean(a,b)=sum(block_NxN(:))/(B*B);
        Total_Diff=(block_NxN-BlockMean(a,b)).^2;
        Total_Sum=sum(Total_Diff(:));
        nele=(B*B)-1;
        BlockVar(a,b)=Total_Sum/nele;
        %---------------->>   <<--------important,why 50---------------------
        if(BlockVar(a,b)<THRESHOLD)  % Background      % here 50 is represented as IMG_VAR of image
            I_out(i:i+B-1,j:j+B-1) = zeros(B,B); 
        else                        % Foreground
            I_out(i:i+B-1,j:j+B-1) = I(i:i+B-1,j:j+B-1); 
            I_Foreground_Pixels(i:i+B-1,j:j+B-1) = true;
        end
        b=b+1;   
    end
    % For Residue Col Part (374%10)=4
    if colResidue>0
        j=j+gap_to_forward_col;
        block_NxN = I(i:i+B-1,j:j+B-1);
%         fprintf('[%d - %d] ------[%d - %d]\n', i,(i+B-1),j,(j+B-1))
        tmpBlockMean=sum(block_NxN(:))/(B*B);
        Total_Diff=(block_NxN-tmpBlockMean).^2;
        Total_Sum=sum(Total_Diff(:));
        nele=(B*B)-1;
        tmpBlockVar=Total_Sum/nele;
        %---------------->>   <<--------important,why 50---------------------
        if(tmpBlockVar<THRESHOLD)  % Background      % here 50 is represented as IMG_VAR of image
            I_out(i:i+B-1,j:j+B-1) = zeros(B,B); 
        else                        % Foreground
            I_out(i:i+B-1,j:j+B-1) = I(i:i+B-1,j:j+B-1); 
            I_Foreground_Pixels(i:i+B-1,j:j+B-1) = false; % Externally forced to FALSE
        end
    end
    a=a+1;
end

%% For Residue Row Part (388%10)=8
if rowResidue>0
    i=i+gap_to_forward_row;
    b=1;
    for j=1:B:n-B+1
        block_NxN = I(i:i+B-1,j:j+B-1);
%         fprintf('[%d - %d] ------[%d - %d]\n', i,(i+B-1),j,(j+B-1))
        tmpBlockMean=sum(block_NxN(:))/(B*B);
        Total_Diff=(block_NxN-tmpBlockMean).^2;
        Total_Sum=sum(Total_Diff(:));
        nele=(B*B)-1;
        tmpBlockVar=Total_Sum/nele;
        %---------------->>   <<--------important,why 50---------------------
        if(tmpBlockVar<THRESHOLD)  % Background      % here 50 is represented as IMG_VAR of image
            I_out(i:i+B-1,j:j+B-1) = zeros(B,B); 
        else                        % Foreground
            I_out(i:i+B-1,j:j+B-1) = I(i:i+B-1,j:j+B-1); 
            I_Foreground_Pixels(i:i+B-1,j:j+B-1) = true;
        end
        b=b+1;   
    end
    % For Residue Col Part (374%10)=4
    if colResidue>0
        j=j+gap_to_forward_col;
                block_NxN = I(i:i+B-1,j:j+B-1);
%         fprintf('[%d - %d] ------[%d - %d]\n', i,(i+B-1),j,(j+B-1))
        tmpBlockMean=sum(block_NxN(:))/(B*B);
        Total_Diff=(block_NxN-tmpBlockMean).^2;
        Total_Sum=sum(Total_Diff(:));
        nele=(B*B)-1;
        tmpBlockVar=Total_Sum/nele;
        %---------------->>   <<--------important,why 50---------------------
        if(tmpBlockVar<THRESHOLD)  % Background      % here 50 is represented as IMG_VAR of image
            I_out(i:i+B-1,j:j+B-1) = zeros(B,B); 
        else                        % Foreground
            I_out(i:i+B-1,j:j+B-1) = I(i:i+B-1,j:j+B-1); 
            I_Foreground_Pixels(i:i+B-1,j:j+B-1) = false;  % Externally forced to FALSE
        end
    end
    
end


