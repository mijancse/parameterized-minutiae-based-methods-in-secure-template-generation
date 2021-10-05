function [] = Draw_Figure_Combined(ChaffRemovedTemplate, Chaffs, Title)


ChaffMinutiae=[]
%% Showing Original Minutiae
figure(72)
imshow('103_1_Thinned.bmp');
title(Title);
hold on
Minutiae=[];
Minutiae=ChaffRemovedTemplate;
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'b.');
   hold on
   % drawing main minutiae circle
   r=2;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'b.');
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





%% Anglewise Line Creating + Equidistant Circle
ChaffIndex=1;
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
   
   
   
   
%    % DO THE VAULT THINK for what? [BIF or TER]
%    if(Minutiae(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
%        continue;
%    end
   
   
   
   % Drwaing Fuzzy Vault Circles for the minutiae
   StatingAngle = Minutiae(i,4);
   r=20;     % <----------- Circle Varied {{{VARIABLE}}}
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'Color',[0 0 0]);
   hold on
   
%    % detecting 7 points
%    angForPoints=(StatingAngle+pi/4):pi/4:(StatingAngle+(2*pi)-(pi/4)); 
%    xp=r*cos(angForPoints);
%    yp=r*sin(angForPoints);

   % detecting 16 points
   angForPoints=(StatingAngle+0):pi/8:(StatingAngle+(2*pi)-(pi/8)); 
   xp=r*cos(angForPoints);
   yp=r*sin(angForPoints);
%    plot(xc+xp,yc+yp,'r.');
   
   
   
   
   
   % Getting 16 circles Centers
   for k=1:16
      Center_x(k) = xc+xp(k); 
      Center_y(k) = yc+yp(k); 
   end
   
   SixteenPointsAngles=0:pi/8:(2*pi)-(pi/8); 
   %drawing 16 circle
   for k=1:16
       r=3;
       xc=Center_x(k);
       yc=Center_y(k);
       ang=0:0.01:2*pi; 
       xp=r*cos(ang);
       yp=r*sin(ang);
       plot(xc+xp,yc+yp,'Color',[0 0 0]);
       
       % Selecting Chaff
       if(k==6)    %%%%<<<------------- 6th point chosen (clockwise)
           plot(xc,yc,'g.','MarkerSize',20);
           ChaffMinutiae(ChaffIndex,1) = xc;
           ChaffMinutiae(ChaffIndex,2) = yc;
           if( (Minutiae(i,4) + 2.5)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + 2.5) - 6.2832;
           else
               ChaffMinutiae(ChaffIndex,4) = (Minutiae(i,4) + 2.5);
           end
           
           % drawing the angle line for the minutiae
           r=2;
           angle=ChaffMinutiae(ChaffIndex,4); 
           xp=r*cos(angle);
           yp=r*sin(angle);
           x1=xc+xp;
           y1=yc+yp;
           r=15;
           angle=ChaffMinutiae(ChaffIndex,4); 
           xp=r*cos(angle);
           yp=r*sin(angle);
           x2=xc+xp;
           y2=yc+yp;

           line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[0 1 0]);
           hold on

           
           ChaffIndex = ChaffIndex+1;

       end
        
       hold on

   end
end







%% Showing Chaff Minutiae
Minutiae=[];
Minutiae=Chaffs;
for i=1:size(Minutiae(:,1),1)
   plot(Minutiae(i,1),Minutiae(i,2),'r.');
   hold on
   % drawing main minutiae circle
   r=2;
   xc=Minutiae(i,1);
   yc=Minutiae(i,2);
   ang=0:0.01:2*pi; 
   xp=r*cos(ang);
   yp=r*sin(ang);
   plot(xc+xp,yc+yp,'r.');
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
   
   line([x1 x2],[y1 y2],'LineWidth',2, 'Color',[1 0 0]);
   hold on
end

set(gcf,'position',[475 110 450 450]);