% load ('CSE_FP_TMP_DB.dat')
tmp = char(Templates{:,3});
k=0;
for i=1:10
    for j=1:300
        flag = strcmp(tmp(j,:),Ref_imgs(i,1));
        display(flag);
        if flag==1
            Ref_imgs{i,2} = Templates{j,1};
            display(num2str(j));
            k=k+1;
        end
    end
end