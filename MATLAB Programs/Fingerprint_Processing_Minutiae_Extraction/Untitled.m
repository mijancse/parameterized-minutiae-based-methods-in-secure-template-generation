mx = max(max(I_Oriented));
mn = min(min(I_Oriented));

tmp=[]
for i=1:size(I_Oriented,1)
   for j=1:size(I_Oriented,2)
       if I_Oriented(i,j)<0.1
           tmp(i,j) =  I_Oriented(i,j);
       elseif I_Oriented(i,j)>0.5
           tmp(i,j) =  I_Oriented(i,j);
       end
   end
end

figure
surf(tmp)
I_Thinned_Orient =  bwmorph(tmp, 'thin',Inf);
figure
contour(I_Thinned_Orient)
figure
imshow(I_Thinned_Orient)
figure
imshow(tmp2)