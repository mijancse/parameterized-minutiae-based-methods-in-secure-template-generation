function [] = Draw_Figure_Real_Only(Minutiae, Title)


%% Showing All Minutiae
figure(73)
imshow('103_1_Thinned.bmp');
title(Title);
hold on
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=3;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b');
   hold on
   
   % drawing the angle line for main minutiae
   r=2;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x1=xc+xp;
   y1=yc+yp;
   r=15;
   angle=Minutiae(i,4); 
   xp=r*cos(angle);
   yp=r*sin(angle);
   x2=xc+xp;
   y2=yc+yp;
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 0 1]);
   hold on
end

set(gcf,'position',[950 110 450 450]);