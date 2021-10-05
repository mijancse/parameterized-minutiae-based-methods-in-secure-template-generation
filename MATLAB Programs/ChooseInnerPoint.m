function [tri_x,tri_y]=ChooseInnerPoint(c_x_i,c_y_i,c_x_j,c_y_j,c_x_k,c_y_k,x_ij,y_ij,x_ki,y_ki,x_kj,y_kj)
    % ith circle hote j,k er point 2tar durutto
    X = [c_x_i,c_y_i; x_kj(1),y_kj(1)];
    d1 = pdist(X,'euclidean');
    X = [c_x_i,c_y_i; x_kj(2),y_kj(2)];
    d2 = pdist(X,'euclidean');

    if d1<d2
       tri_x(1)=x_kj(1);
       tri_y(1)=y_kj(1); 
    else
       tri_x(1)=x_kj(2);
       tri_y(1)=y_kj(2); 
    end

    % jth circle hote k,i er point 2tar durutto
    X = [c_x_j,c_y_j; x_ki(1),y_ki(1)];
    d1 = pdist(X,'euclidean');
    X = [c_x_j,c_y_j; x_ki(2),y_ki(2)];
    d2 = pdist(X,'euclidean');

    if d1<d2
       tri_x(2)=x_ki(1);
       tri_y(2)=y_ki(1); 
    else
       tri_x(2)=x_ki(2);
       tri_y(2)=y_ki(2); 
    end


    % kth circle hote i,j er point 2tar durutto
    X = [c_x_k,c_y_k; x_ij(1),y_ij(1)];
    d1 = pdist(X,'euclidean');
    X = [c_x_k,c_y_k; x_ij(2),y_ij(2)];
    d2 = pdist(X,'euclidean');

    if d1<d2
       tri_x(3)=x_ij(1);
       tri_y(3)=y_ij(1); 
    else
       tri_x(3)=x_ij(2);
       tri_y(3)=y_ij(2); 
    end
end