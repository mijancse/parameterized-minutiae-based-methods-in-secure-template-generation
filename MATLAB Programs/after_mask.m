function mask = after_mask(mask)
    block_size_c = 24; YA=0; YB=0; XA=0; XB=0;
    mask_t=mask;
    for y=19:size(mask,1)-block_size_c*2
        for x=block_size_c:size(mask,2)-block_size_c*2
          n_mask = 0;
          for yy=-1:1
              for xx=-1:1
                  y_t = y + yy *block_size_c; 
                  x_t = x + xx *block_size_c; 
                  if y_t > 0 && x_t > 0 && (y_t ~= y || x_t ~= x) && mask(y_t,x_t) == 0
                     n_mask = n_mask + 1;
                  end
              end
          end 
          if n_mask == 0
             continue 
          end
          if mask(y,x) == 0 || y > size(mask,1) - 20  ||  y < yt || y > yb || x < xl || x > xr
               cimg2(ceil(y/(block_size_c)), ceil(x/(block_size_c))) = 255;
               mask_t(y,x) = 0;
               continue;
          end
          for i = y:y+1
            for j = x-9:x+9
              if i > 0 && j > 0 && i < size(mask,1) && j < size(mask,2) && mask(i,j) > 0
              else
                 cimg2(ceil(y/(block_size_c)), ceil(x/(block_size_c))) = 255;
                 mask_t(y,x)=0;
                 break
              end
            end
          end
        end
    end
    mask=mask_t;
    inv_binim = (binim == 0);
    thinned =  bwmorph(inv_binim, 'thin',Inf);
    mask_t=mask;
    if numel(find(mask(125:150,150:250)>0)) > 0 && numel(find(mask(250:275,150:250)>0)) > 0
      mask(150:250,150:250)=1;
    end
    method=-1; core_y = 0; core_x = 0; core_val=0; lc=0;
    o_img=sin(orient_img); o_img(mask == 0) = 1;

    lower_t=0.1;
    [v,y]=min(cimg);
    [dt1,x]=min(v);
    delta1_y=y(x)*block_size_c/2; delta1_x=x*block_size_c/2;

    v(x)=255; v(x+1)=255;
    [dt2,x]=min(v);
    delta2_y=y(x)*block_size_c/2; delta2_x=x*block_size_c/2;

    v(x)=255; v(x+1)=255;
    [dt3,x]=min(v);
    delta3_y=y(x)*block_size_c/2; delta3_x=x*block_size_c/2;

    db=60;
    if dt1 < 1 && delta1_y+db < core_y && delta1_y > 15 || dt2 < 1 && delta2_y+db < core_y && delta2_y > 15 || dt3 < 1 && delta3_y+db < core_y && delta3_y > 15 
        core_val=255;
    end
    for y=10:size(o_img,1)-10
        for x=10:size(o_img,2)-10
            s1=0; t=10; %few of bad cores here 
            if y < 50 && x > 250
               t=11; 
            end
            if y > 38
               yt=20;
            else
               yt=5;
            end
            if lc > 0.41 && (core_y + 60 < y)
               break;
            end
            if mask(y,x)==0 || mask(max(y-t,1),x)==0 || mask(y,min(x+t, size(o_img,2)))==0 || mask(y,max(x-t,1))==0 || mask(max(y-t,1),min(x+t,size(o_img,2)))==0 || mask(max(y-t,1),max(x-t,1))==0 || o_img(y,x) < lc || o_img(y,x) < 0.1 
               continue
            end  
            if dt1 < 1 && delta1_y+db < y && delta1_y > 15 || dt2 < 1 && delta2_y+db < y &&    delta2_y > 15 || dt3 < 1 && delta3_y+db < y && delta3_y > 15 
               continue
            end
            test_m=min(o_img(1:y-yt,max((x-10),1):min(x+10,size(o_img,2)) ));
            if numel(test_m)>0 && min(test_m) >= 0.17
               continue
            end 
            for a=y:y+2 
                for b=x:x+1
                    s1=s1+o_img(a,b);    
                end
            end
            s1=s1/6; s2=[]; i=1;
            for a=y-3:y-1
                for b=x:x+1
                    s2(i)=o_img(a,b);    
                    i=i+1;
                end
            end
            if min(s2) < lower_t
               s2=sum(s2)/6;       
            else 
               s2=s1;
            end
            s3=[]; i=1;
            for a=y:y+2 
                for b=x+2:x+3
                    s3(i)=o_img(a,b);    
                    i=i+1;
                end
            end
            if min(s3) < lower_t
               s3=sum(s3)/6;       
            else 
               s3=s1;
            end
            s4=[]; i=1;
            for a=y:y+2 
                for b=x-2:x-1
                    s4(i)=o_img(a,b);    
                    i=i+1;
                end
            end
            if min(s4) < lower_t
               s4=sum(s4)/6;       
            else 
               s4=s1;
            end
            s5=[];
            i=1;
            for a=y-3:y-1 
                for b=x-2:x-1
                    s5(i)=o_img(a,b);    
                    i=i+1;
                end
            end
            if min(s5) < lower_t
               s5=sum(s5)/6;       
            else 
              s5=s1;
            end
            s6=[]; i=1;
            for a=y-3:y-1 
                for b=x+2:x+3
                    s6(i)=o_img(a,b);    
                    i=i+1;
                end
            end
            if min(s6) < lower_t
              s6=sum(s6)/6;       
            else 
              s6=s1;
            end
            if s1-s2 > core_val
               core_val=s1-s2;
               core_x=x;
               core_y=y;
               lc=o_img(y,x);
               method=1;
            end 
            if s1-s3 > core_val
               core_val=s1-s3;
               core_x=x;
               core_y=y;
               lc=o_img(y,x);
               method=2;
            end 
            if x < 300 && s1-s4 > core_val
               core_val=s1-s4;
               core_x=x;
               core_y=y;
               lc=o_img(y,x);
               method=3;
            end 
            if x < 300 && s1-s5 > core_val
               core_val=s1-s5;
               core_x=x;
               core_y=y;
               lc=o_img(y,x);
               method=4;
            end 
            if s1-s6 > core_val
               core_val=s1-s6;
               core_x=x;
               core_y=y;
               lc=o_img(y,x);
               method=5;
            end 
        end
    end
    if core_y > 37
       yt=20;
    else
       yt=5;
    end
    test_smooth = 100;
    if core_y > 0
       test_smooth= sum(sum(o_img(core_y-yt-5:core_y-yt+5,core_x-5:core_x+5)));
    end
    if lc > 0.41 && (test_smooth < 109.5 && method~=2 || test_smooth < 100) %&& min(min(o_img(1:core_y-yt,core_x-10:core_x+10))) < 0.17 
       start_t=0;
       core_val=1/(core_val+1);
    else
       core_x=0;
       core_y=0;
       core_val = 255;
    end
    mask=mask_t; path_len = 45;