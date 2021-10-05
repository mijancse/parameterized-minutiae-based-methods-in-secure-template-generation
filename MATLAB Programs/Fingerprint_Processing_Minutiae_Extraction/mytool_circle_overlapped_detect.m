radius = 30;
Circles = centers;
Circles(:,3) = radius;
count=1;
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

