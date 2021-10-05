
function [ChaffRemovedTemplate, Chaffs] = RemoveChaff_Ultimate_TER_BIF(ChaffIncludedTemplate)
	% first generate corresponding chaff of each minutiae(chaff+real) in 
	% oi corresponding chaff hote protiti minutiae er DISTANCE and ANGLE DISTANCE check kore decision nea hoy j oi minutiae REAL or CHAFF ??
	% chaff hole remove kora.
	% evabe chaff gulu remove hoye jabe.
    
    hasChaff=0;
    
    r=15;     % <----------- Circle Varied {{{VARIABLE}}}
    ChaffPointsOnCircumference = 16;
    SelectedChaffPoint = 6;
    RealMinutiaeMovingPoint = 11;
    ReverseMovingPoint = 0;
    if(RealMinutiaeMovingPoint<=8)
        ReverseMovingPoint = RealMinutiaeMovingPoint+8;
    else
        ReverseMovingPoint = RealMinutiaeMovingPoint-8;
    end
    
    ChaffAngleOffset=2.5;
    MovedAngleOffset=6.2832 - ChaffAngleOffset;
    
    
    
	idx = 1;
    idx2 = 1;
    Chaffs=[];
	for i=1:size(ChaffIncludedTemplate(:,1),1)

%         if(ChaffIncludedTemplate(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
%             ChaffRemovedTemplate(idx,:) = ChaffIncludedTemplate(i,:);
%             idx=idx+1;
%             continue;
%         end


       % Correcting Angle before moving to prv right place
       if(ChaffIncludedTemplate(i,4)<MovedAngleOffset)
            MinutiaeBackAgain(1,4) = (ChaffIncludedTemplate(i,4) + 6.2832) - MovedAngleOffset;
       else
            MinutiaeBackAgain(1,4) = ChaffIncludedTemplate(i,4) - MovedAngleOffset;
       end


       % Drwaing Fuzzy Vault Circles for the minutiae
       StatingAngle = MinutiaeBackAgain(1,4);
       xc=ChaffIncludedTemplate(i,1);
       yc=ChaffIncludedTemplate(i,2);

       % detecting 16 points   <----------- Points Varied {{{VARIABLE}}}
       angForPoints=(StatingAngle+0):pi/8:(StatingAngle+(2*pi)-(pi/8)); 
       xp=r*cos(angForPoints);
       yp=r*sin(angForPoints);

       % Getting 16 circles Centers
       for m=1:ChaffPointsOnCircumference
          Center_x(m) = xc+xp(m); 
          Center_y(m) = yc+yp(m); 
       end

       % Moving real minutiae to its original position
       % drawing 16 circle; protiti minutiae move kore dheka j eta ORIGINAL
       % kina?
       for m=1:ChaffPointsOnCircumference
           xc=Center_x(m);
           yc=Center_y(m);
           if(m==ReverseMovingPoint) %%%%<<<-------------  moved point er biporit
               MinutiaeBackAgain(1,1) = round(xc);
               MinutiaeBackAgain(1,2) = round(yc);
               MinutiaeBackAgain(1,3) = ChaffIncludedTemplate(i,3);
           end
       end
       
%        display(['Coordinate Bf: x='  num2str(MinutiaeBackAgain(1,1)) '  y=' num2str(MinutiaeBackAgain(2,2)) ]);

       hasChaff = HasItChaff(MinutiaeBackAgain, ChaffIncludedTemplate, r, ChaffPointsOnCircumference, SelectedChaffPoint, ChaffAngleOffset);

        if(hasChaff==0)  % If the BackAgain minutiae has no chaff, then its not the original, its a chaff
            Chaffs(idx2,:) = ChaffIncludedTemplate(i,:);
            idx2 = idx2 + 1;
        else % BackAgain minutiae has chaff, so the BackAgain minutiae is a original one
            ChaffRemovedTemplate(idx,:) = MinutiaeBackAgain(1,:);
            idx=idx+1;
            % display(['nooooooo ' num2str(idx)]);
        end

    end
end
	
	
	
	