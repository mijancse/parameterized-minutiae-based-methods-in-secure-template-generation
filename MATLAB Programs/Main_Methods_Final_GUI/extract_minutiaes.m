function [minutiae, min_path_index] = extract_minutiaes(thinned, img, mask, orient_img_m)
    
    % -----------------
    core_x=0;core_y=0;
    % -----------------
    
    minu_count = 1;
    minutiae(minu_count, :) = [0,0,0,0,0,1];
    min_path_index = [];
    % loop through image and find minutiae, ignore certain pixels for border
    for y=20:size(img,1)-14
        for x=21:size(img,2)-21
            if (thinned(y, x) == 1) % only continue if pixel is white
                % calculate CN from Raymond Thai
                CN = 0; sx=0; sy=0;
                for i = 1:8
                  t1 = p(thinned, x, y, i);
                  t2 = p(thinned, x, y, i+1);
                  CN = CN + abs (t1-t2);
                end   
                CN = CN / 2;
                if ((CN == 1) || (CN == 3)) %&& mask(y,x) > 0
                   skip=0;
                   for i = y-5:y+5
                        for j = x-5:x+5
                          if i>0 && j>0 && mask(i,j) == 0   
                             skip=1;
                          end
                        end
                   end
                   if skip == 1
                      continue;
                   end
                   
                   t_a=[];
                   c = 0;
                   for e=y-1:y+1
                       for f=x-1:x+1
                           c = c + 1;
                           t_a(c) = orient_img_m(e,f);
                       end
                   end 
                   m_o = median(t_a); % 9ta pixel er orientation value hote, median choose kore
                   m_f = 0; % what is this??? ajibon zero thaklo.........
                   
                   if CN == 3
                      [CN, prog, sx, sy,ang]=test_bifurcation(thinned, x,y, m_o, core_x, core_y);
                      if prog < 3
                         continue
                      end
                      if ang < pi 
                         m_o = mod(m_o+pi,2*pi);
                      end
                   else
                      progress=0;
                      xx=x; yy=y; pao=-1; pos=0;
                      while progress < 15 && xx > 1 && yy > 1 && yy<size(img,1) && xx<size(img,2) && pos > -1
                            pos=-1;
                            for g = 1:8
                                [ta, xa, ya] = p(thinned, xx, yy, g);
                                [tb, xb, yb] = p(thinned, xx, yy, g+1);
                                if (ta > tb)  && pos==-1 && g ~= pao
                                   pos=ta; 
                                   if g < 5
                                      pao = 4 + g;
                                   else
                                      pao = mod(4 + g, 9) + 1;
                                   end
                                   xx=xa; yy=ya;
                                end 
                            end
                            progress=progress+1;
                      end
                      if progress < 10
                         continue
                      end
                      if mod(atan2(y-yy,xx-x), 2*pi) > pi
                         m_o=m_o+pi;
                      end
                   end               
                   minutiae(minu_count, :) = [ x, y, CN, m_o, m_f, 1];
                   min_path_index(minu_count, :) = [sx sy];
                   minu_count = minu_count + 1;
                end
            end % if pixel white
        end % for y
    end % for x
