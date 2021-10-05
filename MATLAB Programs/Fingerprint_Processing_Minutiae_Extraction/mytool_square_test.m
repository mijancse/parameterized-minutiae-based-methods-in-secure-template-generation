clear all;
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

x2 = nan;
y2 = nan;
for i=1:size(Minutiae1,1)
    if Minutiae1(i,3)==3
        x2(i) = Minutiae1(i,1);
        y2(i) = Minutiae1(i,2);
    end
end


IMG=double(~(I_Thinned.*Mask));

%-------------------------------------------
% DT1 = delaunayTriangulation(x1,y1);
% DT2 = delaunayTriangulation(x2,y2);

square_lenght = 30;
centers(:,1) = x2;
centers(:,2) = y2;
% row(1:size(centers,1),1) = square_lenght; 
% col(1:size(centers,1),1) = square_lenght; 
% figure;
% Output_IMG = insertShape(IMG, 'Rectangle', [x2-square_lenght/2 y2-square_lenght/2 row row],'Color', 'red', 'LineWidth', 1);
% imshow(Output_IMG)














radius = 20;
Circles = centers;
Circles(:,3) = radius;
count=1;
Found_Tringles=[ 0 0 0 0 0 0];
figure
axis([0 500 0 500])
for i=1:size(Circles,1)
    for j=1:size(Circles,1)
        if i==j 
            continue; 
        end
        % intersection btn i,j
        [x_ij,y_ij] = circcirc(Circles(i,1),Circles(i,2),Circles(i,3),Circles(j,1),Circles(j,2),Circles(j,3));
        % if circle i & j intersect
        if x_ij(1)>0 && x_ij(2)>0
            % FOR THE 3RD CIRCLE
            for k=1:size(Circles,1)
                if k==i || k==j
                    continue; 
                end
                % intersection btn k,i
                [x_ki,y_ki] = circcirc(Circles(k,1),Circles(k,2),Circles(k,3),Circles(i,1),Circles(i,2),Circles(i,3));
                % intersection btn k,j
                [x_kj,y_kj] = circcirc(Circles(k,1),Circles(k,2),Circles(k,3),Circles(j,1),Circles(j,2),Circles(j,3));
                % if (k,i) intersects & (k,j) intersects ie. all three
                % circles intersects
                if x_ki(1)>0 && x_ki(2)>0 && x_kj(1)>0 && x_kj(2)>0
                    % checking GOOD intersect or NOT
                    inPoint = linlinintersect2(x_ij(1),y_ij(1),x_ij(2),y_ij(2),x_kj(1),y_kj(1),x_kj(2),y_kj(2));
                    if ~isnan(inPoint(1)) 
%                         ResOf1stLine = pointonline(x_ij,x_ij,inPoint); % bindu ta j kono line er upor thake hobe. extended line er upor na.
%                         ResOf2ndLine = pointonline(x_kj,x_kj,inPoint); % bindu ta j kono line er upor thake hobe. extended line er upor na.
                        ResOf3rdLine = pointonline(x_ki,y_ki,inPoint);
                        if  ResOf3rdLine==1
                            [tri_x,tri_y]=ChooseInnerPoint(Circles(i,1),Circles(i,2),Circles(j,1),Circles(j,2),Circles(k,1),Circles(k,2),x_ij,y_ij,x_ki,y_ki,x_kj,y_kj);
                            fill(roundsd(tri_x,3),roundsd(tri_y,3),'r');
                            hold on                        
                            plot(x_ij,y_ij,'r');
                            hold on                        
                            plot(x_kj,y_kj,'y');
                            hold on                        
                            plot(x_ki,y_ki,'g');
                            hold on  
                            tri_x = roundsd(tri_x,3);
                            tri_y = roundsd(tri_y,3);
                            [tri_x, indx_order] = sort(tri_x);
                            tmp = tri_y(indx_order);
                            tri_y = tmp;
                            tmp = ismember(Found_Tringles, [tri_x(1) tri_y(1) tri_x(2) tri_y(2) tri_x(3) tri_y(3)]);
                            result = sum(tmp);
                            if result==0
                                Found_Tringles(count,:)=[tri_x(1) tri_y(1) tri_x(2) tri_y(2) tri_x(3) tri_y(3)];
                                Found_Tringles(count,:)= roundsd(Found_Tringles(count,:),3);                           
                                count=count+1;
                                % drawing circle
                                x=Circles(i,1);
                                y=Circles(i,2);
                                r=Circles(i,3);
                                ang=0:0.01:2*pi; 
                                xp=r*cos(ang);
                                yp=r*sin(ang);
                                plot(x+xp,y+yp,'b');
                                hold on
                                % drawing circle
                                x=Circles(j,1);
                                y=Circles(j,2);
                                r=Circles(j,3);
                                ang=0:0.01:2*pi; 
                                xp=r*cos(ang);
                                yp=r*sin(ang);
                                plot(x+xp,y+yp,'b');
                                hold on
                                % drawing circle
                                x=Circles(k,1);
                                y=Circles(k,2);
                                r=Circles(k,3);
                                ang=0:0.01:2*pi; 
                                xp=r*cos(ang);
                                yp=r*sin(ang);
                                plot(x+xp,y+yp,'b');
                                hold on
                            end
                        end
                    end
                end
            end
        end
    end
end

Found_Tringles_UQ = unique(Found_Tringles, 'rows');
a_row(1) = size(Found_Tringles_UQ,1);
for i=1:size(Found_Tringles_UQ,1)
    X = [Found_Tringles_UQ(i,1), Found_Tringles_UQ(i,3), Found_Tringles_UQ(i,5)]; % x values
    Y = [Found_Tringles_UQ(i,2), Found_Tringles_UQ(i,4), Found_Tringles_UQ(i,6)]; %yy values
    triangle_area = polyarea(X, Y);
    a_row(i+1) = triangle_area;
    disp(['The area of triangle (A,B,C) is ' num2str(triangle_area) '.']);
end
size_Tris = size(Found_Tringles_UQ,1);
size_Tris = size_Tris+1;
a_row(2:size_Tris) = sort(a_row(2:size_Tris));
Indexing_Info(1,:) = a_row;
