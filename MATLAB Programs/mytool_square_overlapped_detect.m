square_lenght = 30;
Rectangles = centers;
Rectangles(:,3) = square_lenght/2;
Rectangles(:,4) = square_lenght/2;
count=1;
figure
axis([0 500 0 500])
for i=1:size(Rectangles,1)
    for j=1:size(Rectangles,1)
        if i==j continue; end
        rect1 = Rectangles(i,:);
        rect2 = Rectangles(j,:);
        l = max(rect1(1,1),rect2(1,1));
        r = min(rect1(1,1)+rect1(1,3),rect2(1,1)+rect2(1,3));
        b = max(rect1(1,2),rect2(1,2));
        t = min(rect1(1,2)+rect1(1,4),rect2(1,2)+rect2(1,4));
        rect3 = [l b r-l t-b];
        if(rect3(1,3)>0 && rect3(1,4)>0) % if 2ta really overlap hoy
            for k=1:size(Rectangles,1)
                if (j==k || i==k || i==j) continue; end
                rect4 = Rectangles(k,:);
                l = max(rect3(1,1),rect4(1,1));
                r = min(rect3(1,1)+rect3(1,3),rect4(1,1)+rect4(1,3));
                b = max(rect3(1,2),rect4(1,2));
                t = min(rect3(1,2)+rect3(1,4),rect4(1,2)+rect4(1,4));
                rect5 = [l b r-l t-b];
                if(rect5(1,3)>0 && rect5(1,4)>0) % if 3ta overlap hoy
                    Overlapped_Rectangles(count,:) = rect5;
                    count=count+1;
                    rectangle('Position',rect5,'FaceColor','red')
                    hold on
                end
            end
        end
    end
end

for i=1:size(Rectangles,1)
    rectangle('Position',Rectangles(i,:))
    hold on
end
        

