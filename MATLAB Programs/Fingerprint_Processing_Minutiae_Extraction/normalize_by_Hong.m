% Hong, Wan and Jain, 1998

% This function make sure that every fingerprint have the same 
% statistics. we choose that evry fingerprint will have a mean 
% of zero and a variance of one.

% The inputs are : I         - the image
%       `          Mean0     - desired mean
%                  Variance0 - desired variance

% The output is: I3 - normelised image

%**************************************************************

function [ I2 ] = normalize_by_Hong ( I , Mean0 , Variance0 )

%**************************************************************
% getting matrixes parameters

[m,n] = size( I ) ;

%**************************************************************
% normalasing the fingerprint

% changing into vector
I1 = double(reshape(I,1,m*n)) ;

% find the original mean and variance   
% Global Mean of Image
Mean1=sum(double(I(:)))/(m*n);
% Global Variance of Image
TotalDiff=(double(I-Mean1)).^2;
TotalSum=sum(TotalDiff(:));
nele=(m*n)-1;
Variance1=TotalSum/nele;

    
for i = 1:1:m*n
    if ( I1(i) > Mean1 )
        I1(i) = Mean0 + sqrt( Variance0/Variance1 * (I1(i) - Mean1)^2 ) ;
    else
        I1(i) = Mean0 - sqrt( Variance0/Variance1 * (I1(i) - Mean1)^2 ) ;
    end ;
end ;

%**************************************************************
% the normalised fingerprint

I2 = reshape( I1 , m , n ) ;

