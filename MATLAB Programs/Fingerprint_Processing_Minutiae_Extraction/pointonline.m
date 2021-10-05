function [res]= pointonline(x_ki,y_ki,inPoint)
    inPoint = roundsd(inPoint,3);
    LEFT_SIDE = (inPoint(2)-y_ki(1))/(y_ki(2)-y_ki(1));
    RIGHT_SIDE = (inPoint(1)-x_ki(1))/(x_ki(2)-x_ki(1));
    if roundsd(LEFT_SIDE,2)==roundsd(RIGHT_SIDE,2)
        res=1;
    else
        res=0;
    end
end

