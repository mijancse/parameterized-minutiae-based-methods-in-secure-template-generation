
[filename, pathname] = uigetfile('*.*','Image Selector');
file=fullfile(pathname, filename);
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
[Minutiae1, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);
x1 = Minutiae1(:,1);
y1 = Minutiae1(:,2);

IMG1=I;

%------------------------------------------------------
[filename, pathname] = uigetfile('*.*','Image Selector');
file=fullfile(pathname, filename);
I = imread(file);
m = size(I,1); 
n = size(I,2);
imshow(I);
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
[Minutiae1, Min_path_index] = extract_minutiaes(I_Thinned, I, Mask, I_Oriented);
x2 = Minutiae1(:,1);
y2 = Minutiae1(:,2);





IMG2=double(~(I_Thinned.*Mask));

%-------------------------------------------
% DT1 = delaunayTriangulation(x1,y1);
% DT2 = delaunayTriangulation(x2,y2);


centers(:,1) = x2;
centers(:,2) = y2;
row(1:size(centers,1),1) = 30; 
col(1:size(centers,1),1) = 30; 
figure;
Output_IMG2 = insertShape(IMG2, 'Rectangle', [x2-15 y2-15 row row],'Color', 'red', 'LineWidth', 1);
imshow(Output_IMG2)
