
function [ChaffRemovedTemplate, Chaffs] = RemoveChaff(ChaffIncludedTemplate)
	% first generate corresponding chaff of each minutiae(chaff+real) in 
	% oi corresponding chaff hote protiti minutiae er DISTANCE and ANGLE DISTANCE check kore decision nea hoy j oi minutiae REAL or CHAFF ??
	% chaff hole remove kora.
	% evabe chaff gulu remove hoye jabe.
	idx = 1;
    idx2 = 1;
    Chaffs=[];
	for i=1:size(ChaffIncludedTemplate(:,1),1)

        if(ChaffIncludedTemplate(i,3) == 1)    % <----------- Chaff can bed added for BIF or TER {{{VARIABLE}}}
            ChaffRemovedTemplate(idx,:) = ChaffIncludedTemplate(i,:);
            idx=idx+1;
            continue;
        end

       % Drwaing Fuzzy Vault Circles for the minutiae
       StatingAngle = ChaffIncludedTemplate(i,4);
       r=15;     % <----------- Circle Varied {{{VARIABLE}}}
       xc=ChaffIncludedTemplate(i,1);
       yc=ChaffIncludedTemplate(i,2);

       % detecting 7 points   <----------- Points Varied {{{VARIABLE}}}
       angForPoints=(StatingAngle+pi/4):pi/4:(StatingAngle+(2*pi)-(pi/4)); 
       xp=r*cos(angForPoints);
       yp=r*sin(angForPoints);

       % Getting 7 circles Centers
       for m=1:7
          Center_x(m) = xc+xp(m); 
          Center_y(m) = yc+yp(m); 
       end

       %drawing 7 circle
       for m=1:7
           xc=Center_x(m);
           yc=Center_y(m);
           if(m==5)
               CorespondingChaffMinutiae(1,1) = round(xc);
               CorespondingChaffMinutiae(1,2) = round(yc);
               CorespondingChaffMinutiae(1,3) = 3;
               CorespondingChaffMinutiae(1,5) = ChaffIncludedTemplate(i,5);
               CorespondingChaffMinutiae(1,6) = ChaffIncludedTemplate(i,6);
               if( ChaffIncludedTemplate(i,4)>=3.7832)   %%%% <<-------------- ANGLE ADDED 2.5 {{{VARIABLE}}}
                   CorespondingChaffMinutiae(1,4) = (ChaffIncludedTemplate(i,4) + 2.5) - 6.2832;
               else
                   CorespondingChaffMinutiae(1,4) = (ChaffIncludedTemplate(i,4) + 2.5);
               end
               % ChaffIndex = ChaffIndex+1;
           end
       end

        % +++ Got the CorespondingChaffMinutiae. Now measure distance btn CorespondingChaffMinutiae & chaffIncludedTemplate minutiae

        chaffFlag = 0;
        for q=1:size(ChaffIncludedTemplate(:,1),1)
            if((CorespondingChaffMinutiae(1,1)>(ChaffIncludedTemplate(q,1)-.5)) && (CorespondingChaffMinutiae(1,1)<(ChaffIncludedTemplate(q,1)+.5)) )
                if((CorespondingChaffMinutiae(1,2)>(ChaffIncludedTemplate(q,2)-.5)) && (CorespondingChaffMinutiae(1,2)<(ChaffIncludedTemplate(q,2)+.5)) )
                    if((CorespondingChaffMinutiae(1,4)>(ChaffIncludedTemplate(q,4)-.05)) && (CorespondingChaffMinutiae(1,4)<(ChaffIncludedTemplate(q,4)+.05)) )
                        chaffFlag=1;
                    end   
                end
            end
        end
        
        if(chaffFlag==1)  % Chaff Minutiae Detected
            Chaffs(idx2,:) = ChaffIncludedTemplate(i,:);
            idx2 = idx2 + 1;
            % display('yaaaaaaaaaaa Chaff');
        else % Not chaff, Real Minutiae
            ChaffRemovedTemplate(idx,:) = ChaffIncludedTemplate(i,:);
            idx=idx+1;
            % display(['nooooooo ' num2str(idx)]);
        end
        
%         euclidianDistMatchFlag = 0;
%         angleDistMatchFlag = 0;
%         euclidianDist = sqrt((ChaffIncludedTemplate(i,1)-CorespondingChaffMinutiae(1,1))^2+((ChaffIncludedTemplate(i,2)-CorespondingChaffMinutiae(1,2))^2));
%         if((euclidianDist>(r-.15)) && (euclidianDist<(r+.15)))
%             euclidianDistMatchFlag = 1;
%         else
%             euclidianDistMatchFlag = 0;
%         end
% 
%         if(ChaffIncludedTemplate(i,4)<3.7832)
%             angleDistStandard = 2.5;
%             angleDist = CorespondingChaffMinutiae(1,4) - ChaffIncludedTemplate(i,4);
%         elseif(ChaffIncludedTemplate(i,4)>=3.7832)
%             angleDistStandard = 3.7832;
%             angleDist = ChaffIncludedTemplate(i,4) - CorespondingChaffMinutiae(1,4);
%         end
% 
%         if((angleDist>(angleDistStandard-.1)) && (angleDist<(angleDistStandard+.1)))
%             angleDistMatchFlag = 1;
%         else
%             angleDistMatchFlag = 0;
%         end
% 
%         if((euclidianDistMatchFlag==1) && (angleDistMatchFlag==1))  % Chaff Minutiae Detected
%             Chaffs(idx2,:) = ChaffIncludedTemplate(i,:);
%             idx2 = idx2 + 1;
%             display('yaaaaaaaaaaa Chaff');
%         else % Not chaff, Real Minutiae
%             ChaffRemovedTemplate(idx,:) = ChaffIncludedTemplate(i,:);
%             idx=idx+1;
%             display(['nooooooo ' num2str(idx)]);
%         end

    end
end
	
	
	
	