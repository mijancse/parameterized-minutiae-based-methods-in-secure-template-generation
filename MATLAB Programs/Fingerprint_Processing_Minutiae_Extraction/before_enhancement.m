function img = before_enhancement(img)

yt=1; xl=1; yb=size(img,2); xr=size(img,1);
    for x=1:55
        if numel(find(img(x,:)<200)) < 8
           img(1:x,:) = 255;
           yt=x;
        end
    end
    for x=225:size(img,1)
        if numel(find(img(x,:)<200)) < 3
           img(x-17:size(img,1),:) = 255;
           yb=x;
           break
        end
    end
    for y=200:size(img,2)
        if numel(find(img(:,y)<200)) < 1
           img(:,y:size(img,2)) = 255;
           xr=y;
           break
        end
    end
    for y=1:75
        if numel(find(img(:,y)<200)) < 1
           img(:,1:y) = 255;
           xl=y;
        end	
    end
