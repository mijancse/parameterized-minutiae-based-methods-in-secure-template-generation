function point = linlinintersect2(x1,y1,x2,y2,x3,y3,x4,y4)
% calculate intersection point of two 2d lines specified with 2 points each
% (X1, Y1; X2, Y2; X3, Y3; X4, Y4), while 1&2 and 3&4 specify a line.
% Gives back NaN or Inf/-Inf if lines are parallel (= when denominator = 0)
% see http://en.wikipedia.org/wiki/Line-line_intersection

    x(1)=x1;
    y(1)=y1;
    x(2)=x2;
    y(2)=y2;
    x(3)=x3;
    y(3)=y3;
    x(4)=x4;
    y(4)=y4;
    % Calculation
    denominator = (x(1)-x(2))*(y(3)-y(4))-(y(1)-y(2))*(x(3)-x(4));
    point = [((x(1)*y(2)-y(1)*x(2))*(x(3)-x(4))-(x(1)-x(2))*(x(3)*y(4)-y(3)*x(4)))/denominator ...
        ,((x(1)*y(2)-y(1)*x(2))*(y(3)-y(4))-(y(1)-y(2))*(x(3)*y(4)-y(3)*x(4)))/denominator];
    
    
    %%%%%% Point on line or out of line?
    if ~isnan(point(1)) % got a point or line is parallel
        l1minX=min([x1 x2]);
        l2minX=min([x3 x4]);
        l1minY=min([y1 y2]);
        l2minY=min([y3 y4]);

        l1maxX=max([x1 x2]);
        l2maxX=max([x3 x4]);
        l1maxY=max([y1 y2]);
        l2maxY=max([y3 y4]);

        x=point(1);
        y=point(2);

        %Test if the intersection is a point from the two lines because 
        %all the performed calculations where for infinite lines 
        if ((x<l1minX) | (x>l1maxX) | (y<l1minY) | (y>l1maxY) |...
               (x<l2minX) | (x>l2maxX) | (y<l2minY) | (y>l2maxY) )
            point(1)=nan;
            point(2)=nan;
        end
    end
end