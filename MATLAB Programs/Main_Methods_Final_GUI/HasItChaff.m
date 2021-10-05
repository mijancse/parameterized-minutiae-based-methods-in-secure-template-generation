
function [hasChaff] = HasItChaff(MinutiaeBackAgain, ChaffIncludedTemplate, r, ChaffPointsOnCircumference, SelectedChaffPoint, ChaffAngleOffset)
    
       hasChaff=0;

       % Drwaing Fuzzy Vault Circles for the minutiae
       StatingAngle = MinutiaeBackAgain(1,4);
       xc=MinutiaeBackAgain(1,1);
       yc=MinutiaeBackAgain(1,2);

       % detecting 16 points   <----------- Points Varied {{{VARIABLE}}}
       angForPoints=(StatingAngle+0):pi/8:(StatingAngle+(2*pi)-(pi/8)); 
       xp=r*cos(angForPoints);
       yp=r*sin(angForPoints);

       % Getting 16 circles Centers
       for m=1:ChaffPointsOnCircumference
          Center_x(m) = xc+xp(m); 
          Center_y(m) = yc+yp(m); 
       end
       
       % drawing 16 circle; Oi minutiae er chaff tui kora
       for m=1:ChaffPointsOnCircumference
           xc=Center_x(m);
           yc=Center_y(m);
           if(m==SelectedChaffPoint)  %%%<<<<---------- 6th is the chaff
               CorespondingChaffMinutiae(1,1) = round(xc);
               CorespondingChaffMinutiae(1,2) = round(yc);
               CorespondingChaffMinutiae(1,3) = 3;
               if( (MinutiaeBackAgain(1,4) + ChaffAngleOffset)>=6.2832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
                   CorespondingChaffMinutiae(1,4) = (MinutiaeBackAgain(1,4) + ChaffAngleOffset) - 6.2832;
               else
                   CorespondingChaffMinutiae(1,4) = (MinutiaeBackAgain(1,4) + ChaffAngleOffset);
               end
           end
       end


        for q=1:size(ChaffIncludedTemplate(:,1),1)
            if((CorespondingChaffMinutiae(1,1)>(ChaffIncludedTemplate(q,1)-.5)) && (CorespondingChaffMinutiae(1,1)<(ChaffIncludedTemplate(q,1)+.5)) )
                if((CorespondingChaffMinutiae(1,2)>(ChaffIncludedTemplate(q,2)-.5)) && (CorespondingChaffMinutiae(1,2)<(ChaffIncludedTemplate(q,2)+.5)) )
                    if((CorespondingChaffMinutiae(1,4)>(ChaffIncludedTemplate(q,4)-.05)) && (CorespondingChaffMinutiae(1,4)<(ChaffIncludedTemplate(q,4)+.05)) )
                        hasChaff=1;
                        break;
                    end   
                end
            end
        end

end
	
	
	
	